package com.spacegame.utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * 数据库连接工具类
 * 负责与 space_game 数据库建立连接
 */
public class DB {
    // 确保数据库名为 space_game
    private static final String URL = "jdbc:mysql://localhost:3306/space_game?useUnicode=true&characterEncoding=UTF-8&useSSL=false";
    private static final String USER = "root"; // 请替换为您的数据库账号
    private static final String PASS = "123456"; // 请替换为您的数据库密码

    static {
        try {
            // 加载 MySQL 驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}