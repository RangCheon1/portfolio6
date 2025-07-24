
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
  <link
    rel="stylesheet"
    href="https://unpkg.com/leaflet/dist/leaflet.css"
  />
  <style>
  	body{
  		margin:0;
  		
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
	#toggleGridBtn{
	width:110px;
	height:36px;
	font-size:16pt;
	}
	
	/* infobox style 추가분 */
	.info{
	border: 1px solid #dddddd;
	border-radius:10px;
	position: fixed;
	top:50px;
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
<button id="toggleGridBtn" style="position: absolute; top: 20px; left: 60px; z-index: 1000;">
  격자 켜기
</button>

<!-- html 추가분 -->
<button id="toggleWarnBtn" style="position: absolute; top: 80px; left: 60px; z-index: 1000;">
  경보 켜기
</button>

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
</div>

<!-- 여기까지 -->

<div id="loadingSpinner">
  <div class="spinner"></div>
</div>

  <div id="map"></div>

  <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
  <script src="https://unpkg.com/leaflet-pip/leaflet-pip.min.js"></script>
  
  <script>
  
  </script>
  
  
  <script>
  
  // 임시 pointData 
  const pointData = [
	  { lat: 36.302537, lng: 126.358910 },
	  { lat: 36.302538, lng: 126.358910 },
	  { lat: 36.302537, lng: 126.358913 },
	  { lat: 36.299908, lng: 126.394958 },
	  { lat: 36.299908, lng: 126.394958 },
	  { lat: 36.265037, lng: 126.393757 },
	  { lat: 36.262131, lng: 126.358309 },
	  { lat: 36.262131, lng: 126.358309 },
	  { lat: 36.262131, lng: 126.358309 },
	  { lat: 36.262131, lng: 126.358309 }
	];
  
 
  
  
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
        style: { opacity:0, fillOpacity: 0 } 
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
    	        color: 'white', // 격자 테두리 색상
    	        fillColor: fillColor,
    	        weight: 0.5, 
    	        fillOpacity: 0.5,
    	        dashArray: '1, 4' // 격자 점선 '선 길이,선 간격'
    	      });

    	      gridLayerGroup.addLayer(rect);
    	    }
    	  }
    	  
    	 
    	  
    	}
    
    
  
   	
   	
   	
    //테스트용 맵 클릭 시 위도 경도 표시 이벤트
    
    map.on('click', function(e) {
    	  alert("클릭 위치\n위도: " + e.latlng.lat.toFixed(6) + "\n경도: " + e.latlng.lng.toFixed(6));
    	}); 
    
    let gridLayerGroup = L.layerGroup()
    let gridVisible = true;
    let gridDrawn = false; // 격자가 생성됐는지 여부 추적

    $('#toggleGridBtn').on('click', function () {
    	  if (!gridDrawn) {
    		$('#loadingSpinner').css('display','flex');
    	    $('#loadingSpinner').show(); // 로딩 스피너 표시
			
    	    setTimeout(() => {
    	      drawSeaGrid(); // 격자 최초 생성
    	      gridDrawn = true;
    	      map.addLayer(gridLayerGroup);
    	      $(this).text('격자 끄기');
    	      gridVisible = true;
    	      $('#loadingSpinner').hide(); // 로딩 스피너 숨기기
    	      $('#loadingSpinner').css('display','none');
    	    }, 100); // 최소 100ms 지연하여 렌더링 타이밍 확보
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
    	  { name: "울산항", lat: 35.518500, lng: 129.375043 },
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
    	  //{ name: "격렬비열도항", lat: 36.6783, lng: 126.0722 },
    	  { name: "부산항신항", lat: 35.077283, lng: 128.829803 },
    	  { name: "인천신항", lat: 37.344983, lng: 126.629963 },
    	  { name: "인천북항", lat: 37.500057, lng: 126.634426 },
    	  { name: "광양항", lat: 34.901560, lng: 127.665424 },
    	  { name: "동해신항", lat: 37.498559, lng: 129.136906 },
    	  { name: "새만금신항", lat: 35.794146, lng: 126.485939 },
    	  { name: "목포신항", lat: 34.763897, lng: 126.350284 },
    	  { name: "영일만항", lat: 36.112362, lng: 129.438107 },
    	  { name: "평택당진항", lat: 36.958534, lng: 126.836386 },
    	  { name: "울산신항", lat: 35.456755, lng: 129.360580 },
    	  //{ name: "보령신항", lat: 36.3311, lng: 126.4975 },
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
    	  { name: "장승포항", lat: 34.863803, lng: 128.724210 },
    	  { name: "옥포항", lat: 34.890525, lng: 128.698933 },
    	  { name: "통영항", lat: 34.839520, lng: 128.420348 },
    	  { name: "고현항", lat: 34.896808, lng: 128.616321 },
    	  { name: "진해항", lat: 35.133317, lng: 128.693461 },
    	  { name: "제주항", lat: 33.522399, lng: 126.538639 },
    	  { name: "서귀포항", lat: 33.236821, lng: 126.566620 },
    	  { name: "부산남항", lat: 35.090733, lng: 129.026549 },
    	  { name: "주문진항", lat: 37.893042, lng: 128.830447 },
    	  { name: "마량진항", lat: 36.129678, lng: 126.504586 },
    	  { name: "대천항", lat: 36.328230, lng: 126.506689 },
    	  { name: "진도항", lat: 34.374329, lng: 126.134076 },
    	  { name: "땅끝항", lat: 34.299717, lng: 126.532288 },
    	  { name: "녹동신항", lat: 34.522646, lng: 127.143660 },
    	  { name: "송공항", lat: 34.848132, lng: 126.226408 },
    	  { name: "화흥포항", lat: 34.304219, lng: 126.678500 },
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
    map.getPane('topMarkers').style.zIndex = 1000; // z-index를 충분히 크게
    map.getPane('topMarkers').style.pointerEvents = 'auto'; // 클릭 가능하도록 설정
    
    ports.forEach(port => {
    	  const customIcon = L.icon({
    	    iconUrl: '${pageContext.request.contextPath}/resources/image/ship.png', // 사용할 이미지 경로
    	    iconSize: [25, 41], // 이미지 크기 [가로, 세로]
    	    iconAnchor: [12, 41], // 마커의 기준점 (이미지 아래 중앙)
    	    popupAnchor: [0, -41], // 툴팁 위치 조정
    	  });

    	  L.marker([port.lat, port.lng], { icon: customIcon })
    	    .bindTooltip(port.name, { permanent: false, direction: 'top' })
    	    .on('click', () => {
    	      alert("항만명: " + port.name);
    	    })
    	    .addTo(map);
    	});
    
    
    // 아이콘 템플릿
	  const customIcon2 = L.icon({
  	    iconUrl: '${pageContext.request.contextPath}/resources/image/naver.png', // 사용할 이미지 경로
  	    iconSize: [25, 41], // 이미지 크기 [가로, 세로]
  	    iconAnchor: [12, 41], // 마커의 기준점 (이미지 아래 중앙)
  	    popupAnchor: [0, -41], // 툴팁 위치 조정
  	  });

  	  L.marker([36.289670, 126.361828], { icon: customIcon2 })
  	    .bindTooltip("test", { permanent: false, direction: 'top' })
  	    .on('click', () => {
  	      alert("test");
  	    })
  	    .addTo(map);
  	  
  	  
  	  
  	  
  	  
  	//script 추가분  

      //DMS → Decimal 변환 함수
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
    	      $(this).text('경보 켜기');
    	    } else {
    	      map.addLayer(warnLayerGroup);
    	      $(this).text('경보 끄기');
    	    }
    	    warnVisible = !warnVisible;
    	  }
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