package com.spacegame.servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/crew/*")
public class CrewServlet extends HttpServlet {

    // 获取用户的所有舰员（修正表名 user_crew）
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        int userId;
        try {
            userId = Integer.parseInt(request.getParameter("userId"));
        } catch (NumberFormatException e) {
            response.getWriter().write("[]");
            return;
        }

        try (Connection conn = DB.getConnection()) {
            // 修正：表名改为 user_crew，别名为 uc
            String sql = "SELECT uc.id, uc.crew_id, uc.nickname, uc.fatigue, uc.fatigue_max, uc.is_active, cb.name " +
                    "FROM user_crew uc " +
                    "LEFT JOIN crew_base cb ON uc.crew_id = cb.id " +
                    "WHERE uc.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            JsonArray list = new JsonArray();
            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("id", rs.getInt("id"));
                obj.addProperty("crewId", rs.getInt("crew_id"));
                obj.addProperty("name", rs.getString("name"));
                obj.addProperty("nickname", rs.getString("nickname"));
                obj.addProperty("fatigue", rs.getInt("fatigue"));
                obj.addProperty("fatigueMax", rs.getInt("fatigue_max"));
                obj.addProperty("isActive", rs.getBoolean("is_active"));
                list.add(obj);
            }
            response.getWriter().write(list.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    // 使用道具恢复疲劳（增加疲劳为0的拦截）
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject res = new JsonObject();

        int crewId;
        int itemId;
        try {
            crewId = Integer.parseInt(request.getParameter("crewId"));
            itemId = Integer.parseInt(request.getParameter("itemId"));
        } catch (NumberFormatException e) {
            res.addProperty("code", 1);
            res.addProperty("msg", "参数错误");
            try { response.getWriter().write(res.toString()); } catch (Exception ignored) {}
            return;
        }

        Connection conn = null;
        try {
            conn = DB.getConnection();
            conn.setAutoCommit(false);

            // 1. 获取舰员信息
            PreparedStatement psCrew = conn.prepareStatement(
                    "SELECT user_id, crew_id, fatigue, fatigue_max FROM user_crew WHERE id = ? FOR UPDATE"
            );
            psCrew.setInt(1, crewId);
            ResultSet rsCrew = psCrew.executeQuery();
            if (!rsCrew.next()) {
                res.addProperty("code", 1);
                res.addProperty("msg", "舰员不存在");
                response.getWriter().write(res.toString());
                return;
            }
            int userId = rsCrew.getInt("user_id");
            int baseCrewId = rsCrew.getInt("crew_id");
            int currentFatigue = rsCrew.getInt("fatigue");
            int fatigueMax = rsCrew.getInt("fatigue_max");

            // 【修复1】疲劳已满（为0）时不允许使用恢复道具
            if (currentFatigue == 0) {
                res.addProperty("code", 1);
                res.addProperty("msg", "舰员当前无疲劳，无需恢复");
                response.getWriter().write(res.toString());
                return;
            }

            // 2. 验证物品恢复值
            PreparedStatement psPower = conn.prepareStatement(
                    "SELECT supply_power FROM shop_items WHERE id = ?"
            );
            psPower.setInt(1, itemId);
            ResultSet rsPower = psPower.executeQuery();
            if (!rsPower.next()) {
                res.addProperty("code", 1);
                res.addProperty("msg", "物品不存在");
                response.getWriter().write(res.toString());
                return;
            }
            int supplyPower = rsPower.getInt("supply_power");
            if (supplyPower <= 0) {
                res.addProperty("code", 1);
                res.addProperty("msg", "该物品无法用于恢复能量");
                response.getWriter().write(res.toString());
                return;
            }

            // 3. 匹配规则：专属物资（1-15且等于crew_id）或通用物资（16）
            boolean valid = (itemId == 16) || (itemId >= 1 && itemId <= 15 && itemId == baseCrewId);
            if (!valid) {
                res.addProperty("code", 1);
                res.addProperty("msg", "该物品不适用于此舰员");
                response.getWriter().write(res.toString());
                return;
            }

            // 4. 扣减库存（原子操作）
            PreparedStatement psDeduct = conn.prepareStatement(
                    "UPDATE user_items SET amount = amount - 1 WHERE user_id = ? AND item_id = ? AND amount > 0"
            );
            psDeduct.setInt(1, userId);
            psDeduct.setInt(2, itemId);
            int affected = psDeduct.executeUpdate();
            if (affected == 0) {
                res.addProperty("code", 1);
                res.addProperty("msg", "物资不足");
                response.getWriter().write(res.toString());
                return;
            }
            // 清理数量为0的记录（可选）
            PreparedStatement psClean = conn.prepareStatement(
                    "DELETE FROM user_items WHERE user_id = ? AND item_id = ? AND amount = 0"
            );
            psClean.setInt(1, userId);
            psClean.setInt(2, itemId);
            psClean.executeUpdate();

            // 5. 更新疲劳值（不低于0）
            int newFatigue = Math.max(0, currentFatigue - supplyPower);
            PreparedStatement psFatigue = conn.prepareStatement(
                    "UPDATE user_crew SET fatigue = ? WHERE id = ?"
            );
            psFatigue.setInt(1, newFatigue);
            psFatigue.setInt(2, crewId);
            psFatigue.executeUpdate();

            conn.commit();

            res.addProperty("code", 0);
            res.addProperty("msg", "能量补充成功！");
            JsonObject data = new JsonObject();
            data.addProperty("newFatigue", newFatigue);
            res.add("data", data);

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            res.addProperty("code", 500);
            res.addProperty("msg", "系统异常");
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }
        try {
            response.getWriter().write(res.toString());
        } catch (Exception ignored) {}
    }
}