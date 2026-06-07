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
        Random rand = new Random();

        int userId = Integer.parseInt(request.getParameter("userId"));
        String gachaType = request.getParameter("type");
        int cost = gachaType.equals("advanced") ? 500 : 100;

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false); // 开启事务

            // 1. 检查余额并扣费
            PreparedStatement psCheck = conn.prepareStatement("SELECT coins FROM users WHERE id = ? AND coins >= ? FOR UPDATE");
            psCheck.setInt(1, userId);
            psCheck.setInt(2, cost);
            ResultSet rsCheck = psCheck.executeQuery();

            if (!rsCheck.next()) {
                res.addProperty("code", 1);
                res.addProperty("msg", "星币不足，无法开启补给舱！");
                response.getWriter().write(res.toString());
                return;
            }

            conn.prepareStatement("UPDATE users SET coins = coins - " + cost + " WHERE id = " + userId).executeUpdate();

            // 2. 获取奖池配置并随机抽取
            String poolSql = "SELECT * FROM gacha_pool WHERE gacha_type = ? ORDER BY RAND() LIMIT 1";
            PreparedStatement poolPs = conn.prepareStatement(poolSql);
            poolPs.setString(1, gachaType);
            ResultSet rewardRs = poolPs.executeQuery();

            if (rewardRs.next()) {
                String rewardType = rewardRs.getString("reward_type");
                String rewardName = rewardRs.getString("reward_name"); // 基础显示名称
                String rarity = rewardRs.getString("rarity");
                int minVal = rewardRs.getInt("min_id");
                int maxVal = rewardRs.getInt("max_id");

                // 计算随机值 (如果是coin则是数量，如果是crew/supply则是ID)
                int randomVal = rand.nextInt(maxVal - minVal + 1) + minVal;

                Integer rewardId = null;
                Integer rewardAmount = null;
                String finalDisplayName = rewardName;

                // 3. 根据类型处理奖励
                if ("coin".equals(rewardType)) {
                    rewardAmount = randomVal;
                    finalDisplayName = randomVal + " 星币";
                    conn.prepareStatement("UPDATE users SET coins = coins + " + randomVal + " WHERE id = " + userId).executeUpdate();
                } else if ("crew".equals(rewardType)) {
                    rewardId = randomVal;

                    // 【修改点】先获取舰员基础信息
                    PreparedStatement basePs = conn.prepareStatement("SELECT name, fatigue_max FROM crew_base WHERE id = ?");
                    basePs.setInt(1, rewardId);
                    ResultSet baseRs = basePs.executeQuery();

                    String crewName = "新舰员";
                    int baseFatigue = 100;

                    if (baseRs.next()) {
                        crewName = baseRs.getString("name"); // 获取真实名称
                        baseFatigue = baseRs.getInt("fatigue_max"); // 获取真实疲劳上限
                    }

                    // 【修改点】插入时显式写入 nickname 和 fatigue_max
                    PreparedStatement crewPs = conn.prepareStatement("INSERT INTO user_crew (user_id, crew_id, nickname, fatigue_max) VALUES (?, ?, ?, ?)");
                    crewPs.setInt(1, userId);
                    crewPs.setInt(2, rewardId);
                    crewPs.setString(3, crewName); // 初始代号设为舰员名
                    crewPs.setInt(4, baseFatigue); // 写入正确的上限
                    crewPs.executeUpdate();

                    finalDisplayName = crewName; // 更新返回给前端的显示名
                } else if ("supply".equals(rewardType)) {
                    rewardId = randomVal;
                    // 查询物资名字
                    PreparedStatement namePs = conn.prepareStatement("SELECT name FROM supply_base WHERE id = ?");
                    namePs.setInt(1, rewardId);
                    ResultSet nameRs = namePs.executeQuery();
                    if (nameRs.next()) finalDisplayName = nameRs.getString("name");

                    PreparedStatement itemPs = conn.prepareStatement("INSERT INTO user_items (user_id, item_id, amount) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE amount = amount + 1");
                    itemPs.setInt(1, userId);
                    itemPs.setInt(2, rewardId);
                    itemPs.executeUpdate();
                }

                // 4. 记录到日志
                PreparedStatement logPs = conn.prepareStatement("INSERT INTO gacha_logs (user_id, gacha_type, reward_type, reward_id, reward_amount, reward_name, rarity) VALUES (?, ?, ?, ?, ?, ?, ?)");
                logPs.setInt(1, userId);
                logPs.setString(2, gachaType);
                logPs.setString(3, rewardType);
                if (rewardId != null) logPs.setInt(4, rewardId); else logPs.setNull(4, Types.INTEGER);
                if (rewardAmount != null) logPs.setInt(5, rewardAmount); else logPs.setNull(5, Types.INTEGER);
                logPs.setString(6, finalDisplayName);
                logPs.setString(7, rarity);
                logPs.executeUpdate();

                // 获取最新余额
                ResultSet coinsRs = conn.createStatement().executeQuery("SELECT coins FROM users WHERE id = " + userId);
                int newCoins = coinsRs.next() ? coinsRs.getInt("coins") : 0;

                conn.commit();
                res.addProperty("code", 0);
                res.addProperty("msg", "恭喜获得: " + finalDisplayName);
                JsonObject data = new JsonObject();
                data.addProperty("newCoins", newCoins);
                res.add("data", data);
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.addProperty("code", 500);
            res.addProperty("msg", "系统异常");
        }
        response.getWriter().write(res.toString());
    }
}