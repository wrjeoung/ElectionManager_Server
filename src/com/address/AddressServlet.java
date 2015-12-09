package com.address;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import java.security.*;
import java.security.cert.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.net.ssl.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
				sql = "SELECT DISTINCT '제' || TO_NUMBER(REPLACE(REPLACE(tupogu, '제', ''),'투표구', '')) || '투표구' AS tupogu FROM DATAADDRESS	where haengjoungdong =?"
						+ "ORDER BY TO_NUMBER(REPLACE(REPLACE(tupogu, '제', ''),'투표구', '')) asc";
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
		System.out.println("mode:"+mode);
		
		
		if(mode.equals("Login")){
			
			String loginid = request.getParameter("loginid");
			String passwd = request.getParameter("passwd");
			
			System.out.println("loginid:"+loginid);
			System.out.println("passwd:"+passwd);
			
			UserDAO udo = new UserDAO();
			DBProc dp = new DBProc();
			
			udo.setUserid(loginid);
			udo.setPwd(passwd);
			
			UserDAO re_udo = new UserDAO();
			
			re_udo = dp.LoginCheck(udo);
			
			String result = re_udo.getResult();
			
			System.out.println("result:"+result);
			
	        if(result.equals("SUCCESS")){
	        	
	        	HttpSession session = request.getSession();
	        	
	        	session.setAttribute("userid", re_udo.getUserid());
	        	session.setAttribute("groupcd", re_udo.getGroupcd());
	        	session.setAttribute("groupname", re_udo.getGroupname());
	        	session.setAttribute("classcd", re_udo.getClasscd());
	        	session.setAttribute("result", re_udo.getResult());
	        	
	        	response.sendRedirect("/ElectionManager_server/OrganList.jsp");
	        	//response.sendRedirect("/Woori/OrganList.jsp");
	        	

	        }else{
		        response.sendRedirect("/ElectionManager_server/Login.jsp");
		        //response.sendRedirect("/Woori/Login.jsp");
	        }
		}
		else if(mode.equals("business_reg")){
			System.out.println("business_reg....");
			
			request.setCharacterEncoding("UTF-8");
			 
		    // 10Mbyte 제한
		    int maxSize  = 1024*1024*50;        
		 
		    // 웹서버 컨테이너 경로
		    String root = request.getSession().getServletContext().getRealPath("/");
		 
		    // 파일 저장 경로(ex : /home/tour/web/ROOT/upload)
		    //String savePath = root + "upload";
		    //String savePath = "D:\\Upload\\";
		    String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/business_upload/";
		    int arrSize = 3;
		    // 업로드 파일명
		    String uploadFile[] = new String[arrSize];
		 
		    // 실제 저장할 파일명
		    String newFileName[] = new String[arrSize];
		    
		    String result = "FAIL";

		    int read = 0;
		    byte[] buf = new byte[1024];
		    FileInputStream fin = null;
		    FileOutputStream fout = null;
		    long currentTime = System.currentTimeMillis();  
		    SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMddHHmmss"); 
		    
		    try{
		    	
		    	//business_reg	title	kind	ct_area_in	summary	content	progress_process	result	regGb	uploadFile1	uploadFile2	uploadFile3
		    	MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

		    	String regGb = multi.getParameter("regGb");
		    	String title = multi.getParameter("title");
		    	String kind = multi.getParameter("kind");
		    	String ct_area_in = multi.getParameter("ct_area_in");
		    	String summary = multi.getParameter("summary");
		    	String content = multi.getParameter("content");
		    	String progress_process = multi.getParameter("progress_process");
		    	String results = multi.getParameter("result");
		    	String groupcd = multi.getParameter("groupcd");
		    	String etc = multi.getParameter("etc");
		    	String img_url = "";
		    	
		        //전송받은 parameter의 한글깨짐 방지
		        //String title = multi.getParameter("title");
		        //title = new String(title.getBytes("8859_1"), "UTF-8");
				
		        System.out.println("regGb:" + regGb);
		        System.out.println("title:" + title);
		        System.out.println("kind:" + kind);
		        System.out.println("ct_area_in:" + ct_area_in);
		        System.out.println("summary:" + summary);
		        System.out.println("content:" + content);
		        System.out.println("progress_process:" + progress_process);
		        System.out.println("results:" + results);
		        System.out.println("groupcd:" + groupcd);
		        System.out.println("etc:" + etc);
		        
		        // 파일업로드
		    	for(int i = 0; i < uploadFile.length; i++){
		    		uploadFile[i] = multi.getFilesystemName("uploadFile"+i+"");
		    		System.out.println("uploadFile["+i+"]:"+uploadFile[i]);
		    		if(uploadFile[i]!=null){
		    			
		    			if(i==0){
		    				img_url = img_url + uploadFile[i];
		    			}else{
		    				img_url = img_url + ";" +uploadFile[i];
		    			}
		    		}
		    	}
		    	
		    	System.out.println("img_url:" + img_url);
		    			        
		        
		        if(regGb.equals("N")){
		        	
		        	System.out.println("주요사업 신규등록");
					
					// 실제 저장할 파일명(ex : 20140819151221.zip)
		        	for(int i=0; i < newFileName.length; i++){
		        		if(uploadFile[i]!=null){
		        			newFileName[i] = simDf.format(new Date(currentTime)) +"."+ uploadFile[i].substring(uploadFile[i].lastIndexOf(".")+1);
		        		}
		        	}
		        	
		        	File oldFile[] = new File[arrSize];
		        	File newFile[] = new File[arrSize];
		        	
		        	for(int i=0; i < oldFile.length; i++){
		        		oldFile[i] = new File(savePath + uploadFile[i]);
		        		newFile[i] = new File(savePath + newFileName[i]);
		        	}
		        	
		        	for(int i =0; i < oldFile.length; i++ ){
		        		
		        		if(!oldFile[i].renameTo(newFile[i])){
		        			buf = new byte[1024];
				            fin = new FileInputStream(oldFile[i]);
				            fout = new FileOutputStream(newFile[i]);
				            read = 0;
				            while((read=fin.read(buf,0,buf.length))!=-1){
				                fout.write(buf, 0, read);
				            }
				            fin.close();
				            fout.close();
				            oldFile[i].delete();
		        		}		
		        	}
		        	
		        	BusinessDTO bd = new BusinessDTO();
		        	
		    		bd.setTitle(title);
		    		bd.setKind(kind);
		    		bd.setGroupcd(groupcd);
		    		bd.setCt_area(ct_area_in);
		    		bd.setProgress_process(progress_process);
		    		bd.setResult(results);
		    		bd.setEtc(etc);
		    		bd.setImg_yn("Y");
		    		bd.setContent(content);
		    		bd.setImg_url(img_url);
		    		bd.setSummary(summary);
		        	
		        	DBProc db = new DBProc();
		    
		        	result = db.Inbusiness(bd);
		        	System.out.println("result:"+result);
			        System.out.println("-----");
			        
		        }else{
		        	System.out.println("주요사업 정보 수정");
		        	
		            String uploadFile_Mf[] = new String[arrSize];
		            
		            for(int i=0; i < arrSize; i++){
		            	
		            	
		            }
		        			
		        	// 실제 저장할 파일명(ex : 20140819151221.zip)
		        	for(int i=0; i < newFileName.length; i++){
		        		if(uploadFile[i]!=null){
		        			newFileName[i] = simDf.format(new Date(currentTime)) +"."+ uploadFile[i].substring(uploadFile[i].lastIndexOf(".")+1);
		        		}
		        	}
		        	
		        	File oldFile[] = new File[arrSize];
		        	File newFile[] = new File[arrSize];
		        	
		        	for(int i=0; i < oldFile.length; i++){
		        		oldFile[i] = new File(savePath + uploadFile[i]);
		        		newFile[i] = new File(savePath + newFileName[i]);
		        	}
		        	
		        	for(int i =0; i < oldFile.length; i++ ){
		        		
		        		if(!oldFile[i].renameTo(newFile[i])){
		        			buf = new byte[1024];
				            fin = new FileInputStream(oldFile[i]);
				            fout = new FileOutputStream(newFile[i]);
				            read = 0;
				            while((read=fin.read(buf,0,buf.length))!=-1){
				                fout.write(buf, 0, read);
				            }
				            fin.close();
				            fout.close();
				            oldFile[i].delete();
		        		}		
		        	}
		        	
		        	BusinessDTO bd = new BusinessDTO();
		        	
		    		bd.setTitle(title);
		    		bd.setKind(kind);
		    		bd.setGroupcd(groupcd);
		    		bd.setCt_area(ct_area_in);
		    		bd.setProgress_process(progress_process);
		    		bd.setResult(results);
		    		bd.setEtc(etc);
		    		bd.setImg_yn("Y");
		    		bd.setContent(content);
		    		bd.setImg_url(img_url);
		    		bd.setSummary(summary);
		        	
		        	DBProc db = new DBProc();
		    
		        	result = db.Inbusiness(bd);
		        	System.out.println("result:"+result);
			        System.out.println("-----");
		        	
		        }
		        
		        /**
		        System.out.println("uploadFile_Mf:" + uploadFile_Mf);
		        
				if((uploadFile1!=null || uploadFile2!=null || uploadFile3!=null )&& business_img1.equals("")){
					System.out.println("신규등록");
					
					 // 실제 저장할 파일명(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // 업로드된 파일 객체 생성
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // 실제 저장될 파일 객체 생성
			        File newFile = new File(savePath + newFileName);
			        
			        // 파일명 rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename이 되지 않을경우 강제로 파일을 복사하고 기존파일은 삭제
			 
			            buf = new byte[1024];
			            fin = new FileInputStream(oldFile);
			            fout = new FileOutputStream(newFile);
			            read = 0;
			            while((read=fin.read(buf,0,buf.length))!=-1){
			                fout.write(buf, 0, read);
			            }
			             
			            fin.close();
			            fout.close();
			            oldFile.delete();
			        }
			        
			        Organ_Img = "D:\\upload\\"+newFileName;
			        //Organ_Img = "/usr/local/server/tomcat/webapps/ElectionManager_server/organ_upload/"+newFileName;
					
				}else if(uploadFile==null && Organ_Img != null ){
					System.out.println("기존");
					
				}else if(uploadFile!=null && Organ_Img != null){
					System.out.println("변경");
					 // 실제 저장할 파일명(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // 업로드된 파일 객체 생성
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // 실제 저장될 파일 객체 생성
			        File newFile = new File(savePath + newFileName);
			        
			        // 파일명 rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename이 되지 않을경우 강제로 파일을 복사하고 기존파일은 삭제
			 
			            buf = new byte[1024];
			            fin = new FileInputStream(oldFile);
			            fout = new FileOutputStream(newFile);
			            read = 0;
			            while((read=fin.read(buf,0,buf.length))!=-1){
			                fout.write(buf, 0, read);
			            }
			             
			            fin.close();
			            fout.close();
			            oldFile.delete();
			        }
			        
			        //Organ_Img = "/usr/local/server/tomcat/webapps/ElectionManager_server/organ_upload/"+newFileName;
			        Organ_Img = "D:\\upload\\"+newFileName;
				}
		 
		        WOrganDAO od = new WOrganDAO();
				od.setOrgan_Gb(Organ_Gb);
				od.setGroup_Cd(Group_Cd);
				od.setGroup_Name(Group_Name);
				od.setOrgan_Name(Organ_Name);
				od.setOrgan_Add(Organ_Add);
				od.setOrgan_Img(Organ_Img);
				od.setOrgan_Date(Organ_Date);
				od.setOrgan_Mem_Cman(Organ_Mem_Cman);
				od.setOrgan_Mem_Board(iOrgan_Mem_Board);
				od.setOrgan_Mem_Cnt(iOrgan_Mem_Cnt);
				od.setOrgan_Con_Num(Organ_Con_Num);
				od.setAddr_cox(addr_cox);
				od.setAddr_coy(addr_coy);
				od.setSidocode(sidocode);
				od.setSigungucode(sigungucode);
				od.setHaengcode(haengcode);
				od.setAddr_auth(addr_auth);
		        od.setOrgan_Seq(iOrgan_Seq);
				
				DBProc dp = new DBProc();
				
				String result = "FAIL";
				
				if(regGb.equals("N")){
					result = dp.InOrgan(od);
				}else{
					result = dp.UpOrgan(od);
				}
				System.out.println("result:"+result);
		        
				request.setAttribute("result", result);
		        ServletContext sc = getServletContext();
	        	RequestDispatcher rd = sc.getRequestDispatcher("/OrganList.jsp");
		        rd.forward(request, response);
		        
		 	**/
		        
				request.setAttribute("result", result);
		        ServletContext sc = getServletContext();
	        	RequestDispatcher rd = sc.getRequestDispatcher("/BusinessList.jsp");
		        rd.forward(request, response);
		        
		    }catch(Exception e){
		        e.printStackTrace();
		    }
			
		}
		
		else if(mode.equals("organ_reg")){
			
			System.out.println("organ_reg....");
			
			request.setCharacterEncoding("UTF-8");
			 
		    // 10Mbyte 제한
		    int maxSize  = 1024*1024*10;        
		 
		    // 웹서버 컨테이너 경로
		    String root = request.getSession().getServletContext().getRealPath("/");
		 
		    // 파일 저장 경로(ex : /home/tour/web/ROOT/upload)
		    //String savePath = root + "upload";
		    //String savePath = "D:\\Upload\\";
		    String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/organ_upload/";
		    
		    // 업로드 파일명
		    String uploadFile = "";
		    String uploadFile_Mf = "";
		 
		    // 실제 저장할 파일명
		    String newFileName = "";
		 
		    int read = 0;
		    byte[] buf = new byte[1024];
		    FileInputStream fin = null;
		    FileOutputStream fout = null;
		    long currentTime = System.currentTimeMillis();  
		    SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMddHHmmss"); 
		    
		    try{
		    	
		    	MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
		    	
		    	String Organ_Seq = multi.getParameter("organ_seq");
		    	int iOrgan_Seq = 0;
		    	
				if(Organ_Seq!=null){
					iOrgan_Seq = Integer.parseInt(Organ_Seq);
				}
		    	
		    	String regGb = multi.getParameter("regGb");
				String Organ_Name = multi.getParameter("organ_name");
				String Organ_Add = multi.getParameter("organ_addr");
				String Organ_Img = multi.getParameter("organ_imgss");
				String Organ_Date = multi.getParameter("organ_date");
				String Organ_Mem_Cman = multi.getParameter("organ_mem_cman");
				String Organ_Gb = multi.getParameter("organ_gb");
				String Group_Cd =  multi.getParameter("group_name");
				String Organ_Mem_Board = multi.getParameter("organ_mem_board");
				System.out.println("Organ_Mem_Board:"+Organ_Mem_Board);
				
				int iOrgan_Mem_Board = 0;
				
				if(Organ_Mem_Board!=null){
					iOrgan_Mem_Board = Integer.parseInt(Organ_Mem_Board);
				}
				
				String Organ_Mem_Cnt = multi.getParameter("organ_mem_cnt");
				
				int iOrgan_Mem_Cnt = 0;
				
				if(Organ_Mem_Cnt!=null){
					iOrgan_Mem_Cnt = Integer.parseInt(Organ_Mem_Cnt);
				}
				
				String Organ_Con_Num = multi.getParameter("organ_con_num");
				String Group_Name = multi.getParameter("group_name");
				
				System.out.println("String addr_cox:"+multi.getParameter("addr_cox"));
				System.out.println("String addr_coy:"+multi.getParameter("addr_coy"));
				
				Double addr_cox = Double.parseDouble(multi.getParameter("addr_cox"));
				Double addr_coy =  Double.parseDouble(multi.getParameter("addr_coy"));

				String sidocode = multi.getParameter("addr_sidocode");
				String sigungucode = multi.getParameter("addr_sigungucode");
				String haengcode = multi.getParameter("addr_haengcode");
				String addr_auth = multi.getParameter("addr_auth"); 

				System.out.println("iOrgan_Seq:"+iOrgan_Seq);
				System.out.println("regGb:"+regGb);
				System.out.println("Organ_Gb:"+Organ_Gb);
				System.out.println("Group_Name:"+Group_Name);
				System.out.println("Organ_Name:"+Organ_Name);
				System.out.println("Organ_Add:"+Organ_Add);
				System.out.println("Organ_Img:"+Organ_Img);
				System.out.println("Organ_Date:"+Organ_Date);
				System.out.println("Organ_Mem_Cman:"+Organ_Mem_Cman);
				System.out.println("iOrgan_Mem_Board:"+iOrgan_Mem_Board);
				System.out.println("iOrgan_Mem_Cnt:"+iOrgan_Mem_Cnt);
				System.out.println("Organ_Con_Num:"+Organ_Con_Num);
				System.out.println("addr_cox:"+addr_cox);
				System.out.println("addr_coy:"+addr_coy);
				System.out.println("sidocode:"+sidocode);
				System.out.println("sigungucode:"+sigungucode);
				System.out.println("haengcode:"+haengcode);
				System.out.println("addr_auth:"+addr_auth);
				System.out.println("Group_Cd:"+Group_Cd);
				
		        // 전송받은 parameter의 한글깨짐 방지
		        //String title = multi.getParameter("title");
		        //title = new String(title.getBytes("8859_1"), "UTF-8");
				
		        // 파일업로드
		        uploadFile = multi.getFilesystemName("uploadFile");
		        uploadFile_Mf = multi.getFilesystemName("uploadFile_Mf");
		        System.out.println("uploadFile:" + uploadFile);
		        System.out.println("uploadFile_Mf:" + uploadFile_Mf);
		        
				if(uploadFile!=null && Organ_Img.equals("")){
					System.out.println("신규등록");
					
					 // 실제 저장할 파일명(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // 업로드된 파일 객체 생성
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // 실제 저장될 파일 객체 생성
			        File newFile = new File(savePath + newFileName);
			        
			        // 파일명 rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename이 되지 않을경우 강제로 파일을 복사하고 기존파일은 삭제
			 
			            buf = new byte[1024];
			            fin = new FileInputStream(oldFile);
			            fout = new FileOutputStream(newFile);
			            read = 0;
			            while((read=fin.read(buf,0,buf.length))!=-1){
			                fout.write(buf, 0, read);
			            }
			             
			            fin.close();
			            fout.close();
			            oldFile.delete();
			        }
			        
			        //Organ_Img = "D:\\upload\\"+newFileName;
			        Organ_Img = "/usr/local/server/tomcat/webapps/ElectionManager_server/organ_upload/"+newFileName;
					
				}else if(uploadFile==null && Organ_Img != null ){
					System.out.println("기존");
					
				}else if(uploadFile!=null && Organ_Img != null){
					System.out.println("변경");
					 // 실제 저장할 파일명(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // 업로드된 파일 객체 생성
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // 실제 저장될 파일 객체 생성
			        File newFile = new File(savePath + newFileName);
			        
			        // 파일명 rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename이 되지 않을경우 강제로 파일을 복사하고 기존파일은 삭제
			 
			            buf = new byte[1024];
			            fin = new FileInputStream(oldFile);
			            fout = new FileOutputStream(newFile);
			            read = 0;
			            while((read=fin.read(buf,0,buf.length))!=-1){
			                fout.write(buf, 0, read);
			            }
			             
			            fin.close();
			            fout.close();
			            oldFile.delete();
			        }
			        
			        Organ_Img = "/usr/local/server/tomcat/webapps/ElectionManager_server/organ_upload/"+newFileName;
			        //Organ_Img = "D:\\upload\\"+newFileName;
				}
		 
		        WOrganDAO od = new WOrganDAO();
				od.setOrgan_Gb(Organ_Gb);
				od.setGroup_Cd(Group_Cd);
				od.setGroup_Name(Group_Name);
				od.setOrgan_Name(Organ_Name);
				od.setOrgan_Add(Organ_Add);
				od.setOrgan_Img(Organ_Img);
				od.setOrgan_Date(Organ_Date);
				od.setOrgan_Mem_Cman(Organ_Mem_Cman);
				od.setOrgan_Mem_Board(iOrgan_Mem_Board);
				od.setOrgan_Mem_Cnt(iOrgan_Mem_Cnt);
				od.setOrgan_Con_Num(Organ_Con_Num);
				od.setAddr_cox(addr_cox);
				od.setAddr_coy(addr_coy);
				od.setSidocode(sidocode);
				od.setSigungucode(sigungucode);
				od.setHaengcode(haengcode);
				od.setAddr_auth(addr_auth);
		        od.setOrgan_Seq(iOrgan_Seq);
				
				DBProc dp = new DBProc();
				
				String result = "FAIL";
				
				if(regGb.equals("N")){
					result = dp.InOrgan(od);
				}else{
					result = dp.UpOrgan(od);
				}
				System.out.println("result:"+result);
		        
				request.setAttribute("result", result);
		        ServletContext sc = getServletContext();
	        	RequestDispatcher rd = sc.getRequestDispatcher("/OrganList.jsp");
		        rd.forward(request, response);
		        
		 
		    }catch(Exception e){
		        e.printStackTrace();
		    }
			
		}else if(mode.equals("addrseach")){
			
			System.out.println("addrseach");
			String data = request.getParameter("data");
			System.out.println("data:"+data);
			
			PrintWriter writer = response.getWriter();

			String sData[] = data.split(";");
			String consumer_key = sData[0];
			String consumer_secret = sData[1];
			String address = sData[2];
			//String resultData = HttpConnection.PostData("https://sgisapi.kostat.go.kr/OpenAPI3/addr/geocode.json", sUrl);
			
			String urlStr1 = "consumer_key="+consumer_key+"&consumer_secret="+consumer_secret;
			String urlStr2;
			System.out.println("urlStr1:"+urlStr1);
			String resultData = HttpConnection.GetData("https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?"+ urlStr1);
			System.out.println("resultData1:"+resultData.toString());
			
	        JSONObject jre=null;
	        JSONObject re_jre=new JSONObject();
	        JSONParser par = new JSONParser();
	        String accessToken = "";
	        
	        try {
				jre = (JSONObject) par.parse(resultData.toString());
				System.out.println("jre:"+jre);
				jre = (JSONObject) jre.get("result");
				accessToken = (String) jre.get("accessToken");
				System.out.println("accessToken:"+accessToken);
				
			} catch (ParseException e) {
				re_jre.put("RESULT", "FAIL");
				writer.println(re_jre);
				writer.flush();
				e.printStackTrace();
			}	
			
			jre = null;
			resultData = null;
			JSONArray jarr = null;
			String coy;
			String cox;
			Double dcox = null;
			Double dcoy = null;
			String sido_cd;
			String sgg_cd;
			String adm_cd;
			int tCnt = 0;
			urlStr2 = "accessToken="+accessToken+"&address="+URLEncoder.encode(address, "utf-8"); 
			System.out.println("urlStr2:"+urlStr2);
			resultData = HttpConnection.GetData("https://sgisapi.kostat.go.kr/OpenAPI3/addr/geocode.json?"+ urlStr2);
			System.out.println("resultData2:"+resultData.toString());
			
			try{
				jre = (JSONObject) par.parse(resultData.toString());
				
				System.out.println("jre1:"+jre);
				jre = (JSONObject) jre.get("result");
				System.out.println("jre2:"+jre);
				
				String sCnt = "";
				
				try{
					sCnt = (String) jre.get("totalcount");
				}catch(NullPointerException ne){
					System.out.println("NullPointerException...");
				}
				
				System.out.println("totalcount:"+sCnt);
				
				if(sCnt!=null && (!sCnt.equals(""))){
					tCnt = Integer.parseInt(sCnt);
				}
				
				if(tCnt > 0){
					jarr = (JSONArray) jre.get("resultdata");
					System.out.println("jre3:"+jarr);
					jre = (JSONObject) jarr.get(0);
					
					coy = (String) jre.get("y");
					
					if(coy!=null){
						dcoy = Double.parseDouble(coy);
					}
					
					cox = (String) jre.get("x");
					
					if(cox!=null){
						dcox = Double.parseDouble(cox);
					}
					
					sido_cd = (String) jre.get("sido_cd");
					sgg_cd = (String) jre.get("sgg_cd");
					
					System.out.println("sido_cd:"+sido_cd);
					System.out.println("sgg_cd:"+sgg_cd);

					if(sgg_cd.equals("null")){
						System.out.println("111111111");
						sgg_cd = "";
					}
					
					adm_cd = (String) jre.get("adm_cd");		
					
					if(adm_cd.equals("null")){
						System.out.println("222222222222");
						adm_cd = "";
					}
					
					System.out.println("adm_cd:"+adm_cd);
					
					System.out.println("coy:"+coy + ",cox:"+cox);
					re_jre.put("RESULT", "SUCCESS");
					re_jre.put("COX", dcox);
					re_jre.put("COY", dcoy);
					re_jre.put("SIDOCODE", sido_cd);
					re_jre.put("SIGUNGUCODE", sido_cd+sgg_cd);
					re_jre.put("HAENGCODE", adm_cd);
					
				}else{
					re_jre.put("RESULT", "FAIL");
				}
				
				System.out.println("tCnd:"+tCnt);
						
			}catch(ParseException e){
				e.printStackTrace();
				re_jre.put("RESULT", "FAIL");
			}finally{
				writer.println(re_jre);
				writer.flush();
			}

		}else if(mode.equals("detailList")){
			
			System.out.println("detailList");
			String data = request.getParameter("data");
			System.out.println("data:"+data);
			
			PrintWriter writer = response.getWriter();
			
			if(data.equals(null)||data.equals("")){
				
			}else{
				
				WOrganDAO od = new WOrganDAO();
				int idata = Integer.parseInt(data);
				od.setOrgan_Seq(idata);
				
				DBProc dp = new DBProc();
				od = dp.detailList(od);
				
				GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
				
				JSONObject jo = new JSONObject();
				//jo.put("RESULT", "SUCCESS");
				jo.put("OrganDetail", gson.toJson(od));
				writer.println(jo);
				writer.flush();
				
				//request.setAttribute("OrganDetail", od);
		        //ServletContext sc = getServletContext();
		        //RequestDispatcher rd = sc.getRequestDispatcher("/OrganInfo.jsp");
		        //rd.forward(request, response);
		        //response.sendRedirect("/Woori/OrganDetail.jsp");

			}
		}else if(mode.equals("userList")){
			
			
			System.out.println("userList");
			String data = request.getParameter("data");
			System.out.println("data:"+data);
			
			PrintWriter writer = response.getWriter();
			
			if(data.equals(null)||data.equals("")){
				
			}else{
				
				UserDAO ud = new UserDAO();
				ud.setUserid(data);
				
				DBProc dp = new DBProc();
				ud = dp.userList(ud);
				
				GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
				
				JSONObject jo = new JSONObject();
				//jo.put("RESULT", "SUCCESS");
				jo.put("userDetail", gson.toJson(ud));
				writer.println(jo);
				writer.flush();
				
			}
	
		}
		else if(mode.equals("businessList")){
			System.out.println("businessList");
			String data = request.getParameter("data");
			System.out.println("data:"+data);
			
			PrintWriter writer = response.getWriter();
			
			if(data.equals(null)||data.equals("")){
				
			}else{
				
				int idata = Integer.parseInt(data);
				
				BusinessDTO bd = new BusinessDTO();
				bd.setBn_seq(idata);
				
				DBProc dp = new DBProc();
				bd = dp.businessList(bd);
				
				GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
				
				JSONObject jo = new JSONObject();
				//jo.put("RESULT", "SUCCESS");
				jo.put("businessDetail", gson.toJson(bd));
				writer.println(jo);
				writer.flush();
				
			}
			
		}
		else if(mode.equals("groupList")){
			
			
			System.out.println("groupList");
			String data = request.getParameter("data");
			System.out.println("data:"+data);
			
			PrintWriter writer = response.getWriter();
			
			if(data.equals(null)||data.equals("")){
				
			}else{
				
				GroupDAO gd = new GroupDAO();
				gd.setGroupcd(data);
				
				DBProc dp = new DBProc();
				gd = dp.groupList(gd);
				
				GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
				
				JSONObject jo = new JSONObject();
				//jo.put("RESULT", "SUCCESS");
				jo.put("groupDetail", gson.toJson(gd));
				writer.println(jo);
				writer.flush();
				
			}
	
		}else if(mode.equals("user_reg")){
			
			System.out.println("user_reg...");
			
			
			String userid = request.getParameter("hid_userid");
			String usernm = request.getParameter("usernm");
			String pwd = request.getParameter("pwd");
			String groupcd = request.getParameter("group_name");
			String classcd = request.getParameter("classcd");
			String macaddress = request.getParameter("hid_macaddress");
			
			System.out.println("userid:"+userid);
			System.out.println("usernm:"+usernm);
			System.out.println("pwd:"+pwd);
			System.out.println("groupcd:"+groupcd);
			System.out.println("classcd:"+classcd);
			System.out.println("macaddress:"+macaddress);
			
			UserDAO ud = new UserDAO();
			ud.setUserid(userid);
			ud.setUsernm(usernm);
			ud.setPwd(pwd);
			ud.setGroupcd(groupcd);
			ud.setClasscd(classcd);
			ud.setMacaddress(macaddress);
			
			DBProc dp = new DBProc();
			
			String result = "FAIL";
			
			result = dp.UpUser(ud);
			
			System.out.println("result:"+result);
	        
			request.setAttribute("result", result);
	        ServletContext sc = getServletContext();
        	RequestDispatcher rd = sc.getRequestDispatcher("/UserList.jsp");
	        rd.forward(request, response);
	        
		}else if(mode.equals("group_reg")){
			
			System.out.println("group_reg");
			String groupcd = request.getParameter("groupcd");
			String re_groupcd = request.getParameter("re_groupcd");
			String groupname = request.getParameter("groupname");
			String admcd = request.getParameter("admcd");
			String regGb = request.getParameter("regGb");
			String result = "FAIL";
			
			System.out.println("groupcd:"+groupcd);
			System.out.println("re_groupcd:"+re_groupcd);
			System.out.println("groupname:"+groupname);
			System.out.println("admcd:"+admcd);
			System.out.println("regGb:"+regGb);
			
			GroupDAO gd = new GroupDAO();
			DBProc dp = new DBProc();
			
			if(regGb.equals("N")){
				System.out.println("Group Insert");
				gd.setGroupcd(groupcd);
				gd.setGroupname(groupname);
				gd.setAdm_cd(admcd);
				result = dp.InGroup(gd);
			}else{
				System.out.println("Group Update");
				gd.setGroupcd(re_groupcd);
				gd.setGroupname(groupname);
				gd.setAdm_cd(admcd);
				result = dp.UpGroup(gd);
			}
			
			request.setAttribute("result", result);
	        ServletContext sc = getServletContext();
        	RequestDispatcher rd = sc.getRequestDispatcher("/GroupList.jsp");
	        rd.forward(request, response);
			
			
		}
		
		/**
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
		**/
	}

}
