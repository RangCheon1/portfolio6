<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>마이페이지</title>
    <style>
        body {
            font-family: '나눔고딕', '맑은 고딕', Malgun Gothic, dotum, 돋움, Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            color: #333;
        }

        #header {
    width: 100%;
    height: 50px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 16px;
    background-color: #F0F4F9;
    position: fixed;
    top: 0;
    z-index: 1000;
    box-sizing: border-box;
}

#header a {
    font-size: 1.1rem;
    font-weight: 600;
    text-decoration: none;
    color: #3a61b5;
    white-space: nowrap;
}

.btn-logout {
    background-color: #e67e22;
    color: white !important;
    padding: 6px 12px;
    border-radius: 4px;
    font-weight: bold;
    text-decoration: none;
    font-size: 0.9rem;
}

.btn-logout:hover {
    background-color: #cf711b;
}


        .btn-logout {
            background-color: #e67e22;
            color: white !important;
            padding: 6px 14px;
            border-radius: 4px;
            font-weight: bold;
            text-decoration: none;
        }

        .btn-logout:hover {
            background-color: #cf711b;
        }

        .container {
            max-width: 900px;
            margin: 100px auto 20px auto;
            padding: 20px;
        }

        h2, h3 {
            color: #2c3e50;
            margin: 0 0 15px 0;
        }

        .user-info-table,
        .ship-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .user-info-table th, .user-info-table td,
        .ship-table th, .ship-table td {
            padding: 12px 16px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .user-info-table th {
            background-color: #f2f6fa;
            width: 150px;
        }

        .ship-table th {
            background-color: #2980b9;
            color: white;
            text-align: center;
        }

        .ship-table td {
            text-align: center;
        }

        .status-pending {
            color: #e74c3c;
            font-weight: bold;
        }

        .status-active {
            color: #27ae60;
            font-weight: bold;
        }

        .notice {
            color: #e74c3c;
            font-weight: bold;
            margin-top: 10px;
        }

        .btn-request-delete,
        .btn-cancel-delete {
            margin-top: 10px;
            border: none;
            padding: 8px 16px;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            color: white;
        }

        .btn-request-delete {
            background-color: #e74c3c;
        }

        .btn-request-delete:hover {
            background-color: #c0392b;
        }

        .btn-cancel-delete {
            background-color: #2ecc71;
        }

        .btn-cancel-delete:hover {
            background-color: #27ae60;
        }

        a.btn-edit {
            background-color: #3498db;
            color: white !important;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
        }

        a.btn-edit:hover {
            background-color: #217dbb;
        }

        button.btn-delete {
            background-color: #e74c3c;
            border: none;
            color: white;
            padding: 6px 12px;
            border-radius: 4px;
            font-weight: bold;
        }

        button.btn-delete:hover {
            background-color: #c0392b;
        }

        #checkAll {
            cursor: pointer;
            transform: scale(1.2);
        }

        .action-buttons {
            margin-top: 20px;
        }

        .action-buttons .btn-action {
            background-color: #2980b9;
            color: white !important;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: bold;
            margin-right: 15px;
            text-decoration: none;
        }

        .action-buttons .btn-action:hover {
            background-color: #1f5d8b;
        }
    </style>
</head>
<body>

<div id="header">
    <a href="${pageContext.request.contextPath}/">해양교통안전정보시스템</a>
    <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">로그아웃</a>
</div>

<div class="container">
    <c:if test="${not empty message}">
        <script>alert("${message}");</script>
    </c:if>
    <c:if test="${not empty error}">
        <script>alert("${error}");</script>
    </c:if>

    <h2>마이페이지</h2>

    <div class="user-info-wrapper">
        <h3>회원 정보</h3>
        <table class="user-info-table">
            <tr>
                <th>아이디</th>
                <td>${user.userid}</td>
            </tr>
            <tr>
                <th>이름</th>
                <td>${user.username}</td>
            </tr>
            <tr>
                <th>이메일</th>
                <td>${user.email}</td>
            </tr>
            <tr>
                <th>회원 상태</th>
                <td>
                    <c:choose>
                        <c:when test="${user.status eq 'pending_delete'}">
                            <span class="status-pending">탈퇴 유예중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-active">정상 회원</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>

        <c:choose>
            <c:when test="${user.status eq 'pending_delete'}">
                <p class="notice">※ 탈퇴 유예 상태입니다. 7일 후 자동 탈퇴 처리됩니다.</p>
                <form method="post" action="${pageContext.request.contextPath}/user/cancelDelete" onsubmit="return confirm('탈퇴 요청을 취소하시겠습니까?')">
                    <button type="submit" class="btn-cancel-delete">탈퇴 요청 취소</button>
                </form>
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/user/delete" onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
                    <button type="submit" class="btn-request-delete">회원 탈퇴</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <h3>내 선박 목록</h3>

    <c:if test="${empty shipList}">
        <p>등록된 선박이 없습니다.</p>
    </c:if>

    <c:if test="${not empty shipList}">
        <form id="deleteShipsForm" method="post" action="${pageContext.request.contextPath}/mypage/deleteShips">
            <table class="ship-table">
                <tr>
                    <th><input type="checkbox" id="checkAll" /></th>
                    <th>선박명</th>
                    <th>선박 종류</th>
                    <th>선주명</th>
                    <th>등록일</th>
                    <th>작업</th>
                </tr>
                <c:forEach var="ship" items="${shipList}">
                    <tr>
                        <td><input type="checkbox" name="shipnos" value="${ship.shipno}" /></td>
                        <td>${ship.shipname}</td>
                        <td>${ship.shiptype}</td>
                        <td>${ship.ownername}</td>
                        <td><fmt:formatDate value="${ship.regdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <a class="btn-edit" href="${pageContext.request.contextPath}/mypage/editShip?shipno=${ship.shipno}">수정</a>
                            <button type="button" class="btn-delete" onclick="deleteSingle(${ship.shipno})">삭제</button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <br/>
            <button type="button" onclick="deleteSelected()">선택 삭제</button>
        </form>
    </c:if>

    <div class="action-buttons">
        <a href="${pageContext.request.contextPath}/mypage/registerShip" class="btn-action">선박 등록하기</a>
        <a href="${pageContext.request.contextPath}/map3" class="btn-action">지도로 이동</a>
    </div>
</div>

<script>
    document.getElementById('checkAll').addEventListener('change', function() {
        const checkboxes = document.getElementsByName('shipnos');
        checkboxes.forEach(cb => cb.checked = this.checked);
    });

    function deleteSingle(shipno) {
        if(confirm('정말 삭제하시겠습니까?')) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/mypage/deleteShip';
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'shipno';
            input.value = shipno;
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }

    function deleteSelected() {
        const checked = document.querySelectorAll('input[name="shipnos"]:checked');
        if (checked.length === 0) {
            alert('삭제할 선박을 선택해주세요.');
            return;
        }
        if (confirm('선택한 선박을 정말 삭제하시겠습니까?')) {
            document.getElementById('deleteShipsForm').submit();
        }
    }
</script>

</body>
</html>
