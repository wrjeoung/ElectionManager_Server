<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="UTF-8"%>
<%@ page import="com.address.DBBean"%>
<%@ page import="com.address.Loc"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.io.*" %>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="com.address.VoteDAO"%>
<%@ page import="com.address.StatsDAO" %>
<%@ page import="com.address.FamilyDAO" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder"%>
<%@ page import="com.address.ElectDao" %>
<%@ page import="com.address.OrganDAO" %>
<%@ page import="com.address.GeoUtil" %>
<%@ page import="com.address.PdfDAO" %>
<%@ page import="com.address.EtcDAO" %>
<%@ page import="com.address.BusinessKindDTO" %>
<%@ page import="com.address.BusinessListDTO" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>

<%!
	private String md5CheckSum(String fullPath) {
	    String result=null;
	    FileInputStream fis=null;
	    try {
	        MessageDigest md = MessageDigest.getInstance("MD5");
	        
	        fis = new FileInputStream(fullPath);
	
	        byte[] dataBytes = new byte[1024];
	
	        int nread = 0;
	        while ((nread = fis.read(dataBytes)) != -1) {
	            md.update(dataBytes, 0, nread);
	        };
	
	        byte[] mdbytes = md.digest();
	
	        //convert the byte to hex format method 1
	        StringBuffer sb = new StringBuffer();
	        for (int i = 0; i < mdbytes.length; i++) {
	            sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16).substring(1));
	        }
	
	        //convert the byte to hex format method 2
	        StringBuffer hexString = new StringBuffer();
	        for (int i = 0; i < mdbytes.length; i++) {
	            String hex = Integer.toHexString(0xff & mdbytes[i]);
	            if (hex.length() == 1) hexString.append('0');
	            hexString.append(hex);
	        }
	        result = hexString.toString();
	    }catch (FileNotFoundException e) {
	        e.printStackTrace();
	    }catch (NoSuchAlgorithmException e) {
	        e.printStackTrace();
	    }catch (IOException e) {
	        e.printStackTrace();
	    }finally {
	        if(fis!=null) { try{fis.close();}catch (IOException e){}}
	    }
	    return result;
	}
%>

<%
	System.out.println("Call http server");
	String sQuery = "";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	JSONObject obj_re = null;
	Connection conn = null;
	// wrjeoung mac path.
    //String mSaveFolder = "/Users/wrjeong";
	// Woori research sever path.
    String mSaveFolder = "/usr/local/server/tomcat/webapps/ElectionManager_server/data";
	
	request.setCharacterEncoding("UTF-8");		
	response.setContentType("text/html;charset=UTF-8");
	response.setCharacterEncoding("UTF-8");
	
	try{
		obj_re = new JSONObject();
		String data = null;
		InputStream is = request.getInputStream();
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		
		byte buf[] = new byte[1024];
		int letti;
		
		while((letti=is.read(buf))>0)
			baos.write(buf,0,letti);
		
		data = new String(baos.toByteArray(),"utf-8");
		System.out.println("data:"+data);
		
        JSONObject jre=null;
        JSONParser par = new JSONParser();
        jre = (JSONObject) par.parse(data.toString());
                
        sQuery = (String) jre.get("TYPE");
        System.out.println("Query:"+sQuery);
       
		if(sQuery.equals("JOIN")){
			String userinf[];
			JSONArray arr = (JSONArray) jre.get("CONTENTS");
			System.out.println("arr:"+arr);
			jre = (JSONObject) arr.get(0);
			
			userinf = new String[6];
			userinf[0] = (String.valueOf(jre.get("USERID")));
			userinf[1] = (String.valueOf(jre.get("USERNM")));
			userinf[2] = (String.valueOf(jre.get("PWD")));
			userinf[3] = (String.valueOf(jre.get("PHONENUMBER")));
			userinf[4] = (String.valueOf(jre.get("DEVICEID")));
			userinf[5] = (String.valueOf(jre.get("MAC")));

			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			String sql = "insert into USERINFO (UserID, UserNm, Pwd, GroupCd, ClassCd, PhoneNum, IMEI, MACADDRESS, RegDt, MfyDt) values (?,?,?,?,?,?,?,?,sysdate(),sysdate())";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, userinf[0]);
			pstmt.setString(2, userinf[1]);
			pstmt.setString(3, userinf[2]);
			pstmt.setString(4, "99999");
			pstmt.setString(5, "ZZZ");
			pstmt.setString(6, "");
			pstmt.setString(7, userinf[4]);
			pstmt.setString(8, userinf[5]);
			
			int re = pstmt.executeUpdate();
			if(re>0){
				
				request.setCharacterEncoding("UTF-8");		
				response.setContentType("text/html;charset=UTF-8");
				response.setCharacterEncoding("UTF-8");
				
				obj_re.put("RESULT","SUCCESS");
				
			}else{

				obj_re.put("RESULT","FAILED");
			}
			conn.commit();
			pstmt.close();
			
		}else if(sQuery.equals("IDCHECK")){
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			String userid = (String) jre.get("USERID");
			String sql = "select count(userid) from USERINFO where userid=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs = pstmt.executeQuery();
			
			int iCnt = 0;
			while(rs.next()){
				iCnt = rs.getInt(1);
			}
			
			//iCnt가 0보다 크면 아이디 중복 
			if(iCnt>0){
				System.out.println("[중복체크]아이디 등록 불가:"+userid);
				obj_re.put("RESULT","FAILED");

			}else{
				System.out.println("[중복체크]아이디 등록 가능:"+userid);
				obj_re.put("RESULT","SUCCESS");
			}
			
		}else if(sQuery.equals("SELECTITEMS")) {
			String param1 = (String)jre.get("ADM_CD");
			String classCd = (String)jre.get("CLASSCD");
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = null;
			rs = null;
			JSONObject resData = new JSONObject();
			JSONObject resData_code = new JSONObject();
			JSONArray sigunguArray = new JSONArray();
			JSONObject haengObj = new JSONObject();
			JSONObject tupyoguObj = new JSONObject();
			JSONArray singungu_codeArray = new JSONArray();
			JSONObject haeng_codeObj = new JSONObject();
			JSONObject tupyogu_codeObj = new JSONObject();
			
			// rjeong 2015.12.12 sat - pdf files download [.
			String mac_address = (String)jre.get("MACADDRESS");
			JSONArray reqPdfFileInfo = (JSONArray)jre.get("FILE_INFO");;
			int reqPdfFileCount = 0;
			
			if(reqPdfFileInfo != null) {
				reqPdfFileCount = reqPdfFileInfo.size();
			}
			
			
			JSONObject pdfpathObj = new JSONObject();
			JSONArray pdfInfoArray = new JSONArray();
			PreparedStatement pstmPdfs = null;
			ResultSet rsPdfs = null;
			String sqlPdfs = null;
			
			sqlPdfs = "SELECT pdfpath FROM USERINFO A INNER JOIN PDFINFO B WHERE PDFPATH IS NOT NULL AND MACADDRESS=?";
			if(classCd != null && classCd.equals("AAA")) {
				pstmPdfs = conn.prepareStatement(sqlPdfs);
				pstmPdfs.setString(1, mac_address);
			} else {
				sqlPdfs += " AND ADM_CD=?";
				pstmPdfs = conn.prepareStatement(sqlPdfs);
				pstmPdfs.setString(1, mac_address);
				pstmPdfs.setString(2, param1);
			}
			
			rsPdfs = pstmPdfs.executeQuery();
			while(rsPdfs.next()) {
				JSONObject resPdfFileInfo = new JSONObject();
				boolean updatePdfFile = false;
				String pdfpath = rsPdfs.getString("pdfpath");
                int index = pdfpath.lastIndexOf("/");
                String fileName = pdfpath.substring(index+1);
				
				resPdfFileInfo.put("PDFPATH",pdfpath);
				if(reqPdfFileCount > 0) {
					for(int i = 0; i < reqPdfFileCount; i++) {
						JSONObject fileJson = (JSONObject)reqPdfFileInfo.get(i);
						String reqFileName = (String)fileJson.get("FILE_NAME");
						
						if(fileName.equals(reqFileName)) {
							String clientMd5Sum = (String)fileJson.get("MD5SUM");
							boolean existsPdfServer = new File(mSaveFolder + "/" + fileName).exists();
							
							if(existsPdfServer) {
								String serverMd5Sum = md5CheckSum(mSaveFolder+"/"+fileName);
								
								if(serverMd5Sum != null && !serverMd5Sum.equals(clientMd5Sum)) {
									updatePdfFile = true;
								}
							} 
						}
					}
				} else {
					updatePdfFile = true;
				}
				resPdfFileInfo.put("UPDATE_PDF_FILE",updatePdfFile);
				pdfInfoArray.add(resPdfFileInfo);				
			}
			
			//pdfpathObj.put("PDFINFO", pdfpathArray);
			obj_re.put("PDFINFOARRAYS", pdfInfoArray);			
			// pdf files download ].
			
			
			PreparedStatement pstmt2,pstmt3 = null;
			ResultSet rs2,rs3 = null;

			//String sql1 = "select DISTINCT SIGUNGUTEXT,SIGUNGUCODE from ADM_CODE where SIGUNGUCODE=31053 or SIGUNGUCODE=11150";
			String sql1 = "";
			if(classCd != null && classCd.equals("AAA")) {
				sql1 = "select DISTINCT SIGUNGUTEXT,SIGUNGUCODE from ADM_CODE where USEYN=?";
				param1 = "Y";
			} else {
		    	sql1 = "select SIGUNGUTEXT,SIGUNGUCODE from ADM_CODE where ADM_CD=?";
			}
			String sql2 = "select DISTINCT IFNULL(HAENGTEXT,'전체'),HAENGCODE from ADM_CODE where SIGUNGUCODE=? order by HAENGCODE";
			String sql3 = "select DISTINCT IFNULL(ADM_TEXT,'전체'),ADM_CD from ADM_CODE where SIGUNGUCODE=? and HAENGCODE = ?";
			pstmt = conn.prepareStatement(sql1);
			pstmt.setString(1, param1);
			pstmt2 = conn.prepareStatement(sql2);
			pstmt3 = conn.prepareStatement(sql3);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String sigungu = rs.getString(1);
				String sigungu_code = rs.getString(2);
				sigunguArray.add(sigungu);
				singungu_codeArray.add(sigungu_code);
				
				pstmt2.setString(1, sigungu_code);
				rs2 = pstmt2.executeQuery();
				pstmt2.clearParameters();
				
				JSONArray jArray = new JSONArray();
				JSONArray jArray_code = new JSONArray();
				while(rs2.next()) {
					String haengjoungdong = rs2.getString(1);
					String haengjoungdong_code = rs2.getString(2);
					jArray.add(haengjoungdong);
					jArray_code.add(haengjoungdong_code);
					
					pstmt3.setString(1, sigungu_code);
					pstmt3.setString(2, haengjoungdong_code);
					rs3 = pstmt3.executeQuery();
					pstmt3.clearParameters();
					JSONArray jArray2 = new JSONArray();
					JSONArray jArray2_code = new JSONArray();
					
					//jArray2.add("전체");
					//jArray2_code.add("00");
					while(rs3.next()) {
						String tupyogu = rs3.getString(1);
						String tupyogu_code = rs3.getString(2);
						jArray2.add(tupyogu);
						jArray2_code.add(tupyogu_code);
					}
					tupyoguObj.put(haengjoungdong,jArray2);
					tupyogu_codeObj.put(haengjoungdong_code,jArray2_code);
				}
				haengObj.put(sigungu, jArray);
				haeng_codeObj.put(sigungu_code, jArray_code);
			}
			resData.put("SIGUNGU",sigunguArray);
			resData.put("HAENGJOUNGDONG",haengObj);
			resData.put("TUPYOGU",tupyoguObj);
			
			resData_code.put("SIGUNGU",singungu_codeArray);
			resData_code.put("HAENGJOUNGDONG",haeng_codeObj);
			resData_code.put("TUPYOGU",tupyogu_codeObj);
			
			obj_re.put("RESULT","SUCCESS");
			obj_re.put("SELECTITEMS",resData);
			obj_re.put("SELECTITEMS_CODE",resData_code);
			
			//System.out.println("resData = "+resData.toString()); 
		}else if(sQuery.equals("IMEICHECK") || sQuery.equals("CHECK_MACADDRESS")) {
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			String mac = (String) jre.get("IMEI");
			//String sql = "select pwd from USERINFO where macaddress=?";
			
			String sql = "SELECT A.PWD, B.GROUPCD, B.ADM_CD, A.CLASSCD"
				+ " FROM USERINFO A INNER JOIN GROUPINFO B "
				+ " ON(A.GROUPCD=B.GROUPCD) "
				+ " WHERE MACADDRESS = ? ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, mac);
			
			rs = pstmt.executeQuery();
			
			int iCnt = 0;
			String pwd = "";
			String admcd = null;
			String classcd = null;
			
			
			while(rs.next()){
				iCnt++;
				pwd = rs.getString("PWD");
				admcd = rs.getString("ADM_CD");
				classcd = rs.getString("CLASSCD");
				
			}
			System.out.println("admcd : "+admcd);
			System.out.println("classcd : "+classcd);
			//iCnt가 0보다 크면 mac 중복 
			if(iCnt>0){
				System.out.println("[중복체크]서버에 동일한 mac 있음.:"+mac);
				obj_re.put("RESULT",true);
				obj_re.put("ADM_CD",admcd);
				obj_re.put("CLASSCD",classcd);				
				obj_re.put("PWD",pwd);

			}else{
				System.out.println("[중복체크]서버에 동일한 mac 없음.:"+mac);
				obj_re.put("RESULT",false);
			}
		}else if(sQuery.equals("GEODATA")) {
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			JSONArray jArray = new JSONArray();
			JSONObject center = new JSONObject();
			String sigungutext = (String)jre.get("SIGUNGUTEXT");
			String haengtext = (String)jre.get("HAENGTEXT");
			long tupyogu_num = (Long)jre.get("TUPYOGU_NUM");
			long haeng_code = 0;
			int minX = 1938371,minY = 11947124,maxX = 0,maxY = 0;
			
			
			String sqlTemp = "select HAENGCODE from ADM_CODE where SIGUNGUTEXT = ? and HAENGTEXT = ?";
			String sql = "select ADM_CD from BOUNDARYCOORDINATES where haeng_code=? and tupyogu_num=? group by adm_cd";
			String sql2 = "select COX,COY from BOUNDARYCOORDINATES where ADM_CD=? order by SEQ";
			
			PreparedStatement pstmtTemp = conn.prepareStatement(sqlTemp);
			pstmtTemp.setString(1, sigungutext);
			pstmtTemp.setString(2, haengtext);
			
			ResultSet rsTemp = null;
			
			rsTemp = pstmtTemp.executeQuery();
			
			while(rsTemp.next()) {
				haeng_code = rsTemp.getLong(1);
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, haeng_code);
			pstmt.setLong(2, tupyogu_num);
			
			PreparedStatement pstmt2 = conn.prepareStatement(sql2);
			ResultSet rs2 = null;
					
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String adm_cd = rs.getString(1);
				
				JSONObject jo1 = new JSONObject();
				
				JSONArray features = new JSONArray();
				
				JSONObject jo2 = new JSONObject();
				jo2.put("type","Feature");
				
				JSONObject geometry = new JSONObject();
				geometry.put("type","Polygon");
				
				JSONArray coordinates = new JSONArray();
				JSONArray posArray = new JSONArray();
				
				pstmt2.setString(1, adm_cd);
				rs2 = pstmt2.executeQuery();
				pstmt2.clearParameters();
				while(rs2.next()) {
					JSONArray pos = new JSONArray();
					int COX = rs2.getInt("COX");
					int COY = rs2.getInt("COY");
					pos.add(COX);
					pos.add(COY);
					
					if(minX > COX)
						minX = COX;
					
					if(maxX < COX)
						maxX = COX;

					if(minY > COY)
						minY = COY;
					
					if(maxY < COY)
						maxY = COY;
					
					posArray.add(pos);
				}
				coordinates.add(posArray);
				geometry.put("coordinates",coordinates);
				JSONObject properties = new JSONObject();
				properties.put("Name", "11");
				properties.put("Description",haengtext+" 제"+tupyogu_num+"투표구");
				jo2.put("geometry",geometry);
				jo2.put("properties",properties);
				features.add(jo2);
				jo1.put("features",features);
				jo1.put("type", "FeatureCollection");
				//System.out.println("jo1 = "+jo1.toJSONString());
				jArray.add(jo1);
			}
			center.put("x", (minX+maxX)/2);
			center.put("y", (minY+maxY)/2);
			System.out.println("center_x = "+(minX+maxX)/2);
			obj_re.put("RESULT","SUCCESS");
			obj_re.put("GEODATA",jArray);
			obj_re.put("CENTER", center);
			
		}else if(sQuery.equals("SELECTORGAN1")){
			
			String adm_cd = (String) jre.get("ADM_CD");
			
			
		}else if(sQuery.equals("SELECTORGAN2")){
			
			String adm_cd = (String) jre.get("ADM_CD");
			
			
		}else if(sQuery.equals("SEARCHORGAN")){
			
			String adm_cd_before = (String) jre.get("ADM_CD");
			String organ_gb = (String) jre.get("ORGAN_GB");
			System.out.println("SEARCHORGAN:"+adm_cd_before);
			
			String adm_cd_after = adm_cd_before.substring(0,7);
			System.out.println("adm_cd_after:"+adm_cd_after);
			String haengtext = "";
			String organ_name = "";
			int Organ_Seq = 0;
				
			//obj_re.put("RESULT","SUCCESS");
			//obj_re.put("array1",array1);
			//obj_re.put("array2",array2);
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			GsonBuilder builder = new GsonBuilder();
	    	Gson gson = builder.create();
			
			JSONArray al = new JSONArray();
			OrganDAO od = new OrganDAO();
			
			String sql = "";
			
			//3105300 오정구
			//3105353 오정구/원동2동
			
			if(adm_cd_after.substring(5,7).equals("00")){
				adm_cd_after = adm_cd_after.substring(0,5);
				sql = " SELECT A.ORGAN_SEQ, B.HAENGTEXT, A.ORGAN_NAME  "
						 + " FROM ORGANINFO A INNER JOIN ADM_CODE B	"
						 + " ON(A.HAENGCODE = B.HAENGCODE)	"
						 + " WHERE A.ORGAN_GB = ?  "
						 + " AND A.SIGUNGUCODE = ? " 
						 + " GROUP BY A.ORGAN_SEQ, B.HAENGTEXT, A.ORGAN_NAME	";
			}else{
				sql = " SELECT A.ORGAN_SEQ, B.HAENGTEXT, A.ORGAN_NAME  "
						 + " FROM ORGANINFO A INNER JOIN ADM_CODE B	"
						 + " ON(A.HAENGCODE = B.HAENGCODE)	"
						 + " WHERE A.ORGAN_GB = ?  "
						 + " AND A.HAENGCODE = ? "
						 + " GROUP BY A.ORGAN_SEQ, B.HAENGTEXT, A.ORGAN_NAME	";
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, organ_gb);
			pstmt.setString(2, adm_cd_after);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				od.setOrgan_Seq(rs.getInt("ORGAN_SEQ"));
				Organ_Seq = rs.getInt("ORGAN_SEQ");
				System.out.println("ORGAN_SEQ:"+Organ_Seq);
				od.setHaengtext(rs.getString("HAENGTEXT"));
				haengtext = rs.getString("HAENGTEXT");
				System.out.println("HAENGTEXT:"+haengtext);
				od.setOrgan_Name(rs.getString("ORGAN_NAME"));
				organ_name = rs.getString("ORGAN_NAME");
				System.out.println("ORGAN_NAME:"+organ_name);
				al.add(gson.toJson(od));
				System.out.println("toJson:"+gson.toJson(od));
			}
			
			obj_re.put("RESULT","SUCCESS");
			obj_re.put("ORGANLIST", al);
			//obj_re.put("ADM_CD",adm_cd_after);
			//obj_re.put("ORGAN_NAME",organ_name);

		}else if(sQuery.equals("AREA_SEARCH")){
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			JSONArray jArray = new JSONArray();
			JSONObject center = new JSONObject();
			JSONObject point = new JSONObject();
			JSONObject mapData = new JSONObject();
			
			String adm_cd = (String)jre.get("ADM_CD");
			double cox = (Double)jre.get("COX");
			double coy = (Double)jre.get("COY");
			double minX = 1938371,minY = 11947124,maxX = 0,maxY = 0;

			//String sqlTemp = "select DISTINCT HAENGCODE,HAENGTEXT from ADM_CODE where SIDOTEXT = ? and SIGUNGUTEXT = ?";
			String sqlTemp = " select DISTINCT ADM_CD,"
						   + " CASE"
						   + " WHEN SUBSTRING(?,6,2) = '00' THEN HAENGTEXT"
						   + " ELSE ADM_TEXT"
						   + " END AS RES_TEXT"
						   + " from ADM_CODE"
						   + " where SUBSTRING(ADM_CD,1,7) = SUBSTRING(?,1,7) and SUBSTRING(ADM_CD,9,2) != '00'"
						   + " OR SUBSTRING(?,6,2) = '00' and SUBSTRING(?,1,5) = SUBSTRING(ADM_CD,1,5) and SUBSTRING(ADM_CD,9,2) = '00' and ADM_CD != ?";
			String sql = "select COX,COY from BOUNDARYCOORDINATES where ADM_CD=? order by SEQ";
			
			PreparedStatement pstmtTemp = conn.prepareStatement(sqlTemp);
			//pstmtTemp.setString(1,sidotext);
			//pstmtTemp.setString(2, sigungutext);
			pstmtTemp.setString(1,adm_cd);
			pstmtTemp.setString(2,adm_cd);
			pstmtTemp.setString(3,adm_cd);
			pstmtTemp.setString(4,adm_cd);
			pstmtTemp.setString(5,adm_cd);
			
			ResultSet rsTemp = null;
			
			rsTemp = pstmtTemp.executeQuery();
			while(rsTemp.next()) {
				String admCd = rsTemp.getString(1);
				String resText = rsTemp.getString(2);
				JSONObject jo1 = new JSONObject();
				
				JSONArray features = new JSONArray();
				
				JSONObject jo2 = new JSONObject();
				jo2.put("type","Feature");
				
				JSONObject geometry = new JSONObject();
				geometry.put("type","Polygon");
				
				JSONArray coordinates = new JSONArray();
				JSONArray posArray = new JSONArray();
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, admCd);
				rs = pstmt.executeQuery();
				pstmt.clearParameters();
				while(rs.next()) {
					JSONArray pos = new JSONArray();
					double COX = rs.getDouble("COX");
					double COY = rs.getDouble("COY");
					pos.add(COX);
					pos.add(COY);
					
					if(minX > COX)
						minX = COX;
					
					if(maxX < COX)
						maxX = COX;
	
					if(minY > COY)
						minY = COY;
					
					if(maxY < COY)
						maxY = COY;
					
					posArray.add(pos);
				}
				coordinates.add(posArray);
				geometry.put("coordinates",coordinates);
				JSONObject properties = new JSONObject();
				properties.put("Name", admCd);
				properties.put("Description",resText);
				jo2.put("geometry",geometry);
				jo2.put("properties",properties);
				features.add(jo2);
				jo1.put("features",features);
				jo1.put("type", "FeatureCollection");
				//jo1.put("selected",haengtext_param.equals(haengtext));
				jo1.put("selected",adm_cd.equals(admCd) && !adm_cd.substring(8, 10).equals("00"));
				//System.out.println("jo1 = "+jo1.toJSONString());
				jArray.add(jo1);
			}
			center.put("x", (minX+maxX)/2);
			center.put("y", (minY+maxY)/2);
			System.out.println("center_x = "+(minX+maxX)/2);
			point.put("x",cox);
			point.put("y",coy);
			/* obj_re.put("GEODATA",jArray);
			obj_re.put("CENTER", center);
			obj_re.put("POINT", point); */
			int zoomLevel = adm_cd.substring(5,7).equals("00") ? 7 : 8;
			mapData.put("GEODATA", jArray);
			mapData.put("CENTER", center);
			mapData.put("POINT", point);
			mapData.put("ZOOMLEVEL", zoomLevel);
			obj_re.put("MAPDATA", mapData);
			
			
			System.out.println("ENVSEARCH");
			String adm_cd1 = "";
			String adm_cd2 = "";
			String adm_cd3 = "";
			
			adm_cd1 = adm_cd.substring(0, 5) + "00-00";
			adm_cd2 = adm_cd.substring(0, 8) + "00";
			adm_cd3 = adm_cd;
			
			//3105300-00
			
			sql = " SELECT CASE "
				+ " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
				+ " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
				+ " ELSE '3' "
				+ " END AS LEVEL , `ADM_CD`,`20TH`,`30TH`,`40TH`,`50TH`,`60TH_OVER`, ROUND((20TH+30TH+40TH),1) AS 40TH_UNDER, ROUND((50TH+60TH_OVER),1) AS 50TH_OVER " 
				+ " FROM ENVINFO "
				+ "	WHERE ADM_CD = ? \n";

			sql = sql + " UNION " + sql + " UNION " +sql;
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, adm_cd1);
			pstmt.setString(2, adm_cd2);
			pstmt.setString(3, adm_cd3);
			
			rs = pstmt.executeQuery();
			
			VoteDAO vd = null;
			
			JSONArray al1 = new JSONArray();
			GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
		    
			while(rs.next()){
				vd = new VoteDAO();
				vd.setAdm_cd(rs.getString("ADM_CD"));
				vd.setLevel(rs.getInt("LEVEL"));
				vd.setV20th(rs.getFloat("20TH"));
				vd.setV30th(rs.getFloat("30TH"));
				vd.setV40th(rs.getFloat("40TH"));
				vd.setV40th_under(rs.getFloat("40TH_UNDER"));
				vd.setV50th(rs.getFloat("50TH"));
				vd.setV50th_over(rs.getFloat("50TH_OVER"));
				vd.setV60th_over(rs.getFloat("60TH_OVER"));
				//al1.add(vd);
				al1.add(gson.toJson(vd));
			}
			
			obj_re.put("RATE", al1);
			
			System.out.println("al1:"+al1.size());
			
			System.out.println("STATSSEARCH");
			
			sql = " SELECT CASE "
				 + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
				 + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
				 + " ELSE '3' "
				 + " END AS LEVEL, ADM_CD,`PARTNER_YN`,`UNIV_OVER`,`POP_DENSITY`,`AGED_CHILD_RATIO`,`CHILDHOOD_ALIMONY`,`AGE_AVG` "
				 + " FROM  ENVINFO "
				 + " WHERE ADM_CD = ? \n";
			
			if(!adm_cd.substring(5,7).equals("00")) {
				sql = sql + " UNION "+sql;
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				
				if(adm_cd2.equals(adm_cd3)) {
					pstmt.setString(2, adm_cd2);
				} else {
					pstmt.setString(2, adm_cd3);
				}
				
			} else {
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
			}
			
			//pstmt = null;
			//rs = null;
		
			rs = pstmt.executeQuery();
			
			StatsDAO sd = null;
			JSONArray al2 = new JSONArray();
			
			// ADM_CD,`PARTNER_YN`,`UNIV_OVER`,`POP_DENSITY`,`AGED_CHILD_RATIO`,`FAMILY_AVG`,`CHILDHOOD_ALIMONY`,`AGE_AVG`
			while(rs.next()){
				sd = new StatsDAO();
				sd.setLevel(rs.getInt("LEVEL"));
				sd.setAdm_cd(rs.getString("ADM_CD"));
				sd.setAge_avg(rs.getFloat("AGE_AVG"));
				sd.setAged_child_ratio(rs.getFloat("AGED_CHILD_RATIO"));
				sd.setPartner_yn(rs.getFloat("PARTNER_YN"));
				sd.setUniv_over(rs.getFloat("UNIV_OVER"));
				sd.setPop_dnsity(rs.getInt("POP_DENSITY"));
				sd.setChildhood_alimony(rs.getFloat("CHILDHOOD_ALIMONY"));
				al2.add(gson.toJson(sd));
		
			}	
			
			System.out.println("al2:"+al2.size());
			
			obj_re.put("STATS", al2);
			
			System.out.println("FAMILYSEARCH");
			
			sql = " SELECT CASE "
				  + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1'  "
				  + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
				  + " ELSE '3' "
				  + " END AS LEVEL, `ADM_CD`,`FAMILY_ONE`,`FAMILY_AVG`,`FAMILY_TWO_OVER`,`MYHOME_RATIO`,`APT_RATIO`,`40M_OVER` FROM ENVINFO "
				  + " WHERE ADM_CD = ? \n"; 
			
			if(!adm_cd.substring(5,7).equals("00")) {
				sql = sql + " UNION "+sql;
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				
				if(adm_cd2.equals(adm_cd3)) {
					pstmt.setString(2, adm_cd2);
				} else {
					pstmt.setString(2, adm_cd3);
				}
				
			} else {
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
			}			
			
			/*
			if(!adm_cd2.equals(adm_cd3)){
				sql = sql + " UNION "+sql;
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				pstmt.setString(2, adm_cd3);
				
			}else{
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				
			}
			*/
			rs = pstmt.executeQuery();
			
			FamilyDAO fd = null;
			JSONArray al3 = new JSONArray();	 
			
			//`ADM_CD`,`FAMILY_ONE`,`FAMILY_TWO_OVER`,`MYHOME_RATIO`,`APT_RATIO`,`40M_OVER` 
			while(rs.next()){
				fd =  new FamilyDAO();
				
				fd.setLevel(rs.getInt("LEVEL"));
				fd.setAdm_cd(rs.getString("ADM_CD"));
				fd.setApt_ratio(rs.getFloat("APT_RATIO"));
				fd.setFamily_one(rs.getFloat("FAMILY_ONE"));
				fd.setFamily_avg(rs.getFloat("FAMILY_AVG"));
				fd.setFamily_two_over(rs.getFloat("FAMILY_TWO_OVER"));
				fd.setMyhome_ratio(rs.getFloat("MYHOME_RATIO"));
				fd.setF40m_over(rs.getFloat("40M_OVER"));
				al3.add(gson.toJson(fd));
			}
						
			System.out.println("al3:"+al3.size());
			
			obj_re.put("FAMILY", al3);
			
			System.out.println("ELECTSEARCH");
			
			sql = " SELECT CASE "
				 + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
				 + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
				 + " ELSE '3' "
				 + " END AS LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2, " 
				 + " (IFNULL(SUM(6TH), 0) + IFNULL(SUM(19TH), 0) + IFNULL(SUM(18TH_1),0) + IFNULL(SUM(18TH_2),0)) / 4 AS AVG "
				 + " FROM ( "
				 + " SELECT ADM_CD, "
				 + " CASE "
				 + " WHEN EGB = 'E01' AND SEQ = 6 THEN V1_RATE - V2_RATE "
				 + " END AS 6TH, "
				 + " CASE "
				 + " WHEN EGB = 'E03' AND SEQ = 19 THEN V1_RATE - V2_RATE "
				 + " END AS 19TH, "
				 + " CASE "
				 + " WHEN EGB = 'E02' AND SEQ = 18 THEN V1_RATE - V2_RATE "
				 + " END AS 18TH_1, "
				 + " CASE "
				 + " WHEN EGB = 'E03' AND SEQ = 18 THEN V1_RATE - V2_RATE "
				 + " END AS 18TH_2 "
				 + " FROM VOTEINFO "
				 + " WHERE ADM_CD = ? "
				 + " ) A "
				 + " GROUP BY ADM_CD \n";
				 
		     sql = sql + " UNION " + sql + " UNION " + sql;
		     
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				pstmt.setString(2, adm_cd2);
				pstmt.setString(3, adm_cd3);
				
				rs = pstmt.executeQuery();
				
				ElectDao ed = null;
				JSONArray al4 = new JSONArray();	
				
				////LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2
				while(rs.next()){
					ed = new ElectDao();
					ed.setLevel(rs.getInt("LEVEL"));
					ed.setAdm_cd(rs.getString("ADM_CD"));
					ed.setAvg(Float.parseFloat(String.format("%.1f",rs.getFloat("AVG"))));
					ed.setF6th(Float.parseFloat(String.format("%.1f",rs.getFloat("6TH"))));
					ed.setF19th(Float.parseFloat(String.format("%.1f",rs.getFloat("19TH"))));
					ed.setF18th_1(Float.parseFloat(String.format("%.1f",rs.getFloat("18th_1"))));
					ed.setF18th_2(Float.parseFloat(String.format("%.1f",rs.getFloat("18TH_2"))));
					al4.add(gson.toJson(ed));
				}
		     
				System.out.println("al4:"+al4.size());
			
				obj_re.put("ELECT", al4);
				
				System.out.println("PDFSEARCH");
				System.out.println("adm_cd1:"+adm_cd1);
				System.out.println("adm_cd2:"+adm_cd2);
				
				sql = " SELECT ADM_CD, PDF_CODE, PDF_PAGE, PDF_ETC FROM ( "
					+ "		SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'M' "
					+ "		UNION ALL  "
					+ "		SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'M' "
					+ "		AND pdf_code NOT IN (SELECT pdf_code FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc='M') "
					+ "		) A " 
					+ " UNION ALL "
					+ " SELECT ADM_CD, PDF_CODE, PDF_PAGE, PDF_ETC FROM ("
					+ " 	SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P' "
					+ "		UNION ALL " 
					+ " 	SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P' "
					+ "		AND pdf_code NOT IN (SELECT pdf_code FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P') "
					+ "		) A "
					+ " ORDER BY pdf_code ";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd2);
				pstmt.setString(2, adm_cd1);
				pstmt.setString(3, adm_cd2);
				pstmt.setString(4, adm_cd2);
				pstmt.setString(5, adm_cd1);
				pstmt.setString(6, adm_cd2);
				
				rs = pstmt.executeQuery();
				
				PdfDAO pd = null;
				JSONArray al5 = new JSONArray();
				
				while(rs.next()){
					pd = new PdfDAO();
					pd.setAdm_cd(rs.getString("ADM_CD"));
					pd.setPdf_code(rs.getString("PDF_CODE"));
					pd.setPdf_page(rs.getString("PDF_PAGE"));
					pd.setPdf_etc(rs.getString("PDF_ETC"));
					al5.add(gson.toJson(pd));
				}
				
				System.out.println("al5:"+al5.size());
				obj_re.put("PDF", al5);
				
				System.out.println("ETCSEARCH");
				
				sql = " SELECT A.ADM_CD, SUM(A.POPULATION) AS POPULATION, SUM(A.FAMILY) AS FAMILY, A.TUPYOGU_ADDR "
					+ " ,SUM(C.ELECTOR_CNT) AS ELECTOR_CNT "
					+ " ,CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(B.SIDOTEXT, ' '), B.SIGUNGUTEXT), ' '), B.HAENGTEXT), ' '), B.ADM_TEXT) AS TUPYOGU_NAME "
					+ " FROM ENVINFO A INNER JOIN ADM_CODE B "
					+ " ON (A.ADM_CD=B.ADM_CD) "
					+ " INNER JOIN (SELECT ADM_CD, SUM(ELECTOR_CNT) AS ELECTOR_CNT FROM VOTEINFO WHERE ADM_CD = ? GROUP BY ADM_CD) C "
					+ " ON (A.ADM_CD=C.ADM_CD) "
					+ " WHERE A.ADM_CD = ? "
					+ " GROUP BY A.ADM_CD, A.TUPYOGU_ADDR, B.SIDOTEXT, B.SIGUNGUTEXT, B.HAENGTEXT ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd3);
				pstmt.setString(2, adm_cd3);
				
				rs = pstmt.executeQuery();
				
				EtcDAO etd = null;
				
				JSONArray al6 = new JSONArray();
				
				while(rs.next()){
					etd = new EtcDAO();
					etd.setAdm_cd(rs.getString("ADM_CD"));
					etd.setElector_cnt(rs.getInt("ELECTOR_CNT"));
					etd.setFamily(rs.getInt("FAMILY"));
					etd.setPopulation(rs.getInt("POPULATION"));
					etd.setTupyogu_addr(rs.getString("TUPYOGU_ADDR"));
					etd.setTupyogu_name(rs.getString("TUPYOGU_NAME"));
					al6.add(gson.toJson(etd));
				}
				
				System.out.println("al6:"+al6.size());
				obj_re.put("ETC", al6);
				
				obj_re.put("RESULT","SUCCESS");
		     
		}else if(sQuery.equals("GPS")) {
			System.out.println("GPS");
			String adm_cd = null;
			double cox = (Double)jre.get("COX");
			double coy = (Double)jre.get("COY");
			//cox = 936271.0; coy = 1947119.0;
			//cox = 935713.0; coy = 1946562.0;
			//cox = 940031.0; coy = 1945537.0;
			// yangchun-gu
			//cox = 941434.0; coy = 1945787.0; // tupyogu
			//cox = 943731.0; coy = 1947957.0; // haengjoungdong
			
			boolean isPointInPolygon = false;
			JSONArray jArray = new JSONArray();
			JSONObject center = new JSONObject();
			JSONObject point = new JSONObject();
			JSONObject mapData = new JSONObject();
			double minX = 1938371,minY = 11947124,maxX = 0,maxY = 0;
			
			Loc loc = new Loc(cox,coy);

			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			System.out.println("address = "+GeoUtil.getAddressFromPoint(cox, coy));
			JSONObject address = GeoUtil.getAddressFromPoint(cox, coy);
			String sigungu = (String)address.get("sgg_nm");
			String haengtext = (String)address.get("emdong_nm");
			String selectedAdm_cd = null;
			
			String sqlTemp  = " select DISTINCT ADM_CD from ADM_CODE" 
							+ " where SIGUNGUTEXT = ? and HAENGTEXT = ? and SUBSTRING(ADM_CD,9,2) != '00'"; 
			String sql = "select COX,COY from BOUNDARYCOORDINATES where ADM_CD=? order by SEQ";
			
			PreparedStatement pstmtTemp = conn.prepareStatement(sqlTemp);
			pstmtTemp.setString(1, sigungu);
			pstmtTemp.setString(2, haengtext);
			
			ResultSet rsTemp = null;
			rsTemp = pstmtTemp.executeQuery();
			while(rsTemp.next()) {
				ArrayList<Loc> list = new ArrayList<Loc>();
				adm_cd = rsTemp.getString(1);
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd);
				rs = pstmt.executeQuery();
				pstmt.clearParameters();
				
				while(rs.next()) {
					double COX = rs.getDouble("COX");
					double COY = rs.getDouble("COY");
					
					Loc loc_temp = new Loc(COX,COY);
					list.add(loc_temp);
				}
				
				isPointInPolygon = loc.IsPointInPolygon(list,loc);
				
				if(isPointInPolygon) {
					selectedAdm_cd = adm_cd;
					break;
				}
			}			
			
			if(adm_cd != null && adm_cd.length() > 1) {
				
				if(!isPointInPolygon)
					adm_cd = adm_cd.substring(0,5)+ "00-00";
				
				sqlTemp = " select DISTINCT ADM_CD,"
						   + " CASE"
						   + " WHEN SUBSTRING(?,6,2) = '00' THEN HAENGTEXT"
						   + " ELSE ADM_TEXT"
						   + " END AS RES_TEXT"
						   + " from ADM_CODE"
						   + " where SUBSTRING(ADM_CD,1,7) = SUBSTRING(?,1,7) and SUBSTRING(ADM_CD,9,2) != '00'"
						   + " OR SUBSTRING(?,6,2) = '00' and SUBSTRING(?,1,5) = SUBSTRING(ADM_CD,1,5) and SUBSTRING(ADM_CD,9,2) = '00' and ADM_CD != ?";
				
				pstmtTemp = conn.prepareStatement(sqlTemp);
				pstmtTemp.setString(1, adm_cd);
				pstmtTemp.setString(2, adm_cd);
				pstmtTemp.setString(3, adm_cd);
				pstmtTemp.setString(4, adm_cd);
				pstmtTemp.setString(5, adm_cd);
				rsTemp = pstmtTemp.executeQuery();
				
				while(rsTemp.next()) {
					ArrayList<Loc> list = new ArrayList<Loc>();
					
					String admCd = rsTemp.getString(1);
					String resText = rsTemp.getString(2);
					JSONObject jo1 = new JSONObject();
					
					JSONArray features = new JSONArray();
					
					JSONObject jo2 = new JSONObject();
					jo2.put("type","Feature");
					
					JSONObject geometry = new JSONObject();
					geometry.put("type","Polygon");
					
					JSONArray coordinates = new JSONArray();
					JSONArray posArray = new JSONArray();
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, admCd);
					rs = pstmt.executeQuery();
					pstmt.clearParameters();
					while(rs.next()) {
						JSONArray pos = new JSONArray();
						double COX = rs.getDouble("COX");
						double COY = rs.getDouble("COY");
						pos.add(COX);
						pos.add(COY);
						
						if(minX > COX)
							minX = COX;
						
						if(maxX < COX)
							maxX = COX;
		
						if(minY > COY)
							minY = COY;
						
						if(maxY < COY)
							maxY = COY;
						
						posArray.add(pos);
						
						Loc loc_temp = new Loc(COX,COY);
						list.add(loc_temp);
					}
					
					if(!isPointInPolygon) {
						isPointInPolygon = loc.IsPointInPolygon(list,loc);
						if(isPointInPolygon) {
							selectedAdm_cd = admCd;
						}
					}
					
					coordinates.add(posArray);
					geometry.put("coordinates",coordinates);
					JSONObject properties = new JSONObject();
					properties.put("Name", admCd);
					properties.put("Description",resText);
					jo2.put("geometry",geometry);
					jo2.put("properties",properties);
					features.add(jo2);
					jo1.put("features",features);
					jo1.put("type", "FeatureCollection");
					//jo1.put("selected",haengtext_param.equals(haengtext));
					jo1.put("selected",selectedAdm_cd != null && selectedAdm_cd.equals(admCd));
					//System.out.println("jo1 = "+jo1.toJSONString());
					jArray.add(jo1);
	
				}
				center.put("x", (minX+maxX)/2);
				center.put("y", (minY+maxY)/2);
				System.out.println("center_x = "+(minX+maxX)/2);
				point.put("x",cox);
				point.put("y",coy);
				adm_cd = selectedAdm_cd;
				
				int zoomLevel = adm_cd.substring(5,7).equals("00") ? 7 : 8;
				mapData.put("GEODATA", jArray);
				mapData.put("CENTER", center);
				mapData.put("POINT", point);
				mapData.put("ZOOMLEVEL", zoomLevel);
				mapData.put("ADM_CD", adm_cd);
				mapData.put("COX", cox);
				mapData.put("COY", coy);
			}

			if(isPointInPolygon) {
				obj_re.put("MAPDATA",mapData);
				
				System.out.println("ENVSEARCH");
				String adm_cd1 = "";
				String adm_cd2 = "";
				String adm_cd3 = "";
				
				adm_cd1 = adm_cd.substring(0, 5) + "00-00";
				adm_cd2 = adm_cd.substring(0, 8) + "00";
				adm_cd3 = adm_cd;
				
				//3105300-00
				
				sql = " SELECT CASE "
					+ " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
					+ " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
					+ " ELSE '3' "
					+ " END AS LEVEL , `ADM_CD`,`20TH`,`30TH`,`40TH`,`50TH`,`60TH_OVER`, ROUND((20TH+30TH+40TH),1) AS 40TH_UNDER, ROUND((50TH+60TH_OVER),1) AS 50TH_OVER " 
					+ " FROM ENVINFO "
					+ "	WHERE ADM_CD = ? \n";

				sql = sql + " UNION " + sql + " UNION " +sql;
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, adm_cd1);
				pstmt.setString(2, adm_cd2);
				pstmt.setString(3, adm_cd3);
				
				rs = pstmt.executeQuery();
				
				VoteDAO vd = null;
				
				JSONArray al1 = new JSONArray();
				GsonBuilder builder = new GsonBuilder();
			    Gson gson = builder.create();
			    
				while(rs.next()){
					vd = new VoteDAO();
					vd.setAdm_cd(rs.getString("ADM_CD"));
					vd.setLevel(rs.getInt("LEVEL"));
					vd.setV20th(rs.getFloat("20TH"));
					vd.setV30th(rs.getFloat("30TH"));
					vd.setV40th(rs.getFloat("40TH"));
					vd.setV40th_under(rs.getFloat("40TH_UNDER"));
					vd.setV50th(rs.getFloat("50TH"));
					vd.setV50th_over(rs.getFloat("50TH_OVER"));
					vd.setV60th_over(rs.getFloat("60TH_OVER"));
					//al1.add(vd);
					al1.add(gson.toJson(vd));
				}
				
				obj_re.put("RATE", al1);
				
				System.out.println("al1:"+al1.size());
				
				System.out.println("STATSSEARCH");
				
				sql = " SELECT CASE "
					 + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
					 + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
					 + " ELSE '3' "
					 + " END AS LEVEL, ADM_CD,`PARTNER_YN`,`UNIV_OVER`,`POP_DENSITY`,`AGED_CHILD_RATIO`,`CHILDHOOD_ALIMONY`,`AGE_AVG` "
					 + " FROM  ENVINFO "
					 + " WHERE ADM_CD = ? \n";
				
				if(!adm_cd.substring(5,7).equals("00")) {
					sql = sql + " UNION "+sql;
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
					
					if(adm_cd2.equals(adm_cd3)) {
						pstmt.setString(2, adm_cd2);
					} else {
						pstmt.setString(2, adm_cd3);
					}
					
				} else {
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
				}
				
				//pstmt = null;
				//rs = null;
			
				rs = pstmt.executeQuery();
				
				StatsDAO sd = null;
				JSONArray al2 = new JSONArray();
				
				// ADM_CD,`PARTNER_YN`,`UNIV_OVER`,`POP_DENSITY`,`AGED_CHILD_RATIO`,`FAMILY_AVG`,`CHILDHOOD_ALIMONY`,`AGE_AVG`
				while(rs.next()){
					sd = new StatsDAO();
					sd.setLevel(rs.getInt("LEVEL"));
					sd.setAdm_cd(rs.getString("ADM_CD"));
					sd.setAge_avg(rs.getFloat("AGE_AVG"));
					sd.setAged_child_ratio(rs.getFloat("AGED_CHILD_RATIO"));
					sd.setPartner_yn(rs.getFloat("PARTNER_YN"));
					sd.setUniv_over(rs.getFloat("UNIV_OVER"));
					sd.setPop_dnsity(rs.getInt("POP_DENSITY"));
					sd.setChildhood_alimony(rs.getFloat("CHILDHOOD_ALIMONY"));
					al2.add(sd);
				}	
				
				System.out.println("al2:"+al2.size());
				
				System.out.println("FAMILYSEARCH");
				
				sql = " SELECT CASE "
					  + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1'  "
					  + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
					  + " ELSE '3' "
					  + " END AS LEVEL, `ADM_CD`,`FAMILY_ONE`,`FAMILY_AVG`,`FAMILY_TWO_OVER`,`MYHOME_RATIO`,`APT_RATIO`,`40M_OVER` FROM ENVINFO "
					  + " WHERE ADM_CD = ? \n"; 
				
				if(!adm_cd.substring(5,7).equals("00")) {
					sql = sql + " UNION "+sql;
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
					
					if(adm_cd2.equals(adm_cd3)) {
						pstmt.setString(2, adm_cd2);
					} else {
						pstmt.setString(2, adm_cd3);
					}
					
				} else {
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
				}	
								
				/*
				if(!adm_cd2.equals(adm_cd3)){
					sql = sql + " UNION "+sql;
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
					pstmt.setString(2, adm_cd3);
					
				}else{
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
					
				}
				*/
				rs = pstmt.executeQuery();
				
				FamilyDAO fd = null;
				JSONArray al3 = new JSONArray();	 
				
				//`ADM_CD`,`FAMILY_ONE`,`FAMILY_TWO_OVER`,`MYHOME_RATIO`,`APT_RATIO`,`40M_OVER` 
				while(rs.next()){
					fd =  new FamilyDAO();
					
					fd.setLevel(rs.getInt("LEVEL"));
					fd.setAdm_cd(rs.getString("ADM_CD"));
					fd.setApt_ratio(rs.getFloat("APT_RATIO"));
					fd.setFamily_one(rs.getFloat("FAMILY_ONE"));
					fd.setFamily_avg(rs.getFloat("FAMILY_AVG"));
					fd.setFamily_two_over(rs.getFloat("FAMILY_TWO_OVER"));
					fd.setMyhome_ratio(rs.getFloat("MYHOME_RATIO"));
					fd.setF40m_over(rs.getFloat("40M_OVER"));
					al3.add(fd);
				}
							
				System.out.println("al3:"+al3.size());
				
				obj_re.put("FAMILY", al3);
				
				System.out.println("ELECTSEARCH");
				
				sql = " SELECT CASE "
						 + " WHEN SUBSTRING(adm_cd, 6, 2) = '00' THEN '1' "
						 + " WHEN SUBSTRING(adm_cd, 6, 2) <> '00' AND SUBSTRING(adm_cd, 9, 2) = '00' THEN '2' "
						 + " ELSE '3' "
						 + " END AS LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2, " 
						 + " (IFNULL(SUM(6TH), 0) + IFNULL(SUM(19TH), 0) + IFNULL(SUM(18TH_1),0) + IFNULL(SUM(18TH_2),0)) / 4 AS AVG "
						 + " FROM ( "
						 + " SELECT ADM_CD, "
						 + " CASE "
						 + " WHEN EGB = 'E01' AND SEQ = 6 THEN V1_RATE - V2_RATE "
						 + " END AS 6TH, "
						 + " CASE "
						 + " WHEN EGB = 'E03' AND SEQ = 19 THEN V1_RATE - V2_RATE "
						 + " END AS 19TH, "
						 + " CASE "
						 + " WHEN EGB = 'E02' AND SEQ = 18 THEN V1_RATE - V2_RATE "
						 + " END AS 18TH_1, "
						 + " CASE "
						 + " WHEN EGB = 'E03' AND SEQ = 18 THEN V1_RATE - V2_RATE "
						 + " END AS 18TH_2 "
						 + " FROM VOTEINFO "
						 + " WHERE ADM_CD = ? "
						 + " ) A "
						 + " GROUP BY ADM_CD \n";
					 
			     sql = sql + " UNION " + sql + " UNION " + sql;
			     
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd1);
					pstmt.setString(2, adm_cd2);
					pstmt.setString(3, adm_cd3);
					
					rs = pstmt.executeQuery();
					
					ElectDao ed = null;
					JSONArray al4 = new JSONArray();	
					
					////LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2
					while(rs.next()){
						ed = new ElectDao();
						ed.setLevel(rs.getInt("LEVEL"));
						ed.setAdm_cd(rs.getString("ADM_CD"));
						ed.setAvg(rs.getFloat("AVG"));
						ed.setF6th(rs.getFloat("6TH"));
						ed.setF19th(rs.getFloat("19TH"));
						ed.setF18th_1(rs.getFloat("18th_1"));
						ed.setF18th_2(rs.getFloat("18TH_2"));
						al4.add(gson.toJson(ed));
					}
			     
					System.out.println("al4:"+al4.size());
				
					obj_re.put("ELECT", al4);
					
					System.out.println("PDFSEARCH");
					System.out.println("adm_cd1:"+adm_cd1);
					System.out.println("adm_cd2:"+adm_cd2);
					
					sql = "SELECT ADM_CD, PDF_CODE, PDF_PAGE, PDF_ETC FROM ( "
						+ " SELECT * FROM PDFINFO WHERE ADM_CD = ? "
						+ "	UNION ALL "
						+ "	SELECT * FROM PDFINFO WHERE ADM_CD = ? "
						+ "	AND pdf_code NOT IN (SELECT pdf_code FROM PDFINFO WHERE ADM_CD = ? ) "
						+ "	) A "
						+ "	ORDER BY pdf_code ";
					
					sql = " SELECT ADM_CD, PDF_CODE, PDF_PAGE, PDF_ETC FROM ( "
						+ "		SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'M' "
						+ "		UNION ALL  "
						+ "		SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'M' "
						+ "		AND pdf_code NOT IN (SELECT pdf_code FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc='M') "
						+ "		) A " 
						+ " UNION ALL "
						+ " SELECT ADM_CD, PDF_CODE, PDF_PAGE, PDF_ETC FROM ("
						+ " 	SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P' "
						+ "		UNION ALL " 
						+ " 	SELECT * FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P' "
						+ "		AND pdf_code NOT IN (SELECT pdf_code FROM PDFINFO WHERE ADM_CD = ? AND pdf_etc = 'P') "
						+ "		) A "
						+ " ORDER BY pdf_code ";

					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd2);
					pstmt.setString(2, adm_cd1);
					pstmt.setString(3, adm_cd2);
					pstmt.setString(4, adm_cd2);
					pstmt.setString(5, adm_cd1);
					pstmt.setString(6, adm_cd2);
					
					rs = pstmt.executeQuery();
					
					PdfDAO pd = null;
					JSONArray al5 = new JSONArray();
					
					while(rs.next()){
						pd = new PdfDAO();
						pd.setAdm_cd(rs.getString("ADM_CD"));
						pd.setPdf_code(rs.getString("PDF_CODE"));
						pd.setPdf_page(rs.getString("PDF_PAGE"));
						pd.setPdf_etc(rs.getString("PDF_ETC"));
						al5.add(gson.toJson(pd));
					}
					
					System.out.println("al5:"+al5.size());
					obj_re.put("PDF", al5);
					
					System.out.println("ETCSEARCH");
					
					sql = " SELECT A.ADM_CD, SUM(A.POPULATION) AS POPULATION, SUM(A.FAMILY) AS FAMILY, A.TUPYOGU_ADDR "
						+ " ,SUM(C.ELECTOR_CNT) AS ELECTOR_CNT "
						+ " ,CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(B.SIDOTEXT, ' '), B.SIGUNGUTEXT), ' '), B.HAENGTEXT), ' '), B.ADM_TEXT) AS TUPYOGU_NAME "
						+ " FROM ENVINFO A INNER JOIN ADM_CODE B "
						+ " ON (A.ADM_CD=B.ADM_CD) "
						+ " INNER JOIN (SELECT ADM_CD, SUM(ELECTOR_CNT) AS ELECTOR_CNT FROM VOTEINFO WHERE ADM_CD = ? GROUP BY ADM_CD) C "
						+ " ON (A.ADM_CD=C.ADM_CD) "
						+ " WHERE A.ADM_CD = ? "
						+ " GROUP BY A.ADM_CD, A.TUPYOGU_ADDR, B.SIDOTEXT, B.SIGUNGUTEXT, B.HAENGTEXT ";
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, adm_cd3);
					pstmt.setString(2, adm_cd3);
					
					rs = pstmt.executeQuery();
					
					EtcDAO etd = null;
					
					JSONArray al6 = new JSONArray();
					
					while(rs.next()){
						etd = new EtcDAO();
						etd.setAdm_cd(rs.getString("ADM_CD"));
						etd.setElector_cnt(rs.getInt("ELECTOR_CNT"));
						etd.setFamily(rs.getInt("FAMILY"));
						etd.setPopulation(rs.getInt("POPULATION"));
						etd.setTupyogu_addr(rs.getString("TUPYOGU_ADDR"));
						etd.setTupyogu_name(rs.getString("TUPYOGU_NAME"));
						al6.add(gson.toJson(etd));
					}
					
					System.out.println("al6:"+al6.size());
					obj_re.put("ETC", al6);
					
					obj_re.put("RESULT","SUCCESS");

			}		
			else {
				obj_re.put("RESULT","FAILED");
			}
			
			System.out.println("obj_re = "+obj_re.toString()); 
		} else if(sQuery.equals("MODIFYPASS")) {
			System.out.println("TYPE is MODIFYPASS");
			int update_pass;
			
			String pass = (String) jre.get("PASS");
			String macadd = (String) jre.get("MACADD");
			
			System.out.println("MODIFYPASS pass : "+pass);
			System.out.println("MODIFYPASS macadd : "+macadd);
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			String sql = "update USERINFO set pwd=? where MACADDRESS=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pass);
			pstmt.setString(2, macadd);
			update_pass = pstmt.executeUpdate();
			obj_re.put("UPDATEPASS",update_pass);
			System.out.println("MODIFYPASS update_pass : "+update_pass);
		} else if(sQuery.equals("BUSINESSKIND")) {
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			pstmt = null;
			rs = null;
			
			String sql = "SELECT DISTINCT BKCODE,BKNAME FROM BUSINESS_KIND A, BUSINESS B" 
					+" WHERE A.BKCODE = B.KIND OR SUBSTRING(BKCODE,3,1) = '0'";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			BusinessKindDTO dto = null;
			JSONObject obj = new JSONObject();
			GsonBuilder builder = new GsonBuilder();
		    Gson gson = builder.create();
			JSONArray jArray = new JSONArray();
			
			while(rs.next()) {
				dto = new BusinessKindDTO();
				dto.bkCode = rs.getString("BKCODE");
				dto.bkName = rs.getString("BKNAME");
				jArray.add(gson.toJson(dto));
			}
			
			obj_re.put("BKINFO", jArray);
			
			obj_re.put("RESULT","SUCCESS");
			
		}else if(sQuery.equals("BUSINESSLIST")) {
			String title = (String) jre.get("TITLE");
			String kind = (String) jre.get("KIND");
			String admCd_before = (String) jre.get("ADM_CD");
									
			System.out.println("BUSINESSLIST title : "+title);
			System.out.println("BUSINESSLIST kind : "+kind);
			System.out.println("BUSINESSLIST admCd_before : "+admCd_before);
			
			String admCd_after = admCd_before;
			
			if(admCd_after.substring(5,7).equals("00")){
				admCd_after = admCd_after.substring(0,5);
			}
				
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
						
			pstmt = null;
			rs = null;
					
			String sql = " SELECT BN_SEQ,BKNAME AS KIND_STR,TITLE FROM BUSINESS_KIND A," 
							+"( SELECT BN_SEQ,KIND,TITLE FROM BUSINESS "
							+"  WHERE ( SUBSTRING(?,1,2) = SUBSTRING(KIND,1,2) AND SUBSTRING(?,3,1) = '0'"
							+"  OR KIND=?)"
							+"  AND CT_AREA LIKE ?";
			if(title != null && title.length() > 0) {
				 	   sql +="  AND TITLE LIKE ?";
			}
					   sql +=") B";
					   sql +=" WHERE A.BKCODE=B.KIND";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,kind);
			pstmt.setString(2,kind);
			pstmt.setString(3,kind);
			pstmt.setString(4,"%"+admCd_after+"%");
			if(title != null && title.length() > 0) {
				pstmt.setString(5,"%"+title+"%");
				
			}
			
			rs = pstmt.executeQuery();			
			JSONArray jArray = new JSONArray();
			GsonBuilder builder = new GsonBuilder();
		    Gson gson = builder.create();
						
			while(rs.next()) {
				BusinessListDTO dto = new BusinessListDTO();
				dto.bnSeq = rs.getInt("BN_SEQ");
				dto.title = rs.getString("TITLE");
				dto.kindStr = rs.getString("KIND_STR");
				jArray.add(gson.toJson(dto));
			}
			obj_re.put("RESULT","SUCCESS");
			obj_re.put("BUSINESSLIST", jArray);
			
		}else {
			
		}
		obj_re.put("TYPE",sQuery);
	
	}catch(NullPointerException npe){
		obj_re.put("RESULT","ERROR");
		npe.printStackTrace();
	}catch(Exception e){
		obj_re.put("RESULT","ERROR");
		e.printStackTrace();
	}finally{
		try {
			if (pstmt!=null) pstmt.close();
			if (conn!=null) conn.commit();
			if (conn!=null) conn.close();
			out.print(obj_re);
			out.flush();
		} catch (SQLException e) {
			obj_re.put("RESULT","ERROR");
			e.printStackTrace();
			e.printStackTrace();
		}
	}
%>