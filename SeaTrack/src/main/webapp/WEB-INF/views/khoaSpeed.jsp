<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>KHOA 유속 데이터 조회</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h1>KHOA 유속 데이터 조회</h1>
    
    <label for="obsCodeInput">관측소 코드 (ObsCode): </label>
    <input type="text" id="obsCodeInput" value="DT_0001" />
    <button id="loadDataBtn">유속 데이터 불러오기</button>

    <div id="result"></div>

    <script>
        $('#loadDataBtn').on('click', function() {
            let obsCode = $('#obsCodeInput').val().trim();
            if (!obsCode) {
                alert('관측소 코드를 입력하세요.');
                return;
            }

            $('#result').html('로딩 중...');

            $.ajax({
                url: '/api/khoaCurrentSpeed',
                method: 'GET',
                data: { obsCode: obsCode },
                dataType: 'json',
                success: function(data) {
                    if (!data.result || !data.result.data) {
                        $('#result').html('데이터가 없습니다.');
                        return;
                    }

                    const meta = data.result.meta;
                    const item = data.result.data;

                    let html = '<h3>관측소명: ' + meta.obs_post_name + ' (ID: ' + meta.obs_post_id + ')</h3>';
                    html += '<table border="1" cellpadding="5" cellspacing="0">';
                    html += '<tr>'
                        + '<th>관측시각</th>'
                        + '<th>유속 (m/s)</th>'
                        + '<th>GUST 풍속 (m/s)</th>'
                        + '<th>풍향 (°)</th>'
                        + '<th>기온 (°C)</th>'
                        + '<th>기압 (hPa)</th>'
                        + '<th>해수면 온도 (°C)</th>'
                        + '<th>조위 (tide level)</th>'
                        + '<th>염분 (Salinity)</th>'
                        + '</tr>';

                    html += '<tr>'
                        + '<td>' + item.record_time + '</td>'
                        + '<td>' + item.wind_speed + '</td>'
                        + '<td>' + item.wind_gust + '</td>'
                        + '<td>' + item.wind_dir + '</td>'
                        + '<td>' + item.air_temp + '</td>'
                        + '<td>' + item.air_press + '</td>'
                        + '<td>' + item.water_temp + '</td>'
                        + '<td>' + item.tide_level + '</td>'
                        + '<td>' + item.Salinity + '</td>'
                        + '</tr>';

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
