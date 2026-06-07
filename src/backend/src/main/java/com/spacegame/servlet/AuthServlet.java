package com.spacegame.servlet;

import com.google.gson.JsonObject;
import com.spacegame.utils.DB;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws java.io.IOException {
        response.setContentType("application/json;charset=UTF-8");
        String pathInfo = request.getPathInfo(); // /login 或 /register

        try (Connection conn = DB.getConnection()) {
            if ("/login".equals(pathInfo)) {
                // 登录逻辑
                String account = request.getParameter("account");
                String pass = request.getParameter("pass");
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE account = ? AND password = ?");
                ps.setString(1, account);
                ps.setString(2, pass);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    JsonObject user = new JsonObject();
                    user.addProperty("id", rs.getInt("id"));
                    user.addProperty("name", rs.getString("name"));
                    user.addProperty("coins", rs.getInt("coins"));
                    sendResponse(response, 0, "登录成功", user);
                } else {
                    sendResponse(response, 1, "账号或密码错误", null);
                }
            } else if ("/register".equals(pathInfo)) {
                // 注册逻辑
                String account = request.getParameter("account");
                String name = request.getParameter("name");
                String pass = request.getParameter("pass");
                PreparedStatement ps = conn.prepareStatement("INSERT INTO users(account, name, password, coins) VALUES(?,?,?,1000)");
                ps.setString(1, account);
                ps.setString(2, name);
                ps.setString(3, pass);
                ps.executeUpdate();
                sendResponse(response, 0, "注册成功，初始资金已发放", null);
            }
        } catch (Exception e) {
            sendResponse(response, 500, "服务器错误", null);
        }
    }

    private void sendResponse(HttpServletResponse response, int code, String msg, JsonObject data) throws java.io.IOException {
        JsonObject res = new JsonObject();
        res.addProperty("code", code);
        res.addProperty("msg", msg);
        if (data != null) res.add("data", data);
        response.getWriter().write(res.toString());
    }
}