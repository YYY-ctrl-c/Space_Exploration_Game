package com.spacegame.servlet;

import com.google.gson.Gson;
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
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        int userId = Integer.parseInt(request.getParameter("userId"));

        // 查询玩家所有舰员
        try (Connection conn = DB.getConnection()) {
            String sql = "SELECT uc.*, cb.name FROM user_crew uc LEFT JOIN crew_base cb ON uc.crew_id = cb.id WHERE uc.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            JsonArray list = new JsonArray();
            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("id", rs.getInt("id"));
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
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        // 补充能量功能 (从货舱消耗物资并减少疲劳)
        int crewId = Integer.parseInt(request.getParameter("crewId"));
        int supplyPower = Integer.parseInt(request.getParameter("supplyPower")); // 恢复值

        try (Connection conn = DB.getConnection()) {
            // 更新疲劳值 (最小为0)
            String sql = "UPDATE user_crew SET fatigue = GREATEST(0, fatigue - ?) WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supplyPower);
            ps.setInt(2, crewId);
            ps.executeUpdate();

            JsonObject res = new JsonObject();
            res.addProperty("code", 0);
            res.addProperty("msg", "能量补充成功！");
            response.getWriter().write(res.toString());
        } catch (Exception e) {
            response.getWriter().write("{\"code\": 500, \"msg\": \"系统异常\"}");
        }
    }
}