<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>선박 수정</title>
</head>
<body>
  <h2>선박 수정</h2>

  <form action="${pageContext.request.contextPath}/ships/edit" method="post">
    <input type="hidden" name="id" value="${ship.id}" />

    <label>선박명: <input type="text" name="ship_name" value="${ship.ship_name}" required /></label><br/><br/>
    <label>선박 종류:
      <select name="ship_type" required>
        <option value="어선" ${ship.ship_type == '어선' ? 'selected' : ''}>어선</option>
        <option value="화물선" ${ship.ship_type == '화물선' ? 'selected' : ''}>화물선</option>
        <option value="여객선" ${ship.ship_type == '여객선' ? 'selected' : ''}>여객선</option>
      </select>
    </label><br/><br/>
    <label>선박주 이름: <input type="text" name="owner_name" value="${ship.owner_name}" required /></label><br/><br/>
    <input type="submit" value="수정 완료" />
  </form>

  <a href="${pageContext.request.contextPath}/ships/list">목록으로 돌아가기</a>
</body>
</html>
