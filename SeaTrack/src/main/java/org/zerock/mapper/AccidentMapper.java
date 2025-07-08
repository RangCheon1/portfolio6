package org.zerock.mapper;

import org.zerock.domain.AccidentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AccidentMapper {
    List<AccidentVO> selectByHour(@Param("hr") int hr);
}
