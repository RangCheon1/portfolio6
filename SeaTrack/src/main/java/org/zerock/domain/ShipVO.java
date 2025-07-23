package org.zerock.domain;

import lombok.Data;
import java.sql.Timestamp;

@Data
public class ShipVO {
    private int shipno;
    private int userno;
    private String shipname;
    private String shiptype;
    private String ownername;
    private Timestamp regdate;
}
