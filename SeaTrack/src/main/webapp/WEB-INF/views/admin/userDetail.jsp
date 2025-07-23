<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<title>관리자 - 사용자 상세</title>
<style>
  body {
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f9fafc;
    color: #333;
    margin: 20px auto;
    max-width: 900px;
    padding: 0 20px 40px 20px;
  }

  h2, h3 {
    color: #2c3e50;
    border-bottom: 2px solid #4a90e2;
    padding-bottom: 6px;
    margin-bottom: 20px;
  }

  form {
    background: #fff;
    padding: 20px 25px;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgb(0 0 0 / 0.1);
    margin-bottom: 40px;
  }

  input[type="text"],
  input[type="email"],
  select {
    width: 100%;
    max-width: 400px;
    padding: 8px 10px;
    margin-top: 6px;
    margin-bottom: 18px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 15px;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
  }

  input[type="text"]:focus,
  input[type="email"]:focus,
  select:focus {
    border-color: #4a90e2;
    outline: none;
  }

  button[type="submit"], button[type="button"] {
    background-color: #4a90e2;
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  button[type="submit"]:hover,
  button[type="button"]:hover {
    background-color: #357abd;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgb(0 0 0 / 0.1);
  }

  thead {
    background-color: #4a90e2;
    color: white;
    font-weight: 600;
  }

  th, td {
    padding: 12px 15px;
    border-bottom: 1px solid #ddd;
    text-align: left;
  }

  tbody tr:hover {
    background-color: #f1f8ff;
  }

  /* 삭제 버튼 폼만 스타일 제거 및 가운데 정렬 */
  td.delete-cell {
    text-align: center;
  }

  form.ship-delete-form {
    margin: 0; /* 폼 마진 제거 */
    padding: 0; /* 폼 패딩 제거 */
    box-shadow: none !important; /* 그림자 제거 */
    border-radius: 0 !important; /* 보더 라운드 제거 */
    display: inline-block;
  }

  form.ship-delete-form button[type="submit"] {
    background-color: #e74c3c;
    padding: 6px 14px;
    font-size: 14px;
     border-radius: 6px;
    box-shadow: none !important;
    border: none;
    cursor: pointer;
  }
  
  form.ship-delete-form button[type="submit"]:hover {
    background-color: #c0392b;
  }

  p {
    margin-top: 10px;
  }

  a {
    text-decoration: none;
  }

  /* 회원 목록으로 돌아가기 버튼을 링크 스타일 없이 버튼 모양으로 */
  a button {
    width: auto;
  }
</style>
</head>
<body>

<h2>사용자 상세 정보</h2>

<form action="${pageContext.request.contextPath}/admin/users/update" method="post">
    <input type="hidden" name="userno" value="${user.userno}" />
    <input type="hidden" name="status" value="${user.status}" />
    아이디: <input type="text" name="userid" value="${user.userid}" readonly /><br/>
    이름: <input type="text" name="username" value="${user.username}" /><br/>
    이메일: <input type="email" name="email" value="${user.email}" /><br/>
    <button type="submit">회원 정보 수정</button>
</form>

<h3>등록된 선박 목록</h3>
<c:if test="${not empty shipList}">
    <table border="1" cellpadding="5">
        <thead>
            <tr><th>선박명</th><th>선박 타입</th><th>소유자</th><th>삭제</th></tr>
        </thead>
        <tbody>
            <c:forEach var="ship" items="${shipList}">
                <tr>
                    <td>${ship.shipname}</td>
                    <td>${ship.shiptype}</td>
                    <td>${ship.ownername}</td>
                    <td class="delete-cell">
                        <form class="ship-delete-form" action="${pageContext.request.contextPath}/admin/users/ship/delete" method="post" onsubmit="return confirm('삭제하시겠습니까?');">
                            <input type="hidden" name="shipno" value="${ship.shipno}" />
                            <input type="hidden" name="userno" value="${user.userno}" />
                            <button type="submit">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>
<c:if test="${empty shipList}">
    <p>등록된 선박이 없습니다.</p>
</c:if>

<h3>선박 추가</h3>
<form action="${pageContext.request.contextPath}/admin/users/ship/add" method="post">
    <input type="hidden" name="userno" value="${user.userno}" />
    선박명: <input type="text" name="shipname" required /><br/>
    선박 타입: <input type="text" name="shiptype" required /><br/>
    소유자명: <input type="text" name="ownername" required /><br/>
    <button type="submit">선박 추가</button>
</form>
<p>
    <a href="${pageContext.request.contextPath}/admin/users">
        <button type="button">회원 목록으로 돌아가기</button>
    </a>
</p>
</body>
<c:if test="${not empty msg}">
<script>
    alert('${msg}');
</script>
</c:if>

</html>
