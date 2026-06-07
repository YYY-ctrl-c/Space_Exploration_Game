package com.spacegame.servlet;

import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.Random;

@WebServlet("/gacha")
public class GachaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException, java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject res = new JsonObject();

        int userId = Integer.parseInt(request.getParameter("userId"));
        String gachaType = request.getParameter("type"); // "normal" 或 "advanced"
        int cost = gachaType.equals("advanced") ? 500 : 100; // 假设高级500，普通100

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // 开启事务

            // 1. 检查余额并扣费
            String checkSql = "SELECT coins FROM users WHERE id = ? AND coins >= ?";
            PreparedStatement ps = conn.prepareStatement(checkSql);
            ps.setInt(1, userId);
            ps.setInt(2, cost);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                res.addProperty("code", 1);
                res.addProperty("msg", "星币不足，无法开启补给舱！");
                response.getWriter().write(res.toString());
                return;
            }

            // 扣费
            PreparedStatement updatePs = conn.prepareStatement("UPDATE users SET coins = coins - ? WHERE id = ?");
            updatePs.setInt(1, cost);
            updatePs.setInt(2, userId);
            updatePs.executeUpdate();

            // 2. 简单的加权随机抽取逻辑 (实际项目中可根据weight列从数据库随机获取)
            // 这里简化为根据类型获取奖池条目
            String poolSql = "SELECT * FROM gacha_pool WHERE gacha_type = ? ORDER BY RAND() LIMIT 1";
            PreparedStatement poolPs = conn.prepareStatement(poolSql);
            poolPs.setString(1, gachaType);
            ResultSet rewardRs = poolPs.executeQuery();

            if (rewardRs.next()) {
                String rewardType = rewardRs.getString("reward_type");
                String rewardName = rewardRs.getString("reward_name");
                int id = rewardRs.getInt("min_id"); // 简单取范围最小值作为ID

                // 3. 将获得的奖励发给玩家
                if ("crew".equals(rewardType)) {
                    PreparedStatement crewPs = conn.prepareStatement("INSERT INTO user_crew (user_id, crew_id, nickname) VALUES (?, ?, ?)");
                    crewPs.setInt(1, userId);
                    crewPs.setInt(2, id);
                    crewPs.setString(3, "新舰员");
                    crewPs.executeUpdate();
                } else if ("supply".equals(rewardType)) {
                    PreparedStatement itemPs = conn.prepareStatement("INSERT INTO user_items (user_id, item_id, amount) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE amount = amount + 1");
                    itemPs.setInt(1, userId);
                    itemPs.setInt(2, id);
                    itemPs.executeUpdate();
                }

                // 4. 记录日志
                PreparedStatement logPs = conn.prepareStatement("INSERT INTO gacha_logs (user_id, gacha_type, reward_type, reward_name) VALUES (?, ?, ?, ?)");
                logPs.setInt(1, userId);
                logPs.setString(2, gachaType);
                logPs.setString(3, rewardType);
                logPs.setString(4, rewardName);
                logPs.executeUpdate();

                // === 查询最新金币 ===
                PreparedStatement coinsPs = conn.prepareStatement("SELECT coins FROM users WHERE id = ?");
                coinsPs.setInt(1, userId);
                ResultSet coinsRs = coinsPs.executeQuery();
                int newCoins = coinsRs.next() ? coinsRs.getInt("coins") : 0;

                // === 准备返回数据 ===
                conn.commit();
                res.addProperty("code", 0);
                res.addProperty("msg", "获得奖励: " + rewardName);

                JsonObject data = new JsonObject();
                data.addProperty("newCoins", newCoins);
                res.add("data", data); // 将新金币放入 data 中
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.addProperty("code", 500);
            res.addProperty("msg", "补给舱故障，请稍后再试");
        }
        response.getWriter().write(res.toString());
    }
}