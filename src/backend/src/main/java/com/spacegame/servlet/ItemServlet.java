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
            // 通过联表查询，把货舱表(user_items)和物资基表(supply_base)关联起来，获取名称
            String sql = "SELECT ui.*, sb.name, sb.description FROM user_items ui " +
                    "JOIN supply_base sb ON ui.item_id = sb.id WHERE ui.user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            JsonArray items = new JsonArray();
            while (rs.next()) {
                JsonObject item = new JsonObject();
                item.addProperty("id", rs.getInt("item_id"));
                item.addProperty("name", rs.getString("name"));
                item.addProperty("amount", rs.getInt("amount"));
                item.addProperty("desc", rs.getString("description"));
                items.add(item);
            }
            response.getWriter().write(items.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }
}