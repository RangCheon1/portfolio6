package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.ShipVO;
import org.zerock.domain.UserVO;
import org.zerock.service.ShipService;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/mypage")
public class MypageController {

    @Autowired
    private ShipService shipService;

    // ✅ 마이페이지 메인 (회원정보 + 선박 목록)
    @GetMapping("")
    public String mypage(HttpSession session, Model model) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) {
            model.addAttribute("message", "로그인이 필요합니다.");
            model.addAttribute("redirectUrl", "/user/login");
            return "alertRedirect";  // alert 후 redirect용 JSP
        }

        List<ShipVO> shipList = shipService.getShipsByUserno(user.getUserno());
        model.addAttribute("user", user);
        model.addAttribute("shipList", shipList);
        return "mypage";  // /WEB-INF/views/mypage.jsp
    }

    // ✅ 선박 등록 폼
    @GetMapping("/registerShip")
    public String showRegisterShip() {
        return "registerShip";  // /WEB-INF/views/registerShip.jsp
    }

    // ✅ 선박 등록 처리
    @PostMapping("/registerShip")
    public String registerShip(ShipVO ship, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        ship.setUserno(user.getUserno());
        shipService.registerShip(ship);
        return "redirect:/mypage";
    }

    // ✅ 선박 수정 폼
    @GetMapping("/editShip")
    public String showEditShip(@RequestParam("shipno") int shipno, HttpSession session, Model model) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        ShipVO ship = shipService.getShipByShipno(shipno);
        if (ship == null || ship.getUserno() != user.getUserno()) return "redirect:/mypage";

        model.addAttribute("ship", ship);
        return "editShip";  // /WEB-INF/views/editShip.jsp
    }

    // ✅ 선박 수정 처리
    @PostMapping("/editShip")
    public String editShip(ShipVO ship, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        ship.setUserno(user.getUserno());
        shipService.updateShip(ship);
        return "redirect:/mypage";
    }

    // ✅ 선박 단일 삭제
    @PostMapping("/deleteShip")
    public String deleteShip(@RequestParam("shipno") int shipno, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        shipService.deleteShip(shipno, user.getUserno());
        return "redirect:/mypage";
    }

    // ✅ 선박 다중 삭제
    @PostMapping("/deleteShips")
    public String deleteMultipleShips(@RequestParam("shipnos") List<Integer> shipnos, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        shipService.deleteMultipleShips(shipnos, user.getUserno());
        return "redirect:/mypage";
    }
}
