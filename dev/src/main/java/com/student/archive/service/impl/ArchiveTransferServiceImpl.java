package com.student.archive.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.student.archive.common.PageResult;
import com.student.archive.entity.ArchiveDestination;
import com.student.archive.entity.ArchiveTransferLetter;
import com.student.archive.mapper.ArchiveDestinationMapper;
import com.student.archive.mapper.ArchiveTransferLetterMapper;
import com.student.archive.service.ArchiveTransferService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ArchiveTransferServiceImpl implements ArchiveTransferService {

    private final ArchiveDestinationMapper archiveDestinationMapper;
    private final ArchiveTransferLetterMapper archiveTransferLetterMapper;

    // ===== 档案去向管理 =====

    @Override
    public ArchiveDestination getDestinationById(Long pkDestination) {
        return archiveDestinationMapper.selectById(pkDestination);
    }

    @Override
    public ArchiveDestination getDestinationByStudentId(Long studentId) {
        return archiveDestinationMapper.selectByStudentId(studentId);
    }

    @Override
    public PageResult<ArchiveDestination> getDestinationList(int pageNum, int pageSize, Long studentId, String status) {
        PageHelper.startPage(pageNum, pageSize);
        List<ArchiveDestination> list = archiveDestinationMapper.selectList(studentId, status);
        PageInfo<ArchiveDestination> pageInfo = new PageInfo<>(list);
        return new PageResult<>(pageInfo.getTotal(), pageNum, pageSize, pageInfo.getList());
    }

    @Override
    @Transactional
    public void saveOrUpdateDestination(ArchiveDestination destination) {
        ArchiveDestination existing = archiveDestinationMapper.selectByStudentId(destination.getStudentId());
        if (existing != null) {
            destination.setPkDestination(existing.getPkDestination());
            archiveDestinationMapper.update(destination);
        } else {
            if (destination.getStatus() == null) {
                destination.setStatus("待处理");
            }
            archiveDestinationMapper.insert(destination);
        }
    }

    @Override
    @Transactional
    public void sendArchive(Long pkDestination, Long sendUserId, String trackingNumber) {
        archiveDestinationMapper.updateStatus(pkDestination, "已寄出", sendUserId, trackingNumber);
    }

    // ===== 调档函申请管理 =====

    @Override
    public ArchiveTransferLetter getTransferLetterById(Long pkLetter) {
        return archiveTransferLetterMapper.selectById(pkLetter);
    }

    @Override
    public List<ArchiveTransferLetter> getTransferLettersByStudentId(Long studentId) {
        return archiveTransferLetterMapper.selectByStudentId(studentId);
    }

    @Override
    public PageResult<ArchiveTransferLetter> getTransferLetterList(int pageNum, int pageSize, Long studentId, Integer status) {
        PageHelper.startPage(pageNum, pageSize);
        List<ArchiveTransferLetter> list = archiveTransferLetterMapper.selectList(studentId, status);
        PageInfo<ArchiveTransferLetter> pageInfo = new PageInfo<>(list);
        return new PageResult<>(pageInfo.getTotal(), pageNum, pageSize, pageInfo.getList());
    }

    @Override
    @Transactional
    public void submitTransferLetter(ArchiveTransferLetter letter) {
        archiveTransferLetterMapper.insert(letter);
    }

    @Override
    @Transactional
    public void auditTransferLetter(Long pkLetter, Integer status, Long auditUserId, String auditRemark) {
        archiveTransferLetterMapper.updateAudit(pkLetter, status, auditUserId, auditRemark);

        // 审核通过时，同步创建或更新档案去向记录
        if (status != null && status == 1) {
            ArchiveTransferLetter letter = archiveTransferLetterMapper.selectById(pkLetter);
            if (letter != null) {
                ArchiveDestination destination = archiveDestinationMapper.selectByStudentId(letter.getStudentId());
                if (destination == null) {
                    destination = new ArchiveDestination();
                    destination.setStudentId(letter.getStudentId());
                    destination.setDestinationType(letter.getDestinationType());
                    destination.setDestinationName(letter.getDestinationName());
                    destination.setDestinationAddress(letter.getDestinationAddress());
                    destination.setContactPerson(letter.getContactPerson());
                    destination.setContactPhone(letter.getContactPhone());
                    destination.setStatus("待处理");
                    archiveDestinationMapper.insert(destination);
                } else {
                    destination.setDestinationType(letter.getDestinationType());
                    destination.setDestinationName(letter.getDestinationName());
                    destination.setDestinationAddress(letter.getDestinationAddress());
                    destination.setContactPerson(letter.getContactPerson());
                    destination.setContactPhone(letter.getContactPhone());
                    archiveDestinationMapper.update(destination);
                }
            }
        }
    }

    @Override
    @Transactional
    public void sendTransferArchive(Long pkLetter, Long sendUserId, String trackingNumber) {
        archiveTransferLetterMapper.updateSend(pkLetter, sendUserId, trackingNumber);

        // 同步更新档案去向表状态
        ArchiveTransferLetter letter = archiveTransferLetterMapper.selectById(pkLetter);
        if (letter != null) {
            ArchiveDestination destination = archiveDestinationMapper.selectByStudentId(letter.getStudentId());
            if (destination != null) {
                archiveDestinationMapper.updateStatus(destination.getPkDestination(), "已寄出", sendUserId, trackingNumber);
            }
        }
    }
}
