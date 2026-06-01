package com.student.archive.mapper;

import com.student.archive.entity.ArchiveDestination;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ArchiveDestinationMapper {

    ArchiveDestination selectById(@Param("pkDestination") Long pkDestination);

    ArchiveDestination selectByStudentId(@Param("studentId") Long studentId);

    List<ArchiveDestination> selectList(@Param("studentId") Long studentId,
                                        @Param("status") String status);

    int insert(ArchiveDestination destination);

    int update(ArchiveDestination destination);

    int updateStatus(@Param("pkDestination") Long pkDestination,
                     @Param("status") String status,
                     @Param("sendUserId") Long sendUserId,
                     @Param("trackingNumber") String trackingNumber);
}
