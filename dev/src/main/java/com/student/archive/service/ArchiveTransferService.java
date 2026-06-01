package com.student.archive.service;

import com.student.archive.common.PageResult;
import com.student.archive.entity.ArchiveDestination;
import com.student.archive.entity.ArchiveTransferLetter;

import java.util.List;

public interface ArchiveTransferService {

    // 档案去向管理
    ArchiveDestination getDestinationById(Long pkDestination);

    ArchiveDestination getDestinationByStudentId(Long studentId);

    PageResult<ArchiveDestination> getDestinationList(int pageNum, int pageSize, Long studentId, String status);

    void saveOrUpdateDestination(ArchiveDestination destination);

    void sendArchive(Long pkDestination, Long sendUserId, String trackingNumber);

    // 调档函申请管理
    ArchiveTransferLetter getTransferLetterById(Long pkLetter);

    List<ArchiveTransferLetter> getTransferLettersByStudentId(Long studentId);

    PageResult<ArchiveTransferLetter> getTransferLetterList(int pageNum, int pageSize, Long studentId, Integer status);

    void submitTransferLetter(ArchiveTransferLetter letter);

    void auditTransferLetter(Long pkLetter, Integer status, Long auditUserId, String auditRemark);

    void sendTransferArchive(Long pkLetter, Long sendUserId, String trackingNumber);
}
