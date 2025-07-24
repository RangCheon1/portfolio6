package org.zerock.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.zerock.domain.AccidentNewVO;

import java.util.List;

@Mapper
public interface AccidentNewMapper {
    List<AccidentNewVO> selectByGrid(
        @Param("minLat") double minLat,
        @Param("maxLat") double maxLat,
        @Param("minLng") double minLng,
        @Param("maxLng") double maxLng
    );
}
