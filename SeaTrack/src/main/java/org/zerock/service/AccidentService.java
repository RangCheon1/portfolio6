package org.zerock.service;

import org.zerock.mapper.AccidentMapper;
import org.zerock.domain.AccidentVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AccidentService {

    @Autowired
    private AccidentMapper accidentMapper;

    public List<AccidentVO> getAccidentsByHour(int hr) {
        return accidentMapper.selectByHour(hr);
    }
}
