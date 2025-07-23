package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.UserVO;
import org.zerock.mapper.UserMapper;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public void register(UserVO user) {
        userMapper.insertUser(user);
    }

    public UserVO login(String userid, String userpw) {
        UserVO user = userMapper.getUserByUserid(userid);
        if (user != null && user.getUserpw().equals(userpw)) {
            return user;
        }
        return null;
    }

    public boolean isUseridAvailable(String userid) {
        return userMapper.getUserByUserid(userid) == null;
    }

    public UserVO getUserByUserno(int userno) {
        return userMapper.getUserByUserno(userno);
    }

    public void requestDelete(int userno) {
        userMapper.markUserAsPendingDelete(userno);
    }

    public boolean cancelPendingDelete(int userno) {
        int updatedRows = userMapper.cancelPendingDelete(userno);
        return updatedRows > 0;
    }

    public void deleteExpiredUsers() {
        List<UserVO> expiredUsers = userMapper.getUsersToDelete();
        for (UserVO user : expiredUsers) {
            userMapper.deleteUserByUserno(user.getUserno());
        }
    }
}
