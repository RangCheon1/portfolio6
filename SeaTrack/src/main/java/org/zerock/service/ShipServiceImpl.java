package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.ShipVO;
import org.zerock.mapper.ShipMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ShipServiceImpl implements ShipService {

    @Autowired
    private ShipMapper shipMapper;

    @Override
    public List<ShipVO> getShipsByUserno(int userno) {
        return shipMapper.getShipsByUserno(userno);
    }

    @Override
    public void registerShip(ShipVO ship) {
        shipMapper.registerShip(ship);
    }

    @Override
    public void deleteShip(int shipno, int userno) {
        Map<String, Object> map = new HashMap<>();
        map.put("shipno", shipno);
        map.put("userno", userno);
        shipMapper.deleteShip(map);
    }

    @Override
    public void deleteMultipleShips(List<Integer> shipnos, int userno) {
        Map<String, Object> map = new HashMap<>();
        map.put("shipnos", shipnos);
        map.put("userno", userno);
        shipMapper.deleteMultipleShips(map);
    }

    @Override
    public ShipVO getShipByShipno(int shipno) {
        return shipMapper.getShipByShipno(shipno);
    }

    @Override
    public void updateShip(ShipVO ship) {
        shipMapper.updateShip(ship);
    }
}
