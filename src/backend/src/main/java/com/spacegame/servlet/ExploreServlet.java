package com.spacegame.servlet;

import com.google.gson.JsonObject;
import com.spacegame.utils.DB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.Random;

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject res = new JsonObject();
        Random rand = new Random();

        int userId = Integer.parseInt(request.getParameter("userId"));
        int crewId = Integer.parseInt(request.getParameter("crewId"));
        int locId = Integer.parseInt(request.getParameter("locId"));

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // 开启事务

            // 1. 验证疲劳
            PreparedStatement psCheck = conn.prepareStatement("SELECT fatigue, fatigue_max FROM user_crew WHERE id = ? AND user_id = ? FOR UPDATE");
            psCheck.setInt(1, crewId);
            psCheck.setInt(2, userId);
            ResultSet rs = psCheck.executeQuery();

            if (!rs.next()) {
                res.addProperty("code", 1); res.addProperty("msg", "舰员未找到");
                response.getWriter().write(res.toString()); return;
            }

            int cost = (locId == 1) ? 10 : (locId == 2) ? 20 : 35;
            if (rs.getInt("fatigue") + cost > rs.getInt("fatigue_max")) {
                res.addProperty("code", 1); res.addProperty("msg", "疲劳值过高！");
            } else {
                // 2. 确定奖励范围
                int minItemId, maxItemId, minCoin, maxCoin;
                switch (locId) {
                    case 1: minItemId = 1; maxItemId = 5; minCoin = 50; maxCoin = 100; break;
                    case 2: minItemId = 6; maxItemId = 10; minCoin = 150; maxCoin = 300; break;
                    default: minItemId = 11; maxItemId = 15; minCoin = 500; maxCoin = 1000; break;
                }

                int rewardItemId = rand.nextInt(maxItemId - minItemId + 1) + minItemId;
                int rewardCoin = rand.nextInt(maxCoin - minCoin + 1) + minCoin;

                // 3. 执行更新 (更新疲劳、加金币、获得物品)
                conn.prepareStatement("UPDATE user_crew SET fatigue = fatigue + " + cost + " WHERE id = " + crewId).executeUpdate();
                conn.prepareStatement("UPDATE users SET coins = coins + " + rewardCoin + " WHERE id = " + userId).executeUpdate();

                PreparedStatement psUpdateItem = conn.prepareStatement("UPDATE user_items SET amount = amount + 1 WHERE user_id = ? AND item_id = ?");
                psUpdateItem.setInt(1, userId);
                psUpdateItem.setInt(2, rewardItemId);
                if (psUpdateItem.executeUpdate() == 0) {
                    PreparedStatement psInsertItem = conn.prepareStatement("INSERT INTO user_items (user_id, item_id, amount) VALUES (?, ?, 1)");
                    psInsertItem.setInt(1, userId);
                    psInsertItem.setInt(2, rewardItemId);
                    psInsertItem.executeUpdate();
                }

                // 获取物品名称
                ResultSet rsItem = conn.createStatement().executeQuery("SELECT name FROM supply_base WHERE id = " + rewardItemId);
                String itemName = rsItem.next() ? rsItem.getString("name") : "未知物资";

                // === 【新增】查询最新金币，用于前端实时更新 ===
                PreparedStatement psCoins = conn.prepareStatement("SELECT coins FROM users WHERE id = ?");
                psCoins.setInt(1, userId);
                ResultSet rsCoins = psCoins.executeQuery();
                int newCoins = rsCoins.next() ? rsCoins.getInt("coins") : 0;

                conn.commit(); // 提交事务

                // === 【修改】构建统一的 JSON 格式 ===
                res.addProperty("code", 0);
                res.addProperty("msg", "探索成功！获得 " + rewardCoin + " 星币 和 " + itemName);

                JsonObject data = new JsonObject();
                data.addProperty("newCoins", newCoins);
                res.add("data", data);
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.addProperty("code", 500); res.addProperty("msg", "探索发生错误");
        }
        response.getWriter().write(res.toString());
    }
}