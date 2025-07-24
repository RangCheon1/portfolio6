<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>격자맵 예시 - 대한민국 해역 (교통량 + 해양 날씨 통합)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  
  <!-- JQuery, Leaflet CSS/JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

  <style>
    /* 스타일은 기존과 동일 */
    *{margin:0; padding:0; box-sizing:border-box;}
    button{
  		transition: transform 0.2s ease-in-out;
  	}

	button:hover {
  		transform: scale(1.1);
	}
    #map { height: 100vh; width: 100%; }
    #header {
    	width: 100%;
    	height: 4rem;
    	display: flex;
    	justify-content: space-between;
    	align-items: center;
    	padding: 1.25rem 1.5rem;
    	background-color: #F0F4F9;
    	position: fixed;
    	top: 0;
    	z-index: 1000;
    }
    #header a{
    color: #3a61b5; 
    font-size: 1.5rem;
    font-weight: bold;
    }
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
    #infoBox {
      position: fixed;
      bottom: 0;
      left: 0;
      width: 100%;
      height: 260px;
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
      height: 180px;
    }
    .infoCard h4 {
      font-size: 14px;
      color: #3a61b5;
      margin-bottom: 10px;
      border-bottom: 1px solid #dde5f2;
      padding-bottom: 4px;
    }
    .infoCard p, .infoCard li {
      font-size: 13px;
      color: #333;
      margin: 4px 0;
      line-height: 1.3em;
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
    /* 로그인 영역 스타일 */
    #userInfo {
      position:absolute; top:10px; right:10px; padding:8px; z-index:3000;
      font-family: 'Noto Sans KR', sans-serif;
    }
    #userInfo a {
      margin-left: 10px;
      padding: 6px 10px;
      border-radius: 4px;
      text-decoration: none;
      color: white;
      font-weight: 600;
      font-size: 13px;
    }
    #userInfo .logout { background:#e74c3c; }
    #userInfo .admin { background:#2ecc71; }
    #userInfo .mypage { background:#3498db; }
    #userInfo .login { background:#3a61b5; }
    
    /* 지도 확대·축소 버튼*/
    .leaflet-top{
    	position: fixed;
    	top: 4rem;
    	left: auto !important;
    	right: 1rem !important;
    }
    
    #leftBox{
    	position: fixed;
    	top: 4.5rem;
    	left: 0;
    	width: 17rem;
    	height: 35rem;
    	z-index: 1000;
    	border-radius: 1rem;
    	background-color: #F0F4F9;
    	display: flex;
    	flex-direction: column;
    	align-items: center;
    	padding-top: 7px;
    }
    #toggleGridBtn{
      width: 90%; height: 4rem;
      padding: 1rem;
      margin: 0.5rem 0.5rem;
      color: white;
      background-color: #3a61b5;
      border: none;
      border-radius: 1rem;
      font-size: 2rem;
      display: flex;
      justify-content: center; /* 수평 정렬 */
  	  align-items: center; 
    }
    #toggleWarnBtn{
      width: 90%; height: 4rem;
      padding: 1rem;
      margin: 0.5rem 0.5rem;
      color: white;
      background-color: rgb(200, 70, 70);
      border: none;
      border-radius: 1rem;
      font-size: 2rem;
      display: flex;
      justify-content: center; /* 수평 정렬 */
  	  align-items: center;
    }
    #findRouteBtn{
      width: 90%; height: 4rem;
      padding: 1rem;
      margin: 0.5rem 0.5rem;
      color: white;
      background-color: #3a61b5;
      border: none;
      border-radius: 1rem;
      font-size: 2rem;
      display: flex;
      justify-content: center;
  	  align-items: center;
    }
    #inputBox{
    	width: 90%;
    	display: flex;
    	flex-direction: column;
    	justify-content: center;
  	    align-items: center;
  	    margin: 0.5rem 0.5rem;
  	    gap: 5px;
    }
    .inputBox{
      width: 100%;
      height: 3.5rem;
      border: none;
      font-size: 2rem;
      padding: 1rem;
    }
    #inputBtnBox{
      display: flex;
      flex-direction: row;
      justify-content: center;
  	  align-items: center;
  	  width: 90%;
  	  height: 2rem;
  	  margin: 0.5rem 0.5rem;
  	  gap: 10px
    }
    .inputBtn{
      width: 45%;
      height: 2rem;
      padding: 0.5rem;
      border: none;
      border-radius: 1rem;
      font-size: 1rem;
      color: white;
      background-color: #3a61b5;
      display: flex;
      justify-content: center;
  	  align-items: center;
    }
    .popupBox{
      width: 8rem;
      height: 3.5rem;
   	  display: flex;
   	  flex-direction: column;
    }
    .popupStrong{font-size: 1rem;}
    .popupBtnBox{
      display: flex;
      flex-direction: row;
      justify-content: center;
  	  align-items: center;
  	  width: 100%;
  	  gap: 10px;
  	  position: relative;
  	  bottom: 15px;
    }
    .popupBtn{
      width: 45%;
      height: 2.5rem;
      padding: 0.25rem;
      border:none;
      border-radius: 1rem;
      color: white;
      background-color: #3a61b5;
      display: flex;
      justify-content: center;
  	  align-items: center;
    }
    
    /* infobox style 추가분 */
	.info{
	border: 1px solid #dddddd;
	border-radius:10px;
	position: fixed;
	top:70px;
	display: flex;
  	flex-direction: column;
	left:80vw;
	background-color:white;
	width:100px;
	height:114px;
	z-index:10000;
	font-size:9.5pt;
	box-sizing: border-box;
	user-select: none;
  	-webkit-user-select: none; /* Safari */
  	-moz-user-select: none;    /* Firefox */
  	-ms-user-select: none;     /* IE10+ */
	}
	.infohead{
	background-color:#d1d1d1;
	margin:0;
	padding: 4px 0 4px 10px;
	border-radius:7px 7px 0px 0px;
	font-weight: bold;
	}
	.colorinfo{
	width:10px;
	height:10px;
	margin:0;
	padding:0;
	}
	.color1{
	background-color:rgb(101, 211, 67);
	}
	.color2{
	background-color:rgb(235, 255, 51);
	}
	.color3{
	background-color:#ffb74d;
	}
	.color4{
	background-color:#e57373;
	}
	.infotable {
  	width: 100%;
  	box-sizing: border-box;
	}
	.info td {
  	padding: 0;
  	line-height:0;
  	height:18px;
  	}
	.info td:first-child {
  	width: 25%;
  	padding-left:10px;
  	text-align:center;
	}
	.info td:last-child {
  	width: 75%;
  	padding-left:5px
	}
  </style>
</head>
<body>
<div id="header">
<a>해양교통안전정보시스템</a>
<div id="userInfo">
  <c:choose>
    <c:when test="${not empty sessionScope.user}">
      <span style="color:#3a61b5; font-weight:bold;">${sessionScope.user.username}</span> 님 환영합니다!
      <a href="${pageContext.request.contextPath}/user/logout" class="logout">로그아웃</a>
      <c:choose>
        <c:when test="${sessionScope.user.role eq 'admin'}">
          <a href="${pageContext.request.contextPath}/admin/users" class="admin">관리자 페이지</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/mypage" class="mypage">마이페이지</a>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/user/login" class="login">로그인</a>
    </c:otherwise>
  </c:choose>
</div> <!-- userInfo -->
</div> <!-- header -->

<div id="leftBox">
<button id="toggleGridBtn">실시간 교통량</button>
<button id="toggleWarnBtn">경보 표시</button>
<div id="inputBox">
<input type="number" id="startLat" class="inputBox" placeholder="출발지 위도">
<input type="number" id="startLng" class="inputBox" placeholder="출발지 경도">
<input type="number" id="endLat" class="inputBox" placeholder="도착지 위도">
<input type="number" id="endLng" class="inputBox" placeholder="도착지 경도">
</div>
<div id="inputBtnBox">
<button type="button" class="inputBtn" id="startBtn">출발지 설정</button>
<button type="button" class="inputBtn" id="endBtn">도착지 설정</button>
</div>
<button id="findRouteBtn">최단 경로 찾기</button>
</div> <!-- leftBox -->

<div class='info'>
<p class='infohead'>교통량</p>
<table class='infotable'>
	<tr>
		<td><div class='colorinfo color1'></div></td><td>원활</td>
	</tr>
	<tr>
		<td><div class='colorinfo color2'></div></td><td>보통</td>
	</tr>
	<tr>
		<td><div class='colorinfo color3'></div></td><td>혼잡</td>
	</tr>
	<tr>
		<td><div class='colorinfo color4'></div></td><td>매우혼잡</td>
	</tr>
</table>
</div><!-- info Box -->
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
    <div class="infoCard" id="infocenter">
      <h4>사고량 통계</h4>
      <p>내용 로드 중...</p>
    </div>
    <div class="infoCard" id="infoRight">
      <h4>해양 날씨 정보</h4>
      <p>내용 로드 중...</p>
    </div>
  </div>
</div>

<script>
// 항구 좌표
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
  // JSP 렌더링 시 contextPath 값을 JS 변수로 전달
  var contextPath = '${pageContext.request.contextPath}';

  // 지도 초기화
  const bounds = L.latLngBounds([32.5, 122.5], [38.7, 132.0]);
  const map = L.map('map', { maxBounds: bounds, maxBoundsViscosity: 1.0 }).setView([36.5, 128], 8);

  L.tileLayer('https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png', {
    maxZoom: 16,
    minZoom: 8,
    attribution: '&copy; <a href="http://www.vworld.kr/">VWorld</a>'
  }).addTo(map);

  let pointData = [];
  let gridLayerGroup = L.layerGroup();
  let gridVisible = false;
  let gridDrawn = false;
  const gridSize = 0.035;

  function safeDisplay(value) {
    return (value === null || value === undefined || value === '' || value === false) ? '-' : value;
  }

  // 선박 데이터 불러오기
  function loadShipData() {
    return $.ajax({
      url: contextPath + '/api/ships/with-coordinates',
      method: 'GET',
      dataType: 'json',
      success: function(items) {
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

  // 격자 그리기
  function drawSeaGrid() {
    gridLayerGroup.clearLayers();

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

          // 사고 데이터 AJAX 호출
          $.ajax({
            url: contextPath + '/accidentNew/byGrid',
            method: 'GET',
            data: {
              minLat: lat,
              maxLat: lat + gridSize,
              minLng: lng,
              maxLng: lng + gridSize
            },
            dataType: 'json',
            success: function(accidents) {
              let accidentContent = '';
              if (!accidents || (Array.isArray(accidents) && accidents.length === 0)) {
                accidentContent = '<p>사고 없음</p>';
              } else {
                let accidentList = Array.isArray(accidents) ? accidents : (accidents.data || []);
                if (accidentList.length === 0) {
                  accidentContent = '<p>사고 없음</p>';
                } else {
                  accidentContent = '<div>사고 수: ' + accidentList.length + '건</div><ul>';
                  accidentList.forEach(function(a) {
                    accidentContent += '<li>' + a.accidentDatetime + ' - ' + a.accidentType + ' (' + a.accidentName + ')</li>';
                    console.log(a.accidentDatetime, a.accidentType, a.accidentName);
                  });
                  accidentContent += '</ul>';
                  console.log(accidentContent);
                }
              }

              // 해양 날씨 데이터 AJAX 호출
              $.ajax({
                url: contextPath + '/api/khoaCurrentSpeed',
                method: 'GET',
                data: { lat: centerLat, lng: centerLng },
                dataType: 'json',
                success: function(response) {
                  $('#loadingSpinner').hide();

                  let marineInfoHtml = '';
                  if (response && response.result && response.result.data) {
                    let dataObj = Array.isArray(response.result.data)
                      ? response.result.data[0]
                      : response.result.data;
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
                  $('#infocenter').html('<h4>사고량 통계</h4>' + accidentContent);
                  $('#infoRight').html('<h4>해양 날씨 정보</h4>' + marineInfoHtml);
                  $('#infoBox').fadeIn();
                },
                error: function() {
                  $('#loadingSpinner').hide();
                  alert('해양 데이터 로드 실패');
                }
              });
            },
            error: function() {
              alert('사고 데이터 로드 실패');
            }
          });
        });

        gridLayerGroup.addLayer(rect);
      }
    }
  }

  // 초기 데이터 로드 및 격자 그리기
  function loadAllDataAndDrawGrid() {
    $('#loadingSpinner').show();
    $.when(loadShipData())
      .done(() => {
        drawSeaGrid();
        if (gridVisible) map.addLayer(gridLayerGroup);
        $('#loadingSpinner').hide();
      })
      .fail(() => {
        alert("데이터 로드 실패");
        $('#loadingSpinner').hide();
      });
  }

  // 토글 버튼 이벤트 처리
  $('#toggleGridBtn').on('click', function () {
    if (!gridDrawn) {
      loadAllDataAndDrawGrid();
      gridDrawn = true;
      $(this).text('실시간 교통량');
      gridVisible = true;
    } else {
      if (gridVisible) {
        map.removeLayer(gridLayerGroup);
        $('#infoBox').fadeOut();
        $(this).text('실시간 교통량');
      } else {
        drawSeaGrid();
        map.addLayer(gridLayerGroup);
        $(this).text('실시간 교통량');
      }
      gridVisible = !gridVisible;
    }
  });

  // 정보 박스 닫기 버튼 처리
  $('#closeInfoBtn').on('click', () => $('#infoBox').fadeOut());

  
  // 길찾기
  let start = { lat: 34.303457, lng: 126.951828 };
  let end = { lat: 34.430133, lng: 127.111816 };

  $('#findRouteBtn').on('click', function () {
	start['lat'] = parseFloat($("#startLat").val());
	start['lng'] = parseFloat($("#startLng").val());
	end['lat'] = parseFloat($("#endLat").val());
	end['lng'] = parseFloat($("#endLng").val());
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
  // 경로 그리기
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
  
  // 경보 그리기
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
  function drawWarnGrid(){
 	 // 항행경보 api
	fetch('/api/navi-warning/list')
 .then(res => res.json())
 .then(data => {
   const uniqueDocNums = [...new Set(data.map(item => item.docNum))];

   uniqueDocNums.forEach(docNum => {
     fetch('/api/navi-warning/detail?doc_num=' + docNum)
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

           let layer;
           if (latlngs.length === 1) {
             const match = item.positionDesc.match(/반경\s*(\d+)\s*NM/i);
             const radiusNM = match ? parseInt(match[1]) : 2.5;
             const radiusM = radiusNM * 1852;

             layer = L.circle(latlngs[0], {
               radius: radiusM,
               color: 'blue',
               fillOpacity: 0.3
             }).bindPopup(popupText);

           } else if (latlngs.length > 1) {
             layer = L.polygon(latlngs, {
               color: 'red',
               fillOpacity: 0.4
             }).bindPopup(popupText);
           }

           if (layer) {
             warnLayerGroup.addLayer(layer); // ✅ 그룹에 추가
           }
         });
       });
   });
 });
 }
  let warnLayerGroup = L.layerGroup()
  let warnVisible = true;
  let warnDrawn = false; // 격자가 생성됐는지 여부 추적
  // 경보 버튼 이벤트
  $('#toggleWarnBtn').on('click', function () {
	  if (!warnDrawn) {
	      drawWarnGrid(); // 격자 최초 생성
	      warnDrawn = true;
	      map.addLayer(warnLayerGroup);
	      $(this).text('경보 끄기');
	      warnVisible = true;
	  } else {
	    if (warnVisible) {
	      map.removeLayer(warnLayerGroup);
	      $(this).text('경보 표시');
	    } else {
	      map.addLayer(warnLayerGroup);
	      $(this).text('경보 끄기');
	    }
	    warnVisible = !warnVisible;
	  }
	});
  
  // 출발지 도착지 버튼 이벤트
  let settingStart = false;
  let settingEnd = false;
  $('#startBtn').on('click', function () {
	  settingStart = true;
	  alert("지도를 클릭해서 출발지를 선택하세요.");
  });
  $('#endBtn').on('click', function () {
	  settingEnd = true;
	  alert("지도를 클릭해서 도착지를 선택하세요.");
  });
  map.on('click', function (e) {
	  if (settingStart) {
	    $('#startLat').val(e.latlng.lat.toFixed(6));
	    $('#startLng').val(e.latlng.lng.toFixed(6));
	    settingStart = false;
	  } else if (settingEnd) {
	    $('#endLat').val(e.latlng.lat.toFixed(6));
	    $('#endLng').val(e.latlng.lng.toFixed(6));
	    settingEnd = false;
	  }
  });
  
//항구 표시
  ports.forEach(port => {
    const customIcon = L.icon({
      iconUrl: '${pageContext.request.contextPath}/resources/image/ship.png', // 아이콘 이미지 경로
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [0, -41]
    });

    const marker = L.marker([port.lat, port.lng], { icon: customIcon }).addTo(map);

    const popupHtml =
    	  '<div class="popupBox">' +
    	  '<strong class="popupStrong">' + port.name + '</strong><br>' +
    	  '<div class="popupBtnBox"><button class="popupBtn set-start" data-lat="' + port.lat + '" data-lng="' + port.lng + '">출발</button>' +
    	  '<button class="popupBtn set-end" data-lat="' + port.lat + '" data-lng="' + port.lng + '">도착</button></div>' +
    	  '</div>';

    marker.bindPopup(popupHtml);
  });

  // "출발지 설정" 버튼 클릭 시 input 태그에 값 설정
  $(document).on('click', '.set-start', function () {
	console.log("동작확인");
    const lat = $(this).data('lat');
    const lng = $(this).data('lng');
	console.log("위도: "+lat);
	console.log("경도: "+lng);
    $('#startLat').val(lat);
    $('#startLng').val(lng);
  });

  // "도착지 설정" 버튼 클릭 시 input 태그에 값 설정
  $(document).on('click', '.set-end', function () {
    const lat = $(this).data('lat');
    const lng = $(this).data('lng');

    $('#endLat').val(lat);
    $('#endLng').val(lng);
  });
  
	//info 드래그 이동 기능
  $(function() {
	  var isDragging = false;
	  var offset = { x: 0, y: 0 };

	  $('.info').on('mousedown', function(e) {
	    isDragging = true;
	    var infoBox = $('.info');
	    offset.x = e.clientX - infoBox.offset().left;
	    offset.y = e.clientY - infoBox.offset().top;

	    // 마우스 이동 이벤트 바인딩
	    $(document).on('mousemove.dragInfo', function(e) {
	      if (isDragging) {
	        $('.info').css({
	          left: e.clientX - offset.x + 'px',
	          top: e.clientY - offset.y + 'px'
	        });
	      }
	    });

	    // 마우스 떼면 이벤트 제거
	    $(document).on('mouseup.dragInfo', function() {
	      isDragging = false;
	      $(document).off('.dragInfo'); // .dragInfo 네임스페이스로 등록된 mousemove, mouseup 제거
	    });
	  });
	});
</script>

</body>
</html>
