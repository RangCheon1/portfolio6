<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>선박 등록</title>
    <style>
        body {
            font-family: '나눔고딕', '맑은 고딕', Malgun Gothic, dotum, 돋움, Arial, sans-serif;
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            color: #333;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }
        label {
            font-weight: 600;
            font-size: 1.1em;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        input[type="text"], select {
            padding: 10px 12px;
            font-size: 1em;
            border: 1px solid #ccc;
            border-radius: 5px;
            transition: border-color 0.3s ease;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="text"]:focus, select:focus {
            outline: none;
            border-color: #2980b9;
            box-shadow: 0 0 6px rgba(41,128,185,0.5);
        }
        button[type="submit"] {
            padding: 12px 0;
            background-color: #2980b9;
            border: none;
            color: white;
            font-weight: bold;
            font-size: 1.1em;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button[type="submit"]:hover {
            background-color: #1f5d8b;
        }
        a {
            display: block;
            margin-top: 30px;
            text-align: center;
            color: #2980b9;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #1f5d8b;
        }
    </style>
</head>
<body>
    <h2>선박 등록</h2>

    <form action="${pageContext.request.contextPath}/mypage/registerShip" method="post">
        <label>
    선박명:
    <input type="text" name="shipname" required />
</label>
<label>
    선박 종류:
    <select name="shiptype" required>
        <option value="">--선택--</option>
        <option value="어선">어선</option>
        <option value="화물선">화물선</option>
        <option value="여객선">여객선</option>
    </select>
</label>
<label>
    선주명:
    <input type="text" name="ownername" required />
</label>

        <button type="submit">등록</button>
    </form>

    <a href="${pageContext.request.contextPath}/mypage">마이페이지로 돌아가기</a>
</body>
</html>
