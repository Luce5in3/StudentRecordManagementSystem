package com.student.archive.mapper;

import com.student.archive.entity.ArchiveTransferLetter;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ArchiveTransferLetterMapper {

    ArchiveTransferLetter selectById(@Param("pkLetter") Long pkLetter);

    List<ArchiveTransferLetter> selectByStudentId(@Param("studentId") Long studentId);

    List<ArchiveTransferLetter> selectList(@Param("studentId") Long studentId,
                                           @Param("status") Integer status);

    int insert(ArchiveTransferLetter letter);

    int updateAudit(@Param("pkLetter") Long pkLetter,
                    @Param("status") Integer status,
                    @Param("auditUserId") Long auditUserId,
                    @Param("auditRemark") String auditRemark);

    int updateSend(@Param("pkLetter") Long pkLetter,
                   @Param("sendUserId") Long sendUserId,
                   @Param("trackingNumber") String trackingNumber);
}
