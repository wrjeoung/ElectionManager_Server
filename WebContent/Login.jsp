<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<% 
	/**
	String result = "INIT";
	try{
		result = (String) session.getAttribute("result");
	}catch(NullPointerException npe){
		result = "INIT"; 
	}finally{
		if(result==null){
			result = "INIT"; 
		}
	}
	System.out.println("Login result:"+result);
	**/
	
	
	
%>
<head>
	<meta charset="utf-8" />
    <title>선거관리서비스</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.min.css" />

    <script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">

<div class="page-header">
    <h1>선거관리서비스<small> 관리자페이지</small></h1>
</div>

<!-- Simple Login - START -->
<form name = "Login" class="col-md-12" action="AddressServlet" method="post">
    <div class="form-group">
        <input type="text" id="loginid" name = "loginid" class="form-control input-lg" placeholder="아이디" size="30">
    </div>
    <div class="form-group">
        <input type="password" id="passwd" name ="passwd" class="form-control input-lg" placeholder="비밀번호" size="30">
    </div>
    <div class="form-group">
        <button class="btn btn-primary btn-lg btn-block">로그인</button>
    </div>
<input type = "hidden" name = "mode" value="Login">
</form>
<% //if(!result.equals("INIT") && !result.equals("SUCCESS")){%>
<!--  <span>로그인 실패하였습니다. 다시 시도해주세요.</span> -->	
<% //} %>
<!-- Simple Login - END -->

</div>

</body>
</html>