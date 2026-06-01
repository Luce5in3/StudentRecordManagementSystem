package com.student.archive.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 调档函申请表
 */
@Data
public class ArchiveTransferLetter {

    private Long pkLetter;
    private Long studentId;
    private String destinationType;
    private String destinationName;
    private String destinationAddress;
    private String contactPerson;
    private String contactPhone;
    private String letterFilePath;
    private Long letterFileId;
    private String reason;
    private Integer status;        // 0-待审核 1-已通过 2-已驳回 3-已寄出
    private Long auditUserId;
    private LocalDateTime auditTime;
    private String auditRemark;
    private LocalDateTime sendTime;
    private Long sendUserId;
    private String trackingNumber;
    private LocalDateTime createTime;

    // 关联字段（JOIN查询填充）
    private String studentName;
    private String studentNo;
}
