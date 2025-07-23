<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
  body {
    font-family: '나눔고딕', '맑은 고딕', Malgun Gothic, dotum, 돋움, Arial, sans-serif;
    background-color: #f7f9fc;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
  }
  .login-container {
    background-color: white;
    padding: 30px 40px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 320px;
  }
  h2 {
    text-align: center;
    margin-bottom: 25px;
    color: #2c3e50;
  }
  form {
    display: flex;
    flex-direction: column;
  }
  label {
    font-weight: 600;
    margin-bottom: 6px;
    font-size: 1rem;
  }
  input[type="text"],
  input[type="password"] {
    padding: 10px 12px;
    margin-bottom: 18px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 1rem;
    transition: border-color 0.3s ease;
  }
  input[type="text"]:focus,
  input[type="password"]:focus {
    border-color: #2980b9;
    outline: none;
    box-shadow: 0 0 6px rgba(41,128,185,0.5);
  }
  button {
    background-color: #2980b9;
    color: white;
    font-weight: bold;
    padding: 12px 0;
    border: none;
    border-radius: 6px;
    font-size: 1.1rem;
    cursor: pointer;
    margin-bottom: 12px;
    transition: background-color 0.3s ease;
  }
  button:hover {
    background-color: #1f5d8b;
  }
  .register-btn {
    background-color: #27ae60;
  }
  .register-btn:hover {
    background-color: #1e8449;
  }
</style>
</head>
<body>

<div class="login-container">
  <h2>로그인</h2>

  <c:if test="${param.error eq 'true'}">
    <script>
      alert('아이디 또는 비밀번호가 올바르지 않습니다.');
    </script>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/user/login">
    <label for="userid">아이디</label>
    <input type="text" id="userid" name="userid" required autocomplete="username">

    <label for="userpw">비밀번호</label>
    <input type="password" id="userpw" name="userpw" required autocomplete="current-password">

    <button type="submit">로그인</button>
  </form>

  <!-- 회원가입 버튼 -->
  <form method="get" action="${pageContext.request.contextPath}/user/register">
    <button type="submit" class="register-btn">회원가입</button>
  </form>
</div>

</body>
</html>
