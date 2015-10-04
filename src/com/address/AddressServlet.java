package com.address;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class AddressServlet
 */
public class AddressServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final String[][] array = {{"googlex","googley"},{"naverx","navery"},{"daumx","daumy"}};   
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	
	public void getAddressInfo(HttpServletRequest request, HttpServletResponse response,String mode) throws ServletException, IOException
	{
		System.out.println("getAddressInfo");
		
		PrintWriter writer = response.getWriter();
		
		DBBean dbbean = new DBBean();
		Connection conn = dbbean.getConnection();
		
		if(mode.equals("haengjoungdong"))
		{
			String sql = "select DISTINCT haengjoungdong from dataaddress";
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
		else if(mode.equals("tupogu") || mode.equals("tong"))
		{
			String haengjoungdong = request.getParameter("haengjoungdong");
			String sql = "";
			
			if(mode.equals("tupogu"))
			{
				sql = "SELECT DISTINCT '力' || TO_NUMBER(REPLACE(REPLACE(tupogu, '力', ''),'捧钎备', '')) || '捧钎备' AS tupogu FROM DATAADDRESS	where haengjoungdong =?"
						+ "ORDER BY TO_NUMBER(REPLACE(REPLACE(tupogu, '力', ''),'捧钎备', '')) asc";
			}
			else
			{
				sql = "select DISTINCT "+mode+" from dataaddress"+" where haengjoungdong =? order by TO_NUMBER(tong)";
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
			getAddressInfo(request,response,mode);
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
		String sql = "select DISTINCT "+loc_array[0]+","+loc_array[1]+" from dataaddress where haengjoungdong =? and "+param+" = ? and "+loc_array[0]+" is not null";
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
