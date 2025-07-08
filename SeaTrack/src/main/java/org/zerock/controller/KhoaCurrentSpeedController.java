package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;

@Controller
public class KhoaCurrentSpeedController {

    private final String KHOA_API_KEY = "3za8sE7jh5wmO4LilBV8qQ==";

    // 관측소 객체
    public static class ObsStation {
        private String code;
        private String name;
        private double lat;
        private double lon;

        public ObsStation(String code, String name, double lat, double lon) {
            this.code = code;
            this.name = name;
            this.lat = lat;
            this.lon = lon;
        }
        public String getCode() { return code; }
        public double getLat() { return lat; }
        public double getLon() { return lon; }
    }

    // 관측소 전체 리스트 (생략없이 모두 포함)
    private final List<ObsStation> obsStations = Arrays.asList(
        new ObsStation("DT_0063","가덕도",35.024,128.81),
        new ObsStation("DT_0032","강화대교",37.731,126.522),
        new ObsStation("DT_0031","거문도",34.028,127.308),
        new ObsStation("DT_0029","거제도",34.801,128.699),
        new ObsStation("DT_0026","고흥발포",34.481,127.342),
        new ObsStation("DT_0049","광양",34.903,127.754),
        new ObsStation("DT_0042","교본초",34.704,128.306),
        new ObsStation("DT_0018","군산",35.975,126.563),
        new ObsStation("DT_0017","대산",37.007,126.352),
        new ObsStation("DT_0065","덕적도",37.226,126.156),
        new ObsStation("DT_0057","동해항",37.494,129.143),
        new ObsStation("DT_0062","마산",35.197,128.576),
        new ObsStation("DT_0023","모슬포",33.214,126.251),
        new ObsStation("DT_0007","목포",34.779,126.375),
        new ObsStation("DT_0006","묵호",37.55,129.116),
        new ObsStation("DT_0025","보령",36.406,126.486),
        new ObsStation("DT_0005","부산",35.096,129.035),
        new ObsStation("DT_0056","부산항신항",35.077,128.784),
        new ObsStation("DT_0061","삼천포",34.924,128.069),
        new ObsStation("DT_0094","서거차도",34.251,125.915),
        new ObsStation("DT_0010","서귀포",33.24,126.561),
        new ObsStation("DT_0051","서천마량",36.128,126.495),
        new ObsStation("DT_0022","성산포",33.474,126.927),
        new ObsStation("DT_0093","소무의도",37.373,126.44),
        new ObsStation("DT_0012","속초",38.207,128.594),
        new ObsStation("IE_0061","신안가거초",33.941,124.592),
        new ObsStation("DT_0008","안산",37.192,126.647),
        new ObsStation("DT_0067","안흥",36.674,126.129),
        new ObsStation("DT_0037","어청도",36.117,125.984),
        new ObsStation("DT_0016","여수",34.747,127.765),
        new ObsStation("DT_0092","여호항",34.661,127.469),
        new ObsStation("DT_0003","영광",35.426,126.42),
        new ObsStation("DT_0044","영종대교",37.545,126.584),
        new ObsStation("DT_0043","영흥도",37.238,126.428),
        new ObsStation("IE_0062","옹진소청초",37.423,124.738),
        new ObsStation("DT_0027","완도",34.315,126.759),
        new ObsStation("DT_0039","왕돌초",36.719,129.732),
        new ObsStation("DT_0013","울릉도",37.491,130.913),
        new ObsStation("DT_0020","울산",35.501,129.387),
        new ObsStation("DT_0068","위도",35.618,126.301),
        new ObsStation("IE_0060","이어도",32.122,125.182),
        new ObsStation("DT_0001","인천",37.451,126.592),
        new ObsStation("DT_0052","인천송도",37.338,126.586),
        new ObsStation("DT_0024","장항",36.006,126.687),
        new ObsStation("DT_0004","제주",33.527,126.543),
        new ObsStation("DT_0028","진도",34.377,126.308),
        new ObsStation("DT_0021","추자도",33.961,126.3),
        new ObsStation("DT_0050","태안",36.913,126.238),
        new ObsStation("DT_0014","통영",34.827,128.434),
        new ObsStation("DT_0002","평택",36.966,126.822),
        new ObsStation("DT_0091","포항",36.051,129.376),
        new ObsStation("DT_0066","향화도",35.167,126.359),
        new ObsStation("DT_0011","후포",36.677,129.453),
        new ObsStation("DT_0035","흑산도",34.684,125.435)
    );

    private double distance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // 지구 반경(km)
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon/2) * Math.sin(dLon/2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    private ObsStation findClosestStation(double lat, double lon) {
        ObsStation closest = null;
        double minDist = Double.MAX_VALUE;
        for (ObsStation s : obsStations) {
            double dist = distance(lat, lon, s.getLat(), s.getLon());
            if (dist < minDist) {
                minDist = dist;
                closest = s;
            }
        }
        return closest;
    }

    @GetMapping(value = "/api/khoaCurrentSpeed", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getCurrentSpeedByCoord(
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng
    ) throws Exception {
        String obsCode = "DT_0001"; // 기본값 인천

        if (lat != null && lng != null) {
            ObsStation closest = findClosestStation(lat, lng);
            if (closest != null) {
                obsCode = closest.getCode();
            }
        }

        String urlStr = "http://www.khoa.go.kr/api/oceangrid/tideObsRecent/search.do"
                + "?ServiceKey=" + URLEncoder.encode(KHOA_API_KEY, "UTF-8")
                + "&ObsCode=" + URLEncoder.encode(obsCode, "UTF-8")
                + "&ResultType=json";

        System.out.println("API 호출 URL: " + urlStr);

        return httpGet(urlStr);
    }

    private String httpGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br;
        int responseCode = conn.getResponseCode();
        if (responseCode >= 200 && responseCode < 300) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        conn.disconnect();
        
        System.out.println("KHOA API 원본 JSON 응답:\n" + sb.toString());

        return sb.toString();
    }
}
