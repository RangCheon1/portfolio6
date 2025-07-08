package org.zerock.controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@Controller
public class MarineWeatherController {

    private final String KMA_API_KEY = "GHfVXBZiT_G31VwWYs_x0Q";

    @GetMapping(value = "/api/kmaMarineWeather", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getMarineWeather() throws Exception {
        String tm = "202501011200"; 
        String stn = "0";

        String urlStr = "https://apihub.kma.go.kr/api/typ01/url/sea_obs.php"
                + "?tm=" + URLEncoder.encode(tm, "UTF-8")
                + "&stn=" + URLEncoder.encode(stn, "UTF-8")
                + "&authKey=" + URLEncoder.encode(KMA_API_KEY, "UTF-8")
                + "&help=0";

        String response = httpGet(urlStr);

        JSONArray parsedData = parseKmaResponse(response);

        JSONObject result = new JSONObject();
        result.put("kmaData", parsedData);

        return result.toString();
    }

    private JSONArray parseKmaResponse(String response) {
        JSONArray jsonArray = new JSONArray();

        String[] lines = response.split("\\r?\\n");
        for (String line : lines) {
            line = line.trim();
            if (line.isEmpty() || line.startsWith("#START7777#") || line.startsWith("#END")) {
                continue;
            }

            String[] fields = line.split(",\\s*");  // 쉼표+옵션 공백 기준 분리

            if (fields.length < 12) continue;

            JSONObject obj = new JSONObject();
            obj.put("TP", fields[0]);
            obj.put("TM", fields[1]);
            obj.put("STN_ID", fields[2]);
            obj.put("STN_KO", fields[3]);
            obj.put("LON", fields[4]);
            obj.put("LAT", fields[5]);
            obj.put("WH", fields[6]);
            obj.put("WD", fields[7]);
            obj.put("WS", fields[8]);
            obj.put("WS_GST", fields[9]);
            obj.put("TW", fields[10]);
            obj.put("TA", fields[11]);

            jsonArray.put(obj);
        }

        return jsonArray;
    }


    private String httpGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        String contentType = conn.getContentType();

        BufferedReader br;
        int responseCode = conn.getResponseCode();

        if (responseCode >= 200 && responseCode < 300) {
            if (contentType != null && contentType.toLowerCase().contains("euc-kr")) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "EUC-KR"));
            } else {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            }
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line).append("\n");
        }

        br.close();
        conn.disconnect();

        return sb.toString();
    }

}
