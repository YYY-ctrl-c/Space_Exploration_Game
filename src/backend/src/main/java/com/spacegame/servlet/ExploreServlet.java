package com.spacegame.servlet;

import com.google.gson.JsonObject;
import com.spacegame.utils.DB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject res = new JsonObject();

        // 获取参数：玩家ID，舰员服役ID，星域ID
        int userId = Integer.parseInt(request.getParameter("userId"));
        int crewId = Integer.parseInt(request.getParameter("crewId"));
        int locId = Integer.parseInt(request.getParameter("locId"));

        try (Connection conn = DB.getConnection()) {
            // 1. 获取舰员当前疲劳值和上限
            String sql = "SELECT fatigue, fatigue_max FROM user_crew WHERE id = ? AND user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, crewId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int currentFatigue = rs.getInt("fatigue");
                int maxFatigue = rs.getInt("fatigue_max");

                // 2. 计算本次消耗 (核心逻辑)
                int cost = 0;
                switch (locId) {
                    case 1: cost = 10; break; // 太阳系前哨站
                    case 2: cost = 20; break; // 天狼星资源带
                    case 3: cost = 35; break; // 猎户座遗迹星域
                }

                // 3. 疲劳状态判断
                if (currentFatigue + cost > maxFatigue) {
                    res.addProperty("code", 1);
                    res.addProperty("msg", "舰员疲劳值过高，请先补充能量！");
                } else {
                    // 更新疲劳
                    String updateSql = "UPDATE user_crew SET fatigue = fatigue + ? WHERE id = ?";
                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                    updatePs.setInt(1, cost);
                    updatePs.setInt(2, crewId);
                    updatePs.executeUpdate();

                    // 4. 返回探索结果
                    res.addProperty("code", 0);
                    res.addProperty("msg", "探索任务完成，获得资源！");
                    // 这里可以加入逻辑判断：如果 fatigue > 80，探索成功率降低
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.addProperty("code", 500);
            res.addProperty("msg", "系统异常");
        }
        response.getWriter().write(res.toString());
    }
}