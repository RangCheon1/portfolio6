package org.zerock.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.UserVO;
import org.zerock.domain.ShipVO;
import org.zerock.service.AdminUserService;
import org.zerock.service.ShipService;

import java.util.List;

@Controller
@RequestMapping("/admin/users")
public class AdminController {

    @Autowired
    private AdminUserService adminUserService;

    @Autowired
    private ShipService shipService;

    // 회원 목록 조회 (예: GET /admin/users?status=active)
    @GetMapping("")
    public String userList(@RequestParam(value = "status", required = false) String status, Model model) {
        List<UserVO> users = adminUserService.getUsers(status);
        model.addAttribute("users", users);
        model.addAttribute("status", status);
        return "admin/users";  // 회원 목록 JSP 경로
    }

    // 회원 상세 조회 (예: GET /admin/users/detail/{userno})
    @GetMapping("/detail/{userno}")
    public String userDetail(@PathVariable int userno, Model model) {
        UserVO user = adminUserService.getUserByUserno(userno);
        if (user == null) {
            model.addAttribute("errorMessage", "존재하지 않는 사용자입니다.");
            return "redirect:/admin/users";
        }
        List<ShipVO> shipList = shipService.getShipsByUserno(userno);
        model.addAttribute("user", user);
        model.addAttribute("shipList", shipList);
        return "admin/userDetail";  // 사용자 상세 JSP 경로
    }

    // 회원 상태 변경 처리 (예: POST /admin/users/changeStatus)
    @PostMapping("/changeStatus")
    public String changeStatus(@RequestParam int userno, @RequestParam String status) {
        adminUserService.changeUserStatus(userno, status);
        return "redirect:/admin/users";
    }

    // 회원 즉시 삭제 처리 (예: POST /admin/users/delete)
    @PostMapping("/delete")
    public String deleteUser(@RequestParam int userno) {
        adminUserService.deleteUser(userno);
        return "redirect:/admin/users?status=pending_delete";
    }

    // 회원 정보 수정 처리 (예: POST /admin/users/update)
    @PostMapping("/update")
    public String updateUser(UserVO user, RedirectAttributes rttr) {
        adminUserService.updateUser(user);
        rttr.addFlashAttribute("msg", "회원정보가 수정되었습니다.");
        return "redirect:/admin/users/detail/" + user.getUserno();
    }


    // 선박 추가 처리 (예: POST /admin/users/ship/add)
    @PostMapping("/ship/add")
    public String addShip(ShipVO ship) {
        shipService.registerShip(ship);
        return "redirect:/admin/users/detail/" + ship.getUserno();
    }

    // 선박 삭제 처리 (예: POST /admin/users/ship/delete)
    @PostMapping("/ship/delete")
    public String deleteShip(@RequestParam int shipno, @RequestParam int userno) {
        shipService.deleteShip(shipno, userno);
        return "redirect:/admin/users/detail/" + userno;
    }
}
