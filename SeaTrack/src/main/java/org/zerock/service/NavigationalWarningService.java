package org.zerock.service;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.*;
import org.zerock.domain.NavigationalWarningDTO;

@Service
public class NavigationalWarningService {

    private final String baseUrl = "http://apis.data.go.kr/1192136/NavigationalWarning";
    private final String serviceKey = "gQ%2BzMvC4WbivI0NoDlqKr%2B98yCXSRd2bDH0Dc8Zhg5R0t9H2tMWbrVru9%2F9nR17q3YadlzAL76LAJt4zXWRrzA%3D%3D";

    public List<NavigationalWarningDTO> getWarningList() {
        String url = baseUrl + "/getNavigationalWarningInfo?serviceKey=" + serviceKey  + "&numOfRows=1000";
        return parseXmlToDtoList(url);
    }

    public List<NavigationalWarningDTO> getWarningDetail(String docNum) {
        String url = baseUrl + "/getNavigationalWarningDetailInfo?serviceKey=" + serviceKey + "&doc_num=" + docNum + "&numOfRows=1000";
        return parseXmlToDtoList(url);
    }

    private List<NavigationalWarningDTO> parseXmlToDtoList(String urlStr) {
        List<NavigationalWarningDTO> result = new ArrayList<>();
        try {
            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            InputStream is = conn.getInputStream();
            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
            doc.getDocumentElement().normalize();

            NodeList itemList = doc.getElementsByTagName("item");

            for (int i = 0; i < itemList.getLength(); i++) {
                Node node = itemList.item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    Element elem = (Element) node;
                    NavigationalWarningDTO dto = new NavigationalWarningDTO();

                    dto.setDocNum(getTagValue("doc_num", elem));
                    dto.setArea(getTagValue("area", elem));
                    dto.setPositionNm(getTagValue("position_nm", elem));
                    dto.setPosition(getTagValue("position", elem));
                    dto.setPositionDesc(getTagValue("position_desc", elem));
                    dto.setAlarmDate(getTagValue("alarm_date", elem));
                    dto.setAlarmTime(getTagValue("alarm_time", elem));
                    dto.setSeaPos(getTagValue("sea_pos", elem));

                    result.add(dto);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private String getTagValue(String tag, Element elem) {
        NodeList nlList = elem.getElementsByTagName(tag);
        if (nlList.getLength() > 0 && nlList.item(0).hasChildNodes()) {
            return nlList.item(0).getTextContent();
        }
        return "";
    }
}