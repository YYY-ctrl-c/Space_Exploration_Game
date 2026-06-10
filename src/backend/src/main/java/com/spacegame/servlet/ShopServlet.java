package com.spacegame.servlet;

import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {

    // 获取商店商品列表（保持不变）
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws java.io.IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DB.getConnection()) {
            String sql = "SELECT id,name,price,description,supply_power " +
                    "FROM shop_items WHERE price > 0";
            ResultSet rs = conn.createStatement().executeQuery(sql);
            com.google.gson.JsonArray items = new com.google.gson.JsonArray();
            while (rs.next()) {
                JsonObject item = new JsonObject();
                item.addProperty("id", rs.getInt("id"));
                item.addProperty("name", rs.getString("name"));
                item.addProperty("price", rs.getInt("price"));
                item.addProperty("description", rs.getString("description"));
                item.addProperty("supplyPower", rs.getInt("supply_power"));
                items.add(item);
            }
            response.getWriter().write(items.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    // 购买物品（修复累加问题）
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws java.io.IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        Connection conn = null;

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int itemId = Integer.parseInt(request.getParameter("itemId"));

            conn = DB.getConnection();
            conn.setAutoCommit(false);

            // 1. 查询商品价格
            PreparedStatement psPrice = conn.prepareStatement(
                    "SELECT price FROM shop_items WHERE id = ?"
            );
            psPrice.setInt(1, itemId);
            ResultSet rsPrice = psPrice.executeQuery();
            if (!rsPrice.next()) {
                JsonObject result = new JsonObject();
                result.addProperty("code", 1);
                result.addProperty("msg", "物品不存在");
                response.getWriter().write(result.toString());
                return;
            }
            int price = rsPrice.getInt("price");

            // 2. 扣除金币
            PreparedStatement psUpdate = conn.prepareStatement(
                    "UPDATE users SET coins = coins - ? WHERE id = ? AND coins >= ?"
            );
            psUpdate.setInt(1, price);
            psUpdate.setInt(2, userId);
            psUpdate.setInt(3, price);
            if (psUpdate.executeUpdate() == 0) {
                JsonObject result = new JsonObject();
                result.addProperty("code", 1);
                result.addProperty("msg", "星币不足，无法购买该物品");
                response.getWriter().write(result.toString());
                return;
            }

            // 3. 增加物品数量（先查是否存在，再决定插入或更新）
            PreparedStatement psCheck = conn.prepareStatement(
                    "SELECT amount FROM user_items WHERE user_id = ? AND item_id = ?"
            );
            psCheck.setInt(1, userId);
            psCheck.setInt(2, itemId);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // 存在则更新数量 +1
                PreparedStatement psUpdateItem = conn.prepareStatement(
                        "UPDATE user_items SET amount = amount + 1 WHERE user_id = ? AND item_id = ?"
                );
                psUpdateItem.setInt(1, userId);
                psUpdateItem.setInt(2, itemId);
                psUpdateItem.executeUpdate();
            } else {
                // 不存在则插入
                PreparedStatement psInsert = conn.prepareStatement(
                        "INSERT INTO user_items (user_id, item_id, amount) VALUES (?, ?, 1)"
                );
                psInsert.setInt(1, userId);
                psInsert.setInt(2, itemId);
                psInsert.executeUpdate();
            }

            // 4. 查询最新金币
            PreparedStatement psCoins = conn.prepareStatement(
                    "SELECT coins FROM users WHERE id = ?"
            );
            psCoins.setInt(1, userId);
            ResultSet rsCoins = psCoins.executeQuery();
            int newCoins = rsCoins.next() ? rsCoins.getInt("coins") : 0;

            conn.commit();

            JsonObject result = new JsonObject();
            result.addProperty("code", 0);
            result.addProperty("msg", "购买成功");
            JsonObject data = new JsonObject();
            data.addProperty("newCoins", newCoins);
            result.add("data", data);
            response.getWriter().write(result.toString());

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ignored) {}
            JsonObject result = new JsonObject();
            result.addProperty("code", 500);
            result.addProperty("msg", "交易系统异常");
            response.getWriter().write(result.toString());
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
}