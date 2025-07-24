package org.zerock.domain;

import lombok.Data;

@Data
public class AccidentNewVO {
    private String accidentName;
    private String accidentDatetime;
    private String accidentType;
    private String safetyAccidentType;
    private Long deaths;
    private Long missing;
    private Long deathsAndMissing;
    private Long injured;
    private String seaArea;
    private String shipUsageStats;
    private String shipUsageLarge;
    private String shipUsageMedium;
    private String shipUsageSmall;
    private Double shipTonnage;
    private String tonnageStats;
    private Double latitude;
    private Double longitude;
}
