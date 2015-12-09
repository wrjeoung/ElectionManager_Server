<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.GroupDAO"%>
<%@ page import="com.address.DBBean" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList"%>
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
	System.out.println("GroupInfo.jsp"); 

	String userid = "";
	String classcd = "";
	String groupcd = "";
	String groupname = "";
	String admcd = "";
	
	String regGb = "N";

	userid = (String) session.getAttribute("userid");
	classcd = (String) session.getAttribute("classcd");
		
	System.out.println("userid:"+userid);
	System.out.println("classcd:"+classcd);
	
    Gson gs = new Gson();
    
    JSONObject jo = new JSONObject();
 
	if(userid==null || userid.equals(null)){
		response.sendRedirect("Login.jsp");
	}
	
	GroupDAO gd = null;
	request.setCharacterEncoding("UTF-8");
	System.out.println("data:"+request.getParameter("data"));

	gd = gs.fromJson((String)request.getParameter("data"), GroupDAO.class);
	
	System.out.println("gd:"+gd);
	
	if(gd == null){
		regGb = "N";

	}else{
		regGb = "Y";
		
		groupcd = gd.getGroupcd();
		groupname = gd.getGroupname();
		admcd = gd.getAdm_cd();
		
		System.out.println("groupcd:"+groupcd);
		System.out.println("groupname:"+groupname);
		System.out.println("admcd:"+admcd);
	}
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = " SELECT SIGUNGUTEXT, ADM_CD FROM ADM_CODE "
		 + " WHERE USEYN = 'Y' AND ADM_CD LIKE '%00-00' "; 
	
	pstmt = conn.prepareStatement(sql);
	//pstmt.setString(1,"1");	
	rs = pstmt.executeQuery();
	
	//ComboDAO cd2 = null;
	ArrayList al = new ArrayList();	

	while(rs.next()){
		al.add(rs.getString("ADM_CD")  + ";" +rs.getString("SIGUNGUTEXT"));
	}
	
%>
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
	//alert("init");
	
	var groupnames = "<%=groupname %>";
	var groupcds = "<%=groupcd%>";
	var admcd = "<%=admcd%>";
	var regGbs = "<%=regGb%>";
	
	f.groupname.value=groupnames;
	f.re_groupcd.value=groupcds;
	f.groupcd.value=groupcds;
	f.regGb.value = regGbs;
	
	if(f.regGb.value=="Y"){
		f.groupcd.disabled=true;
	}
	
	var combo_adm = "<%=al.toString()%>";
	combo_adm = combo_adm.replace("[", "");
	combo_adm = combo_adm.replace("]", "");
	var sedr_gp = combo_adm.split(",");
	var group_cnt = "<%=al.size()%>";
	var gp = new Array();
		
	for(var i = 0; i < group_cnt; i++){
		gp[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr_gp[i].split(";");
		gp[i].value=temp_arr[0].replace(" ", "");  
		gp[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['admcd'].add(gp[i]);	
	}
		
	selectedOption('admcd', "<%=admcd%>", 'value');	
	
	//alert(f.regGb.value);
} 

function check()
{
	//alert("check");
	
	var groupcd_cnt = f.groupcd.value.length;
	
	if(f.groupname.value=="" || f.groupname.value == null){
		alert("이름을 입력해주세요.");
		return false;
	}else if(f.groupcd.value=="" || f.groupcd.value == null){
		alert("그룹코드를 입력해주세요.");
		return false;
	}else if(groupcd_cnt!=5){
		alert("그룹코드는 5자리로 입력해주세요.");
		return false;
	}

	var message = "해당 내용으로 정말 등록 하시겠습니까?";
	
	if(confirm(message) == false){
		return false;
	}
	
}


</script>
<body onload=init();>
<script src="js/jquery-1.10.2.min.js"></script>
<!--  <script src="bootstrap/js/bootstrap.min.js"></script>-->
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
                        <li><a href="#"><i class="fa fa-user fa-fw"></i> User Profile</a>
                        </li>
                        <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                        </li>
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
                        <%if(classcd.equals("AAA")){ %>
                        <li>
                            <a href="UserList.jsp"><i class="fa fa-edit fa-fw"></i>사용자정보관리</a>
                            <a href="GroupList.jsp"><i class="fa fa-edit fa-fw"></i>그룹정보관리</a>
                            <a href="BusinessList.jsp"><i class="fa fa-edit fa-fw"></i>주요사업관리</a>
                        </li>
                        <% } else if(classcd.equals("BBB")){ %>
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
                            	그룹정보등록
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a>Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>그룹정보등록
                            </li>
                        </ol>
                    </div>
                </div>
                <!-- /.row -->
				
                <div class="row">
                    <div class="col-lg-6">

                        <form id = "f" name = "organ_reg" method = "post" action = "AddressServlet?mode=group_reg"  onsubmit="return check();">

                            <div class="form-group">
                                <label>그룹명</label>
                                <input id="groupname" name = "groupname" class="form-control" placeholder="Enter text">
                            </div>

                            <div class="form-group">
                                <label>그룹코드</label>
                                <input id="groupcd" name = "groupcd" class="form-control" placeholder="Enter text" maxlength=5>
                            </div>
                            
                           <div class="form-group">
                                <label>지역코드</label>
                                <select id = "admcd" name = "admcd" class="form-control">
                                </select>
                            </div>

							<% if(regGb.equals("Y")){ %>
								<button type="submit" class="btn btn-default">수정</button>
							<% }else{ %>
								<button type="submit" class="btn btn-default">등록</button>
							<% } %>
                            <button type="reset" class="btn btn-default">취소</button>
                            <input type = "hidden" id = "re_groupcd"	name = "re_groupcd"/>
                            <input type = "hidden" id = "regGb"	name = "regGb"/>
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
