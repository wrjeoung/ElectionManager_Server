<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.WOrganDAO"%>
<%@ page import="com.address.ElectDao" %>
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
	System.out.println("OrgnInfo.jsp"); 

	String userid = "";
	
	String Organ_Name= "";
	String Organ_Add = "";
	String Organ_Img = "";
	String Organ_Date = "";
	String Organ_Mem_Cman = "";
	String Organ_Mem_Board = "";
	int iOrgan_Mem_Board = 0;
	String Organ_Mem_Cnt = "";
	int iOrgan_Mem_Cnt = 0;
	String Organ_Con_Num = "";
	String Group_Name = "";
	Double addr_cox = 0.0;
	Double addr_coy = 0.0;
	String Group_Cd = "";
	String Organ_Gb = "";
	String organ_auth = "";
	int Organ_Seq = 0;
	String sidocode = "";
	String sigungucode = "";
	String haengcode = "";
	
	String classcd = "";
	
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
	
	WOrganDAO od = null;
	request.setCharacterEncoding("UTF-8");
	System.out.println("data:"+request.getParameter("data"));

	//od = (OrganDAO) request.getAttribute("OrganDetail");
	od = gs.fromJson((String)request.getParameter("data"), WOrganDAO.class);
	
	System.out.println("od:"+od);
	
	Group_Name =(String) session.getAttribute("groupname");
	Group_Cd = (String) session.getAttribute("groupcd"); 
	System.out.println("Group_Name:"+Group_Name);
	System.out.println("Group_Cd:"+Group_Cd);
	
	if(od == null){
		regGb = "N";

	}else{
		regGb = "Y";
		Organ_Name = od.getOrgan_Name();
		Organ_Gb = od.getOrgan_Gb();
		Organ_Add = od.getOrgan_Add();
		Organ_Date = od.getOrgan_Date();
		organ_auth = od.getAddr_auth();
		Organ_Mem_Cman = od.getOrgan_Mem_Cman();
		Organ_Mem_Board = od.getOrgan_Mem_Board() + "";
		Organ_Mem_Cnt = od.getOrgan_Mem_Cnt() + "";
		Organ_Con_Num = od.getOrgan_Con_Num();
		Organ_Img = od.getOrgan_Img();
		Organ_Seq = od.getOrgan_Seq();
		Organ_Img = Organ_Img.replace("\\", "\\\\");
		addr_cox = od.getAddr_cox();
		addr_coy = od.getAddr_coy();
		sidocode = od.getSidocode();
		sigungucode = od.getSigungucode();
		haengcode = od.getHaengcode();
		
		System.out.println("Organ_Gb:"+Organ_Gb);
		System.out.println("Organ_Addr:"+Organ_Add);
		System.out.println("Organ_Date:"+Organ_Date);
		System.out.println("Organ_Mem_Cman:"+Organ_Mem_Cman);
		System.out.println("Organ_Mem_Board:"+Organ_Mem_Board);
		System.out.println("Organ_Mem_Cnt:"+Organ_Mem_Cnt);
		System.out.println("Organ_Con_Num:"+Organ_Con_Num);
		System.out.println("Organ_Img:"+Organ_Img);
		System.out.println("Organ_Seq:"+Organ_Seq);
		System.out.println("addr_cox:"+addr_cox);
		System.out.println("addr_coy:"+addr_coy);
	}
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = " SELECT GROUPCD,GROUPNAME FROM GROUPINFO "; 
	
	pstmt = conn.prepareStatement(sql);
	//pstmt.setString(1,"1");	
	rs = pstmt.executeQuery();
	
	//ComboDAO cd2 = null;
	ArrayList al = new ArrayList();	

	while(rs.next()){
		al.add(rs.getString("GROUPCD")  + ";" +rs.getString("GROUPNAME"));
	}
	
%>
<script type="text/javascript">

function init(){
	//alert("init");
	
	var classcd = "<%=classcd %>";
	
	if(classcd=="AAA"){
	
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
			document.forms['f'].elements['group_name'].add(gp[i]);	
		}
	
	}else{
	
		var opt1 = document.createElement('option');
		opt1.text = "<%=Group_Name%>";
		opt1.value = "<%=Group_Cd%>";
		document.forms['f'].elements['group_name'].add(opt1); //select 태그에 sption을 추가
	}
	// 기관(A), 단체(B)
	/**
	var opt2_1 = document.createElement('option'); //새로운 option 속성을 생성
	opt2_1.text = "기관"; //새로운 option의 text 지정
	opt2_1.value = "A"; //새로운 option의 value 지정
	
	var opt2_2 = document.createElement('option'); //새로운 option 속성을 생성
	opt2_2.text = "단체"; //새로운 option의 text 지정
	opt2_2.value = "B"; //새로운 option의 value 지정
	document.forms['f'].elements['organ_gb'].add(opt2_1) //select 태그에 sption을 추가
	document.forms['f'].elements['organ_gb'].add(opt2_2) //select 태그에 sption을 추가
	**/
	
	var organ_names = "<%=Organ_Name%>";
	var organ_addrs = "<%=Organ_Add %>";
	var organ_dates = "<%=Organ_Date %>";
	var organ_auths = "<%=organ_auth %>";
	
	var organ_mem_cmans = "<%=Organ_Mem_Cman %>";
	var organ_mem_boards = "<%=Organ_Mem_Board %>";
	var organ_mem_cnts = "<%= Organ_Mem_Cnt %>";
	var organ_con_nums = "<%= Organ_Con_Num %>";

	var uploadFiles = "<%= Organ_Img%>";	
	var addr_coxs = "<%=addr_cox%>";
	var addr_coys = "<%=addr_coy%>";
	var regGbs = "<%=regGb%>";
	var organ_seqs = "<%=Organ_Seq%>";
	var organ_imgs = "<%=Organ_Img%>";
	var sidocodes = "<%=sidocode %>";
	var sigungucodes = "<%=sigungucode %>";
	var haengcodes = "<%=haengcode %>";
	
	f.organ_name.value = organ_names;
	f.organ_addr.value = organ_addrs; 
	f.organ_date.value = organ_dates;
	f.organ_auth.value = organ_auths;
	f.organ_mem_cman.value = organ_mem_cmans;
	f.organ_mem_board.value = organ_mem_boards;
	f.organ_mem_cnt.value = organ_mem_cnts;
	f.organ_con_num.value = organ_con_nums;
	//f.organ_img.value = uploadFiles;
	f.addr_cox.value = addr_coxs;
	f.addr_coy.value = addr_coys;
	f.organ_seq.value = organ_seqs;
	f.organ_imgss.value = organ_imgs;
	f.addr_sidocode.value = sidocodes;
	f.addr_sigungucode.value = sigungucodes;
	f.addr_haengcode.value = haengcodes;
	
	if(f.organ_auth.value=="Y"){
		f.organ_auth.value="검증완료"; 
		f.addr_auth.value="Y";					
	}else{
		f.organ_auth.value="미검증"; 
		f.addr_auth.value="N";
	}
	
	f.regGb.value = regGbs;
	//alert(f.regGb.value);
} 

function check()
{
	//alert("check");
	//alert(f.group_name.value);
	
	//alert(f.organ_date.value.substring(0,4));
	//alert(f.organ_date.value.substring(6,2));
	//alert(f.organ_date.value.substring(8,2));

	var organ_addrs = "<%=Organ_Add %>";
	var regGbs = "<%=regGb%>";
	var uploadFiles = "<%= Organ_Img%>";
	
	//alert(f.addr_cox.value);
	//alert(f.addr_coy.value);
	//alert(uploadFiles);
	
	if(f.organ_name.value=="" || f.organ_name.value == null){
		alert("기관명을 입력해주세요.");
		return false;
	}else if(f.organ_addr.value=="" || f.organ_addr.value ==null){
		alert("기관주소를 입력해주세요.");
		return false;
	}else if(f.organ_date.value=="" || f.organ_date.value ==null){
		alert("설립년월을 입력해주세요.");
		return false;
	}else if(f.organ_mem_cman.value=="" || f.organ_mem_cman.value ==null){
		alert("회장을 입력해주세요.");
		return false;
	}else if(f.organ_mem_board.value=="" || f.organ_mem_board.value ==null){
		alert("임원(명)을 입력해주세요.");
		return false;
	}else if(f.organ_mem_cnt.value=="" || f.organ_mem_cnt.value ==null){
		alert("회원(명)을 입력해주세요.");
		return false;
	}else if(f.organ_con_num.value=="" || f.organ_con_num.value ==null){
		alert("연락처를 입력해주세요.");
		return false;
	}else if(f.organ_img.value=="" && uploadFiles ==""){
		alert("업로드할 이미지를 선택해주세요.");
		return false;
	}else if(f.addr_auth.value != "Y"){
		alert("입력한 주소를 검증해주세요");
		return false;
	}else if((organ_addrs != f.organ_addr.value) && regGbs=="Y"){
		alert("주소를 변경하였습니다. 주소 검증을 해주세요.");
		return false;
	}
	
	//return false;
	
	var message = "기관정보 상세보기에 보여지는 정보입니다.\n해당 내용으로 정말 등록 하시겠습니까?";
	
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

function AddrSearch(){	
	//alert("AddrSearch");
	
	if(f.organ_addr.value== "" || f.organ_addr.value ==null){
		alert("검증할 기관주소를 입력해주세요.");
		return false;
	}
	
	var param = "";
	var data = f.organ_addr.value;
	var servletUrl = "AddressServlet";
	var consumer_key = "f59544edd2be4a4f91dd";
	var consumer_secret = "86bf4eaf0ad3465dae84";
	data = consumer_key + ";" + consumer_secret + ";" + data;
	//alert(data);
	
	$.ajax({
	     type : "POST",
	     url : servletUrl,
	     data : "mode=addrseach&data="+data,     
	     success : function(data) {
			//alert("data:"+data);
			var obj = JSON.parse(data);
			var result = obj.RESULT;
			var cox = obj.COX;
			var coy = obj.COY;
			var sidocode = obj.SIDOCODE;
			var sigungucode = obj.SIGUNGUCODE;
			var haengcode = obj.HAENGCODE;
			
			if(result=="SUCCESS"){
				alert("검증완료");
				f.organ_auth.value="검증완료"; 
				f.addr_auth.value="Y";
				f.addr_cox.value=cox;
				f.addr_coy.value=coy;
				
				f.addr_sidocode.value=sidocode;
				f.addr_sigungucode.value=sigungucode;
				f.addr_haengcode.value=haengcode;
					
			}else{
				alert("검증실패");
				f.organ_auth.value="미검증"; 
				f.addr_auth.value="N";
			}
			
	     },    
	     error : function() {
	      
	     },
	     ajaxError : function() {
	      
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
                            	기관정보등록
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a>Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>기관정보등록
                            </li>
                        </ol>
                    </div>
                </div>
                <!-- /.row -->
				
                <div class="row">
                    <div class="col-lg-6">

                        <form id = "f" name = "organ_reg" method = "post" action = "AddressServlet?mode=organ_reg"  onsubmit="return check();" enctype="multipart/form-data" >

                           <div class="form-group">
                                <label>업체명</label>
                                <select id = "group_name" name = "group_name" class="form-control">

                                </select>
                            </div>

                            <div class="form-group">
                                <label>기관명</label>
                                <input id="organ_name" name = "organ_name" class="form-control" placeholder="Enter text">
                            </div>
                            
                           <div class="form-group">
                                <label>기관구분</label>
                                <select id = "organ_gb" name = "organ_gb" class="form-control">
                                	<OPTION value="A"<%=Organ_Gb.equals("A")?" selected":""%>>기관</OPTION>
             						<OPTION value="B"<%=Organ_Gb.equals("B")?" selected":""%>>단체</OPTION>
                                </select>
                            </div>
         
                            <div class="form-group" id = "div_addr">
                                <label>기관주소</label>
                                <table>
                                <tr>
                                <td width="80%">
                                	<input id="organ_addr" name = "organ_addr" class="form-control" placeholder="Enter text">
                                </td>
                                <td width="15%"> 
                                	<!-- <button type="submit" class="btn btn-default">주소검증</button> -->
                                	<input type="button" value="주소검증" onClick="AddrSearch()">
                                </td>
                                <td width="5%">
                                	<input type="text" size= 5 id="organ_auth" name="organ_auth" value="미검증" disabled>
                                </td>
                                </tr>
                                </table>
                            </div>

                            <div class="form-group">
                                <label>설립년월(ex.YYYYMMDD)</label>
                                <input id="organ_date" name = "organ_date" class="form-control onlyNumber" placeholder="Enter text" maxlength="8">
                            </div>
                            
                            <div class="form-group">
                                <label>회장(이름)</label>
                                <input id="organ_mem_cman" name = "organ_mem_cman" class="form-control" placeholder="Enter text">
                            </div>
                            
                            <div class="form-group" id="div_mem_board">
                                <label>임원(명)</label>
                                <input id="organ_mem_board" name = "organ_mem_board" class="form-control onlyNumber" data-rule-required="true" placeholder="숫자만 입력하세요.">
                            </div>
                            
                            <div class="form-group">
                                <label>회원(명)</label>
                                <input id="organ_mem_cnt" name = "organ_mem_cnt" class="form-control onlyNumber" data-rule-required="true" placeholder="숫자만 입력하세요.">
                            </div>
                            
                            <div class="form-group">
                                <label>연락처(ex.010-0000-0000)</label>
                                <input id="organ_con_num" name = "organ_con_num" class="form-control" placeholder="전화번호를 입력하세요.">
                            </div>
                            
                            <div class="form-group">
                                <label>이미지 업로드</label>
		                         <input id="organ_img" name = "uploadFile" type="file">
                            </div>
							<!--  
                            <div class="form-group">
                                <label>기관설명</label>
                                <textarea class="form-control" rows="3"></textarea>
                            </div>
							-->
							<% if(regGb.equals("Y")){ %>
								<button type="submit" class="btn btn-default">수정</button>
							<% }else{ %>
								<button type="submit" class="btn btn-default">등록</button>
							<% } %>
                            <button type="reset" class="btn btn-default">취소</button>
                            <input type = "hidden" id = "addr_auth" name = "addr_auth" value="N"/>
							<!--  <input type = "hidden" name = "mode" value="organ_reg">-->
							<input type = "hidden" id = "uploadFile_Mf" name = "uploadFile_Mf" />
							<input type = "hidden" id = "organ_imgss"	name = "organ_imgss"	/>
							<input type = "hidden" id = "organ_seq"	name = "organ_seq"	/>
							<input type = "hidden" id = "regGb"	name = "regGb"	/>
							<input type = "hidden" id = "group_cd"	name = "group_cd"	/>
							<input type = "hidden" id = "addr_cox" name = "addr_cox"/>
							<input type = "hidden" id = "addr_coy" name = "addr_coy"/>
							<input type = "hidden" id = "addr_sidocode" name = "addr_sidocode"/>
							<input type = "hidden" id = "addr_sigungucode" name = "addr_sigungucode"/>
							<input type = "hidden" id = "addr_haengcode" name = "addr_haengcode"/>
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
