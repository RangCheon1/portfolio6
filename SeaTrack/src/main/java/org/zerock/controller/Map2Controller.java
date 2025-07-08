package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Map2Controller {
	
	
	@GetMapping("/map2")
    public String map2Page() {
        return "map2";
    }
	
	@GetMapping("/test")
	public String testPage() {
		return "test";
	}
	
}
