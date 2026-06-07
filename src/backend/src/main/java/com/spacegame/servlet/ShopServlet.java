package com.spacegame.servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {

    // GET: 获取商店商品列表
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");

        try (Connection conn = DB.getConnection()) {
            String sql = "SELECT * FROM shop_items";
            ResultSet rs = conn.createStatement().executeQuery(sql);

            JsonArray items = new JsonArray();
            while (rs.next()) {
                JsonObject item = new JsonObject();
                item.addProperty("id", rs.getInt("id"));
                item.addProperty("name", rs.getString("name"));
                item.addProperty("price", rs.getInt("price"));
                item.addProperty("description", rs.getString("description"));
                items.add(item);
            }
            response.getWriter().write(items.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // POST: 购买物品
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int itemId = Integer.parseInt(request.getParameter("itemId"));

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // 事务开启

            // 1. 获取物品价格
            PreparedStatement psPrice = conn.prepareStatement("SELECT price FROM shop_items WHERE id = ?");
            psPrice.setInt(1, itemId);
            ResultSet rsPrice = psPrice.executeQuery();

            if (rsPrice.next()) {
                int price = rsPrice.getInt("price");

                // 2. 扣除星币
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE users SET coins = coins - ? WHERE id = ? AND coins >= ?");
                psUpdate.setInt(1, price);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, price);

                if (psUpdate.executeUpdate() > 0) {
                    // 3. 存入玩家货舱
                    PreparedStatement psBag = conn.prepareStatement("INSERT INTO user_items (user_id, item_id, amount) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE amount = amount + 1");
                    psBag.setInt(1, userId);
                    psBag.setInt(2, itemId);
                    psBag.executeUpdate();

                    // === 【新增】查询最新金币 ===
                    PreparedStatement psCoins = conn.prepareStatement("SELECT coins FROM users WHERE id = ?");
                    psCoins.setInt(1, userId);
                    ResultSet rsCoins = psCoins.executeQuery();
                    int newCoins = rsCoins.next() ? rsCoins.getInt("coins") : 0;

                    // === 【修改】构建 JSON 返回 ===
                    JsonObject responseJson = new JsonObject();
                    responseJson.addProperty("code", 0);
                    responseJson.addProperty("msg", "购买成功");

                    JsonObject data = new JsonObject();
                    data.addProperty("newCoins", newCoins);
                    responseJson.add("data", data);

                    response.getWriter().write(responseJson.toString());
                    conn.commit();
                } else {
                    response.getWriter().write("{\"code\": 1, \"msg\": \"星币余额不足\"}");
                }
            }
            conn.setAutoCommit(true);
        } catch (Exception e) {
            response.getWriter().write("{\"code\": 500, \"msg\": \"交易系统异常\"}");
        }
    }
}