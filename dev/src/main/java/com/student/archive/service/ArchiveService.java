package com.student.archive.service;

import com.student.archive.common.PageResult;
import com.student.archive.entity.ArchiveCategory;
import com.student.archive.entity.ArchiveExportRequest;
import com.student.archive.entity.ArchiveFile;

import java.util.List;

public interface ArchiveService {

    // 分类管理
    List<ArchiveCategory> getAllCategories();

    void addCategory(ArchiveCategory category);

    void updateCategory(ArchiveCategory category);

    void deleteCategory(Long pkCategory);

    // 档案文件管理
    ArchiveFile getFileById(Long pkArchiveFile);

    ArchiveFile getFileByFilePath(String filePath);

    List<ArchiveFile> getFilesByStudentId(Long studentId);

    PageResult<ArchiveFile> getFileList(int pageNum, int pageSize, Long studentId, Long categoryId, Integer status);

    void addFile(ArchiveFile file);

    void deleteFile(Long pkArchiveFile);

    void auditFile(Long pkArchiveFile, Integer status, Long auditUserId, String auditRemark);

    // 导出申请管理
    void submitExportRequest(ArchiveExportRequest request);

    List<ArchiveExportRequest> getExportRequestsByStudentId(Long studentId);

    PageResult<ArchiveExportRequest> getExportRequestList(int pageNum, int pageSize, Long studentId, Integer status);

    void auditExportRequest(Long pkRequest, Integer status, Long auditUserId, String auditRemark);

    List<ArchiveExportRequest> getValidApprovedRequests(Long studentId);

    ArchiveExportRequest getExportRequestById(Long pkRequest);
}
