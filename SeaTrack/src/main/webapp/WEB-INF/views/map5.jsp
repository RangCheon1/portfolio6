
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>격자맵 예시 - 대한민국 해역</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<style>
body {
	margin: 0;
}

#map {
	height: 100vh;
	width: 100%;
}

#loadingSpinner {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(255, 255, 255, 0.7);
	z-index: 2000;
	display: none;
	justify-content: center;
	align-items: center;
}

.spinner {
	border: 8px solid #f3f3f3;
	border-top: 8px solid #3498db;
	border-radius: 50%;
	width: 60px;
	height: 60px;
	animation: spin 1s linear infinite;
}

@keyframes spin { 0% {
	transform: rotate(0deg);
	}
	100% {
	transform:rotate(360deg);
	}
}

#toggleGridBtn {
	width: 110px;
	height: 36px;
	font-size: 16pt;
}

.leaflet-top{
	position: fixed; !important;
	right: 5px;
	top: 4rem;
}
</style>
</head>
<body>
	<button id="findRouteBtn">최단 경로 찾기</button>
	<!-- 경로초기화버튼 -->
	<button id="resetRouteBtn"
		tyle="position: absolute; top: 20px; left: 200px; z-index: 1000;">경로
		초기화</button>

	<div class="hourBtnBox">
		<button class="hourBtn" data-hr="0" type="button">0</button>
		<button class="hourBtn" data-hr="1" type="button">1</button>
		<button class="hourBtn" data-hr="2" type="button">2</button>
		<button class="hourBtn" data-hr="3" type="button">3</button>
		<button class="hourBtn" data-hr="4" type="button">4</button>
		<button class="hourBtn" data-hr="5" type="button">5</button>
		<button class="hourBtn" data-hr="6" type="button">6</button>
		<button class="hourBtn" data-hr="7" type="button">7</button>
		<button class="hourBtn" data-hr="8" type="button">8</button>
		<button class="hourBtn" data-hr="9" type="button">9</button>
		<button class="hourBtn" data-hr="10" type="button">10</button>
		<button class="hourBtn" data-hr="11" type="button">11</button>
		<button class="hourBtn" data-hr="12" type="button">12</button>
		<button class="hourBtn" data-hr="13" type="button">13</button>
		<button class="hourBtn" data-hr="14" type="button">14</button>
		<button class="hourBtn" data-hr="15" type="button">15</button>
		<button class="hourBtn" data-hr="16" type="button">16</button>
		<button class="hourBtn" data-hr="17" type="button">17</button>
		<button class="hourBtn" data-hr="18" type="button">18</button>
		<button class="hourBtn" data-hr="19" type="button">19</button>
		<button class="hourBtn" data-hr="20" type="button">20</button>
		<button class="hourBtn" data-hr="21" type="button">21</button>
		<button class="hourBtn" data-hr="22" type="button">22</button>
		<button class="hourBtn" data-hr="23" type="button">23</button>
	</div>
	<button id="toggleGridBtn"
		style="position: absolute; top: 20px; left: 60px; z-index: 1000;">
		격자 켜기</button>
	<div id="loadingSpinner">
		<div class="spinner"></div>
	</div>
	<div id="map"></div>

	<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
	<script src="https://unpkg.com/leaflet-pip/leaflet-pip.min.js"></script>
<script>
  $(document).ready(function () {
    // 지도 초기화 (대한민국 중심)
    const bounds = L.latLngBounds([32.5, 122.5], [38.7, 132.0]);

    const map = L.map('map', {
      maxBounds: bounds,
      maxBoundsViscosity: 1.0
    }).setView([36.5, 128], 8); // 줌레벨 8부터 시작

    // 타일 레이어 추가 
    L.tileLayer('https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png', {
      maxZoom: 16,
      minZoom: 8,
      attribution: '&copy; <a href="http://www.vworld.kr/">VWorld</a>'
    }).addTo(map);

    let coastPolygons;
    let exceptionPolygons;

    $.getJSON('${pageContext.request.contextPath}/resources/static/korea_sea_polygon.geojson', seaData => {
      coastPolygons = L.geoJSON(seaData, {
        style: { opacity: 0, fillOpacity: 0 }
      }).addTo(map);

      // 예외 영역도 로드
      $.getJSON('${pageContext.request.contextPath}/resources/static/exception_area.geojson', exceptionData => {
        exceptionPolygons = L.geoJSON(exceptionData, {
          style: { opacity: 0, fillOpacity: 0 }
        }).addTo(map);
      });
    });

    function drawSeaGrid() {
      const gridSize = 0.035;

      for (let lat = 32.5; lat < 39.0; lat += gridSize) {
        for (let lng = 122.0; lng < 132.0; lng += gridSize) {
          const centerLat = lat + gridSize / 2;
          const centerLng = lng + gridSize / 2;
          const point = [centerLng, centerLat];

          const inSea = leafletPip.pointInLayer(point, coastPolygons).length > 0;
          const inException = leafletPip.pointInLayer(point, exceptionPolygons).length > 0;

          if (inSea && !inException) continue;

          // 격자에 포함된 pointData의 좌표 개수 계산
          const count = pointData.filter(p =>
            p.lat >= lat && p.lat < lat + gridSize &&
            p.lng >= lng && p.lng < lng + gridSize
          ).length;

          // ✅ 좌표 개수에 따른 색상 결정
          let fillColor = 'none'; // 기본 투명
          if (count === 1) fillColor = "rgb(101, 211, 67)"; // 초록
          else if (count === 2) fillColor = "rgb(235, 255, 51)"; //노랑
          else if (count === 3) fillColor = "#ffb74d"; // 주황
          else if (count >= 4) fillColor = "#e57373";// 빨강

          const rect = L.rectangle([[lat, lng], [lat + gridSize, lng + gridSize]], {
            color: 'white',
            fillColor: fillColor,
            weight: 0.5,
            fillOpacity: 0.5,
            dashArray: '1, 4'
          });

          gridLayerGroup.addLayer(rect);
        }
      }
    }

    let gridLayerGroup = L.layerGroup();
    let gridVisible = true;
    let gridDrawn = false;

    $('#toggleGridBtn').on('click', function () {
      if (!gridDrawn) {
        $('#loadingSpinner').css('display', 'flex');
        $('#loadingSpinner').show();

        setTimeout(() => {
          drawSeaGrid();
          gridDrawn = true;
          map.addLayer(gridLayerGroup);
          $(this).text('격자 끄기');
          gridVisible = true;
          $('#loadingSpinner').hide();
          $('#loadingSpinner').css('display', 'none');
        }, 100);
      } else {
        if (gridVisible) {
          map.removeLayer(gridLayerGroup);
          $(this).text('격자 켜기');
        } else {
          map.addLayer(gridLayerGroup);
          $(this).text('격자 끄기');
        }
        gridVisible = !gridVisible;
      }
    });

    const ports = [
      { name: "부산항", lat: 35.101944, lng: 129.040278 },
      { name: "경인항", lat: 37.558935, lng: 126.603656 },
      { name: "인천항", lat: 37.4644, lng: 126.6172 },
      { name: "여수항", lat: 34.744663, lng: 127.751598 },
      { name: "마산항", lat: 35.1983, lng: 128.5778 },
      { name: "동해묵호항", lat: 37.549103, lng: 129.112573 },
      { name: "군산항", lat: 35.978631, lng: 126.628783 },
      { name: "장항항", lat: 36.006739, lng: 126.685667 },
      { name: "목포항", lat: 34.782333, lng: 126.385045 },
      { name: "포항항", lat: 36.051025, lng: 129.378777 },
      { name: "울산항", lat: 35.5185, lng: 129.375043 },
      { name: "대산항", lat: 37.012731, lng: 126.418991 },
      { name: "용기포항", lat: 37.958004, lng: 124.733105 },
      { name: "연평도항", lat: 37.656781, lng: 125.713785 },
      { name: "거문도항", lat: 34.025739, lng: 127.309871 },
      { name: "국도항", lat: 34.547375, lng: 128.443093 },
      { name: "상왕등도항", lat: 35.658429, lng: 126.110837 },
      { name: "가거항리항", lat: 34.050739, lng: 125.127904 },
      { name: "흑산도항", lat: 34.683793, lng: 125.440822 },
      { name: "후포항", lat: 36.680242, lng: 129.453599 },
      { name: "울릉항", lat: 37.482334, lng: 130.908558 },
      { name: "추자항", lat: 33.961764, lng: 126.297219 },
      { name: "화순항", lat: 33.235583, lng: 126.334426 },
      { name: "부산항신항", lat: 35.077283, lng: 128.829803 },
      { name: "인천신항", lat: 37.344983, lng: 126.629963 },
      { name: "인천북항", lat: 37.500057, lng: 126.634426 },
      { name: "광양항", lat: 34.90156, lng: 127.665424 },
      { name: "동해신항", lat: 37.498559, lng: 129.136906 },
      { name: "새만금신항", lat: 35.794146, lng: 126.485939 },
      { name: "목포신항", lat: 34.763897, lng: 126.350284 },
      { name: "영일만항", lat: 36.112362, lng: 129.438107 },
      { name: "평택당진항", lat: 36.958534, lng: 126.836386 },
      { name: "울산신항", lat: 35.456755, lng: 129.36058 },
      { name: "서울항", lat: 37.5275, lng: 126.9364 },
      { name: "호산항", lat: 37.175825, lng: 129.342921 },
      { name: "삼척항", lat: 37.435612, lng: 129.190249 },
      { name: "옥계항", lat: 37.6194, lng: 129.0569 },
      { name: "속초항", lat: 38.2083, lng: 128.5961 },
      { name: "태안항", lat: 36.902033, lng: 126.206839 },
      { name: "보령항", lat: 36.408608, lng: 126.487269 },
      { name: "완도항", lat: 34.317105, lng: 126.762657 },
      { name: "하동항(중평항)", lat: 34.973663, lng: 127.909141 },
      { name: "삼천포항", lat: 34.926158, lng: 128.072691 },
      { name: "장승포항", lat: 34.863803, lng: 128.72421 },
      { name: "옥포항", lat: 34.890525, lng: 128.698933 },
      { name: "통영항", lat: 34.83952, lng: 128.420348 },
      { name: "고현항", lat: 34.896808, lng: 128.616321 },
      { name: "진해항", lat: 35.133317, lng: 128.693461 },
      { name: "제주항", lat: 33.522399, lng: 126.538639 },
      { name: "서귀포항", lat: 33.236821, lng: 126.56662 },
      { name: "부산남항", lat: 35.090733, lng: 129.026549 },
      { name: "주문진항", lat: 37.893042, lng: 128.830447 },
      { name: "마량진항", lat: 36.129678, lng: 126.504586 },
      { name: "대천항", lat: 36.32823, lng: 126.506689 },
      { name: "진도항", lat: 34.374329, lng: 126.134076 },
      { name: "땅끝항", lat: 34.299717, lng: 126.532288 },
      { name: "녹동신항", lat: 34.522646, lng: 127.14366 },
      { name: "송공항", lat: 34.848132, lng: 126.226408 },
      { name: "화흥포항", lat: 34.304219, lng: 126.6785 },
      { name: "홍도항", lat: 34.683264, lng: 125.198886 },
      { name: "강진항(마량항)", lat: 34.448326, lng: 126.819777 },
      { name: "나로도항", lat: 34.463046, lng: 127.453573 },
      { name: "구룡포항", lat: 35.989778, lng: 129.559407 },
      { name: "강구항", lat: 36.359338, lng: 129.390067 },
      { name: "중화항", lat: 34.789823, lng: 128.389106 },
      { name: "한림항", lat: 33.412959, lng: 126.255805 },
      { name: "애월항", lat: 33.466962, lng: 126.323247 },
      { name: "성산포항", lat: 33.475697, lng: 126.931486 },
      { name: "진촌항", lat: 34.842232, lng: 128.220084 }
    ];

    map.createPane('topMarkers');
    map.getPane('topMarkers').style.zIndex = 1000;
    map.getPane('topMarkers').style.pointerEvents = 'auto';

    ports.forEach(port => {
      const customIcon = L.icon({
        iconUrl: '${pageContext.request.contextPath}/resources/image/ship.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [0, -41],
      });

      L.marker([port.lat, port.lng], { icon: customIcon })
        .bindTooltip(port.name, { permanent: false, direction: 'top' })
        .on('click', () => {
          if (!startPort) {
            startPort = port;
            alert("출발지 설정: " + port.name);
          } else if (!endPort) {
            endPort = port;
            alert("도착지 설정: " + port.name);
            drawRoute(startPort, endPort);
          } else {
            if (routeLine) {
              map.removeLayer(routeLine);
            }
            startPort = port;
            endPort = null;
            alert("출발지 다시 설정: " + port.name);
          }
        })
        .addTo(map);
    });

    // 사고표시 버튼 이벤트
    let pointData = [];

    $('.hourBtn').click(function () {
      const hr = $(this).data('hr');

      $.ajax({
        url: '/accident/byHour',
        type: 'GET',
        data: { hr: hr },
        dataType: 'json',
        success: function (response) {
          pointData = response.map(item => ({
            lat: parseFloat(item.lat),
            lng: parseFloat(item.lng)
          }));

          if (gridVisible) {
            gridLayerGroup.clearLayers();
            drawSeaGrid();
          }
        },
        error: function () {
          alert("데이터 조회 실패");
        }
      });
    });

    let start = { lat: 34.303457, lng: 126.951828 };
    let end = { lat: 34.430133, lng: 127.111816 };

    $('#findRouteBtn').on('click', function () {
      $.ajax({
        url: 'http://localhost:8000/route',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ start, end }),
        success: function (response) {
          console.log("응답 데이터:", response);
          drawPath(response.path);
        },
        error: function (xhr) {
          alert("경로 요청 실패: " + xhr.responseText);
        }
      });
    });

    function drawPath(pathCoords) {
      if (!pathCoords || pathCoords.length === 0) {
        alert("경로가 없습니다.");
        return;
      }

      let latlngs = pathCoords.map(p => [p.lat, p.lng]);

      let polyline = L.polyline(latlngs, {
        color: 'blue',
        weight: 4,
        opacity: 0.8
      }).addTo(map);

      map.fitBounds(polyline.getBounds());
    }

    map.on('click', function (e) {
      alert("출발지\n위도: " + e.latlng.lat.toFixed(6) + "\n경도: " + e.latlng.lng.toFixed(6));
    });
  });// document ready
</script>
</body>
</html>