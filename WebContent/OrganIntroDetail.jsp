<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="com.address.DBBean" %>
<%@ page import="java.sql.*"%>
<html>
<head>
<title>기관명</title>
</head>
<%
	System.out.println("{Call OrganIntroDetail}"); 
	System.out.println("organ_seq:"+request.getParameter("organ_seq"));
	
	int organ_seq = Integer.parseInt(request.getParameter("organ_seq"));

	/**
	기관명						ORGAN_NAME
	기관주소	인천광역시 서구 가좌동	ORGAN_ADDR
	설립년월	2015년 04월 11일		ORGAN_DATE
	회장		김주혁				ORGAN_MEM_CMAN
	임원		4명					ORGAN_MEM_BOARD
	이미지경로					ORGAN_IMG
	회원		111명				ORGAN_MEM_CNT
	연락처						ORGAN_CON_NUM
	**/
	
	String COX = "";
	String COY = "";
	String Organ_Name = "";
	String Organ_Addr = "";
	String Organ_Con_Num = "";
	String Organ_Img = "";
	String Organ_Date = "";
	String Organ_Mem_Cman = "";
	int Organ_Mem_Board = 0;
	int Organ_Mem_Cnt = 0;
	
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	DBBean dbbean = new DBBean();
	conn = dbbean.getConnection();
	conn.setAutoCommit(false);
	pstmt = null;
	rs = null;
	
	String sql = "select * from ORGANINFO where ORGAN_SEQ=?";
	
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, organ_seq); // 2305053
	
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		
		COX = rs.getString("COX");
		COY	= rs.getString("COY");
		Organ_Name = rs.getString("ORGAN_NAME");
		Organ_Addr = rs.getString("ORGAN_ADDR");
		Organ_Con_Num = rs.getString("ORGAN_CON_NUM");
		Organ_Img = rs.getString("ORGAN_IMG");
		
		//Organ_Img = Organ_Img.replace("/", "//");
		
		Organ_Date = rs.getString("ORGAN_DATE");
		Organ_Mem_Cman = rs.getString("ORGAN_MEM_CMAN");
		Organ_Mem_Board = rs.getInt("ORGAN_MEM_BOARD");
		Organ_Mem_Cnt = rs.getInt("ORGAN_MEM_CNT");
		
		System.out.println("COX:"+COX);
		System.out.println("COY:"+COY);
		System.out.println("Organ_Name:"+Organ_Name);
		System.out.println("Organ_Addr:"+Organ_Addr);
		System.out.println("Organ_Img:"+Organ_Img);
		System.out.println("Organ_Date:"+Organ_Date);
		System.out.println("Organ_Mem_Cman:"+Organ_Mem_Cman);
		System.out.println("Organ_Mem_Board:"+Organ_Mem_Board);
		System.out.println("Organ_Mem_Cnt:"+Organ_Mem_Cnt);

	}
	
	if(rs!=null) rs.close();
	if(pstmt!=null) pstmt.close();
	if(conn!=null) conn.close();
	
%>
<script type="text/javascript" src="https://sgisapi.kostat.go.kr/OpenAPI3/auth/javascriptAuth?consumer_key=d7b1e5c419cd4e9baebd"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js" charset="utf-8"></script>
<body>
<div id="organ">
<div id="map" style="width:100%;height:250"></div>
<script type="text/javascript">

	var contents = '<div style="font-family: dotum, arial, sans-serif;font-size: 18px; font-weight: bold;margin-bottom: 5px;">경복궁</div>' +
	        '<table style="border-spacing: 2px; border: 0px"><tbody><tr>' +
	        '<td style="width: 40px; color:#767676;padding-right:12px">사이트</td>' +
	        '<td><a href="http://www.royalpalace.go.kr/html/main/main.jsp">홈페이지</a></td></tr>' +
	        '<tr><td style="color:#767676;padding-right:12px">주소</td>' +
	        '<td><span>'+'<%=Organ_Addr %>'+'</span></td></tr>' +
	        '<tr><td style="color:#767676;padding-right:12px">소개</td>' +
	        '<td style=""><span>경복궁은 1395년 태조 이성계에 의해서 새로운 조선왕조의 법궁으로 지어졌다. 경복궁은 동궐(창덕궁)이나 서궐(경희궁)에 비해 위치가 ...</span></td></tr>' +
	        '</tr></tbody></table>';
	
	var map = sop.map("map");

    map.setView(sop.utmk(<%=COX%>, <%=COY%>), 5);

    var marker = sop.marker([<%=COX%>, <%=COY%>], {title:"<%=Organ_Name %>"});
    marker.addTo(map);
    
    marker.on('click', function(e) {
    	var infoWindow = sop.infoWindow() // 인포윈도우 생성
		.setUTMK([<%=COX%>, <%=COY%>]) // 인포윈도우 좌표설정
		.setContent("<%=Organ_Name %>") // 인포윈도우 내용설정
		.openOn(map); // 지도에 인포윈도우 표출
	});
    
</script>
<div id="div_info">
<table border="1" width="100%" height="476" bgcolor="#FBEDDF">
    <tr align="center">
        <td width="131" height="30">
            <p align="center"><b>기관명</b></p>
        </td>
        <td width="276">
            <p align="center"><%=Organ_Name %></p>
        </td>
    </tr>
    <tr>
        <td width="413" height="236" colspan="2" valign="middle">
            <p align="center"><img src="<%=Organ_Img %>" width="280" height="209" border="0"></p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>기관주소</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Addr %></p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>설립년월</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Date %></p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>회장</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Mem_Cman %></p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>임원</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Mem_Board%>명</p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>회원</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Mem_Cnt%>명</p>
        </td>
    </tr>
    <tr>
        <td width="131" height="30" valign="middle">
            <p align="center"><b>연락처</b></p>
        </td>
        <td width="276" valign="middle">
            <p align="center"><%=Organ_Con_Num%></p>
        </td>
    </tr>
</table>
</div>
</div>
</body>
</html>