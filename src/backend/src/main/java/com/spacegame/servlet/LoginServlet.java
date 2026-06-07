package com.spacegame.servlet;

import com.spacegame.utils.DB; // 引入你刚才的 DB 工具类
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 设置响应编码
        resp.setContentType("application/json;charset=UTF-8");

        // 1. 获取前端传来的账号密码 (假设前端通过 JSON 或参数传递)
        String account = req.getParameter("account");
        String password = req.getParameter("password");

        try (Connection conn = DB.getConnection()) { // 使用你的 DB 工具类获取连接
            String sql = "SELECT * FROM users WHERE account = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, account);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // 登录成功
                resp.getWriter().write("{\"status\":\"success\", \"userId\":" + rs.getInt("id") + ", \"name\":\"" + rs.getString("name") + "\"}");
            } else {
                // 登录失败
                resp.setStatus(401);
                resp.getWriter().write("{\"status\":\"error\", \"message\":\"账号或密码错误\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"status\":\"error\", \"message\":\"服务器内部错误\"}");
        }
    }
}