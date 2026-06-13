package com.spacegame.servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/items")
public class ItemServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        int userId = Integer.parseInt(request.getParameter("userId"));

        try (Connection conn = DB.getConnection()) {
            // 注意：SELECT 和 GROUP BY 中都加入了 sb.icon
            String sql = "SELECT ui.item_id, SUM(ui.amount) AS total_amount, sb.name, sb.description, sb.icon " +
                    "FROM user_items ui " +
                    "JOIN supply_base sb ON ui.item_id = sb.id " +
                    "WHERE ui.user_id = ? " +
                    "GROUP BY ui.item_id, sb.name, sb.description, sb.icon";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            JsonArray items = new JsonArray();
            while (rs.next()) {
                JsonObject item = new JsonObject();
                item.addProperty("id", rs.getInt("item_id"));
                item.addProperty("name", rs.getString("name"));
                item.addProperty("amount", rs.getInt("total_amount"));
                item.addProperty("desc", rs.getString("description"));
                item.addProperty("icon", rs.getString("icon")); // 获取图片路径
                items.add(item);
            }
            response.getWriter().write(items.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}