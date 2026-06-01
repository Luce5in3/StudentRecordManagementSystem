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

 Date: 31/05/2026 16:43:04
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

SET FOREIGN_KEY_CHECKS = 1;
