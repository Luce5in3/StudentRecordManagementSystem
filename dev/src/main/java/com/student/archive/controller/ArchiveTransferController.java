package com.student.archive.controller;

import com.student.archive.common.PageResult;
import com.student.archive.common.Result;
import com.student.archive.entity.ArchiveDestination;
import com.student.archive.entity.ArchiveTransferLetter;
import com.student.archive.service.ArchiveTransferService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/archive-transfer")
@RequiredArgsConstructor
public class ArchiveTransferController {

    private final ArchiveTransferService archiveTransferService;

    // ===== 档案去向管理 =====

    @GetMapping("/destination/{id}")
    public Result<ArchiveDestination> getDestinationById(@PathVariable("id") Long id) {
        return Result.success(archiveTransferService.getDestinationById(id));
    }

    @GetMapping("/destination/student/{studentId}")
    public Result<ArchiveDestination> getDestinationByStudentId(@PathVariable("studentId") Long studentId) {
        ArchiveDestination dest = archiveTransferService.getDestinationByStudentId(studentId);
        // 如果学生是在读状态且没有去向记录，返回默认本校
        if (dest == null) {
            dest = new ArchiveDestination();
            dest.setDestinationType("本校");
            dest.setDestinationName("本校");
            dest.setStatus("在校");
        }
        return Result.success(dest);
    }

    @GetMapping("/destination/list")
    public Result<PageResult<ArchiveDestination>> destinationList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) String status) {
        return Result.success(archiveTransferService.getDestinationList(pageNum, pageSize, studentId, status));
    }

    @PostMapping("/destination")
    public Result<Void> saveOrUpdateDestination(@RequestBody ArchiveDestination destination) {
        archiveTransferService.saveOrUpdateDestination(destination);
        return Result.success();
    }

    @PutMapping("/destination/{id}/send")
    public Result<Void> sendArchive(@PathVariable("id") Long id,
                                    @RequestParam Long sendUserId,
                                    @RequestParam(required = false) String trackingNumber) {
        archiveTransferService.sendArchive(id, sendUserId, trackingNumber);
        return Result.success();
    }

    // ===== 调档函申请管理 =====

    @GetMapping("/letter/{id}")
    public Result<ArchiveTransferLetter> getLetterById(@PathVariable("id") Long id) {
        return Result.success(archiveTransferService.getTransferLetterById(id));
    }

    @GetMapping("/letter/student/{studentId}")
    public Result<List<ArchiveTransferLetter>> getLettersByStudentId(@PathVariable("studentId") Long studentId) {
        return Result.success(archiveTransferService.getTransferLettersByStudentId(studentId));
    }

    @GetMapping("/letter/list")
    public Result<PageResult<ArchiveTransferLetter>> letterList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) Integer status) {
        return Result.success(archiveTransferService.getTransferLetterList(pageNum, pageSize, studentId, status));
    }

    @PostMapping("/letter")
    public Result<Void> submitLetter(@RequestBody ArchiveTransferLetter letter) {
        archiveTransferService.submitTransferLetter(letter);
        return Result.success();
    }

    @PutMapping("/letter/{id}/audit")
    public Result<Void> auditLetter(@PathVariable("id") Long id,
                                    @RequestParam Integer status,
                                    @RequestParam Long auditUserId,
                                    @RequestParam(required = false) String auditRemark) {
        archiveTransferService.auditTransferLetter(id, status, auditUserId, auditRemark);
        return Result.success();
    }

    @PutMapping("/letter/{id}/send")
    public Result<Void> sendTransferArchive(@PathVariable("id") Long id,
                                            @RequestParam Long sendUserId,
                                            @RequestParam(required = false) String trackingNumber) {
        archiveTransferService.sendTransferArchive(id, sendUserId, trackingNumber);
        return Result.success();
    }
}
