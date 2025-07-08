	package org.zerock.controller;
	
	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.GetMapping;
	
	@Controller
	public class MapController {
		
		
		@GetMapping("/map")
	    public String mapPage() {
	        return "map";
	    }
		
		@GetMapping("/map3")
	    public String mapPage1() {
	        return "map3";
	    }
		
		@GetMapping("/map4")
	    public String mapPage2() {
	        return "map4";
	    }
	}
