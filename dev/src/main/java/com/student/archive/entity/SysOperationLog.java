package com.student.archive.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 操作日志表
 */
@Data
public class SysOperationLog {

    private Long pkLog;
    private Long userId;
    private String userName;
    private String operation;
    private String module;
    private String description;
    private String requestParams;
    private String ip;
    private LocalDateTime createTime;
}
