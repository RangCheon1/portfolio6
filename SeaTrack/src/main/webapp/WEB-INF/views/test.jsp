<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- leaflet.css & leaflet.js CDN 필수 -->
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<div id="map" style="height: 600px;"></div>

<script>
const map = L.map('map').setView([34.5, 128.5], 7);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
}).addTo(map);

// DMS → Decimal 변환 함수
function dmsToDecimal(dms) {
    const match = dms.match(/(\d+)-(\d+)-([\d.]+)([NSEW])/);
    if (!match) return null;
    const deg = parseFloat(match[1]);
    const min = parseFloat(match[2]);
    const sec = parseFloat(match[3]);
    const dir = match[4];
    let decimal = deg + min / 60 + sec / 3600;
    if (dir === 'S' || dir === 'W') decimal *= -1;
    return decimal;
}


// doc_num 리스트 불러오기 → 각각 상세 조회
fetch('/api/navi-warning/list')

    .then(res => res.json())
    .then(data => {
        const uniqueDocNums = [...new Set(data.map(item => item.docNum))];

        uniqueDocNums.forEach(docNum => {
            fetch('/api/navi-warning/detail?doc_num='+docNum)
                .then(res => res.json())
                .then(items => {
                	items.forEach(item => {
                	    const positions = item.position.trim().split(/\r?\n/);
                	    const latlngs = [];

                	    positions.forEach(pos => {
                	        const [latStr, lngStr] = pos.split(',');
                	        if (latStr && lngStr) {
                	            const lat = dmsToDecimal(latStr);
                	            const lng = dmsToDecimal(lngStr);
                	            if (lat !== null && lng !== null) {
                	                latlngs.push([lat, lng]);
                	            }
                	        }
                	    });

                	    const popupText = 
                	        item.positionNm + '<br/>' +
                	        item.positionDesc + '<br/>' +
                	        item.alarmDate.replace(/,/g, '<br/>') + '<br/>' +
                	        '시간: ' + item.alarmTime;

                	    if (latlngs.length === 1) {
                	        // 반경 추출
                	        const match = item.positionDesc.match(/반경\s*(\d+)\s*NM/i);
                	        const radiusNM = match ? parseInt(match[1]) : 2.5; // 기본값 4NM
                	        const radiusM = radiusNM * 1852;

                	        L.circle(latlngs[0], {
                	            radius: radiusM,
                	            color: 'blue',
                	            fillOpacity: 0.3
                	        }).addTo(map).bindPopup(popupText);

                	    } else if (latlngs.length > 1) {
                	        L.polygon(latlngs, {
                	            color: 'red',
                	            fillOpacity: 0.4
                	        }).addTo(map).bindPopup(popupText);
                	    }
                	});
                });
        });
    });
</script>
</body>
</html>