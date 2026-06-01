package com.student.archive.mapper;

import com.student.archive.entity.ArchiveFile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ArchiveFileMapper {

    ArchiveFile selectById(@Param("pkArchiveFile") Long pkArchiveFile);

    List<ArchiveFile> selectByStudentId(@Param("studentId") Long studentId);

    List<ArchiveFile> selectList(@Param("studentId") Long studentId, @Param("categoryId") Long categoryId,
                                 @Param("status") Integer status);

    int insert(ArchiveFile file);

    int update(ArchiveFile file);

    int deleteById(@Param("pkArchiveFile") Long pkArchiveFile);

    int updateStatus(@Param("pkArchiveFile") Long pkArchiveFile, @Param("status") Integer status,
                     @Param("auditUserId") Long auditUserId, @Param("auditRemark") String auditRemark);

    int countTotal();

    int countByStatus(@Param("status") Integer status);

    int updateFilePath(@Param("pkArchiveFile") Long pkArchiveFile, @Param("filePath") String filePath);

    ArchiveFile selectByFilePath(@Param("filePath") String filePath);
}
