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
            margin: 20px auto;
            max-width: 900px;
            padding: 20px;
            color: #333;
        }
        h2, h3 {
            color: #2c3e50;
            margin: 0;
        }
        p {
            font-size: 1.1em;
            margin: 4px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            background-color: white;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px 15px;
            text-align: center;
        }
        th {
            background-color: #2980b9;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f2f6fa;
        }
        tr:hover {
            background-color: #d9e9ff;
        }
        a {
            color: #2980b9;
            text-decoration: none;
            font-weight: 600;
            margin: 0 5px;
        }
        a.btn-edit {
            background-color: #3498db;
            color: white !important;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        a.btn-edit:hover {
            background-color: #217dbb;
        }
        button.btn-delete {
            background-color: #e74c3c;
            border: none;
            color: white;
            padding: 6px 12px;
            font-size: 0.9em;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 5px;
        }
        button.btn-delete:hover {
            background-color: #c0392b;
        }
        button {
            font-family: inherit;
        }
        #checkAll {
            cursor: pointer;
            transform: scale(1.2);
        }
        form > button {
            background-color: #27ae60;
            margin-top: 15px;
            border: none;
            color: white;
            padding: 8px 16px;
            font-weight: bold;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        form > button:hover {
            background-color: #1e8449;
        }
        br + a {
            margin-top: 10px;
            display: inline-block;
        }
        .header-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .btn-logout {
            background-color: #e67e22;
            color: white !important;
            padding: 6px 14px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .btn-logout:hover {
            background-color: #cf711b;
        }
        .action-buttons {
            margin-top: 20px;
        }
        .action-buttons .btn-action {
            background-color: #2980b9;
            color: white !important;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            margin-right: 15px;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        .action-buttons .btn-action:hover {
            background-color: #1f5d8b;
        }
    </style>
</head>
<body>

<div class="header-container">
    <h2>마이페이지</h2>
    <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">로그아웃</a>
</div>

<p>아이디: ${user.userid}</p>
<p>이름: ${user.username}</p>
<p>이메일: ${user.email}</p>

<p>회원 상태: 
  <c:choose>
    <c:when test="${user.status eq 'pending_delete'}">
      <span style="color: red;">탈퇴 유예중</span>
    </c:when>
    <c:otherwise>
      <span style="color: green;">정상 회원</span>
    </c:otherwise>
  </c:choose>
</p>

<c:choose>
  <c:when test="${user.status eq 'pending_delete'}">
    <p style="color: red; font-weight: bold;">탈퇴 유예 상태입니다. 7일 후 자동 탈퇴 처리됩니다.</p>
    <form method="post" action="${pageContext.request.contextPath}/user/cancelDelete" onsubmit="return confirm('탈퇴 요청을 취소하시겠습니까?')">
        <button type="submit" style="color: green;">탈퇴 요청 취소</button>
    </form>
  </c:when>
  <c:otherwise>
    <form method="post" action="${pageContext.request.contextPath}/user/delete" onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
        <button type="submit" style="color: red;">회원 탈퇴</button>
    </form>
  </c:otherwise>
</c:choose>

<h3>내 선박 목록</h3>

<c:if test="${empty shipList}">
    <p>등록된 선박이 없습니다.</p>
</c:if>

<c:if test="${not empty shipList}">
<form id="deleteShipsForm" method="post" action="${pageContext.request.contextPath}/mypage/deleteShips">
<table border="1" cellpadding="5" cellspacing="0">
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
                <a class="btn-edit" href="${pageContext.request.contextPath}/mypage/editShip?shipno=${ship.shipno}">수정</a> |
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

<script>
    // 전체 선택 / 해제 토글
    document.getElementById('checkAll').addEventListener('change', function() {
        const checkboxes = document.getElementsByName('shipnos');
        checkboxes.forEach(cb => cb.checked = this.checked);
    });

    // 단일 삭제 처리
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

    // 다중 삭제 처리
    function deleteSelected() {
        const checkedBoxes = [...document.querySelectorAll('input[name="shipnos"]:checked')];
        if(checkedBoxes.length === 0) {
            alert('삭제할 선박을 선택해주세요.');
            return;
        }
        if(confirm('선택한 선박을 정말 삭제하시겠습니까?')) {
            document.getElementById('deleteShipsForm').submit();
        }
    }
</script>

</body>
</html>
