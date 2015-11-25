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
		
		if("Add".equals(type)) {
		    // 10Mbyte 제한
		    int maxSize  = 1024*1024*10;        
		 
		    // 웹서버 컨테이너 경로
		    String root = request.getSession().getServletContext().getRealPath("/");
		 
		    // 파일 저장 경로(ex : /home/tour/web/ROOT/upload)
		    //String savePath = root + "upload";
		    String savePath = "E:/project/woori/";
		    //String savePath = "/usr/local/server/tomcat/webapps/ElectionManager_server/memo_upload/";
		    
		    try {
				MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
				
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
			    
			    String admCd = multi.getParameter("AdmCd");
			    String tag = multi.getParameter("Tag");
			    String imgyn = multi.getParameter("ImgYn");
			    String contents = multi.getParameter("Contents");
			    
			    System.out.println("admCd = "+admCd);
			    System.out.println("tag = "+tag);
			    System.out.println("imgyn = "+imgyn);
			    System.out.println("contents = "+contents);
			    
			    
		        // 파일업로드
		        uploadFile = multi.getFilesystemName("Attachment1");
		        System.out.println("uploadFile:" + uploadFile);
		        if(uploadFile!=null) {
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
			
		        }
		        
		        BoardListBody.BoardDTO boardDto = new BoardListBody.BoardDTO();		        
		        boardDto.admCd = admCd;
		        boardDto.contents = contents;
		        boardDto.tag = tag;
		        boardDto.imgYn = imgyn;
		        boardDto.imgShow = newFileName;
		        
		        String result = "FAIL";
		        
		        MemoDBDao dao = new MemoDBDao();
		        result = dao.InMemo(boardDto);
		        
		        System.out.println("memoInsert result:"+result);
		        
		        if(uploadFile!=null && result.equals("SUCCESS")) {
		        	int maxMemoSeq = dao.getMaxMemoSeq();
		        	boardDto.memoSeq = String.valueOf(maxMemoSeq);
		        	result = dao.InImage(boardDto);
		        	System.out.println("ImageInsert result:"+result);
		        }
		        
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
