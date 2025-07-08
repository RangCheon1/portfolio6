package org.zerock.service;

import org.json.JSONArray;
import org.json.JSONObject;
import org.zerock.mapper.GridMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class TrafficService {

    @Autowired
    private GridMapper gridMapper;

    public List<Map<String, Object>> processTrafficData(String apiResponse) {
        System.out.println("원본 JSON : " + apiResponse);
        List<Map<String, Object>> resultList = new ArrayList<>();

        String trimmed = apiResponse.trim();
        if (!(trimmed.startsWith("{") || trimmed.startsWith("["))) {
            System.err.println("API 응답이 JSON 형식이 아닙니다.");
            return resultList; // 빈 리스트 반환
        }

        try {
            JSONObject json = new JSONObject(apiResponse);
            JSONArray items = json.getJSONObject("response")
                                 .getJSONObject("body")
                                 .getJSONObject("items")
                                 .getJSONArray("item");

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                String apiGridId = item.getString("grid_id");
                int vmtc = item.getInt("vmtc");
                double dnsty = item.getDouble("dnsty");

                Map<String, Object> coords = gridMapper.getCoordinatesByGridId(apiGridId);
                if (coords != null) {
                    Map<String, Object> combined = new HashMap<>();
                    combined.put("grid_id", apiGridId);
                    combined.put("vmtc", vmtc);
                    combined.put("dnsty", dnsty);
                    combined.putAll(coords);
                    resultList.add(combined);
                }
            }
        } catch (Exception e) {
            System.err.println("JSON 파싱 중 에러 발생:");
            e.printStackTrace();
        }

        return resultList;
    }
}