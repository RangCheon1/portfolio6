<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>실시간 해양교통정보 조회</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<h2>실시간 해양교통정보</h2>
<button id="loadShipsBtn">정보 불러오기</button>
<a href="marineWeather"><button>해양기상 페이지로 이동</button></a>
<a href="khoaSpeed"><button>해양 유속 페이지로 이동</button></a>

<table border="1" style="border-collapse: collapse; width: 70%; margin-top: 20px;">
    <thead>
    <tr>
        <th>그리드ID</th>
        <th>교통량 (vmtc)</th>
        <th>밀도 (dnsty)</th>
    </tr>
    </thead>
    <tbody id="shipTableBody">
    <tr><td colspan="3" style="text-align:center;">데이터가 없습니다.</td></tr>
    </tbody>
</table>

<script>
    $('#loadShipsBtn').click(function() {
        $.ajax({
            url: '/api/ships',
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                console.log("받은 데이터:", data);

                var items = [];
                if (data.response && data.response.body && data.response.body.items) {
                    items = data.response.body.items.item;

                    // 단일 객체인 경우 배열로 감싸기
                    if (!Array.isArray(items)) {
                        items = [items];
                    }
                }

                var html = '';
                if (items.length === 0) {
                    html = '<tr><td colspan="3" style="text-align:center;">데이터가 없습니다.</td></tr>';
                } else {
                    items.forEach(function(row) {
                        html += '<tr>'
                            + '<td>' + (row.grid_id || '') + '</td>'
                            + '<td>' + (row.vmtc || '') + '</td>'
                            + '<td>' + (row.dnsty || '') + '</td>'
                            + '</tr>';
                    });
                }

                $('#shipTableBody').html(html);
            },
            error: function(xhr, status, error) {
                alert('API 요청 실패: ' + error);
            }
        });
    });
</script>


</body>
</html>
