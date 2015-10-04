<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.address.DBBean"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
asdfasdf

<%
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	JSONObject jso = null; 
	
	try {
		DBBean dbbean = new DBBean();
		conn = dbbean.getConnection();
		stmt = conn.createStatement();
		rs = stmt.executeQuery("select Distinct PhoneNum, IMEI FROM USERINFO");
			
		jso = new JSONObject();
		while(rs.next()) {
			jso.put("PhoneNum",rs.getString("PhoneNum"));
			jso.put("IMEI",rs.getString("IMEI"));
		}
		out.print(jso);
		out.flush();
		
		rs.close();
		conn.close();
		stmt.close(); 	
	} catch(Exception e) {
		rs.close();
		conn.close();
		stmt.close();	
		e.printStackTrace();		
	} 
	System.out.println("여기까진 왔네...");
%>

</body>
</html>