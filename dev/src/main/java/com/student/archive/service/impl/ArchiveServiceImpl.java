package com.student.archive.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.student.archive.common.PageResult;
import com.student.archive.entity.ArchiveCategory;
import com.student.archive.entity.ArchiveExportRequest;
import com.student.archive.entity.ArchiveFile;
import com.student.archive.mapper.ArchiveCategoryMapper;
import com.student.archive.mapper.ArchiveExportRequestMapper;
import com.student.archive.mapper.ArchiveFileMapper;
import com.student.archive.service.ArchiveService;
import com.student.archive.service.OssService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ArchiveServiceImpl implements ArchiveService {

    private final ArchiveCategoryMapper archiveCategoryMapper;
    private final ArchiveFileMapper archiveFileMapper;
    private final ArchiveExportRequestMapper archiveExportRequestMapper;
    private final OssService ossService;

    @Override
    public List<ArchiveCategory> getAllCategories() {
        return archiveCategoryMapper.selectAll();
    }

    @Override
    @Transactional
    public void addCategory(ArchiveCategory category) {
        archiveCategoryMapper.insert(category);
    }

    @Override
    @Transactional
    public void updateCategory(ArchiveCategory category) {
        archiveCategoryMapper.update(category);
    }

    @Override
    @Transactional
    public void deleteCategory(Long pkCategory) {
        archiveCategoryMapper.deleteById(pkCategory);
    }

    @Override
    public ArchiveFile getFileById(Long pkArchiveFile) {
        return archiveFileMapper.selectById(pkArchiveFile);
    }

    @Override
    public ArchiveFile getFileByFilePath(String filePath) {
        return archiveFileMapper.selectByFilePath(filePath);
    }

    @Override
    public List<ArchiveFile> getFilesByStudentId(Long studentId) {
        return archiveFileMapper.selectByStudentId(studentId);
    }

    @Override
    public PageResult<ArchiveFile> getFileList(int pageNum, int pageSize, Long studentId, Long categoryId, Integer status) {
        PageHelper.startPage(pageNum, pageSize);
        List<ArchiveFile> list = archiveFileMapper.selectList(studentId, categoryId, status);
        PageInfo<ArchiveFile> pageInfo = new PageInfo<>(list);
        return new PageResult<>(pageInfo.getTotal(), pageNum, pageSize, pageInfo.getList());
    }

    @Override
    @Transactional
    public void addFile(ArchiveFile file) {
        archiveFileMapper.insert(file);
    }

    @Override
    @Transactional
    public void deleteFile(Long pkArchiveFile) {
        archiveFileMapper.deleteById(pkArchiveFile);
    }

    @Override
    @Transactional
    public void auditFile(Long pkArchiveFile, Integer status, Long auditUserId, String auditRemark) {
        archiveFileMapper.updateStatus(pkArchiveFile, status, auditUserId, auditRemark);

        // 审核通过（status=1）时，将临时文件上传到OSS
        if (status != null && status == 1) {
            ArchiveFile archiveFile = archiveFileMapper.selectById(pkArchiveFile);
            if (archiveFile != null && archiveFile.getFilePath() != null) {
                File tempFile = new File(archiveFile.getFilePath());
                if (tempFile.exists()) {
                    try (FileInputStream fis = new FileInputStream(tempFile)) {
                        String ossUrl = ossService.uploadArchiveFile(fis, tempFile.length(), archiveFile.getFileName());
                        archiveFileMapper.updateFilePath(pkArchiveFile, ossUrl);
                        // 删除本地临时文件
                        tempFile.delete();
                        log.info("档案文件审核通过，已上传OSS: {}", ossUrl);
                    } catch (IOException e) {
                        log.error("审核通过后OSS上传失败: {}", e.getMessage(), e);
                        throw new RuntimeException("文件上传OSS失败: " + e.getMessage());
                    }
                } else {
                    log.warn("临时文件不存在: {}", archiveFile.getFilePath());
                }
            }
        }
    }

    // ===== 导出申请管理 =====

    @Override
    @Transactional
    public void submitExportRequest(ArchiveExportRequest request) {
        archiveExportRequestMapper.insert(request);
    }

    @Override
    public List<ArchiveExportRequest> getExportRequestsByStudentId(Long studentId) {
        return archiveExportRequestMapper.selectByStudentId(studentId);
    }

    @Override
    public PageResult<ArchiveExportRequest> getExportRequestList(int pageNum, int pageSize, Long studentId, Integer status) {
        PageHelper.startPage(pageNum, pageSize);
        List<ArchiveExportRequest> list = archiveExportRequestMapper.selectList(studentId, status);
        PageInfo<ArchiveExportRequest> pageInfo = new PageInfo<>(list);
        return new PageResult<>(pageInfo.getTotal(), pageNum, pageSize, pageInfo.getList());
    }

    @Override
    @Transactional
    public void auditExportRequest(Long pkRequest, Integer status, Long auditUserId, String auditRemark) {
        archiveExportRequestMapper.updateAudit(pkRequest, status, auditUserId, auditRemark);
    }

    @Override
    public List<ArchiveExportRequest> getValidApprovedRequests(Long studentId) {
        return archiveExportRequestMapper.selectValidApproved(studentId);
    }

    @Override
    public ArchiveExportRequest getExportRequestById(Long pkRequest) {
        return archiveExportRequestMapper.selectById(pkRequest);
    }
}
