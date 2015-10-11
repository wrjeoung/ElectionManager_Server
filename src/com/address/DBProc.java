package com.address;

import java.sql.*;

public class DBProc {
	
	private String result = "FAIL";
	
	public UserDAO LoginCheck(UserDAO udo){
		
		String loginid = udo.getUserid();
		String passwd = udo.getPwd();
		
		System.out.println("loginid:"+loginid);
		System.out.println("passwod:"+passwd);
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;;
		Connection conn = null;
		
		UserDAO ud = new UserDAO();
		
		try{
		
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			int ir = 0;
			
			String sql = "select USERID, GROUPCD, GROUPNAME, CLASSCD from USERINFO where USERID=? and PWD=?";
				   sql = "SELECT A.USERID, A.GROUPCD, B.GROUPNAME, A.CLASSCD "
					   + " FROM USERINFO A INNER JOIN GROUPINFO B "
					   + " ON(A.GROUPCD=B.GROUPCD) "
					   + " WHERE A.USERID=? AND A.PWD=? ";
				   
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, loginid);
			pstmt.setString(2, passwd);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				 ir++;
				 result = "SUCCESS";
				 ud.setUserid(rs.getString("USERID"));
				 ud.setGroupcd(rs.getString("GROUPCD"));
				 ud.setGroupname(rs.getString("GROUPNAME"));
				 ud.setClasscd(rs.getString("CLASSCD"));
				 ud.setResult(result);
			}
			
		}catch(Exception e){
			
			e.printStackTrace();
			
		}finally{
			try {
				if(rs!=null) rs.close();
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return ud;
	}
	
	public GroupDAO groupList(GroupDAO gdo){
		
		String groupcd = gdo.getGroupcd();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;;
		Connection conn = null;
		
		GroupDAO gd = null;
		
try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			String sql = " SELECT GROUPCD, GROUPNAME, ADM_CD "
				+ " FROM GROUPINFO "
				+ " WHERE GROUPCD = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, groupcd);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				gd = new GroupDAO();
				gd.setGroupcd(rs.getString("GROUPCD"));
				gd.setGroupname(rs.getString("GROUPNAME"));
				gd.setAdm_cd(rs.getString("ADM_CD"));
			}	
		
		}catch(Exception e){
			
			e.printStackTrace();
			
		}finally{
			
			try {
				if(rs!=null) rs.close();
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}	
		
		return gd;
	}
	
	public UserDAO userList(UserDAO udo){
		
		String userid = udo.getUserid();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;;
		Connection conn = null;
		
		UserDAO ud = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			String sql = " SELECT A.USERID, A.USERNM, A.PWD, B.GROUPCD, B.GROUPNAME, A.CLASSCD, A.REGDT, A.MACADDRESS "
				+ " FROM  USERINFO A INNER JOIN GROUPINFO B "
				+ " ON(A.GROUPCD = B.GROUPCD) "
				+ " WHERE A.USERID = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				ud = new UserDAO();
				ud.setUserid(rs.getString("USERID"));
				ud.setUsernm(rs.getString("USERNM"));
				ud.setPwd(rs.getString("PWD"));
				ud.setGroupcd(rs.getString("GROUPCD"));
				ud.setGroupname(rs.getString("GROUPNAME"));
				ud.setClasscd(rs.getString("CLASSCD"));
				ud.setMacaddress(rs.getString("MACADDRESS"));
			}	
		
		}catch(Exception e){
			
			e.printStackTrace();
			
		}finally{
			
			try {
				if(rs!=null) rs.close();
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}	
			
		return ud;
		
	}
	
	public WOrganDAO detailList(WOrganDAO odo){

		int idata = odo.getOrgan_Seq();
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;;
		Connection conn = null;
		
		WOrganDAO od = new WOrganDAO();
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			int ir = 0;
			
			String sql = "select * from ORGANINFO where ORGAN_SEQ=?";
				   sql = " SELECT A.*, B.GROUPNAME "
					   + " FROM ORGANINFO A INNER JOIN GROUPINFO B "
					   + " ON(A.GROUPCD=B.GROUPCD)"			
					   + " WHERE A.ORGAN_SEQ=? ";
				   
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, idata);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				 ir++;
				 result = "SUCCESS";
				 od.setGroup_Cd(rs.getString("GroupCd"));
				 od.setGroup_Name(rs.getString("GROUPNAME"));
				 od.setOrgan_Name(rs.getString("ORGAN_NAME"));
				 od.setOrgan_Gb(rs.getString("ORGAN_GB"));
				 od.setOrgan_Add(rs.getString("ORGAN_ADDR"));
				 od.setOrgan_Date(rs.getString("ORGAN_DATE"));
				 od.setOrgan_Mem_Cman(rs.getString("ORGAN_MEM_CMAN"));
				 od.setOrgan_Mem_Board(rs.getInt("ORGAN_MEM_BOARD"));
				 od.setOrgan_Seq(rs.getInt("ORGAN_SEQ"));
				 od.setOrgan_Con_Num(rs.getString("ORGAN_CON_NUM"));
				 od.setOrgan_Img(rs.getString("ORGAN_IMG"));
				 od.setAdm_cd(rs.getString("ADM_CD"));
				 od.setAddr_auth(rs.getString("ADDR_AUTH"));
				 od.setOrgan_Mem_Cnt(rs.getInt("ORGAN_MEM_CNT"));
				 od.setAddr_cox(rs.getDouble("COX"));
				 od.setAddr_coy(rs.getDouble("COY"));
				 od.setOrgan_Seq(rs.getInt("Organ_Seq"));
				 od.setSidocode(rs.getString("SIDOCODE"));
				 od.setSigungucode(rs.getString("SIGUNGUCODE"));
				 od.setHaengcode(rs.getString("HAENGCODE"));
			}
			
		}catch(Exception e){
			
			e.printStackTrace();
			
		}finally{
			try {
				if(rs!=null) rs.close();
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return od;
	}
	
	public String UpOrgan(WOrganDAO od){
		
		System.out.println("UpOrgan");
		
		String Group_Name = od.getGroup_Name();
		String Group_Cd = od.getGroup_Cd();
		String Organ_Name = od.getOrgan_Name();
		String Organ_Add = od.getOrgan_Add();
		String Organ_Img = od.getOrgan_Img();
		String Organ_Date = od.getOrgan_Date();
		String Organ_Mem_Cman = od.getOrgan_Mem_Cman();
		int iOrgan_Mem_Board = od.getOrgan_Mem_Board();
		int iOrgan_Mem_Cnt = od.getOrgan_Mem_Cnt();
		String Organ_Con_Num = od.getOrgan_Con_Num();
		int ORGAN_CNT = iOrgan_Mem_Board + iOrgan_Mem_Cnt;
		Double addr_cox = od.getAddr_cox();
		Double addr_coy = od.getAddr_coy();
		String sidocode = od.getSidocode();
		String sigungucode = od.getSigungucode();;
		String haengcode = od.getHaengcode();
		String addr_auth = od.getAddr_auth();
		String Organ_Gb = od.getOrgan_Gb();
		int Organ_Seq = od.getOrgan_Seq();
		
		
		System.out.println("Organ_Seq:"+Organ_Seq);
		System.out.println("Group_Name:"+Group_Name);
		System.out.println("Group_Cd:"+Group_Cd);
		System.out.println("Organ_Name:"+Organ_Name);
		System.out.println("Organ_Add:"+Organ_Add);
		System.out.println("Organ_Img:"+Organ_Img);
		System.out.println("Organ_Date:"+Organ_Date);
		System.out.println("iOrgan_Mem_Cman:"+Organ_Mem_Cman);
		System.out.println("iOrgan_Mem_Board:"+iOrgan_Mem_Board);
		System.out.println("Organ_Mem_Cnt:"+iOrgan_Mem_Cnt);
		System.out.println("Organ_Con_Num:"+Organ_Con_Num);
		System.out.println("addr_cox:"+addr_cox);
		System.out.println("addr_coy:"+addr_coy);
		System.out.println("sidocode:"+sidocode);
		System.out.println("sigungucode:"+sigungucode);
		System.out.println("haengcode:"+haengcode);
		System.out.println("addr_auth:"+addr_auth);
		System.out.println("Organ_Gb:"+Organ_Gb);
		
		
		//String sql = "UPDATE ORGANINFO SET "
			
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		String sql = " UPDATE ORGANINFO "
				+ " SET GROUPCD = ? "
				+ " 	, SIDOCODE = ? "
				+ " 	, SIGUNGUCODE = ? "
				+ " 	, HAENGCODE = ? "
				+ " 	, ORGAN_GB = ? "
				+ " 	, ORGAN_NAME = ? "
				+ " 	, ORGAN_ADDR = ? "
				+ " 	, ORGAN_CON_NUM = ? "
				+ " 	, ORGAN_CNT = ? "
				+ " 	, ORGAN_DATE = ? "
				+ " 	, ORGAN_MEM_CMAN = ? "
				+ " 	, ORGAN_MEM_BOARD = ? "
				+ " 	, ORGAN_MEM_CNT = ? "
				+ " 	, ORGAN_IMG = ? "
				+ " 	, MFYDT = SYSDATE() "
				+ " 	, COX = ? "
				+ " 	, COY = ? "
				+ " 	, ADDR_AUTH = ? "
				+ " WHERE ORGAN_SEQ = ?";
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, Group_Cd);
			pstmt.setString(2, sidocode);
			pstmt.setString(3, sigungucode);
			pstmt.setString(4, haengcode);
			pstmt.setString(5, Organ_Gb);
			pstmt.setString(6, Organ_Name);
			pstmt.setString(7, Organ_Add);
			pstmt.setString(8, Organ_Con_Num);
			pstmt.setInt(9, ORGAN_CNT);
			pstmt.setString(10, Organ_Date);
			pstmt.setString(11, Organ_Mem_Cman);
			pstmt.setInt(12, iOrgan_Mem_Board);
			pstmt.setInt(13, iOrgan_Mem_Cnt);
			pstmt.setString(14, Organ_Img);
			pstmt.setDouble(15, addr_cox);
			pstmt.setDouble(16, addr_coy);
			pstmt.setString(17, addr_auth);
			pstmt.setInt(18, Organ_Seq);
			
			int iResult = pstmt.executeUpdate();
			
			if(iResult>0){
				result = "SUCCESS";
			}else{
				result = "FAIL";
			}
			
			conn.commit();
			
			
		}catch(Exception e){
			result = "FAIL";
			e.printStackTrace();
		}finally{
			try {
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
				result = "FAIL";
			}
		}
		
		return result;
	}
	
	public String UpUser(UserDAO ud){
		
		System.out.println("UpUser..");
		
		String userid = ud.getUserid();
		String usernm = ud.getUserid();
		String pwd = ud.getPwd();
		String groupcd = ud.getGroupcd();
		String classcd = ud.getClasscd();
		String maccaddress = ud.getMacaddress();
		
		System.out.println("userid:"+userid);
		System.out.println("usernm:"+usernm);
		System.out.println("pwd:"+pwd);
		System.out.println("groupcd:"+groupcd);
		System.out.println("classcd:"+classcd);
		System.out.println("maccaddress:"+maccaddress);
		
		
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		String sql = " UPDATE USERINFO "
			+ " SET USERNM = ? "
			+ " ,PWD = ? "
			+ " ,GROUPCD = ? "
			+ " ,CLASSCD = ? "
			+ " ,MFYDT = SYSDATE()"
			+ " WHERE USERID = ? ";
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, usernm);
			pstmt.setString(2, pwd);
			pstmt.setString(3, groupcd);
			pstmt.setString(4, classcd);
			pstmt.setString(5, userid);
			
			int iResult = pstmt.executeUpdate();
			
			if(iResult>0){
				result = "SUCCESS";
			}else{
				result = "FAIL";
			}
			
			conn.commit();
			

		}catch(Exception e){
			result = "FAIL";
			e.printStackTrace();
		}finally{
			try {
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
				result = "FAIL";
			}
		}
			
		return result;
	}
	
	public String UpGroup(GroupDAO gd){
		
		String groupcd = gd.getGroupcd();
		String groupname = gd.getGroupname();
		String admcd = gd.getAdm_cd();
		
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		String sql = " UPDATE GROUPINFO "
			+ " SET GROUPNAME = ? "
			+ " , ADM_CD = ? "
			+ " , MFYDT = SYSDATE() "
			+ " WHERE GROUPCD = ?";
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, groupname);
			pstmt.setString(2, admcd);
			pstmt.setString(3, groupcd);

			int iResult = pstmt.executeUpdate();
			
			if(iResult>0){
				result = "SUCCESS";
			}else{
				result = "FAIL";
			}
			
			conn.commit();
			
		}catch(Exception e){
			result = "FAIL";
			e.printStackTrace();
		}finally{
			try {
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
				result = "FAIL";
			}
		}
			
		return result;
	}
	
	public String InGroup(GroupDAO gd){
		
		String groupcd = gd.getGroupcd();
		String groupname = gd.getGroupname();
		String admcd = gd.getAdm_cd();
		
		String sql = " INSERT INTO GROUPINFO (GROUPCD, GROUPNAME, ADM_CD, REGDT, MFYDT) VALUE(?,?,?,SYSDATE(),SYSDATE()) ";
			
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, groupcd);
			pstmt.setString(2, groupname);
			pstmt.setString(3, admcd);
			
			int re = pstmt.executeUpdate();

			if(re>0){
				result = "SUCCESS";
			}else{
				result = "FAIL";
			}
			
			conn.commit();
			
		}catch(Exception e){
			e.printStackTrace();
			
		}finally{
			try {
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		return result;
		
	}
	
	public String InOrgan(WOrganDAO od){
		
		String Group_Name = od.getGroup_Name();
		String Group_Cd = od.getGroup_Cd();
		String Organ_Name = od.getOrgan_Name();
		String Organ_Add = od.getOrgan_Add();
		String Organ_Img = od.getOrgan_Img();
		String Organ_Date = od.getOrgan_Date();
		String Organ_Mem_Cman = od.getOrgan_Mem_Cman();
		int iOrgan_Mem_Board = od.getOrgan_Mem_Board();
		int iOrgan_Mem_Cnt = od.getOrgan_Mem_Cnt();
		String Organ_Con_Num = od.getOrgan_Con_Num();
		int ORGAN_CNT = iOrgan_Mem_Board + iOrgan_Mem_Cnt;
		Double addr_cox = od.getAddr_cox();
		Double addr_coy = od.getAddr_coy();
		String sidocode = od.getSidocode();
		String sigungucode = od.getSigungucode();;
		String haengcode = od.getHaengcode();
		String addr_auth = od.getAddr_auth();
		String Organ_Gb = od.getOrgan_Gb();
		
		System.out.println("Group_Name:"+Group_Name);
		System.out.println("Group_Cd:"+Group_Cd);
		System.out.println("Organ_Name:"+Organ_Name);
		System.out.println("Organ_Add:"+Organ_Add);
		System.out.println("Organ_Img:"+Organ_Img);
		System.out.println("Organ_Date:"+Organ_Date);
		System.out.println("iOrgan_Mem_Cman:"+Organ_Mem_Cman);
		System.out.println("iOrgan_Mem_Board:"+iOrgan_Mem_Board);
		System.out.println("Organ_Mem_Cnt:"+iOrgan_Mem_Cnt);
		System.out.println("Organ_Con_Num:"+Organ_Con_Num);
		System.out.println("addr_cox:"+addr_cox);
		System.out.println("addr_coy:"+addr_coy);
		System.out.println("sidocode:"+sidocode);
		System.out.println("sigungucode:"+sigungucode);
		System.out.println("haengcode:"+haengcode);
		System.out.println("addr_auth:"+addr_auth);
		System.out.println("Organ_Gb:"+Organ_Gb);
		
		String sql = "INSERT INTO ORGANINFO(groupcd,ORGAN_NAME,ORGAN_ADDR,ORGAN_CON_NUM,ORGAN_CNT,ORGAN_DATE,ORGAN_MEM_CMAN,ORGAN_MEM_BOARD,ORGAN_MEM_CNT,ORGAN_IMG,ORGAN_DISP,COY,COX,SIDOCODE,SIGUNGUCODE,HAENGCODE,REGDT,MFYDT,addr_auth,Organ_Gb)"
		 + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE(),SYSDATE(),?,?)";
		
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, Group_Cd);
			pstmt.setString(2, Organ_Name);
			pstmt.setString(3, Organ_Add);
			pstmt.setString(4, Organ_Con_Num);
			pstmt.setInt(5, ORGAN_CNT);
			pstmt.setString(6, Organ_Date);
			pstmt.setString(7, Organ_Mem_Cman);
			pstmt.setInt(8, iOrgan_Mem_Board);
			pstmt.setInt(9, iOrgan_Mem_Cnt);
			pstmt.setString(10, Organ_Img);
			pstmt.setString(11, " ");
			pstmt.setDouble(12, addr_coy);
			pstmt.setDouble(13, addr_cox);
			pstmt.setString(14, sidocode);
			pstmt.setString(15, sigungucode);
			pstmt.setString(16, haengcode);
			pstmt.setString(17, addr_auth);
			pstmt.setString(18, Organ_Gb);
			
			int re = pstmt.executeUpdate();

			if(re>0){
				result = "SUCCESS";
			}else{
				result = "FAIL";
			}
			
			conn.commit();
			
		}catch(Exception e){
			e.printStackTrace();
			
		}finally{
			try {
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		return result;
	}	
}
