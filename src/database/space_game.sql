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

 Date: 08/06/2026 02:01:31
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
INSERT INTO `crew_base` VALUES (1, '导航机器人', 1, '基础导航辅助，适合前哨站探索', '/icons/nav_bot.png', 1, 50);
INSERT INTO `crew_base` VALUES (2, '工程维护员', 1, '负责舰船基础维护与抢修', '/icons/engineer.png', 2, 50);
INSERT INTO `crew_base` VALUES (3, '医疗助手', 1, '提供基础医疗与心理健康保障', '/icons/medic.png', 3, 50);
INSERT INTO `crew_base` VALUES (4, '勘探无人机', 1, '用于小行星带的基础物资采集', '/icons/drone.png', 4, 50);
INSERT INTO `crew_base` VALUES (5, '基础突击兵', 1, '处理低等星际海盗威胁', '/icons/soldier.png', 5, 50);
INSERT INTO `crew_base` VALUES (6, '深空测绘员', 2, '可绘制复杂星云地形，发现稀有资源', '/icons/mapper.png', 6, 80);
INSERT INTO `crew_base` VALUES (7, '能源专家', 2, '优化能源供给，降低跃迁损耗', '/icons/energy_expert.png', 7, 80);
INSERT INTO `crew_base` VALUES (8, '量子研究员', 2, '解析未知星体数据的高阶人才', '/icons/researcher.png', 8, 80);
INSERT INTO `crew_base` VALUES (9, '突击队长', 2, '经验丰富，可应对中等虫族袭击', '/icons/captain.png', 9, 80);
INSERT INTO `crew_base` VALUES (10, '护卫舰驾驶员', 2, '精通各类护航战术编队', '/icons/pilot.png', 10, 80);
INSERT INTO `crew_base` VALUES (11, '战术指挥官', 3, '传奇将领，能化解近乎绝境的星际危机', '/icons/commander.png', 11, 100);
INSERT INTO `crew_base` VALUES (12, '主控AI', 3, '觉醒的超级量子计算机，算力无上限', '/icons/ai_core.png', 12, 100);
INSERT INTO `crew_base` VALUES (13, '星际舰长', 3, '拥有丰富的开拓经验与领袖光环', '/icons/star_captain.png', 13, 100);
INSERT INTO `crew_base` VALUES (14, '远古遗民', 3, '沉睡万年苏醒的神秘种族，自带远古科技', '/icons/ancient.png', 14, 100);
INSERT INTO `crew_base` VALUES (15, '星际执行官', 3, '银河最高议会特使，权限极高', '/icons/executor.png', 15, 100);

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
INSERT INTO `shop_items` VALUES (1, '标准能量包', 20, '恢复微量疲劳', '/shop/supply1.png', 1, 10);
INSERT INTO `shop_items` VALUES (2, '初级冷却液', 20, '恢复微量疲劳', '/shop/supply2.png', 1, 10);
INSERT INTO `shop_items` VALUES (3, '机械润滑油', 20, '恢复微量疲劳', '/shop/supply3.png', 1, 10);
INSERT INTO `shop_items` VALUES (4, '氧气压缩罐', 20, '恢复微量疲劳', '/shop/supply4.png', 1, 10);
INSERT INTO `shop_items` VALUES (5, '营养合成剂', 20, '恢复微量疲劳', '/shop/supply5.png', 1, 10);
INSERT INTO `shop_items` VALUES (6, '次级护盾发生器', 0, '不可直接购买', '/shop/supply6.png', 0, 0);
INSERT INTO `shop_items` VALUES (7, '脉冲校准仪', 0, '不可直接购买', '/shop/supply7.png', 0, 0);
INSERT INTO `shop_items` VALUES (8, '反物质微粒', 0, '不可直接购买', '/shop/supply8.png', 0, 0);
INSERT INTO `shop_items` VALUES (9, '高能离子体', 0, '不可直接购买', '/shop/supply9.png', 0, 0);
INSERT INTO `shop_items` VALUES (10, '量子纠缠节点', 0, '不可直接购买', '/shop/supply10.png', 0, 0);
INSERT INTO `shop_items` VALUES (11, '暗物质残片', 0, '不可直接购买', '/shop/supply11.png', 0, 0);
INSERT INTO `shop_items` VALUES (12, '超空间信标', 0, '不可直接购买', '/shop/supply12.png', 0, 0);
INSERT INTO `shop_items` VALUES (13, '星核碎片', 0, '不可直接购买', '/shop/supply13.png', 0, 0);
INSERT INTO `shop_items` VALUES (14, '远古文明数据', 0, '不可直接购买', '/shop/supply14.png', 0, 0);
INSERT INTO `shop_items` VALUES (15, '零点能电池', 0, '不可直接购买', '/shop/supply15.png', 0, 0);
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
INSERT INTO `supply_base` VALUES (1, '标准能量包', '基础能量补充，适合低阶机械单位', 0, '/shop/supply1.png');
INSERT INTO `supply_base` VALUES (2, '初级冷却液', '降低引擎过载风险', 0, '/shop/supply2.png');
INSERT INTO `supply_base` VALUES (3, '机械润滑油', '基础保养物资', 0, '/shop/supply3.png');
INSERT INTO `supply_base` VALUES (4, '氧气压缩罐', '适合基础碳基生命舰员', 0, '/shop/supply4.png');
INSERT INTO `supply_base` VALUES (5, '营养合成剂', '提供基础生命维持', 0, '/shop/supply5.png');
INSERT INTO `supply_base` VALUES (6, '次级护盾发生器', '提升舰员微型护盾充能', 0, '/shop/supply6.png');
INSERT INTO `supply_base` VALUES (7, '脉冲校准仪', '校准精英舰员武器系统', 0, '/shop/supply7.png');
INSERT INTO `supply_base` VALUES (8, '反物质微粒', '高阶能量提取物', 0, '/shop/supply8.png');
INSERT INTO `supply_base` VALUES (9, '高能离子体', '强效能量注入', 0, '/shop/supply9.png');
INSERT INTO `supply_base` VALUES (10, '量子纠缠节点', '提升精英科研人员效率', 0, '/shop/supply10.png');
INSERT INTO `supply_base` VALUES (11, '暗物质残片', '极度稀有，蕴含深空之力', 0, '/shop/supply11.png');
INSERT INTO `supply_base` VALUES (12, '超空间信标', '引导传奇舰员跳跃', 0, '/shop/supply12.png');
INSERT INTO `supply_base` VALUES (13, '星核碎片', '恒星衰亡的结晶', 0, '/shop/supply13.png');
INSERT INTO `supply_base` VALUES (14, '远古文明数据', '包含未知科技的加密盘', 0, '/shop/supply14.png');
INSERT INTO `supply_base` VALUES (15, '零点能电池', '无穷尽的能源核心', 0, '/shop/supply15.png');
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '服役舰员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_crew
-- ----------------------------
INSERT INTO `user_crew` VALUES (1, 1, 1, '导航机器人', '2026-06-08 02:00:08', 0, 50, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '舰队货舱表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_items
-- ----------------------------
INSERT INTO `user_items` VALUES (1, 1, 16, 10);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '指挥官档案表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '星际总指挥', 'admin', '/avatars/txone.jpg', 100000, '2026-06-08 02:00:08', '2026-06-08 02:00:08');

SET FOREIGN_KEY_CHECKS = 1;
