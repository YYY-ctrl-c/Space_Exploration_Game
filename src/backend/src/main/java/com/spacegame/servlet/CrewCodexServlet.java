package com.spacegame.servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spacegame.utils.DB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/crew-codex")
public class CrewCodexServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");

        String userIdStr = request.getParameter("userId");
        if (userIdStr == null) {
            response.getWriter().write("{\"code\": 400, \"msg\": \"缺少用户ID\"}");
            return;
        }
        int userId = Integer.parseInt(userIdStr);

        try (Connection conn = DB.getConnection()) {
            // 使用 LEFT JOIN 检查用户是否拥有该舰员
            String sql = "SELECT cb.*, COUNT(uc.id) AS ownership_count " +
                    "FROM crew_base cb " +
                    "LEFT JOIN user_crew uc ON cb.id = uc.crew_id AND uc.user_id = ? " +
                    "GROUP BY cb.id ORDER BY cb.rarity ASC, cb.id ASC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            JsonArray list = new JsonArray();
            while (rs.next()) {
                JsonObject obj = new JsonObject();
                obj.addProperty("id", rs.getInt("id"));
                obj.addProperty("name", rs.getString("name"));
                obj.addProperty("description", rs.getString("description"));
                obj.addProperty("icon", rs.getString("icon"));
                obj.addProperty("rarity", rs.getInt("rarity"));
                // 如果统计数 > 0，说明拥有
                obj.addProperty("isOwned", rs.getInt("ownership_count") > 0);

                list.add(obj);
            }
            response.getWriter().write(list.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"code\": 500, \"msg\": \"查询失败\"}");
        }
    }
}