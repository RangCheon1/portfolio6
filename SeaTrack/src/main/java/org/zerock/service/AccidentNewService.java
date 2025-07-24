package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.AccidentNewVO;
import org.zerock.mapper.AccidentNewMapper;

import java.util.List;

@Service
public class AccidentNewService {

    @Autowired
    private AccidentNewMapper accidentNewMapper;

    public List<AccidentNewVO> getAccidentsByGrid(double minLat, double maxLat, double minLng, double maxLng) {
        return accidentNewMapper.selectByGrid(minLat, maxLat, minLng, maxLng);
    }
}
