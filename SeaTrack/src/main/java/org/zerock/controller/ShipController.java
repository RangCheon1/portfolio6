package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.service.TrafficService;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
public class ShipController {

    // 공공데이터포털에서 받은 디코딩된 원본 서비스키
    private final String SERVICE_KEY_RAW = "XjCyJUkO701bxF7T2UXBMfepjr5kVC/kxx2D6e9C3oghfhv5GLURXFEnWigcrmwMIBRY6Gmy9NC+XykRoRy8aw==";

    @Autowired
    private TrafficService trafficService;

    /**
     * 원본 실시간 교통량 API 반환 (원본 JSON 그대로)
     */
    @GetMapping(value = "/api/ships", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getShipData() throws Exception {
        // 서비스키 URL 인코딩
        String encodedServiceKey = URLEncoder.encode(SERVICE_KEY_RAW, "UTF-8");

        String urlStr = "https://apis.data.go.kr/B554035/realtime/get_realtime"
                + "?serviceKey=" + encodedServiceKey
                + "&pageNo=1"
                + "&numOfRows=5000"
                + "&dataType=JSON";

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br;
        int responseCode = conn.getResponseCode();
        if (responseCode >= 200 && responseCode <= 300) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        conn.disconnect();

        return sb.toString();
    }

    /**
     * 좌표 포함된 교통량 데이터 반환 (가공된 JSON)
     */
    @GetMapping(value = "/api/ships/with-coordinates", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<Map<String, Object>> getShipDataWithCoordinates() {
        try {
            System.out.println("getShipDataWithCoordinates 호출됨");
            String apiData = getShipData();
            return trafficService.processTrafficData(apiData);
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    /**
     * 해양 기상정보 페이지 (JSP)
     */
    @GetMapping("/marineWeather")
    public String showMarineWeatherPage() {
        return "marineWeather";  // /WEB-INF/views/marineWeather.jsp 렌더링
    }

    /**
     * KHOA 해류속도 페이지 (JSP)
     */
    @GetMapping("/khoaSpeed")
    public String showKhoaSpeedPage() {
        return "khoaSpeed";  // /WEB-INF/views/khoaSpeed.jsp 렌더링
    }
}
