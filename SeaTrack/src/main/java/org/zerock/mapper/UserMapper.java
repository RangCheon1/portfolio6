package org.zerock.mapper;

import org.zerock.domain.UserVO;
import java.util.List;

public interface UserMapper {

    void insertUser(UserVO user);

    UserVO getUserByUserid(String userid);

    UserVO getUserByUserno(int userno);

    void markUserAsPendingDelete(int userno);

    int cancelPendingDelete(int userno);

    List<UserVO> getUsersToDelete();

    void deleteUserByUserno(int userno);
}
