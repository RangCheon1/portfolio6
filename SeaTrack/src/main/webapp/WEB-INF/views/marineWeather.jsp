<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>기상청 해양기상 데이터</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>기상청 해양기상 데이터</h1>
    <button id="loadDataBtn">데이터 불러오기</button>
    <div id="result"></div>

    <script>
        $('#loadDataBtn').on('click', function() {
            $('#result').html('로딩 중...');

            $.ajax({
                url: '/api/kmaMarineWeather',
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    if (!data.kmaData || data.kmaData.length === 0) {
                        $('#result').html('데이터가 없습니다.');
                        return;
                    }

                    let html = '<table border="1" cellpadding="5" cellspacing="0">';
                    html += '<tr>'
                        + '<th>관측종류 (TP)</th>'
                        + '<th>지점 ID (STN_ID)</th>'
                        + '<th>지점명 (STN_KO)</th>'
                        + '<th>관측시각 (TM)</th>'
                        + '<th>유의파고 (WH, m)</th>'
                        + '<th>풍향 (WD, °)</th>'
                        + '<th>풍속 (WS, m/s)</th>'
                        + '<th>GUST 풍속 (WS_GST, m/s)</th>'
                        + '<th>해수면 온도 (TW, °C)</th>'
                        + '<th>기온 (TA, °C)</th>'
                        + '<th>해면기압 (PA, hPa)</th>'
                        + '<th>상대습도 (HM, %)</th>'
                        + '</tr>';

                    data.kmaData.forEach(function(item) {
                        html += '<tr>'
                            + '<td>' + item.TP + '</td>'
                            + '<td>' + item.STN_ID + '</td>'
                            + '<td>' + item.STN_KO + '</td>'
                            + '<td>' + item.TM + '</td>'
                            + '<td>' + item.WH + '</td>'
                            + '<td>' + item.WD + '</td>'
                            + '<td>' + item.WS + '</td>'
                            + '<td>' + item.WS_GST + '</td>'
                            + '<td>' + item.TW + '</td>'
                            + '<td>' + item.TA + '</td>'
                            + '<td>' + item.PA + '</td>'
                            + '<td>' + item.HM + '</td>'
                            + '</tr>';
                    });

                    html += '</table>';
                    $('#result').html(html);
                },
                error: function(xhr, status, error) {
                    $('#result').html('데이터 로드 중 오류 발생: ' + error);
                }
            });
        });
    </script>
</body>
</html>
