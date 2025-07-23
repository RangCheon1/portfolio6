package org.zerock.service;

import org.zerock.domain.ShipVO;
import java.util.List;

public interface ShipService {
    List<ShipVO> getShipsByUserno(int userno);
    void registerShip(ShipVO ship);
    void deleteShip(int shipno, int userno);
    void deleteMultipleShips(List<Integer> shipnos, int userno);
    ShipVO getShipByShipno(int shipno);
    void updateShip(ShipVO ship);
}
