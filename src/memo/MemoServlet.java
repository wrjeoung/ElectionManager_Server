package memo;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class MemoServlet extends HttpServlet {
	
	public static final String RESPONSE_RESULT = "result";		
	public static final String RESPONSE_RESULT_ERROR_MSG = "error";
	public static final String RESPONSE_RESULT_ERROR_CODE = "errorcode";		
	public static final String RESPONSE_BODY_DATA_KEY = "data";	
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");		
		response.setContentType("text/html;charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String type= request.getParameter("Type");
		System.out.println("type = "+type);
		
		if("Add".equals(type) || "Update".equals(type)) {
		    // 10Mbyte ����
		    int maxSize  = 1024*1024*10;        
		 
		    // ������ �����̳� ���
		    String root = request.getSession().getServletContext().getRealPath("/");
		 
		    // ���� ���� ���(ex : /home/tour/web/ROOT/upload)
		    //String savePath = "E:/project/woori/";
		    String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/memo_upload/";
		    
		    try {
				MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
				
			    // ���ε� ���ϸ�
			    String uploadFile = "";
			    String uploadFile_Mf = "";
			 
			    // ���� ������ ���ϸ�
			    String newFileName = "";
			    
			    int read = 0;
			    byte[] buf = new byte[1024];
			    FileInputStream fin = null;
			    FileOutputStream fout = null;
			    long currentTime = System.currentTimeMillis();  
			    SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMddHHmmss");
			    
			    String memoSeq = multi.getParameter("MemoSeq");
			    String admCd = multi.getParameter("AdmCd");
			    String tag = multi.getParameter("Tag");
			    String imgyn = multi.getParameter("ImgYn");
			    String contents = multi.getParameter("Contents");
			    String imgUrl = multi.getParameter("ImgUrl");
			    
			    System.out.println("admCd = "+admCd);
			    System.out.println("tag = "+tag);
			    System.out.println("imgyn = "+imgyn);
			    System.out.println("contents = "+contents);
			    System.out.println("imgUrl = "+imgUrl);
			    
			    
		        // ���Ͼ��ε�
		        uploadFile = multi.getFilesystemName("Attachment1");
		        System.out.println("uploadFile:" + uploadFile);
		        if(uploadFile!=null && imgUrl == null) {
		        	System.out.println("�űԵ��");
		        	
					 // ���� ������ ���ϸ�(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // ���ε�� ���� ��ü ����
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // ���� ����� ���� ��ü ����
			        File newFile = new File(savePath + newFileName);
			        
			        // ���ϸ� rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename�� ���� ������� ������ ������ �����ϰ� ���������� ����
			 
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
			
		        } else if(uploadFile==null && imgUrl != null){
					System.out.println("����");
				} else if(uploadFile!=null && imgUrl != null){
					System.out.println("����");
					
					// ���� ���� ����
					File orgFile = new File(savePath+imgUrl);
					if(orgFile.exists()) {
						orgFile.delete();
					}
					
					 // ���� ������ ���ϸ�(ex : 20140819151221.zip)
			        newFileName = simDf.format(new Date(currentTime)) +"."+ uploadFile.substring(uploadFile.lastIndexOf(".")+1);
			         
			        // ���ε�� ���� ��ü ����
			        File oldFile = new File(savePath + uploadFile);
			 
			         
			        // ���� ����� ���� ��ü ����
			        File newFile = new File(savePath + newFileName);
			        
			        // ���ϸ� rename
			        if(!oldFile.renameTo(newFile)){
			 
			            // rename�� ���� ������� ������ ������ �����ϰ� ���������� ����
			 
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
				} 
		        
		        BoardListBody.BoardDTO boardDto = new BoardListBody.BoardDTO();
		        boardDto.memoSeq = memoSeq;
		        boardDto.admCd = admCd;
		        boardDto.contents = contents;
		        boardDto.tag = tag;
		        boardDto.imgYn = imgyn;
		        boardDto.imgShow = newFileName;
		        
		        String result = "FAIL";
		        
		        MemoDBDao dao = new MemoDBDao();
		        if("Add".equals(type)) {
		        	result = dao.InMemo(boardDto);
		        } else {
		        	result = dao.UpMemo(boardDto);
		        }
		        
		        System.out.println("memoInsert result:"+result);
		        
		        if(uploadFile!=null && imgUrl == null && result.equals("SUCCESS")) {
		        	int maxMemoSeq = dao.getMaxMemoSeq();
		        	boardDto.memoSeq = String.valueOf(maxMemoSeq);
		        	result = dao.InImage(boardDto);
		        	System.out.println("ImageInsert result:"+result);
		        }else if(uploadFile!=null && imgUrl != null && result.equals("SUCCESS")){
		        	result = dao.UpImage(boardDto);
		        	System.out.println("ImageUpdate result:"+result);
		        }else if(uploadFile == null && imgUrl == null && "Update".equals(type)){
		        	ImageInfoDTO dto = dao.getImageInfo(Integer.parseInt(memoSeq));
		        	if(dto != null) {
						// ���� ���� ����
						File orgFile = new File(savePath+dto.imgUrl);
						if(orgFile.exists()) {
							orgFile.delete();
						}
						result = dao.DelImage(dto.imgSeq);
						System.out.println("ImageDelete result:"+result);
		        	}
		        }
		        
		    }catch(Exception e) {
		    	e.printStackTrace();
		    }
		} else if("Del".equals(type)){ 
			
		    // ���� ���� ���(ex : /home/tour/web/ROOT/upload)
		    //String savePath = "E:/project/woori/";
		    String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/memo_upload/";
			
			
			String memoSeq = request.getParameter("MemoSeq"); 
			MemoDBDao dao = new MemoDBDao();
			int iMemoSeq = 0;
			
			if(memoSeq != null) {
				iMemoSeq = Integer.parseInt(memoSeq);
			}
			try {
				String result = "FAIL";
				
				result = dao.DelMemo(iMemoSeq);
				System.out.println("MemoDelete result:"+result);
				
				if(result.equals("SUCCESS")) {
					ImageInfoDTO dto = dao.getImageInfo(iMemoSeq);
		        	if(dto != null) {
						// ���� ���� ����
						File orgFile = new File(savePath+dto.imgUrl);
						if(orgFile.exists()) {
							orgFile.delete();
						}
						result = dao.DelImage(dto.imgSeq);
						System.out.println("ImageDelete result:"+result);
		        	}
				}
				
				PrintWriter writer = response.getWriter();
				
				GsonBuilder builder = new GsonBuilder();
		    	Gson gson = builder.create();
		    	
		    	DefaultBody body = new DefaultBody();
		    	body.error = "success";
		    	body.errorcode = "000";
		    	body.result = "success";
		    	
		    	JSONObject obj = new JSONObject();
		    	obj.put(RESPONSE_RESULT,"success");
		    	obj.put(RESPONSE_RESULT_ERROR_MSG,"success");
		    	obj.put(RESPONSE_RESULT_ERROR_CODE,"000");
		    	obj.put(RESPONSE_BODY_DATA_KEY, gson.toJson(body));
				
				writer.println(obj);
				writer.flush();
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		} else if("List".equals(type)) {
			String admCd = request.getParameter("AdmCd");
			int offset = Integer.parseInt(request.getParameter("Offset"));
			
			MemoDBDao dao = new MemoDBDao();
			BoardListBody body = dao.GetBoardList(admCd, offset);
			
			PrintWriter writer = response.getWriter();
						
			GsonBuilder builder = new GsonBuilder();
	    	Gson gson = builder.create();
	    	
	    	JSONObject obj = new JSONObject();
	    	obj.put(RESPONSE_RESULT,"success");
	    	obj.put(RESPONSE_RESULT_ERROR_MSG,"success");
	    	obj.put(RESPONSE_RESULT_ERROR_CODE,"000");
	    	obj.put(RESPONSE_BODY_DATA_KEY, gson.toJson(body));
			
			writer.println(obj);
			writer.flush();
		}
	}
}
