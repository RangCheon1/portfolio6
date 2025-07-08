package org.zerock.mapper;

import java.util.Map;

public interface GridMapper {
    Map<String, Object> getCoordinatesByGridId(String gridId);  
}
