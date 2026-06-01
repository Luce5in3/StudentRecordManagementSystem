package com.student.archive.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 档案去向表
 */
@Data
public class ArchiveDestination {

    private Long pkDestination;
    private Long studentId;
    private String destinationType;
    private String destinationName;
    private String destinationAddress;
    private String contactPerson;
    private String contactPhone;
    private String status;
    private LocalDateTime sendTime;
    private Long sendUserId;
    private String trackingNumber;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 关联字段（JOIN查询填充）
    private String studentName;
    private String studentNo;
}
