package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.UserVO;
import org.zerock.mapper.AdminUserMapper;

import java.util.List;

@Service
public class AdminUserService {

    @Autowired
    private AdminUserMapper adminUserMapper;

    // 전체 사용자 또는 상태별 사용자 조회
    public List<UserVO> getUsers(String status) {
        if (status == null || status.isEmpty()) {
            return adminUserMapper.getAllUsers();
        }
        return adminUserMapper.getUsersByStatus(status);
    }

    // 사용자 상태 변경
    public void changeUserStatus(int userno, String status) {
        adminUserMapper.updateUserStatus(userno, status);
    }

    // 사용자 삭제
    public void deleteUser(int userno) {
        adminUserMapper.deleteUserByUserno(userno);
    }

    // 사용자 상세 조회 메서드 추가
    public UserVO getUserByUserno(int userno) {
        return adminUserMapper.getUserByUserno(userno);
    }
    
    public void updateUser(UserVO user) {
        adminUserMapper.updateUser(user);
    }
}
