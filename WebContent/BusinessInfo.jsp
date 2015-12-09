<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.BusinessDTO"%>
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
	System.out.println("BusinessInfo.jsp"); 

	String userid = "";
	String classcd = "";
	String regGb = "N";
	String groupcd = "";

	userid = (String) session.getAttribute("userid");
	classcd = (String) session.getAttribute("classcd");
	groupcd = (String) session.getAttribute("groupcd");	
	
	System.out.println("userid:"+userid);
	System.out.println("classcd:"+classcd);
	
    Gson gs = new Gson();
    
    JSONObject jo = new JSONObject();
 
	if(userid==null || userid.equals(null)){
		response.sendRedirect("Login.jsp");
	}
	
	BusinessDTO bd = null;
	request.setCharacterEncoding("UTF-8");
	System.out.println("data:"+request.getParameter("data"));

	bd = gs.fromJson((String)request.getParameter("data"), BusinessDTO.class);
	
	System.out.println("bd:"+bd);
	
	String title = "";
	String kind = "";
	String ct_area_in = "";
	String summary = "";
	String content ="";
	String progress_process = "";
	String results = "";
	String groupcds = "";
	String etc = "";
	String img_url ="";
	String img_yn = "";
	
	if(bd == null){
		regGb = "N";

	}else{
		regGb = "Y";
		
    	title = bd.getTitle();
    	kind = bd.getKind();
    	ct_area_in =bd.getCt_area();
    	summary = bd.getSummary();
    	//summary = summary.replaceAll("<br>", "\r\n");
    	content = bd.getContent();
    	progress_process = bd.getProgress_process();
    	results = bd.getResult();
    	groupcds = bd.getGroupcd();
    	etc = bd.getEtc();
    	img_url =bd.getImg_url();
    	img_yn = bd.getImg_yn();
    	
    	System.out.println("title:"+title);
    	System.out.println("kind:"+kind);
    	System.out.println("ct_area_in:"+ct_area_in);
    	System.out.println("summary:"+summary);
    	System.out.println("content:"+content);
    	System.out.println("progress_process:"+progress_process);
    	System.out.println("results:"+results);
    	System.out.println("groupcds:"+groupcds);
    	System.out.println("etc:"+etc);
    	System.out.println("img_url:"+img_url);
    	System.out.println("img_yn:"+img_yn);
		
	}
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs1 = null;
	rs2 =  null;
	rs3 =  null;
	
	String sql = "";
	String sql2 = ""; 
	String sql3 = "";
	
	sql3 = " SELECT GROUPCD,GROUPNAME FROM GROUPINFO "; 
	
	//사업종류 콤보박스 사용
	if(classcd.equals("AAA")){
		sql = " SELECT BKCODE,BKNAME FROM BUSINESS_KIND ";
		pstmt = conn.prepareStatement(sql);	
		rs1 = pstmt.executeQuery();
		
		sql2 = "SELECT DISTINCT HAENGCODE, HAENGTEXT FROM ADM_CODE "
			+ "	WHERE USEYN = 'Y' "
			+ "	AND SUBSTRING(HAENGCODE, 6, 2)  <> '00' "; 
		pstmt = conn.prepareStatement(sql2);	
		rs2 = pstmt.executeQuery();
		
		sql3 = " SELECT GROUPCD,GROUPNAME FROM GROUPINFO WHERE GROUPCD <> '99999' ";
		pstmt = conn.prepareStatement(sql3);	
		rs3 = pstmt.executeQuery();
				
	}else{
		sql = " SELECT BKCODE,BKNAME FROM BUSINESS_KIND WHERE GROUPCD=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,groupcd);	
		rs1 = pstmt.executeQuery();
		
		sql2 = " SELECT DISTINCT HAENGCODE, HAENGTEXT FROM ADM_CODE "
			+ "	WHERE USEYN = 'Y' " 
			+ "	AND SUBSTRING(HAENGCODE, 6, 2)  <> '00' " 
			+ "	AND SIGUNGUCODE = (SELECT DISTINCT SUBSTRING(ADM_CD, 1, 5) FROM GROUPINFO WHERE GROUPCD = ?) ";
		pstmt = conn.prepareStatement(sql2);	
		pstmt.setString(1,groupcd);
		rs2 = pstmt.executeQuery();
		
		sql3 = " SELECT GROUPCD,GROUPNAME FROM GROUPINFO "
			+ " WHERE GROUPCD = ? AND GROUPCD <> '99999' ";
		pstmt.setString(1,groupcd);
		pstmt = conn.prepareStatement(sql3);	
		rs3 = pstmt.executeQuery();
	}
	
	//ComboDAO cd2 = null;
	ArrayList al = new ArrayList();	
	ArrayList al2 = new ArrayList();	
	ArrayList al3 = new ArrayList();	

	while(rs1.next()){
		al.add(rs1.getString("BKCODE")  + ";" +rs1.getString("BKNAME"));
	}
	
	while(rs2.next()){
		al2.add(rs2.getString("HAENGCODE")  + ";" +rs2.getString("HAENGTEXT"));
	}
	
	while(rs3.next()){
		al3.add(rs3.getString("GROUPCD")  + ";" +rs3.getString("GROUPNAME"));
	}
	
%>
<script type="text/javascript">

function init(){
	
	//alert("init");
	
	var classcd = "<%=classcd %>";
	var regGbs = "<%=regGb %>";
	
	var combo_group = "<%=al.toString()%>";
	combo_group = combo_group.replace("[", "");
	combo_group = combo_group.replace("]", "");
	var sedr_gp = combo_group.split(",");
	var group_cnt = "<%=al.size()%>";
	var gp = new Array();
	
	for(var i = 0; i < group_cnt; i++){
		gp[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr_gp[i].split(";");
		gp[i].value=temp_arr[0].replace(" ", "");  
		gp[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['kind'].add(gp[i]);	
	}
	combo_group = "";
	combo_group = "<%=al2.toString()%>";
	combo_group = combo_group.replace("[", "");
	combo_group = combo_group.replace("]", "");
	sedr_gp = combo_group.split(",");
	group_cnt = "<%=al2.size()%>";
	gp = new Array();
	
	for(var i = 0; i < group_cnt; i++){
		gp[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr_gp[i].split(";");
		gp[i].value=temp_arr[0].replace(" ", "");  
		gp[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['ct_area'].add(gp[i]);	
	}
	
	combo_group = "";
	combo_group = "<%=al3.toString()%>";
	combo_group = combo_group.replace("[", "");
	combo_group = combo_group.replace("]", "");
	sedr_gp = combo_group.split(",");
	group_cnt = "<%=al3.size()%>";
	gp = new Array();
	
	for(var i = 0; i < group_cnt; i++){
		gp[i] = document.createElement('option');
		var temp_arr = new Array();
		temp_arr = sedr_gp[i].split(";");
		gp[i].value=temp_arr[0].replace(" ", "");  
		gp[i].text=temp_arr[1].replace(" ", "");
		document.forms['f'].elements['groupcd'].add(gp[i]);	
	}

	//alert(f.regGb.value);
	f.regGb.value = regGbs;
	
	if(regGbs=="Y"){
		alert("수정");
		var titles ="<%=title %>";
		var kinds = "<%=kind %>";
		var ct_area_ins = "<%=ct_area_in %>";
		
		var summarys = "<%=summary %>";
		summarys = summarys.replace("<br>", "\n");

		var contents = "<%=content %>";
		contents =  contents.replace("<br>", "\n");
		
		var progress_processs = "<%=progress_process %>";
		progress_processs = progress_processs.replace("<br>", "\n");
		
		var resultss = "<%=results %>";
		resultss = resultss.replace("<br>", "\n");
		
		var groupcdss = "<%=groupcds %>";
		var etcs = "<%=etc %>";
		etcs = etcs.replace("<br>","\n");
		
		var img_urls = "<%=img_url %>";
		var img_yns = "<%=img_yn %>";
		
		f.title.value = titles;
		f.kind.value = kinds;
		f.ct_area_in.value = ct_area_ins;
		f.summary.value = summarys;
		f.content.value = contents;
		f.progress_process.value = progress_processs;
		f.result.value = resultss;
		f.groupcd.value = groupcdss;
		f.etc.value = etcs;
		
		//f.img_url.value = img_urls;
		//f.img_yn.value = img_yns;
		
		var aa = img_urls.split(';');
		alert(aa.length);
		
		var bb = new Array(aa.length);
		
		var str = "";
		for(var i = 0; i < aa.length; + i++){
			
			if(i==0){
				f.uploadFile_Mf0.value = aa[i];
			}if(i==1){
				f.uploadFile_Mf1.value = aa[i];
			}if(i==2){
				f.uploadFile_Mf2.value = aa[i];
			}
					
		}
		
		alert(img_urls);
		
	}else{
		
		alert("등록");
		
	}
} 

function handleEnter (field, event, num) {
// 눌려진 키 코드를 가져온다.
var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;   
	// Enter 키가 눌린 경우
	if (keyCode == 13) {
		event.keyCode = null;
		if(num == 1){
			// alert(f.content.value);			
			// 엔터키가 눌렸을 때 처리할 코드
			
		}
	}
}

function AddrArea(){
	
	if(f.ct_area_in.value==""){
		f.ct_area_in.value=f.ct_area_in.value+f.ct_area.value+"-00";
	}else{
		f.ct_area_in.value= f.ct_area_in.value+"/"+f.ct_area.value+"-00";
	}
}

function check()
{
	
	var message = "주요사업정보 상세보기에 보여지는 정보입니다.\n해당 내용으로 정말 등록 하시겠습니까?";
	
	if(confirm(message) == false){
		return false;
	}
	
}

function file_upload(){
	//alert("file_upload");
	var servletUrl = "AddressServlet";
	var param = "";
	
	$.ajax({
	     type : "POST",
	     url : servletUrl,
	     data : "mode=upload",     
	     success : function(data){
			
	     },    
	     error : function(){
	      
	     },
	     ajaxError : function(){
	      
		 }    
	 });
}

function isValidMonth(mm) {
    var m = parseInt(mm,10);
    return (m >= 1 && m <= 12);
}

function isValidDay(yyyy, mm, dd) {
    var m = parseInt(mm,10) - 1;
    var d = parseInt(dd,10);
    var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
    if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) {
        end[1] = 29;
    }
    return (d >= 1 && d <= end[m]);
}
 
function isValidTime(time) {
    var year  = time.substring(0,4);
    var month = time.substring(4,6);
    var day   = time.substring(6,8);
    if (parseInt(year,10) >= 1900  && isValidMonth(month) &&
        isValidDay(year,month,day) ) {
        return true;
    }
    return false;
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
                            	주요사업등록
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a>Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>주요사업등록
                            </li>
                        </ol>
                    </div>
                </div>
                <!-- /.row -->
				
                <div class="row">
                    <div class="col-lg-6">

                        <form id = "f" name = "c" method = "post" action = "AddressServlet?mode=business_reg"  onsubmit="return check();" enctype="multipart/form-data" >

                            <div class="form-group">
                                <label>사업명</label>
 								<input id="title" name = "title" class="form-control">
                            </div>
                            
                            <div class="form-group">
                                <label>사업종류</label>
                                <select id = "kind" name = "kind" class="form-control">
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>등록업체</label>
                                <select id = "groupcd" name = "groupcd" class="form-control">
                                </select>
                            </div>
         
                            <div class="form-group">
                                <label>관할지역</label>
                                <table>
                                <tr>
                                	<td width="25%"><select id = "ct_area" name = "ct_area" class="form-control"></select></td>
                                	<td width="2%">&nbsp;</td>
                                	<td width="6%"><input type="button" value="추가" onClick="AddrArea()"></td>
                                	<td width="2%">&nbsp;</td>
                                	<td width="65%"><input id="ct_area_in" name = "ct_area_in" class="form-control"></td>
                                </tr>
                                </table>
                            </div>
                            
                            <div class="form-group">
                                <label>사업개요</label>
                                <textarea id="summary" name = "summary"  class="form-control" rows="4"  onkeypress="return handleEnter(this, event, 1)"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>주요내용</label>
                                <textarea id="content" name = "content" class="form-control" rows="4"  onkeypress="return handleEnter(this, event, 1)"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>진행과정</label>
                                <textarea id="progress_process" name = "progress_process" class="form-control" rows="4"  onkeypress="return handleEnter(this, event, 1)"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>사업결과</label>
                                <textarea id="result" name = "result" class="form-control" rows="4"  onkeypress="return handleEnter(this, event, 1)"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>기타</label>
                                <textarea id="etc" name = "etc" class="form-control" rows="4"  onkeypress="return handleEnter(this, event, 1)"></textarea>
                            </div>
                         
                            <div class="form-group">
                                <label>이미지 업로드</label>
		                         	<input id="business_img0" name = "uploadFile0" type="file">
		                         	<input id="business_img1" name = "uploadFile1" type="file">
		                         	<input id="business_img2" name = "uploadFile2" type="file">
                            </div>
                            
							<% if(regGb.equals("Y")){ %>
								<button type="submit" class="btn btn-default">수정</button>
							<% }else{ %>
								<button type="submit" class="btn btn-default">등록</button>
							<% } %>
							
                            <button type="reset" class="btn btn-default">취소</button>
							<input type = "hidden" id = "uploadFile_Mf0" name = "uploadFile_Mf0" />
							<input type = "hidden" id = "uploadFile_Mf1" name = "uploadFile_Mf1" />
							<input type = "hidden" id = "uploadFile_Mf2" name = "uploadFile_Mf2" />
							<input type = "hidden" id = "regGb"	name = "regGb"	/>

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
