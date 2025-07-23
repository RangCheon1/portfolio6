package org.zerock.controller;

import org.zerock.domain.UserVO;
import org.zerock.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")  // 중요: 공통 URL prefix
public class UserAuthController {

    @Autowired
    private UserService userService;

    // 회원가입 페이지
    @GetMapping("/register")
    public String showRegister() {
        return "register";  // /WEB-INF/views/register.jsp
    }

    // 회원가입 처리
    @PostMapping("/register")
    public String register(UserVO user) {
        userService.register(user);
        return "redirect:/user/login";
    }

    // 아이디 중복 확인 (AJAX)
    @GetMapping(value = "/checkUserid", produces = "application/json")
    @ResponseBody
    public Map<String, Object> checkUserid(@RequestParam String userid) {
        boolean available = userService.isUseridAvailable(userid);
        Map<String, Object> result = new HashMap<>();
        result.put("available", available);
        return result;
    }
}
