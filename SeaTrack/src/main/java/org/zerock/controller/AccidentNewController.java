package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.AccidentNewVO;
import org.zerock.service.AccidentNewService;

import java.util.List;

@RestController
@RequestMapping("/accidentNew")
public class AccidentNewController {

    @Autowired
    private AccidentNewService accidentNewService;

    @GetMapping("/byGrid")
    public List<AccidentNewVO> getAccidentsByGrid(
        @RequestParam("minLat") double minLat,
        @RequestParam("maxLat") double maxLat,
        @RequestParam("minLng") double minLng,
        @RequestParam("maxLng") double maxLng
    ) {
        return accidentNewService.getAccidentsByGrid(minLat, maxLat, minLng, maxLng);
    }
}
