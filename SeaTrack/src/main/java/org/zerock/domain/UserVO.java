package org.zerock.domain;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class UserVO {
    private int userno;
    private String userid;
    private String username;
    private String userpw;
    private String email;
    private Timestamp regdate;
    private String status;
    private Timestamp deleteRequestedAt;
    private String role;  // admin, user 구분용
}
