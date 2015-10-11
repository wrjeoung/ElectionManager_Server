<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.DBBean" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.address.WOrganDAO"%>
<%@ page import="java.util.ArrayList"%>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

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
<!--  <script src="js/jquery-1.10.2.min.js"></script>-->
<script type="text/javascript">

function clickTrEvent(trobj){

	//alert("clickTrEvent:"+trobj.id);
	
	var servletUrl = "AddressServlet";
	var param = "";
	var data = trobj.id;
	var obj = "";
	var res = "";
	var form = "";
	var input_id = "";
	
	$.ajax({
	     type : "POST",
	     url : servletUrl,
	     data : "mode=detailList&data="+data,     
	     success : function(data){
	     
	     	//alert("data:"+data);
	     	res = JSON.parse(data);
	     	//alert("res:"+res);
	     	obj = res.OrganDetail;
	     	//alert("obj1:"+obj);
	     	
	     	form = document.createElement("form");     
			form.setAttribute("method","post");                    
			form.setAttribute("action","/ElectionManager_server/OrganInfo.jsp");        
			document.body.appendChild(form);                        
			//alert("obj2:"+obj);
			input_id = document.createElement("input");  
			input_id.setAttribute("type", "hidden");                 
			input_id.setAttribute("name", "data");                        
			input_id.setAttribute("value", obj);                          
			form.appendChild(input_id);
		
			//폼전송
			form.submit();  
			     	
	     },    
	     error : function(){
	      
	     },
	     ajaxError : function(){
	      
		 }    
	 });
	
}

function changeTrColor(trObj, oldColor, newColor){

	trObj.style.backgroundColor = newColor;
	trObj.onmouseout =function(){
		trObj.style.backgroundColor = oldColor;
	}
}

</script>

<%

	System.out.println("OrganLsi.jsp");
	
	String userid = "";
	String classcd = "";
	String groupcd  = "";
	
	userid = (String) session.getAttribute("userid");
	classcd = (String) session.getAttribute("classcd");
	groupcd = (String) session.getAttribute("groupcd");
	
	System.out.println("userid:"+userid);
	System.out.println("classcd:"+classcd);
	System.out.println("groupcd:"+groupcd);
	
	if(userid==null || userid.equals(null)){
		response.sendRedirect("Login.jsp");
	}

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = "";
	if(classcd.equals("AAA")){
		sql = " SELECT  A.ORGAN_SEQ, A.ORGAN_ADDR, A.ORGAN_NAME, A.ORGAN_GB, A.ORGAN_DATE, B.GROUPCD, B.GROUPNAME "
			+ " FROM ORGANINFO A INNER JOIN GROUPINFO B "
			+ " ON(A.GROUPCD=B.GROUPCD)";
		pstmt = conn.prepareStatement(sql);
	}else{
		sql = " SELECT  A.ORGAN_SEQ, A.ORGAN_ADDR, A.ORGAN_NAME, A.ORGAN_GB, A.ORGAN_DATE, B.GROUPCD, B.GROUPNAME "
			+ " FROM ORGANINFO A INNER JOIN GROUPINFO B "
			+ " ON(A.GROUPCD=B.GROUPCD)"
			+ " WHERE B.GROUPCD=? ";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1,groupcd);
	}
	
	rs = pstmt.executeQuery();
	
	WOrganDAO od = null;
	ArrayList al = new ArrayList();
	
	while(rs.next()){
		od = new WOrganDAO();
		od.setOrgan_Seq(rs.getInt("ORGAN_SEQ"));
		od.setOrgan_Add(rs.getString("ORGAN_ADDR"));
		od.setOrgan_Name(rs.getString("ORGAN_NAME"));
		od.setOrgan_Gb(rs.getString("Organ_Gb"));
		od.setOrgan_Date(rs.getString("Organ_Date"));
		od.setGroup_Cd(rs.getString("GROUPCD"));
		od.setGroup_Name(rs.getString("GROUPNAME"));
		al.add(od);
	}

	//aa = name.substring(0, 4);
	//bb = name.substring(4, 6);
	//cc = name.substring(6, 8);
	
%>
<body>

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
                        </li>
                        <%} else{}%>
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">기관정보관리</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            DataTables Advanced Tables
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                        	<th align="center">순번</th>
                                        	<th>등록업체명</th>
                                        	<th>기관구분</th>
                                            <th>기관명</th>
                                            <th>기관주소</th>
                                            <th>설립년월</th>
                                        </tr>
                                    </thead>
                                    <% for(int i=0; i<al.size(); i++){ 
                                    	od = (WOrganDAO) al.get(i);
                                    	
                                    	String Organ_Date = od.getOrgan_Date();
                                    	String Organ_Gb = od.getOrgan_Gb();
                                    	String Organ_Gb_Name = "";
                                    	
                                    	String DateYYYY = "";
                                    	String DateMM = "";
                                    	String DateDD = "";
                                    	
                                    	if(Organ_Gb==null){
                                    		
                                    	}else{
                                    		if(Organ_Gb.equals("A")){
                                        		Organ_Gb_Name = "기관";
                                        	}else if(Organ_Gb.equals("B")){
                                        		Organ_Gb_Name = "단체";
                                        	}
                                    		
                                    	}
                                    	
                                    	if(Organ_Date ==null || Organ_Date.equals("")){
                                    		Organ_Date = "미등록";
                                    	}else{

	                                    	DateYYYY = Organ_Date.substring(0,4);
	                                    	DateMM = Organ_Date.substring(4,6);
	                                    	DateDD = Organ_Date.substring(6,8); 
	                                    	
	                                    	Organ_Date = DateYYYY + "년 " + DateMM + "월 " + DateDD + "일";
                                    		
                                    	}
                                    	
                                    %>
                                    <tbody>
                                        <tr ondblclick="javscript:clickTrEvent(this)" id="<%=od.getOrgan_Seq()%>" onmouseover="javascript:changeTrColor(this,  '#FFFFFF', '#F4FFFD')" style="cursor:hand">
                                        	<th style="text-align:center"><%=od.getOrgan_Seq() %></th>
                                        	<th style="text-align:center"><%=od.getGroup_Name() %></th>
                                        	<th style="text-align:center"><%=Organ_Gb_Name %></th>
                                            <th style="text-align:center"><%=od.getOrgan_Name() %></th>
                                            <th><%=od.getOrgan_Add() %></th>
                                            <th style="text-align:center"><%=Organ_Date %></th>
                                        </tr>
                                    </tbody>
                                    <%} %>
                                </table>
                            </div>
                            <input type="button" id = "test" name = "test" value="신규등록" onclick='location.href="OrganInfo.jsp"'>
                            <!-- /.table-responsive -->

                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
           
            <!-- /.row -->
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
