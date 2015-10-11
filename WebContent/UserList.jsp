<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.address.DBBean" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.address.UserDAO"%>
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

	alert("clickTrEvent:"+trobj.id);
	
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
	     data : "mode=userList&data="+data,     
	     success : function(data){
	     
	     	//alert("data:"+data);
	     	res = JSON.parse(data);
	     	//alert("res:"+res);
	     	obj = res.userDetail;
	     	//alert("obj1:"+obj);
	     	
	     	form = document.createElement("form");     
			form.setAttribute("method","post");                    
			form.setAttribute("action","/ElectionManager_server/UserInfo.jsp");        
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

	String userid = "";
	String classcd = "";

	userid = (String) session.getAttribute("userid");
	classcd = (String) session.getAttribute("classcd");
	
	System.out.println("userid:"+userid);
	System.out.println("classcd:"+classcd);
	
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
	
	String sql = " SELECT A.USERID, A.USERNM, B.GROUPCD, B.GROUPNAME, A.CLASSCD, A.REGDT "
		+ " FROM  USERINFO A INNER JOIN GROUPINFO B "
		+ " ON(A.GROUPCD = B.GROUPCD) ";
		
	pstmt = conn.prepareStatement(sql);
	//pstmt.setString(1,"1");	
	rs = pstmt.executeQuery();
	
	UserDAO ud = null;
	ArrayList al = new ArrayList();
	
	//`UserID``UserNm``GroupCd``GroupName``ClassCd``PhoneNum``IMEI``RegDt`
	while(rs.next()){
		ud = new UserDAO();
		ud.setUserid(rs.getString("UserId"));
		ud.setUsernm(rs.getString("UserNm"));
		ud.setGroupcd(rs.getString("GroupCd"));
		ud.setGroupname(rs.getString("GroupName"));
		ud.setClasscd(rs.getString("ClassCd"));
		al.add(ud);
	}
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
                    <h1 class="page-header">사용자정보관리</h1>
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
                                        	<th>아이디</th>
                                            <th>이름</th>
                                            <th>사용자등급</th>
                                            <th>업체명</th>
                                        </tr>
                                    </thead>
                                    <%
    								for(int i = 0; i < al.size(); i++){
    									ud = (UserDAO) al.get(i);

                                    %>
                                    <tbody>
                                        <tr ondblclick="javscript:clickTrEvent(this)" id="<%=ud.getUserid()%>" onmouseover="javascript:changeTrColor(this,  '#FFFFFF', '#F4FFFD')" style="cursor:hand">
                                        	<th style="text-align:center"><%=i+1%></th>
                                        	<th style="text-align:center"><%=ud.getUserid() %></th>
                                            <th style="text-align:center"><%=ud.getUsernm() %></th>
                                            <th style="text-align:center"><%=ud.getClasscd() %></th>
                                            <th style="text-align:center"><%=ud.getGroupname() %></th>
                                        </tr>

                                    </tbody>
                                    <%
    								}
                                    %>
                                </table>
                            </div>
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
