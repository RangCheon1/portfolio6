package org.zerock.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.NavigationalWarningDTO;
import org.zerock.service.NavigationalWarningService;

@RestController
@RequestMapping("/api/navi-warning")
public class NavigationalWarningController {

    private final NavigationalWarningService warningService;

    public NavigationalWarningController(NavigationalWarningService warningService) {
        this.warningService = warningService;
    }

    @GetMapping(value = "/list", produces = "application/json")
    public ResponseEntity<List<NavigationalWarningDTO>> getWarningList() {
        return ResponseEntity.ok(warningService.getWarningList());
    }

    @GetMapping(value = "/detail", produces = "application/json")
    public ResponseEntity<List<NavigationalWarningDTO>> getWarningDetail(@RequestParam("doc_num") String docNum) {
        return ResponseEntity.ok(warningService.getWarningDetail(docNum));
    }
}