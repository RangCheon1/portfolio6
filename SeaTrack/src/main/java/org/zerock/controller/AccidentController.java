package org.zerock.controller;

import org.zerock.service.AccidentService;
import org.zerock.domain.AccidentVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/accident")
public class AccidentController {

    @Autowired
    private AccidentService accidentService;

    @GetMapping("/byHour")
    public List<AccidentVO> getAccidentsByHour(@RequestParam("hr") int hr) {
        return accidentService.getAccidentsByHour(hr);
    }
}
