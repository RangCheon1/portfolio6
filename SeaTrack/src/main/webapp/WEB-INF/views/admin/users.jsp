<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>관리자 - 회원 관리</title>
    <style>
  body {
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f5f8fb;
    margin: 20px;
    color: #333;
  }

  h1 {
    color: #3a61b5;
    margin-bottom: 20px;
  }

  /* 지도 이동 버튼 */
  p > a > button {
    background-color: #3a61b5;
    color: white;
    border: none;
    padding: 8px 14px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
    transition: background-color 0.3s ease;
  }
  p > a > button:hover {
    background-color: #2a488f;
  }

  /* 필터 폼 */
  form {
    margin-bottom: 20px;
  }

  label {
    font-weight: 600;
    margin-right: 10px;
  }

  select {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
    cursor: pointer;
    transition: border-color 0.3s ease;
  }

  select:focus {
    border-color: #3a61b5;
    outline: none;
  }

  /* 회원 목록 테이블 */
  table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    border-radius: 8px;
    overflow: hidden;
  }

  thead {
    background-color: #3a61b5;
    color: white;
  }

  thead th {
    padding: 12px;
    font-weight: 700;
    text-align: left;
  }

  tbody td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    vertical-align: middle;
  }

  tbody tr:hover {
    background-color: #f0f5ff;
  }

  /* 상태 변경 select + 버튼 가로 배치 */
  td form {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  td form select {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 14px;
    cursor: pointer;
    transition: border-color 0.3s ease;
  }

  td form select:focus {
    border-color: #3a61b5;
    outline: none;
  }

  td form button {
    background-color: #3a61b5;
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
    transition: background-color 0.3s ease;
  }

  td form button:hover {
    background-color: #2a488f;
  }

  /* 즉시 삭제 버튼 스타일 */
  td form button {
    background-color: #e74c3c;
  }

  td form button:hover {
    background-color: #b83227;
  }

  /* 링크 스타일 (회원 아이디) */
  a {
    color: #3a61b5;
    text-decoration: none;
    font-weight: 600;
  }

  a:hover {
    text-decoration: underline;
  }
</style>
    
</head>
<body>
    <h1>회원 관리</h1>
    
     <!-- ▶ 지도 이동 버튼 -->
    <p>
        <a href="${pageContext.request.contextPath}/map3">
            <button type="button">지도로 이동</button>
        </a>
    </p>

    <form method="get" action="${pageContext.request.contextPath}/admin/users">
        <label for="status">회원 상태 필터: </label>
        <select id="status" name="status" onchange="this.form.submit()">
            <option value="" ${status == null ? "selected" : ""}>전체</option>
            <option value="active" ${status == 'active' ? "selected" : ""}>활성</option>
            <option value="pending_delete" ${status == 'pending_delete' ? "selected" : ""}>탈퇴 유예</option>
        </select>
    </form>

    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>회원번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>이메일</th>
                <th>가입일</th>
                <th>상태</th>
                <th>탈퇴 요청일</th>
                <th>상태 변경</th>
                <th>즉시 삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.userno}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/users/detail/${user.userno}">
                            ${user.userid}
                        </a>
                    </td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.regdate}</td>
                    <td>${user.status}</td>
                    <td>
    <c:choose>
        <c:when test="${user.deleteRequestedAt != null}">
            ${user.deleteRequestedAt}
        </c:when>
        <c:otherwise>-</c:otherwise>
    </c:choose>
</td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/users/changeStatus" style="display:inline;">
                            <input type="hidden" name="userno" value="${user.userno}" />
                            <select name="status">
                                <option value="active" ${user.status == 'active' ? 'selected' : ''}>활성</option>
                                <option value="pending_delete" ${user.status == 'pending_delete' ? 'selected' : ''}>탈퇴 유예</option>
                            </select>
                            <button type="submit">변경</button>
                        </form>
                    </td>
                    <td>
                        <c:if test="${user.status == 'pending_delete'}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/users/delete" onsubmit="return confirm('정말 즉시 삭제하시겠습니까?');">
                                <input type="hidden" name="userno" value="${user.userno}" />
                                <button type="submit">즉시 삭제</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</body>
</html>
