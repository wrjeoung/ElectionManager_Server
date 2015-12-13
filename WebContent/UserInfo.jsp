<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.UserDAO" %>
<%@ page import="com.address.DBBean" %>
<%@ page import="com.address.ComboDAO" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.ArrayList"%>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin - Bootstrap Admin Template</title>
    
	<!-- Bootstrap Core CSS -->
    <link href="bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="bower_components/metisMenu/dist/metisMenu.min.css" rel="stylesheet">

    <!-- DataTables CSS -->
    <link href="bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.css" rel="stylesheet">

    <!-- DataTables Responsive CSS -->
    <link href="bower_components/datatables-responsive/css/dataTables.responsive.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	
	<!--  
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	-->
</head>
<% 		
	System.out.println("UserInfo.jsp"); 

	String userid = "";
	String s_classcd = "";	
		
	userid = (String) session.getAttribute("userid");
	s_classcd = (String) session.getAttribute("classcd");
	
	System.out.println("userid:"+userid);
	System.out.println("classcd:"+s_classcd);
		
	Gson gs = new Gson();
		
	JSONObject jo = new JSONObject();
		
	if(userid==null || userid.equals(null)){
		response.sendRedirect("Login.jsp");
	}
	
	//-----------------------------//
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = " SELECT CLASSCD, CLASSNM FROM CLASSINFO ";
		
	pstmt = conn.prepareStatement(sql);
	//pstmt.setString(1,"1");	
	rs = pstmt.executeQuery();
	
	//ComboDAO cd = null;
	ArrayList al = new ArrayList();	

	while(rs.next()){
		//cd = new  ComboDAO();
		//cd.setClasscd(rs.getString("CLASSCD"));
		//cd.setClassnm(rs.getString("CLASSNM"));
		al.add(rs.getString("CLASSCD")  + ";" +rs.getString("CLASSNM"));
	}
		
	System.out.println("class al:"+al);
	
	sql = " SELECT GROUPCD,GROUPNAME FROM GROUPINFO "; 
	
	pstmt = conn.prepareStatement(sql);
	//pstmt.setString(1,"1");	
	rs = pstmt.executeQuery();
	
	//ComboDAO cd2 = null;
	ArrayList al2 = new ArrayList();	

	while(rs.next()){
		al2.add(rs.getString("GROUPCD")  + ";" +rs.getString("GROUPNAME"));
	}
		
	UserDAO ud = null;
	request.setCharacterEncoding("UTF-8");
	System.out.println("data:"+request.getParameter("data"));
	
	//od = (OrganDAO) request.getAttribute("OrganDetail");
	ud = gs.fromJson((String)request.getParameter("data"), UserDAO.class);
		
	System.out.println("ud:"+ud);
	
	String userid_2 = "";
	String usernm = "";
	String pwd = "";
	String groupcd = "";
	String groupname = "";
    String classcd = "";
	String imei = "";
	String macaddress = "";

	if(ud == null){
		
	}else{
	
		userid_2 = ud.getUserid();
		usernm = ud.getUsernm();
		pwd = ud.getPwd();
		groupcd = ud.getGroupcd();
		groupname = ud.getGroupname();
		classcd = ud.getClasscd();
		macaddress = ud.getMacaddress();
		
		System.out.println("userid_2:"+userid_2);
		System.out.println("usernm:"+usernm);
		System.out.println("pwd:"+pwd);
		System.out.println("groupcd:"+groupcd);
		System.out.println("groupname:"+groupname);
		System.out.println("classcd:"+classcd);
		System.out.println("maccaddress:"+macaddress);
	}
%>
<body onload=init();>
<script src="js/jquery-1.10.2.min.js"></script>
<!--  <script src="bootstrap/js/bootstrap.min.js"></script>-->
<script type="text/javascript">
function selectedOption(id, value, type) {
    var obj = document.getElementById(id);
    
    for(i=0; i<obj.length; i++) {
        switch(type) {
            case 'value' :
                if(obj[i].value == value) {
                    obj[i].selected = true;
                }
                break;
            
            case 'text' :
                if(obj[i].text == value) {
                    obj[i].selected = true;
                }
                break;
            default :
                break;
        }
    }    
}

function init(){
	
	var combo_class = "<%=al.toString()%>";
	combo_class = combo_class.replace("[", "");
	combo_class = combo_class.replace("]", "");
	var sedr = combo_class.split(",");
	var cnt = "<%=al.size()%>";
	var ccd = new Array();
	
	for(var i = 0; i < cnt; i++){
		ccd[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr[i].split(";");
		ccd[i].value=temp_arr[0].replace(" ", "");  
		ccd[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['classcd'].add(ccd[i]);	
	}
	
	var combo_group = "<%=al2.toString()%>";
	combo_group = combo_group.replace("[", "");
	combo_group = combo_group.replace("]", "");
	var sedr_gp = combo_group.split(",");
	var group_cnt = "<%=al2.size()%>";
	var gp = new Array();
	
	for(var i = 0; i < group_cnt; i++){
		gp[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr_gp[i].split(";");
		gp[i].value=temp_arr[0].replace(" ", "");  
		gp[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['group_name'].add(gp[i]);	
	}
	
	f.userid.value = "<%=userid_2%>";
	f.hid_userid.value = "<%=userid_2%>";
	f.pwd.value = "<%=pwd%>";
	f.pwd_conf.value = "<%=pwd%>"; 
	f.usernm.value = "<%=usernm %>";
	f.macaddress.value = "<%=macaddress%>";
	f.hid_macaddress.value = "<%=macaddress%>";
	
	selectedOption('classcd', "<%=classcd%>", 'value');
	selectedOption('group_name', "<%=groupcd%>", 'value');
	
	/**
	var opt1 = document.createElement('option');
	opt1.text = "<%=groupname%>";
	opt1.value = "<%=groupcd%>";
	document.forms['f'].elements['group_name'].add(opt1); //select 태그에 sption을 추가
	**/

	
	/**
	var opt2 = document.createElement('option');
	opt2.text = "<%=classcd%>";
	opt2.value = "<%=classcd%>";
	document.forms['f'].elements['classcd'].add(opt2); //select 태그에 sption을 추가
	**/
} 

function check()
{
	//alert(f.pwd.value + ":" + f.pwd_conf.value);
	//return false;
	
	var pwd_len = f.pwd.value.length;
	
	if(f.usernm.value=="" || f.usernm.value == null){
		alert("이름을 입력해주세요.");
		return false;
	}else if(pwd_len!=4){
		alert("비밀번호는 4자리로 입력해주세요.");
		return false;
	}else if(f.pwd.value=="" || f.pwd.value==null){
		alert("비밀번호를 입력해주세요.");
		return false;
	}else if(f.pwd_conf.value=="" || f.pwd_conf.value==null){
		alert("비밀번호 확인을 입력해주세요.");
		return false;
	}else if(f.pwd.value != f.pwd_conf.value){
		alert("비밀번호가 일치하지 않습니다.");
		return false;
	}
}

</script>
<script>
		
			$(function(){
				//모달을 전역변수로 선언
				var modalContents = $(".modal-contents");
				var modal = $("#defaultModal");
				
				$('.onlyAlphabetAndNumber').keyup(function(event){
					if (!(event.keyCode >=37 && event.keyCode<=40)) {
						var inputVal = $(this).val();
						$(this).val($(this).val().replace(/[^_a-z0-9]/gi,'')); //_(underscore), 영어, 숫자만 가능
					}
				});
				
				$(".onlyHangul").keyup(function(event){
					if (!(event.keyCode >=37 && event.keyCode<=40)) {
						var inputVal = $(this).val();
						$(this).val(inputVal.replace(/[a-z0-9]/gi,''));
					}
				});
			
				$(".onlyNumber").keyup(function(event){
					if (!(event.keyCode >=37 && event.keyCode<=40)) {
						var inputVal = $(this).val();
						$(this).val(inputVal.replace(/[^0-9]/gi,''));
					}
				});
				
				//------- 검사하여 상태를 class에 적용
				$('#id').keyup(function(event){
					
					var divId = $('#divId');
					
					if($('#id').val()==""){
						divId.removeClass("has-success");
						divId.addClass("has-error");
					}else{
						divId.removeClass("has-error");
						divId.addClass("has-success");
					}
				});
				
				$('#password').keyup(function(event){
					
					var divPassword = $('#divPassword');
					
					if($('#password').val()==""){
						divPassword.removeClass("has-success");
						divPassword.addClass("has-error");
					}else{
						divPassword.removeClass("has-error");
						divPassword.addClass("has-success");
					}
				});
				
				$('#passwordCheck').keyup(function(event){
					
					var passwordCheck = $('#passwordCheck').val();
					var password = $('#password').val();
					var divPasswordCheck = $('#divPasswordCheck');
					
					if((passwordCheck=="") || (password!=passwordCheck)){
						divPasswordCheck.removeClass("has-success");
						divPasswordCheck.addClass("has-error");
					}else{
						divPasswordCheck.removeClass("has-error");
						divPasswordCheck.addClass("has-success");
					}
				});
				
				$('#name').keyup(function(event){
					
					var divName = $('#divName');
					
					if($.trim($('#name').val())==""){
						divName.removeClass("has-success");
						divName.addClass("has-error");
					}else{
						divName.removeClass("has-error");
						divName.addClass("has-success");
					}
				});
				
				$('#nickname').keyup(function(event){
					
					var divNickname = $('#divNickname');
					
					if($.trim($('#nickname').val())==""){
						divNickname.removeClass("has-success");
						divNickname.addClass("has-error");
					}else{
						divNickname.removeClass("has-error");
						divNickname.addClass("has-success");
					}
				});
				
				$('#email').keyup(function(event){
					
					var divEmail = $('#divEmail');
					
					if($.trim($('#email').val())==""){
						divEmail.removeClass("has-success");
						divEmail.addClass("has-error");
					}else{
						divEmail.removeClass("has-error");
						divEmail.addClass("has-success");
					}
				});
				
				$('#organ_mem_board').keyup(function(event){
					
					var div_mem_board = $('#div_mem_board');
					
					if($.trim($('#phoneNumber').val())==""){
						div_mem_board.removeClass("has-success");
						div_mem_board.addClass("has-error");
					}else{
						div_mem_board.removeClass("has-error");
						div_mem_board.addClass("has-success");
					}
				});
				
				
				//------- validation 검사
				$( "form" ).submit(function( event ) {
					
					var provision = $('#provision');
					var memberInfo = $('#memberInfo');
					var divId = $('#divId');
					var divPassword = $('#divPassword');
					var divPasswordCheck = $('#divPasswordCheck');
					var divName = $('#divName');
					var divNickname = $('#divNickname');
					var divEmail = $('#divEmail');
					var divPhoneNumber = $('#divPhoneNumber');
					
					//회원가입약관
					if($('#provisionYn:checked').val()=="N"){
						modalContents.text("회원가입약관에 동의하여 주시기 바랍니다."); //모달 메시지 입력
						modal.modal('show'); //모달 띄우기
						
						provision.removeClass("has-success");
						provision.addClass("has-error");
						$('#provisionYn').focus();
						return false;
					}else{
						provision.removeClass("has-error");
						provision.addClass("has-success");
					}
					
					//개인정보취급방침
					if($('#memberInfoYn:checked').val()=="N"){
						modalContents.text("개인정보취급방침에 동의하여 주시기 바랍니다.");
						modal.modal('show');
						
						memberInfo.removeClass("has-success");
						memberInfo.addClass("has-error");
						$('#memberInfoYn').focus();
						return false;
					}else{
						memberInfo.removeClass("has-error");
						memberInfo.addClass("has-success");
					}
					
					//아이디 검사
					if($('#id').val()==""){
						modalContents.text("아이디를 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divId.removeClass("has-success");
						divId.addClass("has-error");
						$('#id').focus();
						return false;
					}else{
						divId.removeClass("has-error");
						divId.addClass("has-success");
					}
					
					//패스워드 검사
					if($('#password').val()==""){
						modalContents.text("패스워드를 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divPassword.removeClass("has-success");
						divPassword.addClass("has-error");
						$('#password').focus();
						return false;
					}else{
						divPassword.removeClass("has-error");
						divPassword.addClass("has-success");
					}
					
					//패스워드 확인
					if($('#passwordCheck').val()==""){
						modalContents.text("패스워드 확인을 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divPasswordCheck.removeClass("has-success");
						divPasswordCheck.addClass("has-error");
						$('#passwordCheck').focus();
						return false;
					}else{
						divPasswordCheck.removeClass("has-error");
						divPasswordCheck.addClass("has-success");
					}
					
					//패스워드 비교
					if($('#password').val()!=$('#passwordCheck').val() || $('#passwordCheck').val()==""){
						modalContents.text("패스워드가 일치하지 않습니다.");
						modal.modal('show');
						
						divPasswordCheck.removeClass("has-success");
						divPasswordCheck.addClass("has-error");
						$('#passwordCheck').focus();
						return false;
					}else{
						divPasswordCheck.removeClass("has-error");
						divPasswordCheck.addClass("has-success");
					}
					
					//이름
					if($('#name').val()==""){
						modalContents.text("이름을 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divName.removeClass("has-success");
						divName.addClass("has-error");
						$('#name').focus();
						return false;
					}else{
						divName.removeClass("has-error");
						divName.addClass("has-success");
					}
					
					//별명
					if($('#nickname').val()==""){
						modalContents.text("별명을 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divNickname.removeClass("has-success");
						divNickname.addClass("has-error");
						$('#nickname').focus();
						return false;
					}else{
						divNickname.removeClass("has-error");
						divNickname.addClass("has-success");
					}
					
					//이메일
					if($('#email').val()==""){
						modalContents.text("이메일을 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						divEmail.removeClass("has-success");
						divEmail.addClass("has-error");
						$('#email').focus();
						return false;
					}else{
						divEmail.removeClass("has-error");
						divEmail.addClass("has-success");
					}
					
					//휴대폰 번호
					if($('#organ_mem_board').val()==""){
						modalContents.text("휴대폰 번호를 입력하여 주시기 바랍니다.");
						modal.modal('show');
						
						div_mem_board.removeClass("has-success");
						div_mem_board.addClass("has-error");
						$('#organ_mem_board').focus();
						return false;
					}else{
						div_mem_board.removeClass("has-error");
						div_mem_board.addClass("has-success");
					}
					
				
				});
				
			});
			
		</script>

    <div id="wrapper">
    
        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand">SB Admin v2.0</a>
            </div>
            <!-- /.navbar-header -->

            <ul class="nav navbar-top-links navbar-right">
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li class="divider"></li>
                        <li><a href="Logout.jsp"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->

            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                        <li class="sidebar-search">
                            <div class="input-group custom-search-form">
                                <input type="text" class="form-control" placeholder="Search...">
                                <span class="input-group-btn">
                                <button class="btn btn-default" type="button">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                            </div>
                            <!-- /input-group -->
                        </li>
                        <li>
                            <a href="OrganList.jsp"><i class="fa fa-table fa-fw"></i>기관정보관리</a>
                        </li>
                        <%if(s_classcd.equals("AAA")){ %>
                        <li>
                            <a href="UserList.jsp"><i class="fa fa-edit fa-fw"></i>사용자정보관리</a>
                            <a href="GroupList.jsp"><i class="fa fa-edit fa-fw"></i>그룹정보관리</a>
                            <a href="BusinessList.jsp"><i class="fa fa-edit fa-fw"></i>주요사업관리</a>
                        </li>
                        <% } else if(s_classcd.equals("BBB")){ %>
                             <li>
                             <a href="BusinessList.jsp"><i class="fa fa-edit fa-fw"></i>주요사업관리</a>             
                             </li>      
                        <% }else{}%>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>
        <div id="page-wrapper">

            <div class="container-fluid">

                <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">
                            	사용자정보등록
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a>Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>사용자정보등록
                            </li>
                        </ol>
                    </div>
                </div>
                <!-- /.row -->
				
                <div class="row">
                    <div class="col-lg-6">

                        <form id = "f" name = "user_reg" method = "post" action = "AddressServlet?mode=user_reg"  onsubmit="return check();" >

                            <div class="form-group">
                                <label>아이디</label>
                                <input id="userid" name = "userid" class="form-control" disabled>
                            </div>
                            
                            <div class="form-group">
                                <label>비밀번호</label>
                                <input type = "password" id="pwd" name = pwd class="form-control onlyNumber" placeholder="Enter Password" maxlength=4>
                            </div>
                            
                            <div class="form-group">
                                <label>비밀번호확인</label>
                                <input type = "password" id="pwd_conf" name = "pwd_conf" class="form-control onlyNumber" placeholder="Enter Password" maxlength=4>
                            </div>

                            <div class="form-group">
                                <label>이름</label>
                                <input id="usernm" name = "usernm" class="form-control" placeholder="Enter Name">
                            </div>
                            
                            <div class="form-group">
                                <label>업체명</label>
                                <select id = "group_name" name = "group_name" class="form-control">
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>사용자등급</label>
                                <select id = "classcd" name = "classcd" class="form-control">
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>디바이스ID</label> 
                                <input id="macaddress" name = "macaddress" class="form-control" disabled>
                            </div>
                            
							<button type="submit" class="btn btn-default">수정</button>
                            <button type="reset" class="btn btn-default">취소</button>
                            <input type = "hidden" id = "hid_macaddress" name = "hid_macaddress">
							<input type = "hidden" id = "hid_userid" name = "hid_userid">
						</form>
                    </div>
                   
                </div>
                <!-- /.row -->

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="bower_components/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="bower_components/metisMenu/dist/metisMenu.min.js"></script>

    <!-- DataTables JavaScript -->
    <script src="bower_components/datatables/media/js/jquery.dataTables.min.js"></script>
    <script src="bower_components/datatables-plugins/integration/bootstrap/3/dataTables.bootstrap.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="dist/js/sb-admin-2.js"></script>

    <!-- Page-Level Demo Scripts - Tables - Use for reference -->
    
    <script>
    $(document).ready(function() {
        $('#dataTables-example').DataTable({
                responsive: true
        });
    });
    </script>

</body>

</html>
