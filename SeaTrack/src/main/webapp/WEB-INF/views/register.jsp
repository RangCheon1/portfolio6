<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>회원가입</title>
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
  .register-container {
    background-color: white;
    padding: 30px 40px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    width: 360px;
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
    margin-bottom: 8px;
    font-size: 1rem;
  }
  input[type="text"],
  input[type="password"],
  input[type="email"] {
    padding: 10px 12px;
    margin-bottom: 18px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 1rem;
    transition: border-color 0.3s ease;
    width: 100%;
    box-sizing: border-box;
  }
  input[type="text"]:focus,
  input[type="password"]:focus,
  input[type="email"]:focus {
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
    margin-top: 10px;
    transition: background-color 0.3s ease;
  }
  button:hover {
    background-color: #1f5d8b;
  }
  .error-msg {
    color: red;
    font-size: 0.8em;
    margin-top: -14px;
    margin-bottom: 12px;
    min-height: 18px;
    display: block;
  }
  .success-msg {
    color: green;
    font-size: 0.8em;
    margin-top: -14px;
    margin-bottom: 12px;
    min-height: 18px;
    display: block;
  }
</style>
</head>
<body>

<div class="register-container">
  <h2>회원가입</h2>
  <form id="registerForm" method="post" action="${pageContext.request.contextPath}/user/register" accept-charset="UTF-8" onsubmit="return validateForm()">
      <label for="userid">아이디:</label>
      <input type="text" id="userid" name="userid" onkeyup="checkUserid()" required />
      <span id="userid-msg" class="error-msg"></span>

      <label for="username">이름:</label>
      <input type="text" id="username" name="username" required />
      <span id="username-msg" class="error-msg"></span>

      <label for="userpw">비밀번호:</label>
      <input type="password" id="userpw" name="userpw" onkeyup="checkPassword()" required />
      <span id="userpw-msg" class="error-msg"></span>

      <label for="userpwConfirm">비밀번호 확인:</label>
      <input type="password" id="userpwConfirm" name="userpwConfirm" onkeyup="checkPasswordConfirm()" required />
      <span id="userpwConfirm-msg" class="error-msg"></span>

      <label for="email">이메일:</label>
      <input type="email" id="email" name="email" onkeyup="checkEmail()" required />
      <span id="email-msg" class="error-msg"></span>

      <button type="submit">회원가입</button>
      <button type="button" onclick="location.href='${pageContext.request.contextPath}/map3'">지도로 돌아가기</button>
  </form>
</div>

<script>
const contextPath = "${pageContext.request.contextPath}";

const useridRegex = /^[a-zA-Z0-9]{5,20}$/;
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\[\]{};':"\\|,.<>\/?]).{5,20}$/;

let useridValid = false;
let emailValid = false;
let passwordValid = false;
let passwordConfirmValid = false;

function checkUserid() {
    const userid = document.getElementById('userid').value.trim();
    const msg = document.getElementById('userid-msg');

    if (!useridRegex.test(userid)) {
        msg.textContent = '아이디는 영문+숫자 5~20글자만 가능합니다.';
        msg.className = 'error-msg';
        useridValid = false;
        return;
    }

    fetch(contextPath + "/user/checkUserid?userid=" + encodeURIComponent(userid))
        .then(res => res.json())
        .then(data => {
            if (data.available) {
                msg.textContent = '사용 가능한 아이디입니다.';
                msg.className = 'success-msg';
                useridValid = true;
            } else {
                msg.textContent = '이미 사용 중인 아이디입니다.';
                msg.className = 'error-msg';
                useridValid = false;
            }
        })
        .catch(() => {
            msg.textContent = '서버 오류가 발생했습니다.';
            msg.className = 'error-msg';
            useridValid = false;
        });
}

function checkEmail() {
    const email = document.getElementById('email').value.trim();
    const msg = document.getElementById('email-msg');
    if (emailRegex.test(email)) {
        msg.textContent = '올바른 이메일 형식입니다.';
        msg.className = 'success-msg';
        emailValid = true;
    } else {
        msg.textContent = '이메일 형식이 올바르지 않습니다.';
        msg.className = 'error-msg';
        emailValid = false;
    }
}

function checkPassword() {
    const pw = document.getElementById('userpw').value;
    const msg = document.getElementById('userpw-msg');
    if (passwordRegex.test(pw)) {
        msg.textContent = '안전한 비밀번호 형식입니다.';
        msg.className = 'success-msg';
        passwordValid = true;
    } else {
        msg.textContent = '비밀번호는 영문, 숫자, 특수문자 포함 5~20글자여야 합니다.';
        msg.className = 'error-msg';
        passwordValid = false;
    }
    checkPasswordConfirm();
}

function checkPasswordConfirm() {
    const pw = document.getElementById('userpw').value;
    const pwConfirm = document.getElementById('userpwConfirm').value;
    const msg = document.getElementById('userpwConfirm-msg');
    if (pw === pwConfirm && pwConfirm.length > 0) {
        msg.textContent = '비밀번호가 일치합니다.';
        msg.className = 'success-msg';
        passwordConfirmValid = true;
    } else {
        msg.textContent = '비밀번호가 일치하지 않습니다.';
        msg.className = 'error-msg';
        passwordConfirmValid = false;
    }
}

function validateForm() {
    const username = document.getElementById('username').value.trim();
    const usernameMsg = document.getElementById('username-msg');
    if (username === '') {
        usernameMsg.textContent = '이름을 입력해주세요.';
        return false;
    } else {
        usernameMsg.textContent = '';
    }

    if (!useridValid) {
        alert('아이디를 확인하세요.');
        return false;
    }
    if (!emailValid) {
        alert('이메일을 확인하세요.');
        return false;
    }
    if (!passwordValid) {
        alert('비밀번호를 확인하세요.');
        return false;
    }
    if (!passwordConfirmValid) {
        alert('비밀번호 확인을 맞게 입력하세요.');
        return false;
    }
    return true;
}
</script>

</body>
</html>
