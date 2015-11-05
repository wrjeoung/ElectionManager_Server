package com.address;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

/**
 * Servlet implementation class MapServlet
 */
public class MapServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final String[][] array = {{"googlex","googley"},{"naverx","navery"},{"daumx","daumy"}};
	private int URL_LENGTH;
	private int curUrlIndex = 0;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	
	public void updateGoogleLocationInfo(HttpServletResponse response) throws IOException {
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		
		PrintWriter writer = response.getWriter();
		JSONObject result = new JSONObject();
		
		int updateCount = 0;
		StringBuffer invalidData = new StringBuffer();
		StringBuffer queryUpdate = new StringBuffer();
		StringBuffer querySelect = new StringBuffer();
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		
		
		System.out.println("start");
		try {
			
			querySelect.append("select SIGUNGU,BUBJOUNGDONG,BUNJI,GUNMUL from DATAADDRESS \n");
			querySelect.append("								where googlex is null \n");
			//querySelect.append("								where googlex =?");
			
			
			ps1 = conn.prepareStatement(querySelect.toString());
			//ps1.setString(1, "TEST");
			
			queryUpdate.append("update DATAADDRESS set googlex = ?, googley = ? where BUBJOUNGDONG = ? and BUNJI = ?");
			queryUpdate.append(" and ( GUNMUL = ? OR ? IS NULL )");

			ps2 = conn.prepareStatement(queryUpdate.toString());
			
			ResultSet rs = ps1.executeQuery();
			
			while(rs.next())
			{
				conn.setAutoCommit(false);
				
				String sigungu = rs.getString("SIGUNGU");
				String bubjoungdong = rs.getString("BUBJOUNGDONG");
				String bunji = rs.getString("BUNJI");
				String gunmul = rs.getString("GUNMUL");
				StringBuffer buffer = new StringBuffer();
				
				//System.out.println("update");

				buffer.append(sigungu);
				buffer.append(" ");
				buffer.append(bubjoungdong);
				if(bunji != null && bunji.length() > 0)
				{
					buffer.append(" ");
					buffer.append(bunji);
				}
				if(gunmul != null && gunmul.length() > 0)
				{
					buffer.append(" ");
					buffer.append(gunmul);
				}
				
				double[] locationGoogle = getAddressToPosition(buffer.toString(),0);
				
				if(curUrlIndex == URL_LENGTH - 1) {
					curUrlIndex = 0;
					result.put("status", "OVER_QUERY_LIMIT");
					break;
				}
				
				if(locationGoogle == null)
				{
					invalidData.append(buffer.toString());
					invalidData.append("/");
					continue;
				}
				

				ps2.setString(1, ""+locationGoogle[0]);
				ps2.setString(2, ""+locationGoogle[1]);
				ps2.setString(3, bubjoungdong);
				ps2.setString(4, bunji);
				ps2.setString(5, gunmul);
				ps2.setString(6, gunmul);
				
				//ps2.executeUpdate();
				
				ps2.addBatch();
				// 파라미터 Clear
				ps2.clearParameters();
				
				updateCount++;
				if(updateCount % 1000 == 0) {
					updateCount = 0;
					ps2.executeBatch();
				      // Batch 초기화
                    ps2.clearBatch();
                     
                    // 커밋
                    conn.commit() ;
				}
			}
			if(rs != null) rs.close();
			
			ps2.executeBatch();
			conn.commit();
			
			String status = (String)result.get("status");
			
			if(status == null || status.length() < 1) {
				result.put("status","OK");
			}
			writer.println(result);
			writer.flush();
			
		} catch (SQLException  e) {
			// TODO Auto-generated catch block
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		finally
		{
			try {
				//conn.commit();
				ps1.close();
				ps2.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("invalidData = "+invalidData.toString());
	}
	
	public void updateNaverLocationInfo(HttpServletResponse response) throws IOException {
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		System.out.println("updateNaverLocationInfo");
		PrintWriter writer = response.getWriter();
		JSONObject result = new JSONObject();
		
		int updateCount = 0;
		StringBuffer invalidData = new StringBuffer();
		StringBuffer queryUpdate = new StringBuffer();
		StringBuffer querySelect = new StringBuffer();
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		System.out.println("start");
		try {
			
			querySelect.append("select SIGUNGU,BUBJOUNGDONG,BUNJI,GUNMUL from DATAADDRESS \n");
			querySelect.append("								where naverx is null \n");
			
			ps1 = conn.prepareStatement(querySelect.toString());
			
			queryUpdate.append("update DATAADDRESS set naverx = ?, navery = ? where BUBJOUNGDONG = ? and BUNJI = ?");
			queryUpdate.append(" and ( GUNMUL = ? OR ? IS NULL )");

			ps2 = conn.prepareStatement(queryUpdate.toString());
			
			ResultSet rs = ps1.executeQuery();
			
			while(rs.next())
			{
				conn.setAutoCommit(false);
				
				String sigungu = rs.getString("SIGUNGU");
				String bubjoungdong = rs.getString("BUBJOUNGDONG");
				String bunji = rs.getString("BUNJI");
				String gunmul = rs.getString("GUNMUL");
				StringBuffer buffer = new StringBuffer();
				
				System.out.println("update");

				buffer.append(sigungu);
				buffer.append(" ");
				buffer.append(bubjoungdong);
				if(bunji != null && bunji.length() > 0) {
					buffer.append(" ");
					buffer.append(bunji);
				}
				if(gunmul != null && gunmul.length() > 0)
				{
					buffer.append(" ");
					buffer.append(gunmul);
				}
				
				double[] locationNaver = getAddressToPositionForNaver(buffer.toString());

				
				if(locationNaver == null)
				{
					invalidData.append(buffer.toString());
					invalidData.append("/");
					continue;
				}
				

				ps2.setString(1, ""+locationNaver[0]);
				ps2.setString(2, ""+locationNaver[1]);
				ps2.setString(3, bubjoungdong);
				ps2.setString(4, bunji);
				ps2.setString(5, gunmul);
				ps2.setString(6, gunmul);
				
				//ps2.executeUpdate();
				
				ps2.addBatch();
				// 파라미터 Clear
				ps2.clearParameters();
				
				updateCount++;
				if(updateCount % 1000 == 0) {
					updateCount = 0;
					ps2.executeBatch();
				      // Batch 초기화
                    ps2.clearBatch();
                    // 커밋
                    conn.commit() ;
				}
			}

			if(rs != null) rs.close();
			
			ps2.executeBatch();
			conn.commit();
			
			String status = (String)result.get("status");
			
			if(status == null || status.length() < 1) {
				result.put("status","OK");
			}
			writer.println(result);
			writer.flush();
			
		} catch (SQLException  e) {
			// TODO Auto-generated catch block
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		finally
		{
			try {
				//conn.commit();
				ps1.close();
				ps2.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("invalidData = "+invalidData.toString());
	}
	
	public void updateDaumLocationInfo(HttpServletResponse response) throws IOException {
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		
		PrintWriter writer = response.getWriter();
		JSONObject result = new JSONObject();
		
		int updateCount = 0;
		StringBuffer invalidData = new StringBuffer();
		StringBuffer queryUpdate = new StringBuffer();
		StringBuffer querySelect = new StringBuffer();
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		System.out.println("start");
		try {
			
			querySelect.append("select SIGUNGU,BUBJOUNGDONG,BUNJI,GUNMUL from DATAADDRESS \n");
			querySelect.append("								where daumx is null \n");
			
			ps1 = conn.prepareStatement(querySelect.toString());
			
			queryUpdate.append("update DATAADDRESS set daumx = ?, daumy = ? where BUBJOUNGDONG = ? and BUNJI = ?");
			queryUpdate.append(" and ( GUNMUL = ? OR ? IS NULL )");

			ps2 = conn.prepareStatement(queryUpdate.toString());
			
			ResultSet rs = ps1.executeQuery();
			
			while(rs.next())
			{
				conn.setAutoCommit(false);
				
				String sigungu = rs.getString("SIGUNGU");
				String bubjoungdong = rs.getString("BUBJOUNGDONG");
				String bunji = rs.getString("BUNJI");
				String gunmul = rs.getString("GUNMUL");
				StringBuffer buffer = new StringBuffer();
				
				System.out.println("update");

				buffer.append(sigungu);
				buffer.append(" ");
				buffer.append(bubjoungdong);
				if(bunji != null && bunji.length() > 0)
				{
					buffer.append(" ");
					buffer.append(bunji);
				}
				if(gunmul != null && gunmul.length() > 0)
				{
					buffer.append(" ");
					buffer.append(gunmul);
				}
				
				double[] locationDaum = getAddressToPositionForDaum(buffer.toString());

				
				if(locationDaum == null)
				{
					invalidData.append(buffer.toString());
					invalidData.append("/");
					continue;
				}
				

				ps2.setString(1, ""+locationDaum[0]);
				ps2.setString(2, ""+locationDaum[1]);
				ps2.setString(3, bubjoungdong);
				ps2.setString(4, bunji);
				ps2.setString(5, gunmul);
				ps2.setString(6, gunmul);
				
				//ps2.executeUpdate();
				
				ps2.addBatch();
				// 파라미터 Clear
				ps2.clearParameters();
				
				updateCount++;
				if(updateCount % 1000 == 0) {
					updateCount = 0;
					ps2.executeBatch();
				      // Batch 초기화
                    ps2.clearBatch();
                     
                    // 커밋
                    conn.commit() ;
				}
			}
			
			if(rs != null) rs.close();
			
			ps2.executeBatch();
			conn.commit();
			
			String status = (String)result.get("status");
			
			if(status == null || status.length() < 1) {
				result.put("status","OK");
			}
			writer.println(result);
			writer.flush();
			
		} catch (SQLException  e) {
			// TODO Auto-generated catch block
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		finally
		{
			try {
				//conn.commit();
				ps1.close();
				ps2.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("invalidData = "+invalidData.toString());
	}		

	private double [] getAddressToPosition(String korAddress, int retryCount) {
		String urlStr;
		HttpURLConnection connection = null;
		BufferedReader reader = null;
		StringBuilder stringBuilder;
		double position[];
		final String[] urlArray = {
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyBJ5BXIHpzaU60QCxzFSMgt59S9gZqqB2k&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyAkzIq2mp0n-dBHjUlLsMLNJ2pBA7K_BOo&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyDIVw0gDxBeY31b8UBsr6trnu6bOE1HrGk&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyDWSrwILIfoEY9S7hZp3I-YyZtVr5ppEOs&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyB898YXckS1XoT4lCEZZI_Y0b8W2ohqyqo&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyC_qlMkXopbahacfpAJYKHAsYR_w7BNbmM&address=",
				"https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&key=AIzaSyDWaLZuW0wwrDdm8EFWfY2Z0UCyLvhAboM&address=",
				"http://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address="
			};
		
		URL_LENGTH = urlArray.length;

		try {
			System.out.println("retryCount ="+retryCount);
			System.out.println("curUrlIndex ="+curUrlIndex);
			urlStr = urlArray[curUrlIndex] + URLEncoder.encode(korAddress, "utf-8");
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyBJ5BXIHpzaU60QCxzFSMgt59S9gZqqB2k";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyAkzIq2mp0n-dBHjUlLsMLNJ2pBA7K_BOo";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyDIVw0gDxBeY31b8UBsr6trnu6bOE1HrGk";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyDWSrwILIfoEY9S7hZp3I-YyZtVr5ppEOs";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyB898YXckS1XoT4lCEZZI_Y0b8W2ohqyqo";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyC_qlMkXopbahacfpAJYKHAsYR_w7BNbmM";
			//urlStr = "https://maps.googleapis.com/maps/api/geocode/json?&sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8")+"&key=AIzaSyDWaLZuW0wwrDdm8EFWfY2Z0UCyLvhAboM";
			URL url = new URL(urlStr);
			
			connection = (HttpURLConnection) url.openConnection();
			connection.setReadTimeout(1000);
			// read the output from the server
			
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream(),"utf-8"));
				stringBuilder = new StringBuilder();
	 
				String line = null;
				while ((line = reader.readLine()) != null)
				{
					stringBuilder.append(line + "\n");
				}
				
				Object obj = JSONValue.parse(stringBuilder.toString());
			

				if(obj == null)
				{
					return null;
				}
				JSONObject location = (JSONObject) obj;
				String status = String.valueOf(location.get("status"));
				System.out.println("status = "+status);
				JSONArray arr = (JSONArray) location.get("results");
		
				
				if(status.equalsIgnoreCase("OVER_QUERY_LIMIT"))
				{
					System.out.println("limit");
					try {
						Thread.sleep(1000);
						retryCount++;
						if(retryCount == 3) {
							if(curUrlIndex == URL_LENGTH - 1)
								return null;
							else {
								retryCount = 0;
								curUrlIndex++;
							}
						}
						return getAddressToPosition(korAddress,retryCount);
						
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
				else if(status.equalsIgnoreCase("ZERO_RESULTS"))
				{
					System.out.println("zero_results");
					position = new double[2];
					position[0] = -1;
					position[1] = -1;
					return position;
				}

				location = (JSONObject) arr.get(0);
				location = (JSONObject) location.get("geometry");
				location = (JSONObject) location.get("location");
				
				position = new double[2];
				
				position[0] = Double.parseDouble(String.valueOf(location.get("lng")));
				position[1] = Double.parseDouble(String.valueOf(location.get("lat")));
				
			} else {
				position = null;
			}
		} catch (IOException e) {
			position = null;
			e.printStackTrace();
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return position;
	}		
	
	private double [] getAddressToPositionForNaver(String korAddress) { 
		String urlStr; 
		HttpURLConnection connection = null; 
		BufferedReader reader = null; 
		StringBuilder stringBuilder; 
		double position[]; 

		try {
			//urlStr = "http://openapi.map.naver.com/api/geocode?key=675ace41cc3dd80a9b33254ecec17e98&encoding=utf-8&coord=latlng&output=json&query=" + URLEncoder.encode(korAddress, "utf-8");
			urlStr = "http://openapi.map.naver.com/api/geocode?key=aac462049f4200011230fdedcfbd6c15&encoding=utf-8&coord=latlng&output=json&query=" + URLEncoder.encode(korAddress, "utf-8");
			URL url = new URL(urlStr);
			
			connection = (HttpURLConnection) url.openConnection(); 
			connection.setReadTimeout(1000); 
			// read the output from the server 
	
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) { 
			//reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			reader = new BufferedReader(new InputStreamReader(connection.getInputStream(),"utf-8"));
			stringBuilder = new StringBuilder(); 
	
			String line = null; 
			while ((line = reader.readLine()) != null) 
			{ 
				stringBuilder.append(line + "\n"); 
			} 
			
			Object obj = JSONValue.parse(stringBuilder.toString()); 

			System.out.println("obj = "+obj); 
			JSONObject point = (JSONObject) obj;
			JSONObject error = (JSONObject) point.get("error");
			
			if(error != null) {
				System.out.println("error!!!");
				String code = (String) error.get("code");
				if(code.equals("012")) {
					System.out.println("data is not match");
					position = new double[2];
					position[0] = -1;
					position[1] = -1;
					return position;
				}
				return null;
			}
			
			point = (JSONObject)point.get("result"); 
	
			JSONArray arr = (JSONArray) point.get("items"); 
	
			point = (JSONObject) arr.get(0); 
			point = (JSONObject) point.get("point"); 
	
			position = new double[2]; 
	
			position[0] = Double.parseDouble(String.valueOf(point.get("x"))); 
			position[1] = Double.parseDouble(String.valueOf(point.get("y"))); 
			System.out.println("x = "+position[0]+" y="+position[1]); 

			} else { 
				position = null; 
			} 
		} catch (IOException e) { 
			position = null; 
			e.printStackTrace(); 
		} finally { 
			if (connection != null) { 
				connection.disconnect(); 
			} 
		} 

		return position; 
	}	
	
	public double [] getAddressToPositionForDaum(String korAddress) {
		String urlStr;
		HttpURLConnection connection = null;
		BufferedReader reader = null;
		StringBuilder stringBuilder;
		double position[];
		
		try {
			//urlStr = "https://apis.daum.net/local/geo/addr2coord?apikey=86fb7bffcd2d5168c1556dcbaf40c04f&q=" + korAddress + "&output=json";
			//urlStr = "https://apis.daum.net/local/geo/addr2coord?apikey=86fb7bffcd2d5168c1556dcbaf40c04f&q=" + URLEncoder.encode(korAddress, "utf-8") + "&output=json";
			urlStr = "https://apis.daum.net/local/geo/addr2coord?apikey=574483b67abb142c145a976ae833a965&q=" + URLEncoder.encode(korAddress, "utf-8") + "&output=json";
			URL url = new URL(urlStr);
			System.out.println("urlStr:"+urlStr);
			connection = (HttpURLConnection) url.openConnection();
			connection.setReadTimeout(1000);
			// read the output from the server
			
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream(),"utf-8"));
				stringBuilder = new StringBuilder();
	 
				String line = null;
				while ((line = reader.readLine()) != null)
				{
					stringBuilder.append(line + "\n");
				}
				Object obj = JSONValue.parse(stringBuilder.toString());
				System.out.println("obj = "+obj);
				
				if(obj == null)
				{
					return null;
				}
				
				JSONObject location = (JSONObject) obj;
				location = (JSONObject) location.get("channel");
				JSONArray arr = (JSONArray) location.get("item");
				
				if(arr.size() < 1) {
					System.out.println("data is not match");
					position = new double[2];
					position[0] = -1;
					position[1] = -1;
					return position;
				}
				
				location = (JSONObject) arr.get(0);
	
				position = new double[2];
				
				position[0] = Double.parseDouble(String.valueOf(location.get("point_x"))); 
				position[1] = Double.parseDouble(String.valueOf(location.get("point_y"))); 
				
				System.out.println("x = "+position[0]+" y="+position[1]);
				
			} else {
				position = null;
			}
		} catch (IOException e) {
			position = null;
			e.printStackTrace();
		} catch(NullPointerException npe){
			position = null;
			npe.printStackTrace();
		}catch(IndexOutOfBoundsException iobe){
			position = null;
			iobe.printStackTrace();
		}catch(Exception e){
			position = null;
			e.printStackTrace();
		}
		finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return position;
	}		
	
	private void insertExcelData(HttpServletResponse response, String filePath) throws IOException {
		System.out.println("insertExcelData");
		
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		
		ParseExcel excel = new ParseExcel();
		PrintWriter writer = response.getWriter();
		JSONObject result = new JSONObject();
		//String filepath = "D:/project/오정구(지번,투표구 정보)_DB.xlsx";
		HashSet set = excel.getExcelData(filePath);

		if(set == null) {
			result.put("status","INVALID");
			writer.println(result);
			writer.flush();
			return;
		}
		
		Iterator iter = set.iterator();
		StringBuffer queryInsert = new StringBuffer();
		StringBuffer queryUpdate = new StringBuffer();
		StringBuffer querySelect = new StringBuffer();
		
		int insertCount = 0;
		int updateCount = 0;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		System.out.println("start");
		try {
			querySelect.append("select * from DATAADDRESS where BUBJOUNGDONG = ?\n");
			querySelect.append("								and BUNJI = ?\n");
			querySelect.append("								and (GUNMUL = ? OR ? IS NULL) \n");
			
			//ps1 = conn.prepareStatement(querySelect.toString());
			
			queryInsert.append(" INSERT INTO DATAADDRESS ( BUBJOUNGDONG \n");
			queryInsert.append(" 						  ,BUNJI \n");
			queryInsert.append(" 						  ,GUNMUL \n");
			queryInsert.append(" 						  ,TONG \n");
			queryInsert.append(" 						  ,HAENGJOUNGDONG \n");
			queryInsert.append(" 						  ,TUPYOGU \n");
			queryInsert.append(" 						  ,SIGUNGU \n");
			//queryInsert.append(" 						  ,GOOGLEX \n");
			queryInsert.append(" 						   ) \n");
			queryInsert.append("				   VALUES     ( ? \n");
			queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ,? \n");
			//queryInsert.append(" 						   ,? \n");
			queryInsert.append(" 						   ) \n");
						
			ps2 = conn.prepareStatement(queryInsert.toString());
			
			while(iter.hasNext()) {
				HashMap<String,String> map = (HashMap) iter.next();
				
				if(map.size() < 1) {
					continue;
				}
				
				String bubjoungdong = map.get("BUBJOUNGDONG");
				String bunji = map.get("BUNJI");
				String gunmul = map.get("GUNMUL");
				String tong = map.get("TONG");
				String haengjoungdong = map.get("HAENGJOUNGDONG");
				String tupyogu = map.get("TUPOGU");
				String sigungu = map.get("SIGUNGU");
				StringBuffer addressBuf = new StringBuffer();
				
				addressBuf.append(bubjoungdong);
				addressBuf.append(" ");
				addressBuf.append(bunji);
				if(gunmul != null && gunmul.length() > 0) {
					addressBuf.append(" ");
					addressBuf.append(gunmul);
				}
				
				conn.setAutoCommit(false);
				
				/*ps1.setString(1, bubjoungdong);
				ps1.setString(2, bunji);
				ps1.setString(3, gunmul);
				//ps1.setNull(4, Types.NULL);
				ps1.setString(4, gunmul);
									
				ResultSet rs = ps1.executeQuery();
				ps1.clearParameters();
				
				if(!rs.next())*/ {
					/*System.out.println("insert");
					System.out.println("bubjoungdong = "+bubjoungdong);
					System.out.println("bunji = "+bunji);
					System.out.println("gunmul = "+gunmul);*/
					
					ps2.setString(1, bubjoungdong);
					ps2.setString(2, bunji);
					ps2.setString(3, gunmul);
					ps2.setString(4, tong);
					ps2.setString(5, haengjoungdong);
					ps2.setString(6, tupyogu);
					ps2.setString(7, sigungu);
					//ps2.setString(7, "TEST");
					
					//ps2.executeUpdate();
					ps2.addBatch();
					// 파라미터 Clear
					ps2.clearParameters();
					insertCount++;
					if(insertCount % 1000 == 0) {
						insertCount = 0;
						ps2.executeBatch();
	                    ps2.clearBatch();
	                     
	                    // 커밋
	                    conn.commit() ;
					}
				}
				
				//if(rs != null) rs.close();
			}
			ps2.executeBatch();
			conn.commit();
			
			result.put("status","OK");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			// TODO Auto-generated catch block
			result.put("status","ERROR");
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
		} finally {
			try {
				//ps1.close();
				ps2.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		writer.println(result);
		writer.flush();
		System.out.println("end");
	}
	
	
	
	public void getAddressInfo(HttpServletRequest request, HttpServletResponse response,String mode) throws ServletException, IOException
	{
		System.out.println("getAddressInfo");
		
		PrintWriter writer = response.getWriter();
		
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		
		if(mode.equals("haengjoungdong"))
		{
			String sql = "select DISTINCT haengjoungdong from DATAADDRESS";
			JSONArray jArray = new JSONArray();
			
			try {
				conn.setAutoCommit(false);
				
				PreparedStatement pstmt = conn.prepareStatement(sql);

				ResultSet rs = pstmt.executeQuery();
				
				while(rs.next())
				{
					String haengjoungdong = rs.getString("haengjoungdong");
					
					JSONObject jValue = new JSONObject();
					System.out.println("haengjoungdong = "+haengjoungdong);
					jValue.put("haengjoungdong", haengjoungdong);					
					jArray.add(jValue);
				}				
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			writer.println(jArray);
			writer.flush();
		}
		else if(mode.equals("tupyogu") || mode.equals("tong"))
		{
			String haengjoungdong = request.getParameter("haengjoungdong");
			String sql = "";
			
			/* Oracle
			if(mode.equals("tupyogu"))
			{
				sql = "SELECT DISTINCT '제' || TO_NUMBER(REPLACE(REPLACE(tupogu, '제', ''),'투표구', '')) || '투표구' AS tupogu FROM DATAADDRESS	where haengjoungdong =?"
						+ "ORDER BY TO_NUMBER(REPLACE(REPLACE(tupogu, '제', ''),'투표구', '')) asc";
			}
			else
			{
				sql = "select DISTINCT "+mode+" from DATAADDRESS"+" where haengjoungdong =? order by TO_NUMBER(tong)";
			}
			*/
			
			// Mysql
			if(mode.equals("tupyogu")) {
				sql = "SELECT DISTINCT CONCAT(CONCAT('제',REPLACE(REPLACE(TUPYOGU, '제', ''),'투표구', '')),'투표구') AS TUPYOGU from DATAADDRESS where HAENGJOUNGDONG = ?"
						+ "ORDER BY CAST(REPLACE(REPLACE(TUPYOGU, '제', ''),'투표구', '') AS UNSIGNED) asc";
			}
			else {
				sql = "SELECT DISTINCT "+mode+" from DATAADDRESS"+" where HAENGJOUNGDONG =? order by CAST(TONG AS UNSIGNED)";
			}
	
			JSONArray jArray = new JSONArray();
			
			try {
				conn.setAutoCommit(false);
				
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, haengjoungdong);

				ResultSet rs = pstmt.executeQuery();
				
				while(rs.next())
				{
					String result = rs.getString(mode);
					
					JSONObject jValue = new JSONObject();
					
					jValue.put(mode, result);					
					jArray.add(jValue);
				}				
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			writer.println(jArray);
			writer.flush();			
			
		}
	}
	
	
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");		
		response.setContentType("text/html;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		System.out.println("doPost");
		String mode = request.getParameter("mode");		
				
		if(mode != null && !mode.equals("search"))
		{
			if(mode.equals("convert")) {
				String target = request.getParameter("target");
				
				if(target.equals("google")) {
					updateGoogleLocationInfo(response);
				} else if(target.equals("naver")) {
					updateNaverLocationInfo(response);
				} else if(target.equals("daum")) {
					updateDaumLocationInfo(response);
				}
				
			} else if(mode.equals("insertExcel")) {
			    //String savePath = "/Users/juhyukkim/Downloads/upload/";
				// 500Mbyte
			    int maxSize  = 1024*1024*500; 
			    String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/excel_upload/";
			    MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
			    
				String filePath = multi.getFilesystemName("attachFile");//request.getParameter("filePath");
				filePath = savePath + filePath;
				
				System.out.println("filepath = "+filePath);
				
				insertExcelData(response,filePath);
			} else {
				getAddressInfo(request,response,mode);
			}
			return;
		}
		
		PrintWriter writer = response.getWriter();
		String haengjoungdong = request.getParameter("haengjoungdong");
		String param =  request.getParameter("param");
		String value= request.getParameter("value");
		String mapKindStr = request.getParameter("mapKind");
		int mapKind = Integer.parseInt(mapKindStr);
		
		JSONArray jArray = new JSONArray();
		JSONObject center = new JSONObject();
		JSONObject result = new JSONObject();
		double minX = 500,minY = 500,maxX = 0,maxY = 0;
		double locationxD = 0,locationyD = 0;
		String[] loc_array = array[mapKind];
		
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		//String sql = "select DISTINCT googlex,googley from dataaddress where haengjoungdong =? and "+param+" = ? and googlex is not null";
		String sql = "select DISTINCT "+loc_array[0]+","+loc_array[1]+" from DATAADDRESS where haengjoungdong =? and "+param+" = ? and "+loc_array[0]+" is not null and "+loc_array[0]+ " > 0";
		try {
			conn.setAutoCommit(false);
			
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, haengjoungdong);
			pstmt.setString(2, value);
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				String locationx = rs.getString(1);
				String locationy = rs.getString(2);
				
				if(locationx == null || locationy.length() < 1)
					continue;
				
				locationxD = Double.parseDouble(locationx);
				locationyD = Double.parseDouble(locationy);
				
				JSONObject jValue = new JSONObject(); 
				JSONObject location = new JSONObject();
				
				if(minX > locationxD)
					minX = locationxD;
				
				if(maxX < locationxD)
					maxX = locationxD;

				if(minY > locationyD)
					minY = locationyD;
				
				if(maxY < locationyD)
					maxY = locationyD;
				
				
				jValue.put("x", locationx);
				jValue.put("y", locationy);
				location.put("location", jValue);
				
				jArray.add(location);
			}
			System.out.println("minx="+minX+", maxX="+maxX);
			System.out.println("miny="+minY+", maxY="+maxY);
			result.put("array", jArray);
			center.put("x", (minX+maxX)/2);
			center.put("y", (minY+maxY)/2);
			result.put("center", center);
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		writer.println(result);
		writer.flush();
	}

}
