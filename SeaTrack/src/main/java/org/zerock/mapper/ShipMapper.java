package org.zerock.mapper;

import org.zerock.domain.ShipVO;
import java.util.List;
import java.util.Map;

public interface ShipMapper {
    List<ShipVO> getShipsByUserno(int userno);
    void registerShip(ShipVO ship);
    void deleteShip(Map<String, Object> param);
    void deleteMultipleShips(Map<String, Object> param);
    ShipVO getShipByShipno(int shipno);
    void updateShip(ShipVO ship);
}
