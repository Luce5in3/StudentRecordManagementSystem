/*
 Navicat Premium Dump SQL

 Source Server         : Luce5in3Service
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : studentrecordmanagementsystem

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 31/05/2026 16:44:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for archive_category
-- ----------------------------
DROP TABLE IF EXISTS `archive_category`;
CREATE TABLE `archive_category`  (
  `pk_category` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '材料名称',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `is_required` tinyint NULL DEFAULT 1 COMMENT '是否必需：1-是 0-否',
  PRIMARY KEY (`pk_category`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '档案材料分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of archive_category
-- ----------------------------
INSERT INTO `archive_category` VALUES (1, '入学登记表', 1, 1);
INSERT INTO `archive_category` VALUES (2, '成绩单', 2, 1);
INSERT INTO `archive_category` VALUES (3, '奖惩记录', 3, 0);
INSERT INTO `archive_category` VALUES (4, '毕业论文', 4, 0);
INSERT INTO `archive_category` VALUES (5, '实习鉴定表', 5, 0);
INSERT INTO `archive_category` VALUES (6, '体检报告', 6, 0);
INSERT INTO `archive_category` VALUES (7, '学位证书复印件', 7, 0);
INSERT INTO `archive_category` VALUES (8, '其他材料', 99, 0);

-- ----------------------------
-- Table structure for archive_export_request
-- ----------------------------
DROP TABLE IF EXISTS `archive_export_request`;
CREATE TABLE `archive_export_request`  (
  `pk_request` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `request_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请类型',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请原因',
  `status` tinyint NULL DEFAULT 0 COMMENT '0-待审核 1-已通过 2-已驳回',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '授权有效期',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`pk_request`) USING BTREE,
  INDEX `idx_export_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_export_status`(`status` ASC) USING BTREE,
  INDEX `idx_export_audit_user`(`audit_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '档案导出申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of archive_export_request
-- ----------------------------
INSERT INTO `archive_export_request` VALUES (1, 1, '个人信息', '这是测试数据', 1, 2, '2026-05-21 22:42:27', '', '2026-05-22 22:42:27', '2026-05-21 21:53:35');
INSERT INTO `archive_export_request` VALUES (2, 1, '全部', '', 2, 1, '2026-05-27 16:17:47', '', NULL, '2026-05-24 20:26:40');
INSERT INTO `archive_export_request` VALUES (3, 1, '成绩单', '', 1, 1, '2026-05-27 16:50:37', '', '2026-05-28 16:50:37', '2026-05-27 16:31:05');
INSERT INTO `archive_export_request` VALUES (4, 1, '全部', '', 1, 1, '2026-05-27 17:02:14', '', '2026-05-28 17:02:14', '2026-05-27 17:02:04');
INSERT INTO `archive_export_request` VALUES (5, 1, '全部', '', 1, 2, '2026-05-31 16:38:37', '', '2026-06-01 16:38:37', '2026-05-31 16:38:29');

-- ----------------------------
-- Table structure for archive_file
-- ----------------------------
DROP TABLE IF EXISTS `archive_file`;
CREATE TABLE `archive_file`  (
  `pk_archive_file` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `category_id` bigint NOT NULL COMMENT '材料分类ID → archive_category.pk_category',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '材料描述',
  `status` tinyint NULL DEFAULT 0 COMMENT '审核状态：0-待审核 1-已通过 2-已驳回',
  `upload_user_id` bigint NULL DEFAULT NULL COMMENT '上传人ID → sys_user.pk_user',
  `upload_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID → sys_user.pk_user',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核意见/驳回原因',
  PRIMARY KEY (`pk_archive_file`) USING BTREE,
  INDEX `idx_archive_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_archive_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_archive_status`(`status` ASC) USING BTREE,
  INDEX `idx_archive_upload_time`(`upload_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '档案文件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of archive_file
-- ----------------------------
INSERT INTO `archive_file` VALUES (1, 1, 8, 'chillguy.jpg', 'https://luce5in3-buket.oss-cn-beijing.aliyuncs.com/Archivefiles/b8c3af44fea0407c904097577852e3a3.jpg', 116088, '测试数据', 1, 4, '2026-05-21 22:07:40', 1, '2026-05-21 22:08:12', '');
INSERT INTO `archive_file` VALUES (2, 1, 8, '宿傩.jpg', 'https://luce5in3-buket.oss-cn-beijing.aliyuncs.com/Archivefiles/42e32da2cd26426c8f209ef4a2d6a8e7.jpg', 44935, NULL, 1, 4, '2026-05-24 19:51:05', 1, '2026-05-24 19:51:15', '');

-- ----------------------------
-- Table structure for class_info
-- ----------------------------
DROP TABLE IF EXISTS `class_info`;
CREATE TABLE `class_info`  (
  `pk_class` bigint NOT NULL AUTO_INCREMENT COMMENT '班级ID',
  `major_id` bigint NOT NULL COMMENT '所属专业ID → major.pk_major',
  `class_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '班级名称',
  `grade` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年级',
  PRIMARY KEY (`pk_class`) USING BTREE,
  INDEX `idx_class_major`(`major_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '班级表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of class_info
-- ----------------------------
INSERT INTO `class_info` VALUES (1, 1, '计科2024-1班', '2024');
INSERT INTO `class_info` VALUES (2, 1, '计科2024-2班', '2024');
INSERT INTO `class_info` VALUES (3, 2, '软工2024-1班', '2024');
INSERT INTO `class_info` VALUES (4, 2, '软工2023-1班', '2023');
INSERT INTO `class_info` VALUES (5, 3, '电信2023-1班', '2023');

-- ----------------------------
-- Table structure for college
-- ----------------------------
DROP TABLE IF EXISTS `college`;
CREATE TABLE `college`  (
  `pk_college` bigint NOT NULL AUTO_INCREMENT COMMENT '学院ID',
  `college_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学院名称',
  `college_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学院代码',
  PRIMARY KEY (`pk_college`) USING BTREE,
  UNIQUE INDEX `uk_college_name`(`college_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学院表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of college
-- ----------------------------
INSERT INTO `college` VALUES (1, '计算机科学与技术学院', 'CS');
INSERT INTO `college` VALUES (2, '电子信息工程学院', 'EE');
INSERT INTO `college` VALUES (3, '经济管理学院', 'EM');

-- ----------------------------
-- Table structure for major
-- ----------------------------
DROP TABLE IF EXISTS `major`;
CREATE TABLE `major`  (
  `pk_major` bigint NOT NULL AUTO_INCREMENT COMMENT '专业ID',
  `college_id` bigint NOT NULL COMMENT '所属学院ID → college.pk_college',
  `major_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '专业名称',
  `major_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专业代码',
  PRIMARY KEY (`pk_major`) USING BTREE,
  INDEX `idx_major_college`(`college_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专业表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES (1, 1, '计算机科学与技术', 'CS01');
INSERT INTO `major` VALUES (2, 1, '软件工程', 'CS02');
INSERT INTO `major` VALUES (3, 2, '电子信息工程', 'EE01');
INSERT INTO `major` VALUES (4, 3, '国际经济与贸易', 'EM01');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `pk_notification` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `target_user_id` bigint NOT NULL COMMENT '接收用户ID → sys_user.pk_user',
  `sender_id` bigint NULL DEFAULT NULL COMMENT '发送者ID，系统通知可为空',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '已读状态：0-未读 1-已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '通知时间',
  PRIMARY KEY (`pk_notification`) USING BTREE,
  INDEX `idx_notif_target`(`target_user_id` ASC) USING BTREE,
  INDEX `idx_notif_sender`(`sender_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知提醒表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------
INSERT INTO `notification` VALUES (1, 4, NULL, '欢迎入学', '欢迎来到计算机科学与技术学院，请及时完善个人档案信息。', 1, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (2, 4, 2, '成绩已录入', '您2024-2025学年第一学期的成绩已录入，请登录系统查看。', 0, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (3, 5, 2, '成绩已录入', '您2024-2025学年第一学期的成绩已录入，请登录系统查看。', 0, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (4, 6, NULL, '欢迎入学', '欢迎来到计算机科学与技术学院，请及时完善个人档案信息。', 1, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (5, 8, 3, '获奖信息确认', '您的\"互联网+\"大赛获奖信息已录入系统，请确认。', 0, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (6, 9, 3, '成绩已更新', '您2024-2025学年第一学期的成绩有更新，请查看。', 0, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (7, 2, 1, '系统维护通知', '系统将于本周六凌晨2:00-6:00进行维护升级。', 0, '2026-05-08 13:38:39');
INSERT INTO `notification` VALUES (8, 3, 1, '系统维护通知', '系统将于本周六凌晨2:00-6:00进行维护升级。', 0, '2026-05-08 13:38:39');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `pk_student` bigint NOT NULL AUTO_INCREMENT COMMENT '学生ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '关联用户ID → sys_user.pk_user',
  `student_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别：M-男 F-女',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `enrollment_year` year NULL DEFAULT NULL COMMENT '入学年份',
  `school_length` tinyint NULL DEFAULT NULL COMMENT '学制（年）',
  `college_id` bigint NULL DEFAULT NULL COMMENT '学院ID → college.pk_college',
  `major_id` bigint NULL DEFAULT NULL COMMENT '专业ID → major.pk_major',
  `class_id` bigint NULL DEFAULT NULL COMMENT '班级ID → class_info.pk_class',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '在读' COMMENT '学籍状态：在读/休学/退学/毕业',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '录入时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`pk_student`) USING BTREE,
  UNIQUE INDEX `uk_student_no`(`student_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_id_card`(`id_card` ASC) USING BTREE,
  INDEX `idx_student_college`(`college_id` ASC) USING BTREE,
  INDEX `idx_student_major`(`major_id` ASC) USING BTREE,
  INDEX `idx_student_class`(`class_id` ASC) USING BTREE,
  INDEX `idx_student_status`(`status` ASC) USING BTREE,
  INDEX `idx_student_enrollment`(`enrollment_year` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 4, '2024001', '王明', 'M', '2005-03-15', '110101200503150011', 2024, 4, 1, 1, 1, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (2, 5, '2024002', '李华', 'F', '2005-07-22', '310101200507220022', 2024, 4, 1, 1, 1, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (3, 6, '2024003', '赵敏', 'F', '2005-11-08', '440101200511080033', 2024, 4, 1, 2, 3, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (4, 7, '2024004', '陈晓东', 'M', '2005-01-20', '510101200501200044', 2024, 4, 1, 1, 2, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (5, 8, '2023001', '陈强', 'M', '2004-05-10', '330101200405100055', 2023, 4, 1, 2, 4, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (6, 9, '2023002', '刘婷', 'F', '2004-09-28', '420101200409280066', 2023, 4, 2, 3, 5, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');
INSERT INTO `student` VALUES (7, 10, '2023003', '周杰', 'M', '2004-12-05', '500101200412050077', 2023, 4, 2, 3, 5, '在读', '2026-05-08 13:38:39', '2026-05-08 13:38:39');

-- ----------------------------
-- Table structure for student_award
-- ----------------------------
DROP TABLE IF EXISTS `student_award`;
CREATE TABLE `student_award`  (
  `pk_award` bigint NOT NULL AUTO_INCREMENT COMMENT '奖项ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'award' COMMENT '类型：award-奖励 punishment-处分',
  `award_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '奖项名称',
  `award_level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '奖项级别：国家级/省级/市级/校级/院级',
  `award_date` date NULL DEFAULT NULL COMMENT '获奖日期',
  `issuing_authority` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '颁发机构',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '奖项描述',
  `import_user_id` bigint NULL DEFAULT NULL COMMENT '导入人ID → sys_user.pk_user',
  `import_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '导入时间',
  PRIMARY KEY (`pk_award`) USING BTREE,
  INDEX `idx_award_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_award_date`(`award_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生奖项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_award
-- ----------------------------
INSERT INTO `student_award` VALUES (1, 1, 'award', '全国大学生数学建模竞赛一等奖', '国家级', '2025-11-20', '教育部高等教育司', '团队合作完成数学建模任务', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (2, 1, 'award', 'ACM程序设计竞赛区域赛银奖', '省级', '2025-10-15', '中国计算机学会', 'ACM-ICPC区域赛', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (3, 1, 'award', '校级优秀学生干部', '校级', '2025-06-01', '计算机科学与技术学院', '担任班级学习委员表现突出', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (4, 2, 'award', '全国大学生英语竞赛二等奖', '国家级', '2025-05-10', '高等学校大学外语教学指导委员会', '英语听说读写综合能力竞赛', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (5, 2, 'award', '校级三好学生', '校级', '2025-06-01', '学生处', '德智体美劳全面发展', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (6, 3, 'award', '全国大学生数学竞赛一等奖', '国家级', '2025-12-01', '中国数学会', '非数学专业组一等奖', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (7, 3, 'award', '蓝桥杯全国软件大赛省赛一等奖', '省级', '2025-04-20', '工业和信息化部人才中心', 'C/C++程序设计组', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (8, 3, 'award', '国家励志奖学金', '国家级', '2025-11-01', '教育部', '学业优秀且家庭经济困难', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (9, 3, 'award', '校级一等奖学金', '校级', '2025-10-01', '学校教务处', '专业排名前5%', 2, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (10, 5, 'award', '中国\"互联网+\"大学生创新创业大赛铜奖', '国家级', '2025-10-01', '教育部', '智慧校园项目', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (11, 5, 'award', '省级优秀毕业设计', '省级', '2025-06-15', '省教育厅', '基于微服务的档案管理系统', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (12, 5, 'award', '校级编程马拉松一等奖', '校级', '2024-12-10', '计算机科学与技术学院', '48小时极限编程挑战赛', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (13, 5, 'award', '优秀共青团员', '校级', '2025-05-04', '校团委', '积极参加志愿服务活动', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (14, 6, 'award', '全国大学生电子设计竞赛省赛二等奖', '省级', '2025-08-20', '省教育厅', '智能温控系统设计', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (15, 6, 'award', '校级二等奖学金', '校级', '2025-10-01', '学校教务处', '专业排名前15%', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (16, 7, 'award', '市级物联网应用创新大赛三等奖', '市级', '2025-07-15', '市科学技术协会', '基于LoRa的环境监测系统', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (17, 7, 'award', '校级优秀志愿者', '校级', '2025-03-05', '校团委', '累计志愿服务时长超200小时', 3, '2026-05-08 13:38:39');
INSERT INTO `student_award` VALUES (18, 1, 'punishment', '测试警告', '警告', '2026-05-01', '学院', '测试', 2, '2026-05-31 16:37:45');

-- ----------------------------
-- Table structure for student_detail
-- ----------------------------
DROP TABLE IF EXISTS `student_detail`;
CREATE TABLE `student_detail`  (
  `pk_student_detail` bigint NOT NULL AUTO_INCREMENT COMMENT '详情ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `nation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '民族',
  `political_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '政治面貌',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `home_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '家庭住址',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '紧急联系电话',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  PRIMARY KEY (`pk_student_detail`) USING BTREE,
  UNIQUE INDEX `uk_detail_student`(`student_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生详情子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_detail
-- ----------------------------
INSERT INTO `student_detail` VALUES (1, 1, '汉族', '共青团员', '13800001001', 'wangming@stu.edu.cn', '北京市海淀区中关村大街1号', '王父', '13900001001', NULL);
INSERT INTO `student_detail` VALUES (2, 2, '汉族', '共青团员', '13800001002', 'lihua@stu.edu.cn', '上海市浦东新区陆家嘴路2号', '李母', '13900001002', NULL);
INSERT INTO `student_detail` VALUES (3, 3, '回族', '群众', '13800001003', 'zhaomin@stu.edu.cn', '广州市天河区天河路3号', '赵父', '13900001003', NULL);
INSERT INTO `student_detail` VALUES (4, 4, '汉族', '共青团员', '13800001004', 'chenxiaodong@stu.edu.cn', '成都市武侯区科华路4号', '陈母', '13900001004', NULL);
INSERT INTO `student_detail` VALUES (5, 5, '汉族', '中共党员', '13800001005', 'chenqiang@stu.edu.cn', '杭州市西湖区文三路5号', '陈父', '13900001005', NULL);
INSERT INTO `student_detail` VALUES (6, 6, '苗族', '共青团员', '13800001006', 'liuting@stu.edu.cn', '武汉市洪山区珞喻路6号', '刘母', '13900001006', NULL);
INSERT INTO `student_detail` VALUES (7, 7, '汉族', '群众', '13800001007', 'zhoujie@stu.edu.cn', '重庆市渝中区解放碑路7号', '周父', '13900001007', NULL);

-- ----------------------------
-- Table structure for student_grade
-- ----------------------------
DROP TABLE IF EXISTS `student_grade`;
CREATE TABLE `student_grade`  (
  `pk_grade` bigint NOT NULL AUTO_INCREMENT COMMENT '成绩ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `semester` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学期（如 2024-2025-1）',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课程名称',
  `course_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程类型：必修/选修/公共',
  `credit` decimal(3, 1) NULL DEFAULT NULL COMMENT '学分',
  `score` decimal(5, 1) NULL DEFAULT NULL COMMENT '成绩',
  `gpa` decimal(3, 2) NULL DEFAULT NULL COMMENT '绩点',
  `import_user_id` bigint NULL DEFAULT NULL COMMENT '导入人ID → sys_user.pk_user',
  `import_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '导入时间',
  PRIMARY KEY (`pk_grade`) USING BTREE,
  INDEX `idx_grade_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_grade_semester`(`semester` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生成绩表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_grade
-- ----------------------------
INSERT INTO `student_grade` VALUES (1, 1, '2024-2025-1', '高等数学A', '必修', 5.0, 92.0, 4.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (2, 1, '2024-2025-1', '大学英语(一)', '必修', 3.0, 85.0, 3.70, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (3, 1, '2024-2025-1', 'C语言程序设计', '必修', 4.0, 95.0, 4.50, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (4, 1, '2024-2025-1', '思想道德与法治', '公共', 2.0, 78.0, 3.00, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (5, 1, '2024-2025-1', '体育(一)', '公共', 1.0, 88.0, 3.80, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (6, 1, '2024-2025-1', '线性代数', '必修', 3.0, 90.0, 4.00, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (7, 1, '2024-2025-2', '高等数学B', '必修', 5.0, 88.0, 3.80, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (8, 1, '2024-2025-2', '大学英语(二)', '必修', 3.0, 82.0, 3.40, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (9, 1, '2024-2025-2', '数据结构', '必修', 4.0, 91.0, 4.10, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (10, 1, '2024-2025-2', '离散数学', '必修', 3.0, 87.0, 3.70, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (11, 1, '2024-2025-2', '体育(二)', '公共', 1.0, 90.0, 4.00, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (12, 2, '2024-2025-1', '高等数学A', '必修', 5.0, 78.0, 3.00, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (13, 2, '2024-2025-1', '大学英语(一)', '必修', 3.0, 92.0, 4.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (14, 2, '2024-2025-1', 'C语言程序设计', '必修', 4.0, 80.0, 3.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (15, 2, '2024-2025-1', '思想道德与法治', '公共', 2.0, 85.0, 3.70, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (16, 2, '2024-2025-1', '体育(一)', '公共', 1.0, 75.0, 2.70, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (17, 2, '2024-2025-1', '线性代数', '必修', 3.0, 72.0, 2.40, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (18, 2, '2024-2025-2', '高等数学B', '必修', 5.0, 80.0, 3.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (19, 2, '2024-2025-2', '大学英语(二)', '必修', 3.0, 95.0, 4.50, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (20, 2, '2024-2025-2', '数据结构', '必修', 4.0, 76.0, 2.80, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (21, 2, '2024-2025-2', '离散数学', '必修', 3.0, 70.0, 2.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (22, 2, '2024-2025-2', '体育(二)', '公共', 1.0, 82.0, 3.40, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (23, 3, '2024-2025-1', '高等数学A', '必修', 5.0, 96.0, 4.60, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (24, 3, '2024-2025-1', '大学英语(一)', '必修', 3.0, 90.0, 4.00, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (25, 3, '2024-2025-1', 'C语言程序设计', '必修', 4.0, 98.0, 4.80, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (26, 3, '2024-2025-1', '思想道德与法治', '公共', 2.0, 92.0, 4.20, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (27, 3, '2024-2025-1', '体育(一)', '公共', 1.0, 85.0, 3.70, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (28, 3, '2024-2025-1', '线性代数', '必修', 3.0, 94.0, 4.40, 2, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (29, 5, '2023-2024-1', '高等数学A', '必修', 5.0, 85.0, 3.70, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (30, 5, '2023-2024-1', '大学英语(一)', '必修', 3.0, 79.0, 3.10, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (31, 5, '2023-2024-1', 'C语言程序设计', '必修', 4.0, 88.0, 3.80, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (32, 5, '2023-2024-1', '思想道德与法治', '公共', 2.0, 82.0, 3.40, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (33, 5, '2023-2024-2', '高等数学B', '必修', 5.0, 83.0, 3.40, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (34, 5, '2023-2024-2', '数据结构', '必修', 4.0, 90.0, 4.00, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (35, 5, '2023-2024-2', '数据库原理', '必修', 3.0, 87.0, 3.70, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (36, 5, '2023-2024-2', '面向对象程序设计', '必修', 4.0, 92.0, 4.20, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (37, 5, '2024-2025-1', '操作系统', '必修', 4.0, 86.0, 3.60, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (38, 5, '2024-2025-1', '计算机网络', '必修', 3.0, 91.0, 4.10, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (39, 5, '2024-2025-1', '软件工程', '必修', 3.0, 89.0, 3.90, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (40, 5, '2024-2025-1', 'Java EE开发', '选修', 3.0, 93.0, 4.30, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (41, 6, '2023-2024-1', '电路分析基础', '必修', 4.0, 88.0, 3.80, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (42, 6, '2023-2024-1', '高等数学A', '必修', 5.0, 91.0, 4.10, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (43, 6, '2023-2024-1', '大学英语(一)', '必修', 3.0, 86.0, 3.60, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (44, 6, '2023-2024-2', '模拟电子技术', '必修', 4.0, 84.0, 3.40, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (45, 6, '2023-2024-2', '数字电子技术', '必修', 4.0, 90.0, 4.00, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (46, 6, '2023-2024-2', '信号与系统', '必修', 3.0, 78.0, 3.00, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (47, 6, '2024-2025-1', '通信原理', '必修', 4.0, 87.0, 3.70, 3, '2026-05-08 13:38:39');
INSERT INTO `student_grade` VALUES (48, 6, '2024-2025-1', '微处理器原理', '必修', 3.0, 92.0, 4.20, 3, '2026-05-08 13:38:39');

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `pk_log` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作用户ID → sys_user.pk_user',
  `operation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作类型',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作模块',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细描述',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求参数（JSON）',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作IP',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`pk_log`) USING BTREE,
  INDEX `idx_log_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_log_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_operation_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `pk_permission` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `perm_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `perm_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限标识符',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父权限ID，0为顶级',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由地址',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型：menu/button',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  PRIMARY KEY (`pk_permission`) USING BTREE,
  UNIQUE INDEX `uk_perm_code`(`perm_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `pk_role` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色编码（admin/student/counselor/archive_manager）',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`pk_role`) USING BTREE,
  UNIQUE INDEX `uk_role_name`(`role_name` ASC) USING BTREE,
  UNIQUE INDEX `uk_role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '系统管理员', 'admin', '系统管理员，拥有所有权限');
INSERT INTO `sys_role` VALUES (2, '学生', 'student', '学生用户，可查看个人档案信息');
INSERT INTO `sys_role` VALUES (3, '辅导员', 'counselor', '辅导员/教师，可管理所负责学生的档案');
INSERT INTO `sys_role` VALUES (4, '档案管理员', 'archive_manager', '档案管理员，负责档案审核');

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `pk_role_perm` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `role_id` bigint NOT NULL COMMENT '角色ID → sys_role.pk_role',
  `perm_id` bigint NOT NULL COMMENT '权限ID → sys_permission.pk_permission',
  PRIMARY KEY (`pk_role_perm`) USING BTREE,
  UNIQUE INDEX `uk_role_perm`(`role_id` ASC, `perm_id` ASC) USING BTREE,
  INDEX `idx_role_perm_perm`(`perm_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `pk_user` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '加密密码（BCrypt）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '真实姓名',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`pk_user`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '超级管理员', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (2, 'teacher1', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '张建国', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (3, 'teacher2', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '李秀芳', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (4, 'stu2024001', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '王明', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (5, 'stu2024002', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '李华', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (6, 'stu2024003', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '赵敏', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (7, 'stu2024004', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '陈晓东', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (8, 'stu2023001', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '陈强', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (9, 'stu2023002', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '刘婷', 1, '2026-05-08 13:38:39');
INSERT INTO `sys_user` VALUES (10, 'stu2023003', '$2a$10$cjpHksF.2UxXCfn34MOPKO.vTszIewV1bxXDKup7YLFTrqN0FsUjS', '周杰', 1, '2026-05-08 13:38:39');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `pk_user_role` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID → sys_user.pk_user',
  `role_id` bigint NOT NULL COMMENT '角色ID → sys_role.pk_role',
  PRIMARY KEY (`pk_user_role`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_user_role_role`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2, 3);
INSERT INTO `sys_user_role` VALUES (3, 3, 3);
INSERT INTO `sys_user_role` VALUES (4, 4, 2);
INSERT INTO `sys_user_role` VALUES (5, 5, 2);
INSERT INTO `sys_user_role` VALUES (6, 6, 2);
INSERT INTO `sys_user_role` VALUES (7, 7, 2);
INSERT INTO `sys_user_role` VALUES (8, 8, 2);
INSERT INTO `sys_user_role` VALUES (9, 9, 2);
INSERT INTO `sys_user_role` VALUES (10, 10, 2);

-- ----------------------------
-- Table structure for archive_destination
-- ----------------------------
DROP TABLE IF EXISTS `archive_destination`;
CREATE TABLE `archive_destination`  (
  `pk_destination` bigint NOT NULL AUTO_INCREMENT COMMENT '去向ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `destination_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去向类型：本校/就业单位/研究生院校/其他',
  `destination_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去向单位名称',
  `destination_address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去向单位地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '待处理' COMMENT '状态：待处理/已寄出/已签收',
  `send_time` datetime NULL DEFAULT NULL COMMENT '寄出时间',
  `send_user_id` bigint NULL DEFAULT NULL COMMENT '寄出操作人ID',
  `tracking_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '快递单号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`pk_destination`) USING BTREE,
  INDEX `idx_dest_student`(`student_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '档案去向表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of archive_destination
-- ----------------------------

-- ----------------------------
-- Table structure for archive_transfer_letter
-- ----------------------------
DROP TABLE IF EXISTS `archive_transfer_letter`;
CREATE TABLE `archive_transfer_letter`  (
  `pk_letter` bigint NOT NULL AUTO_INCREMENT COMMENT '调档函ID',
  `student_id` bigint NOT NULL COMMENT '学生ID → student.pk_student',
  `destination_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去向类型：就业单位/研究生院校/其他',
  `destination_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '去向单位名称',
  `destination_address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '去向单位地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `letter_file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '调档函文件路径',
  `letter_file_id` bigint NULL DEFAULT NULL COMMENT '调档函文件ID → archive_file.pk_archive_file',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请原因/备注',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-待审核 1-已通过 2-已驳回 3-已寄出',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审核备注',
  `send_time` datetime NULL DEFAULT NULL COMMENT '寄出时间',
  `send_user_id` bigint NULL DEFAULT NULL COMMENT '寄出操作人ID',
  `tracking_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '快递单号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`pk_letter`) USING BTREE,
  INDEX `idx_letter_student`(`student_id` ASC) USING BTREE,
  INDEX `idx_letter_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调档函申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of archive_transfer_letter
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
