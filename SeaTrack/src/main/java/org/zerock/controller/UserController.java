package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.UserVO;
import org.zerock.domain.ShipVO;
import org.zerock.service.UserService;
import org.zerock.service.ShipService;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private ShipService shipService;

    // 로그인 폼
    @GetMapping("/login")
    public String showLogin(@RequestParam(value = "error", required = false) String error, Model model) {
        if ("true".equals(error)) {
            model.addAttribute("loginError", true);
        }
        return "login";  // /WEB-INF/views/login.jsp
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String userid,
                        @RequestParam String userpw,
                        HttpSession session) {
        UserVO user = userService.login(userid, userpw);
        if (user != null) {
            session.setAttribute("user", user);
            if ("admin".equals(user.getRole())) {
                return "redirect:/admin/users";  // 관리자 페이지로 이동
            }
            return "redirect:/map3";  // 일반 사용자 메인 페이지
        }
        return "redirect:/user/login?error=true";
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/map3";
    }

    // 회원 탈퇴 요청 (유예 상태 변경)
    @PostMapping("/delete")
    public String requestDelete(HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user != null) {
            userService.requestDelete(user.getUserno());
            session.invalidate();  // 로그아웃 처리
        }
        return "redirect:/map3";
    }

    // 회원 탈퇴 취소 요청
    @PostMapping("/cancelDelete")
    public String cancelDelete(HttpSession session, RedirectAttributes rttr) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        boolean success = userService.cancelPendingDelete(user.getUserno());
        if (success) {
            // 세션 정보 갱신
            UserVO refreshedUser = userService.login(user.getUserid(), user.getUserpw());
            session.setAttribute("user", refreshedUser);
            rttr.addFlashAttribute("message", "회원 탈퇴가 취소되었습니다.");
        } else {
            rttr.addFlashAttribute("error", "회원 탈퇴 취소에 실패했습니다.");
        }
        return "redirect:/mypage";
    }

    // 사용자 상세 페이지 - 사용자 정보 + 선박 목록 출력
    @GetMapping("/detail/{userno}")
    public String userDetail(@PathVariable("userno") int userno, Model model) {
        UserVO user = userService.getUserByUserno(userno);
        if (user == null) {
            model.addAttribute("errorMessage", "존재하지 않는 사용자입니다.");
            return "redirect:/user/list";
        }
        List<ShipVO> shipList = shipService.getShipsByUserno(userno);
        model.addAttribute("user", user);
        model.addAttribute("shipList", shipList);
        return "userDetail";
    }


}
