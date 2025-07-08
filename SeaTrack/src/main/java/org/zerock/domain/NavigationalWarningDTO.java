package org.zerock.domain;

import lombok.Data;

@Data
public class NavigationalWarningDTO {
    private String docNum;
    private String area;
    private String positionNm;
    private String position;
    private String positionDesc;
    private String alarmDate;
    private String alarmTime;
    private String seaPos;
}