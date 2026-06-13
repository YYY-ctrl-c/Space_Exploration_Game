/*
 Navicat MySQL Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50744
 Source Host           : localhost:3306
 Source Schema         : space_game

 Target Server Type    : MySQL
 Target Server Version : 50744
 File Encoding         : 65001

 Date: 13/06/2026 22:09:10
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for crew_base
-- ----------------------------
DROP TABLE IF EXISTS `crew_base`;
CREATE TABLE `crew_base`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '舰员ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '舰员名称',
  `rarity` int(11) NOT NULL COMMENT '稀有度（1普通 2精英 3传奇）',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '舰员描述',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '舰员图标URL',
  `supply_item_id` int(11) NULL DEFAULT NULL COMMENT '对应的低级专属物资ID',
  `fatigue_max` int(11) NOT NULL DEFAULT 100 COMMENT '疲劳上限',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '舰员图鉴表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of crew_base
-- ----------------------------
INSERT INTO `crew_base` VALUES (1, '侦察机器人', 1, '基础导航辅助，适合前哨站探索', '/icons/nav_bot.png', 1, 50);
INSERT INTO `crew_base` VALUES (2, '维修工程师', 1, '负责舰船基础维护与抢修', '/icons/engineer.png', 2, 50);
INSERT INTO `crew_base` VALUES (3, '医疗机器人', 1, '提供基础医疗与心理健康保障', '/icons/medic.png', 3, 50);
INSERT INTO `crew_base` VALUES (4, '采矿无人机', 1, '用于小行星带的基础物资采集', '/icons/drone.png', 4, 50);
INSERT INTO `crew_base` VALUES (5, '陆战队员', 1, '处理低等星际海盗威胁', '/icons/soldier.png', 5, 50);
INSERT INTO `crew_base` VALUES (6, '星图导航员', 2, '可绘制复杂星云地形，发现稀有资源', '/icons/mapper.png', 6, 80);
INSERT INTO `crew_base` VALUES (7, '能源工程师', 2, '优化能源供给，降低跃迁损耗', '/icons/energy_expert.png', 7, 80);
INSERT INTO `crew_base` VALUES (8, '量子科学家', 2, '解析未知星体数据的高阶人才', '/icons/researcher.png', 8, 80);
INSERT INTO `crew_base` VALUES (9, '特战指挥官', 2, '经验丰富，可应对中等虫族袭击', '/icons/captain.png', 9, 80);
INSERT INTO `crew_base` VALUES (10, '王牌飞行员', 2, '精通各类护航战术编队', '/icons/pilot.png', 10, 80);
INSERT INTO `crew_base` VALUES (11, '舰队统帅', 3, '传奇将领，能化解近乎绝境的星际危机', '/icons/commander.png', 11, 100);
INSERT INTO `crew_base` VALUES (12, '量子主脑AI', 3, '觉醒的超级量子计算机，算力无上限', '/icons/ai_core.png', 12, 100);
INSERT INTO `crew_base` VALUES (13, '开拓舰长', 3, '拥有丰富的开拓经验与领袖光环', '/icons/star_captain.png', 13, 100);
INSERT INTO `crew_base` VALUES (14, '远古先驱者', 3, '沉睡万年苏醒的神秘种族，自带远古科技', '/icons/ancient.png', 14, 100);
INSERT INTO `crew_base` VALUES (15, '银河执政官', 3, '银河最高议会特使，权限极高', '/icons/executor.png', 15, 100);

-- ----------------------------
-- Table structure for explore_rewards
-- ----------------------------
DROP TABLE IF EXISTS `explore_rewards`;
CREATE TABLE `explore_rewards`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '奖励ID',
  `location_id` int(11) NOT NULL COMMENT '对应星域ID',
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '奖励类型：coin/crew_range/item_range',
  `item_id` int(11) NULL DEFAULT NULL COMMENT '物品或舰员ID',
  `amount` int(11) NULL DEFAULT 1 COMMENT '数量（星币/物资数量）',
  `weight` int(11) NULL DEFAULT 1 COMMENT '概率权重',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `location_id`(`location_id`) USING BTREE,
  CONSTRAINT `explore_rewards_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '探索掉落表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of explore_rewards
-- ----------------------------
INSERT INTO `explore_rewards` VALUES (1, 1, 'coin', NULL, 50, 1);
INSERT INTO `explore_rewards` VALUES (2, 1, 'item_range', 1, 1, 1);
INSERT INTO `explore_rewards` VALUES (3, 1, 'crew_range', 1, 1, 1);
INSERT INTO `explore_rewards` VALUES (4, 2, 'coin', NULL, 150, 1);
INSERT INTO `explore_rewards` VALUES (5, 2, 'item_range', 6, 1, 1);
INSERT INTO `explore_rewards` VALUES (6, 2, 'crew_range', 6, 1, 1);
INSERT INTO `explore_rewards` VALUES (7, 3, 'coin', NULL, 500, 1);
INSERT INTO `explore_rewards` VALUES (8, 3, 'item_range', 11, 1, 1);
INSERT INTO `explore_rewards` VALUES (9, 3, 'crew_range', 11, 1, 1);

-- ----------------------------
-- Table structure for gacha_logs
-- ----------------------------
DROP TABLE IF EXISTS `gacha_logs`;
CREATE TABLE `gacha_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `gacha_type` enum('normal','advanced') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `reward_type` enum('coin','crew','supply') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `reward_id` int(11) NULL DEFAULT NULL,
  `reward_amount` int(11) NULL DEFAULT NULL,
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `reward_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `rarity` enum('normal','rare','epic') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `gacha_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gacha_pool
-- ----------------------------
DROP TABLE IF EXISTS `gacha_pool`;
CREATE TABLE `gacha_pool`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gacha_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '补给舱类型：normal/advanced',
  `reward_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '奖励类别：coin/crew/supply',
  `min_id` int(11) NOT NULL,
  `max_id` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `rarity` enum('normal','rare','epic') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '稀有度',
  `reward_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '奖励展示名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gacha_pool
-- ----------------------------
INSERT INTO `gacha_pool` VALUES (1, 'normal', 'coin', 100, 500, 5, 'normal', '星币补给');
INSERT INTO `gacha_pool` VALUES (2, 'normal', 'crew', 1, 5, 2, 'normal', '普通舰员');
INSERT INTO `gacha_pool` VALUES (3, 'normal', 'supply', 1, 5, 3, 'normal', '基础物资');
INSERT INTO `gacha_pool` VALUES (4, 'advanced', 'coin', 500, 2000, 4, 'normal', '星币箱');
INSERT INTO `gacha_pool` VALUES (5, 'advanced', 'crew', 6, 10, 2, 'rare', '精英舰员');
INSERT INTO `gacha_pool` VALUES (6, 'advanced', 'supply', 6, 10, 2, 'rare', '稀有物资');
INSERT INTO `gacha_pool` VALUES (7, 'advanced', 'crew', 11, 15, 1, 'epic', '传奇舰员');
INSERT INTO `gacha_pool` VALUES (8, 'advanced', 'supply', 11, 15, 1, 'epic', '史诗科技');

-- ----------------------------
-- Table structure for locations
-- ----------------------------
DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '星域ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '星域名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '星域介绍',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '星域信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of locations
-- ----------------------------
INSERT INTO `locations` VALUES (1, '太阳系前哨站', '适合新手探索；疲劳消耗较低；主要获得基础资源。', NULL);
INSERT INTO `locations` VALUES (2, '天狼星资源带', '可获得稀有矿物资源；探索风险增加；疲劳消耗提高。', NULL);
INSERT INTO `locations` VALUES (3, '猎户座遗迹星域', '存在远古文明遗迹；奖励更加丰富；探索难度最高。', NULL);

-- ----------------------------
-- Table structure for shop_items
-- ----------------------------
DROP TABLE IF EXISTS `shop_items`;
CREATE TABLE `shop_items`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '道具ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '道具名称',
  `price` int(11) NOT NULL COMMENT '价格（星币）',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '说明',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标URL',
  `is_supply` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为疲劳补给物资',
  `supply_power` int(11) NULL DEFAULT 0 COMMENT '恢复疲劳值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '星际商店物品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shop_items
-- ----------------------------
INSERT INTO `shop_items` VALUES (1, '侦察芯片', 20, '恢复微量疲劳', '/shop/supply1.png', 1, 10);
INSERT INTO `shop_items` VALUES (2, '维修工具箱', 20, '恢复微量疲劳', '/shop/supply2.png', 1, 10);
INSERT INTO `shop_items` VALUES (3, '医疗纳米包', 20, '恢复微量疲劳', '/shop/supply3.png', 1, 10);
INSERT INTO `shop_items` VALUES (4, '采矿模块', 20, '恢复微量疲劳', '/shop/supply4.png', 1, 10);
INSERT INTO `shop_items` VALUES (5, '战术补给包', 20, '恢复微量疲劳', '/shop/supply5.png', 1, 10);
INSERT INTO `shop_items` VALUES (6, '星图数据库', 0, '不可直接购买', '/shop/supply6.png', 0, 25);
INSERT INTO `shop_items` VALUES (7, '聚变稳压器', 0, '不可直接购买', '/shop/supply7.png', 0, 25);
INSERT INTO `shop_items` VALUES (8, '量子运算核心', 0, '不可直接购买', '/shop/supply8.png', 0, 25);
INSERT INTO `shop_items` VALUES (9, '战术指挥终端', 0, '不可直接购买', '/shop/supply9.png', 0, 25);
INSERT INTO `shop_items` VALUES (10, '飞行控制模块', 0, '不可直接购买', '/shop/supply10.png', 0, 25);
INSERT INTO `shop_items` VALUES (11, '统帅勋章', 0, '不可直接购买', '/shop/supply11.png', 0, 40);
INSERT INTO `shop_items` VALUES (12, '主脑核心', 0, '不可直接购买', '/shop/supply12.png', 0, 40);
INSERT INTO `shop_items` VALUES (13, '开拓者徽记', 0, '不可直接购买', '/shop/supply13.png', 0, 40);
INSERT INTO `shop_items` VALUES (14, '远古遗物', 0, '不可直接购买', '/shop/supply14.png', 0, 40);
INSERT INTO `shop_items` VALUES (15, '银河权杖', 0, '不可直接购买', '/shop/supply15.png', 0, 40);
INSERT INTO `shop_items` VALUES (16, '聚变电池', 300, '通用物资，极大地降低疲劳状态', '/shop/golden_supply.png', 1, 50);

-- ----------------------------
-- Table structure for supply_base
-- ----------------------------
DROP TABLE IF EXISTS `supply_base`;
CREATE TABLE `supply_base`  (
  `id` int(11) NOT NULL COMMENT '物资ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物资名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物资说明',
  `is_universal` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否通用（1=所有舰员可用）',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '能源物资图鉴表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of supply_base
-- ----------------------------
INSERT INTO `supply_base` VALUES (1, '侦察芯片', '基础能量补充，适合低阶机械单位', 0, '/shop/supply1.png');
INSERT INTO `supply_base` VALUES (2, '维修工具箱', '降低引擎过载风险', 0, '/shop/supply2.png');
INSERT INTO `supply_base` VALUES (3, '医疗纳米包', '基础保养物资', 0, '/shop/supply3.png');
INSERT INTO `supply_base` VALUES (4, '采矿模块', '适合基础碳基生命舰员', 0, '/shop/supply4.png');
INSERT INTO `supply_base` VALUES (5, '战术补给包', '提供基础生命维持', 0, '/shop/supply5.png');
INSERT INTO `supply_base` VALUES (6, '星图数据库', '提升舰员微型护盾充能', 0, '/shop/supply6.png');
INSERT INTO `supply_base` VALUES (7, '聚变稳压器', '校准精英舰员武器系统', 0, '/shop/supply7.png');
INSERT INTO `supply_base` VALUES (8, '量子运算核心', '高阶能量提取物', 0, '/shop/supply8.png');
INSERT INTO `supply_base` VALUES (9, '战术指挥终端', '强效能量注入', 0, '/shop/supply9.png');
INSERT INTO `supply_base` VALUES (10, '飞行控制模块', '提升精英科研人员效率', 0, '/shop/supply10.png');
INSERT INTO `supply_base` VALUES (11, '统帅勋章', '极度稀有，蕴含深空之力', 0, '/shop/supply11.png');
INSERT INTO `supply_base` VALUES (12, '主脑核心', '引导传奇舰员跳跃', 0, '/shop/supply12.png');
INSERT INTO `supply_base` VALUES (13, '开拓者徽记', '恒星衰亡的结晶', 0, '/shop/supply13.png');
INSERT INTO `supply_base` VALUES (14, '远古遗物', '包含未知科技的加密盘', 0, '/shop/supply14.png');
INSERT INTO `supply_base` VALUES (15, '银河权杖', '无穷尽的能源核心', 0, '/shop/supply15.png');
INSERT INTO `supply_base` VALUES (16, '聚变电池', '海量能量恢复，全体舰员通用', 1, '/shop/golden_supply.png');

-- ----------------------------
-- Table structure for user_crew
-- ----------------------------
DROP TABLE IF EXISTS `user_crew`;
CREATE TABLE `user_crew`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '舰员服役唯一ID',
  `user_id` int(11) NOT NULL COMMENT '所属指挥官ID',
  `crew_id` int(11) NOT NULL COMMENT '对应舰员图鉴ID (crew_base)',
  `nickname` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义代号',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '招募时间',
  `fatigue` int(11) NOT NULL DEFAULT 0 COMMENT '当前疲劳值',
  `fatigue_max` int(11) NOT NULL DEFAULT 100 COMMENT '疲劳上限',
  `is_active` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否出战中（1=出战）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `crew_id`(`crew_id`) USING BTREE,
  CONSTRAINT `user_crew_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_crew_ibfk_2` FOREIGN KEY (`crew_id`) REFERENCES `crew_base` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '服役舰员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_crew
-- ----------------------------
INSERT INTO `user_crew` VALUES (1, 1, 1, '导航机器人', '2026-06-08 02:00:08', 0, 50, 1);
INSERT INTO `user_crew` VALUES (2, 1, 11, '舰队统帅', '2026-06-08 02:10:00', 12, 100, 1);
INSERT INTO `user_crew` VALUES (3, 1, 12, '量子主脑AI', '2026-06-08 02:15:00', 0, 100, 0);
INSERT INTO `user_crew` VALUES (4, 2, 2, '维修工程师', '2026-06-10 14:30:00', 45, 50, 0);
INSERT INTO `user_crew` VALUES (5, 2, 4, '采矿无人机', '2026-06-10 14:35:00', 10, 50, 1);
INSERT INTO `user_crew` VALUES (6, 2, 6, '星图导航员', '2026-06-11 11:20:00', 32, 80, 1);
INSERT INTO `user_crew` VALUES (7, 2, 7, '能源工程师', '2026-06-12 15:40:00', 15, 80, 0);
INSERT INTO `user_crew` VALUES (8, 3, 11, '舰队统帅', '2026-06-11 09:05:00', 0, 100, 1);
INSERT INTO `user_crew` VALUES (9, 3, 13, '开拓舰长', '2026-06-11 09:05:00', 5, 100, 1);
INSERT INTO `user_crew` VALUES (10, 3, 14, '远古先驱者', '2026-06-11 09:10:00', 0, 100, 1);
INSERT INTO `user_crew` VALUES (11, 3, 15, '银河执政官', '2026-06-12 20:18:00', 25, 100, 0);
INSERT INTO `user_crew` VALUES (12, 3, 8, '量子科学家', '2026-06-11 09:30:00', 40, 80, 0);
INSERT INTO `user_crew` VALUES (13, 3, 9, '特战指挥官', '2026-06-11 09:35:00', 8, 80, 1);
INSERT INTO `user_crew` VALUES (14, 4, 1, '侦察机器人', '2026-06-13 10:15:30', 50, 50, 0);
INSERT INTO `user_crew` VALUES (15, 4, 3, '医疗机器人', '2026-06-13 10:20:00', 48, 50, 1);
INSERT INTO `user_crew` VALUES (16, 5, 5, '陆战队员', '2026-06-10 01:00:00', 20, 50, 1);
INSERT INTO `user_crew` VALUES (17, 5, 10, '王牌飞行员', '2026-06-10 01:05:00', 55, 80, 1);
INSERT INTO `user_crew` VALUES (18, 5, 2, '维修工程师', '2026-06-10 02:00:00', 12, 50, 0);

-- ----------------------------
-- Table structure for user_items
-- ----------------------------
DROP TABLE IF EXISTS `user_items`;
CREATE TABLE `user_items`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '货舱记录ID',
  `user_id` int(11) NOT NULL COMMENT '玩家ID',
  `item_id` int(11) NOT NULL COMMENT '道具ID',
  `amount` int(11) NULL DEFAULT 1 COMMENT '数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `item_id`(`item_id`) USING BTREE,
  CONSTRAINT `user_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '舰队货舱表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_items
-- ----------------------------
INSERT INTO `user_items` VALUES (1, 1, 16, 10);
INSERT INTO `user_items` VALUES (2, 2, 1, 8);
INSERT INTO `user_items` VALUES (3, 2, 2, 4);
INSERT INTO `user_items` VALUES (4, 2, 16, 2);
INSERT INTO `user_items` VALUES (5, 3, 16, 99);
INSERT INTO `user_items` VALUES (6, 3, 11, 15);
INSERT INTO `user_items` VALUES (7, 3, 12, 8);
INSERT INTO `user_items` VALUES (8, 3, 15, 5);
INSERT INTO `user_items` VALUES (9, 3, 8, 20);
INSERT INTO `user_items` VALUES (10, 4, 3, 1);
INSERT INTO `user_items` VALUES (11, 5, 5, 25);
INSERT INTO `user_items` VALUES (12, 5, 2, 12);
INSERT INTO `user_items` VALUES (13, 5, 16, 6);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '指挥官ID',
  `account` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录账号',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '指挥官代号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录密码',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `coins` int(11) NULL DEFAULT 0 COMMENT '星币数量',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `account`(`account`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '指挥官档案表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '星际总指挥', 'admin', '/avatars/txone.jpg', 100000, '2026-06-08 02:00:08', '2026-06-08 02:00:08');
INSERT INTO `users` VALUES (2, 'star_lord', '流浪星爵', '123456', '/avatars/txb.jpg', 4850, '2026-06-10 14:20:00', '2026-06-13 18:30:22');
INSERT INTO `users` VALUES (3, 'galaxy_whale', '氪金执政官', '666666', '/avatars/txwhale.jpg', 680000, '2026-06-11 09:00:15', '2026-06-13 21:00:00');
INSERT INTO `users` VALUES (4, 'rookie_space', '星际萌新小刘', 'abc123', '/avatars/txfresh.jpg', 320, '2026-06-13 10:15:30', '2026-06-13 10:15:30');
INSERT INTO `users` VALUES (5, 'bounty_hunter', '独行猎人·零', 'hunter0', '/avatars/txhunter.jpg', 24500, '2026-06-09 23:45:10', '2026-06-13 19:12:45');

SET FOREIGN_KEY_CHECKS = 1;
