package org.zerock.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.service.UserService;

@Component
public class UserBatchScheduler {

    @Autowired
    private UserService userService;

    /**
     * 매일 자정 0시에 실행됨 (크론 표현식: 초 분 시 일 월 요일)
     * 유예기간 7일 지난 회원 완전 삭제
     */
    @Scheduled(cron = "0 0 0 * * *")
    public void deleteExpiredUsersBatch() {
        System.out.println("[스케줄러 실행] 유예기간 지난 회원 삭제 실행");
        userService.deleteExpiredUsers();
    }
}
