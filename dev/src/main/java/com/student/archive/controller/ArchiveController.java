package com.student.archive.controller;

import com.aliyun.oss.model.OSSObject;
import com.student.archive.common.PageResult;
import com.student.archive.common.Result;
import com.student.archive.entity.ArchiveCategory;
import com.student.archive.entity.ArchiveExportRequest;
import com.student.archive.entity.ArchiveFile;
import com.student.archive.service.ArchiveService;
import com.student.archive.service.OssService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/archive")
@RequiredArgsConstructor
public class ArchiveController {

    private final ArchiveService archiveService;
    private final OssService ossService;

    @Value("${file.upload-path}")
    private String uploadPath;

    // ===== 分类管理 =====

    @GetMapping("/category/list")
    public Result<List<ArchiveCategory>> categoryList() {
        return Result.success(archiveService.getAllCategories());
    }

    @PostMapping("/category")
    public Result<Void> addCategory(@RequestBody ArchiveCategory category) {
        archiveService.addCategory(category);
        return Result.success();
    }

    @PutMapping("/category")
    public Result<Void> updateCategory(@RequestBody ArchiveCategory category) {
        archiveService.updateCategory(category);
        return Result.success();
    }

    @DeleteMapping("/category/{id}")
    public Result<Void> deleteCategory(@PathVariable("id") Long id) {
        archiveService.deleteCategory(id);
        return Result.success();
    }

    // ===== 档案文件管理 =====

    @GetMapping("/file/{id}")
    public Result<ArchiveFile> getFileById(@PathVariable("id") Long id) {
        return Result.success(archiveService.getFileById(id));
    }

    @GetMapping("/file/by-path")
    public Result<ArchiveFile> getFileByPath(@RequestParam("filePath") String filePath) {
        return Result.success(archiveService.getFileByFilePath(filePath));
    }

    @GetMapping("/file/student/{studentId}")
    public Result<List<ArchiveFile>> getFilesByStudentId(@PathVariable("studentId") Long studentId) {
        return Result.success(archiveService.getFilesByStudentId(studentId));
    }

    @GetMapping("/file/list")
    public Result<PageResult<ArchiveFile>> fileList(@RequestParam(defaultValue = "1") int pageNum,
                                                    @RequestParam(defaultValue = "10") int pageSize,
                                                    @RequestParam(required = false) Long studentId,
                                                    @RequestParam(required = false) Long categoryId,
                                                    @RequestParam(required = false) Integer status) {
        return Result.success(archiveService.getFileList(pageNum, pageSize, studentId, categoryId, status));
    }

    @PostMapping("/file")
    public Result<Void> addFile(@RequestBody ArchiveFile file) {
        archiveService.addFile(file);
        return Result.success();
    }

    /**
     * 学生上传档案文件（先存本地临时目录，审核通过后上传OSS）
     */
    @PostMapping("/file/upload")
    public Result<ArchiveFile> uploadFile(@RequestParam("file") MultipartFile file,
                                          @RequestParam Long studentId,
                                          @RequestParam Long categoryId,
                                          @RequestParam Long uploadUserId,
                                          @RequestParam(required = false) String description) {
        if (file.isEmpty()) {
            return Result.error(400, "文件不能为空");
        }
        try {
            // 保存到本地临时目录
            String originalName = file.getOriginalFilename();
            String ext = originalName != null && originalName.contains(".")
                    ? originalName.substring(originalName.lastIndexOf(".")) : "";
            String tempFileName = UUID.randomUUID().toString().replace("-", "") + ext;
            File dir = new File(uploadPath + "temp/").getAbsoluteFile();
            if (!dir.exists()) dir.mkdirs();
            File tempFile = new File(dir, tempFileName);
            file.transferTo(tempFile.getAbsoluteFile());

            // 写入DB记录，status=0待审核，filePath存临时路径
            ArchiveFile archiveFile = new ArchiveFile();
            archiveFile.setStudentId(studentId);
            archiveFile.setCategoryId(categoryId);
            archiveFile.setFileName(originalName);
            archiveFile.setFilePath(tempFile.getAbsolutePath());
            archiveFile.setFileSize(file.getSize());
            archiveFile.setDescription(description);
            archiveFile.setStatus(0);
            archiveFile.setUploadUserId(uploadUserId);
            archiveService.addFile(archiveFile);

            return Result.success(archiveFile);
        } catch (IOException e) {
            return Result.error(500, "文件上传失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/file/{id}")
    public Result<Void> deleteFile(@PathVariable("id") Long id) {
        archiveService.deleteFile(id);
        return Result.success();
    }

    /**
     * 预览/下载档案文件，兼容本地临时文件与OSS文件
     */
    @GetMapping("/file/{id}/preview")
    public ResponseEntity<InputStreamResource> previewFile(@PathVariable("id") Long id) throws IOException {
        ArchiveFile archiveFile = archiveService.getFileById(id);
        if (archiveFile == null || archiveFile.getFilePath() == null) {
            return ResponseEntity.notFound().build();
        }
        String filePath = archiveFile.getFilePath();
        String fileName = archiveFile.getFileName() != null ? archiveFile.getFileName() : "file";
        String contentType = guessContentType(fileName);

        InputStream inputStream;
        long contentLength;

        if (filePath.startsWith("http://") || filePath.startsWith("https://")) {
            OSSObject ossObject = ossService.getObject(filePath);
            inputStream = ossObject.getObjectContent();
            contentLength = ossObject.getObjectMetadata().getContentLength();
        } else {
            File localFile = new File(filePath);
            if (!localFile.exists()) {
                return ResponseEntity.notFound().build();
            }
            inputStream = new FileInputStream(localFile);
            contentLength = localFile.length();
        }

        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .contentLength(contentLength)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename*=UTF-8''" + encoded)
                .body(new InputStreamResource(inputStream));
    }

    private String guessContentType(String fileName) {
        if (fileName == null) return "application/octet-stream";
        String n = fileName.toLowerCase();
        if (n.endsWith(".pdf")) return "application/pdf";
        if (n.endsWith(".png")) return "image/png";
        if (n.endsWith(".jpg") || n.endsWith(".jpeg")) return "image/jpeg";
        if (n.endsWith(".gif")) return "image/gif";
        if (n.endsWith(".webp")) return "image/webp";
        if (n.endsWith(".bmp")) return "image/bmp";
        if (n.endsWith(".svg")) return "image/svg+xml";
        if (n.endsWith(".txt") || n.endsWith(".log") || n.endsWith(".md")) return "text/plain;charset=UTF-8";
        if (n.endsWith(".html") || n.endsWith(".htm")) return "text/html;charset=UTF-8";
        if (n.endsWith(".json")) return "application/json";
        return "application/octet-stream";
    }

    @PutMapping("/file/{id}/audit")
    public Result<Void> auditFile(@PathVariable("id") Long id,
                                  @RequestParam Integer status,
                                  @RequestParam Long auditUserId,
                                  @RequestParam(required = false) String auditRemark) {
        archiveService.auditFile(id, status, auditUserId, auditRemark);
        return Result.success();
    }

    // ===== 导出申请管理 =====

    @PostMapping("/export-request")
    public Result<Void> submitExportRequest(@RequestBody ArchiveExportRequest request) {
        archiveService.submitExportRequest(request);
        return Result.success();
    }

    @GetMapping("/export-request/{id}")
    public Result<ArchiveExportRequest> getExportRequestById(@PathVariable("id") Long id) {
        return Result.success(archiveService.getExportRequestById(id));
    }

    @GetMapping("/export-request/student/{studentId}")
    public Result<List<ArchiveExportRequest>> getExportRequestsByStudentId(@PathVariable("studentId") Long studentId) {
        return Result.success(archiveService.getExportRequestsByStudentId(studentId));
    }

    @GetMapping("/export-request/list")
    public Result<PageResult<ArchiveExportRequest>> exportRequestList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) Integer status) {
        return Result.success(archiveService.getExportRequestList(pageNum, pageSize, studentId, status));
    }

    @PutMapping("/export-request/{id}/audit")
    public Result<Void> auditExportRequest(@PathVariable("id") Long id,
                                           @RequestParam Integer status,
                                           @RequestParam Long auditUserId,
                                           @RequestParam(required = false) String auditRemark) {
        archiveService.auditExportRequest(id, status, auditUserId, auditRemark);
        return Result.success();
    }

    @GetMapping("/export-request/valid")
    public Result<List<ArchiveExportRequest>> getValidApprovedRequests(
            @RequestParam Long studentId) {
        return Result.success(archiveService.getValidApprovedRequests(studentId));
    }
}
