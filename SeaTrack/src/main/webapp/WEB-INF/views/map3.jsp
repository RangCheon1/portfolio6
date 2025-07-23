<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>격자맵 예시 - 대한민국 해역 (교통량 + 해양 날씨 통합)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
  
  <style>
    body { margin: 0; }
    #map { height: 100vh; width: 100%; }
    #loadingSpinner {
      position: fixed; top: 0; left: 0; width: 100%; height: 100%;
      background-color: rgba(255,255,255,0.7);
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
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    #toggleGridBtn {
      width: 110px; height: 36px; font-size: 16pt;
      position: absolute; top: 20px; left: 60px; z-index: 1000;
    }

    #infoBox {
      position: fixed;
      bottom: 0;
      left: 0;
      width: 100%;
      background-color: #e9eff6;
      padding: 10px 20px;
      display: none;
      z-index: 3000;
      box-sizing: border-box;
      font-family: 'Noto Sans KR', sans-serif;
    }

    #infoTitle {
      font-weight: bold;
      color: #3a61b5;
      background-color: #e9eff6;
      border-bottom: 2px solid #a0bce0;
      padding: 8px 0;
      margin-bottom: 10px;
      position: relative;
    }

    .infoCardContainer {
      display: flex;
      gap: 16px;
    }

    .infoCard {
      flex: 1;
      background-color: #ffffff;
      border: 1px solid #ccd7e3;
      border-radius: 6px;
      padding: 15px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      overflow-y: auto;
      max-height: 150px;
    }

    .infoCard h4 {
      font-size: 14px;
      color: #3a61b5;
      margin-bottom: 10px;
      border-bottom: 1px solid #dde5f2;
      padding-bottom: 4px;
    }

    .infoCard p {
      font-size: 13px;
      color: #333;
      margin: 4px 0;
    }

    #closeInfoBtn {
      background: transparent;
      border: none;
      color: #666;
      font-size: 22px;
      font-weight: bold;
      cursor: pointer;
      position: absolute;
      top: 8px;
      right: 0;
    }

    #closeInfoBtn:hover {
      color: #e74c3c;
    }
  </style>
</head>
<body>

<!-- 로그인 사용자 이름 표시 -->
<div style="position:absolute; top:10px; right:10px; padding:8px; z-index:3000;">
  <c:choose>
    <c:when test="${not empty sessionScope.user}">
      <span style="color:#3a61b5; font-weight:bold;">${sessionScope.user.username}</span> 님 환영합니다!
      <a href="${pageContext.request.contextPath}/user/logout" 
         style="margin-left:10px; background:#e74c3c; color:#fff; padding:6px 10px; border-radius:4px; text-decoration:none;">
        로그아웃
      </a>

      <!-- ✅ 관리자 여부 확인: role 기반 -->
      <c:choose>
        <c:when test="${sessionScope.user.role eq 'admin'}">
          <a href="${pageContext.request.contextPath}/admin/users"
             style="margin-left:10px; background:#2ecc71; color:#fff; padding:6px 10px; border-radius:4px; text-decoration:none;">
            관리자 페이지
          </a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/mypage"
             style="margin-left:10px; background:#3498db; color:#fff; padding:6px 10px; border-radius:4px; text-decoration:none;">
            마이페이지
          </a>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/user/login" 
         style="background:#3a61b5; color:#fff; padding:6px 10px; border-radius:4px; text-decoration:none;">
        로그인
      </a>
    </c:otherwise>
  </c:choose>
</div>





<button id="toggleGridBtn">격자 켜기</button>
<div id="loadingSpinner"><div class="spinner"></div></div>
<div id="map"></div>

<div id="infoBox">
  <div id="infoTitle">
    격자 정보
    <button id="closeInfoBtn" title="닫기">×</button>
  </div>
  <div class="infoCardContainer">
    <div class="infoCard" id="infoLeft">
      <h4>교통량 통계</h4>
      <p>내용 로드 중...</p>
    </div>
    <div class="infoCard" id="infoRight">
      <h4>해양 날씨 정보</h4>
      <p>내용 로드 중...</p>
    </div>
  </div>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script>
  const bounds = L.latLngBounds([32.5, 122.5], [38.7, 132.0]);
  const map = L.map('map', {
    maxBounds: bounds,
    maxBoundsViscosity: 1.0
  }).setView([36.5, 128], 8);

  L.tileLayer('https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png', {
    maxZoom: 16,
    minZoom: 8,
    attribution: '&copy; <a href="http://www.vworld.kr/">VWorld</a>'
  }).addTo(map);

  let pointData = [];
  let gridLayerGroup = L.layerGroup();
  let gridVisible = false;
  let gridDrawn = false;

  function safeDisplay(value) {
    return (value === null || value === undefined || value === '' || value === false) ? '-' : value;
  }

  function loadShipData() {
    return $.ajax({
      url: '${pageContext.request.contextPath}/api/ships/with-coordinates',
      method: 'GET',
      dataType: 'json',
      success: function(items) {
        if (!Array.isArray(items)) {
          alert("서버 응답 형식이 배열이 아닙니다.");
          return;
        }
        pointData = items
          .map(ship => ({
            lat: parseFloat(ship.latitude),
            lng: parseFloat(ship.longitude),
            vmtc: ship.vmtc,
            dnsty: ship.dnsty,
            grid_id: ship.grid_id
          }))
          .filter(p => !isNaN(p.lat) && !isNaN(p.lng));
      },
      error: function(xhr, status, error) {
        alert("선박 데이터 로드 실패: " + error);
      }
    });
  }
  
  

  function drawSeaGrid() {
    gridLayerGroup.clearLayers();
    const gridSize = 0.035;

    const gridMap = new Map();
    pointData.forEach(p => {
      const latIndex = Math.floor((p.lat - 32.5) / gridSize);
      const lngIndex = Math.floor((p.lng - 122.0) / gridSize);
      const key = latIndex + '_' + lngIndex;
      if (!gridMap.has(key)) gridMap.set(key, []);
      gridMap.get(key).push(p);
    });

    for (let lat = 32.5; lat < 39.0; lat += gridSize) {
      for (let lng = 122.0; lng < 132.0; lng += gridSize) {
        const latIndex = Math.floor((lat - 32.5) / gridSize);
        const lngIndex = Math.floor((lng - 122.0) / gridSize);
        const key = latIndex + '_' + lngIndex;
        const shipsInGrid = gridMap.get(key) || [];

        const centerLat = lat + gridSize / 2;
        const centerLng = lng + gridSize / 2;
        const gridId = shipsInGrid.length > 0 ? shipsInGrid[0].grid_id : 'G_' + latIndex + '_' + lngIndex;

        const totalVmtc = shipsInGrid.reduce((sum, p) => sum + (p.vmtc || 0), 0);
        const avgDnsty = shipsInGrid.length > 0
          ? (shipsInGrid.reduce((sum, p) => sum + (p.dnsty || 0), 0) / shipsInGrid.length).toFixed(2)
          : 0;

        let fillColor = 'rgba(0,0,0,0)';
        if (shipsInGrid.length === 1) fillColor = "rgb(101, 211, 67)";
        else if (shipsInGrid.length === 2) fillColor = "rgb(235, 255, 51)";
        else if (shipsInGrid.length === 3) fillColor = "#ffb74d";
        else if (shipsInGrid.length >= 4) fillColor = "#e57373";

        const rect = L.rectangle([[lat, lng], [lat + gridSize, lng + gridSize]], {
          color: 'white',
          fillColor: fillColor,
          weight: 0.5,
          fillOpacity: 0.5,
          dashArray: '1,4'
        });

        rect.on('click', () => {
          $('#loadingSpinner').show();

          // 클릭 위치 근처 관측소 해양 데이터 요청
          $.ajax({
            url: `${pageContext.request.contextPath}/api/khoaCurrentSpeed`,
            method: 'GET',
            data: {
              lat: centerLat,
              lng: centerLng
            },
            dataType: 'json',
            success: function(response) {
              $('#loadingSpinner').hide();

              // KHOA API 응답 구조에 맞게 해양 데이터 파싱
              let marineInfoHtml = '';
              if (response && response.result && response.result.data) {
                let dataObj = null;
                if (Array.isArray(response.result.data)) {
                  dataObj = response.result.data.length > 0 ? response.result.data[0] : null;
                } else if (typeof response.result.data === 'object' && response.result.data !== null) {
                  dataObj = response.result.data;
                }
                if (dataObj) {
                  marineInfoHtml += '<p>관측소: ' + safeDisplay(response.result.meta.obs_post_name) + '</p>';
                  marineInfoHtml += '<p>위도: ' + safeDisplay(response.result.meta.obs_lat) + ' 경도: ' + safeDisplay(response.result.meta.obs_lon) + '</p>';
                  marineInfoHtml += '<p>관측 시각: ' + safeDisplay(dataObj.record_time) + '</p>';
                  marineInfoHtml += '<p>풍속: ' + safeDisplay(dataObj.wind_speed) + ' m/s</p>';
                  marineInfoHtml += '<p>풍향: ' + safeDisplay(dataObj.wind_dir) + '°</p>';
                  marineInfoHtml += '<p>돌풍: ' + safeDisplay(dataObj.wind_gust) + ' m/s</p>';
                  marineInfoHtml += '<p>기온: ' + safeDisplay(dataObj.air_temp) + ' °C</p>';
                  marineInfoHtml += '<p>기압: ' + safeDisplay(dataObj.air_press) + ' hPa</p>';
                  marineInfoHtml += '<p>수온: ' + safeDisplay(dataObj.water_temp) + ' °C</p>';
                  marineInfoHtml += '<p>조위: ' + safeDisplay(dataObj.tide_level) + '</p>';
                  marineInfoHtml += '<p>염분: ' + safeDisplay(dataObj.Salinity) + '</p>';

                  if (dataObj.current_dir !== undefined && dataObj.current_speed !== undefined) {
                    marineInfoHtml += '<p>유향: ' + safeDisplay(dataObj.current_dir) + '°</p>';
                    marineInfoHtml += '<p>유속: ' + safeDisplay(dataObj.current_speed) + ' m/s</p>';
                  }
                } else {
                  marineInfoHtml = '<p>해양 데이터 없음</p>';
                }
              } else {
                marineInfoHtml = '<p>해양 데이터 없음</p>';
              }

              const contentLeft =
                '<p>격자번호: ' + gridId + '</p>' +
                '<p>위도: ' + centerLat.toFixed(6) + '</p>' +
                '<p>경도: ' + centerLng.toFixed(6) + '</p>' +
                '<p>교통량: ' + (shipsInGrid.length > 0 ? totalVmtc + '척' : '교통량 없음') + '</p>' +
                '<p>밀집도: ' + (shipsInGrid.length > 0 ? avgDnsty + '%' : '0%') + '</p>';

              $('#infoLeft').html('<h4>교통량 통계</h4>' + contentLeft);
              $('#infoRight').html('<h4>해양 날씨 정보</h4>' + marineInfoHtml);

              $('#infoBox').fadeIn();
            },
            error: function() {
              $('#loadingSpinner').hide();
              alert('해양 데이터 로드 실패');
            }
          });
        });

        gridLayerGroup.addLayer(rect);
      }
    }
  }
  
  
  
  

  function loadAllDataAndDrawGrid() {
    $('#loadingSpinner').show();
    $.when(loadShipData())
      .done(() => {
        drawSeaGrid();
        if (gridVisible) {
          map.addLayer(gridLayerGroup);
        }
        $('#loadingSpinner').hide();
      })
      .fail(() => {
        alert("데이터 로드 실패");
        $('#loadingSpinner').hide();
      });
  }

  $('#toggleGridBtn').on('click', function () {
    if (!gridDrawn) {
      loadAllDataAndDrawGrid();
      gridDrawn = true;
      $(this).text('격자 끄기');
      gridVisible = true;
    } else {
      if (gridVisible) {
        map.removeLayer(gridLayerGroup);
        $('#infoBox').fadeOut();
        $(this).text('격자 켜기');
      } else {
        drawSeaGrid();
        map.addLayer(gridLayerGroup);
        $(this).text('격자 끄기');
      }
      gridVisible = !gridVisible;
    }
  });

  $('#closeInfoBtn').on('click', () => {
    $('#infoBox').fadeOut();
  });
</script>

</body>
</html>
