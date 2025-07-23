package org.zerock.mapper;

import org.zerock.domain.UserVO;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface AdminUserMapper {

    List<UserVO> getAllUsers();

    List<UserVO> getUsersByStatus(String status);

    void updateUserStatus(@Param("userno") int userno, @Param("status") String status);

    void deleteUserByUserno(int userno);
    
    UserVO getUserByUserno(int userno);
    
    void updateUser(UserVO user);
}
