package memo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.address.DBBean;

public class MemoDBDao {
	private String result = "FAIL";
	
	public int getMaxMemoSeq() {
		int maxSeq = 0;
		String sql = "SELECT max(MEMO_SEQ) FROM BOARD";
		
		PreparedStatement pstmt = null;
		Connection conn = null;
		ResultSet rs = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				maxSeq = rs.getInt(1);
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
		return maxSeq;
	}
	
	public String InMemo(BoardListBody.BoardDTO dto){
		String admCd = dto.admCd;
		String contents = dto.contents;
		String tag = dto.tag;
		String imgYn = dto.imgYn;
		String imgShow = dto.imgShow;
		
		System.out.println("admCd:"+admCd);
		System.out.println("contents:"+contents);
		System.out.println("imgYn:"+imgYn);
		System.out.println("imgShow:"+imgShow);
		
		if(tag == null) {
			tag = "";
		}
				
		String sql = "INSERT INTO BOARD(ADM_CD,DATE,CONTENT,TAG,IMG_YN)"
				 + "VALUES (?,SYSDATE(),?,?,?)";
				
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, admCd);
			pstmt.setString(2, contents);
			pstmt.setString(3, tag);
			pstmt.setString(4, imgYn);
			
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
	
	public String InImage(BoardListBody.BoardDTO dto){
		String memoSeq = dto.memoSeq;
		String admCd = dto.admCd;
		String contents = dto.contents;
		String tag = dto.tag;
		String imgYn = dto.imgYn;
		String imgShow = dto.imgShow;
		
		
		System.out.println("memoSeq:"+memoSeq);
		System.out.println("admCd:"+admCd);
		System.out.println("contents:"+contents);
		System.out.println("imgYn:"+imgYn);
		System.out.println("imgShow:"+imgShow);
		
		
		String sql = "INSERT INTO BOARD_IMG(MEMO_SEQ,IMG_URL)"
				 + "VALUES (?,?)";
				
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, Integer.parseInt(memoSeq));
			pstmt.setString(2, imgShow);
			
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
	
	public BoardListBody GetBoardList(String admCd, int offset){
		BoardListBody body = new BoardListBody();
		body.custMemoList = new ArrayList<BoardListBody.BoardDTO>();
				
		System.out.println("admCd : "+admCd);
		System.out.println("offset : "+offset);
		
		String sql = " SELECT D.*"
					+" FROM"
					+" ( SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM , C.*"
					+"   FROM"
				 	+"   ("
					+"     SELECT A.MEMO_SEQ,ADM_CD,DATE,CONTENT,TAG,IMG_YN,IMG_SEQ,IMG_URL"
				 	+"     FROM BOARD A"
					+"     LEFT OUTER JOIN BOARD_IMG B on A.MEMO_SEQ = B.MEMO_SEQ"
				 	+"     WHERE SUBSTRING(ADM_CD,1,7) = SUBSTRING(?,1,7) and SUBSTRING(ADM_CD,9,2) != '00'"
					+"     OR SUBSTRING(?,6,2) = '00' and SUBSTRING(?,1,5) = SUBSTRING(ADM_CD,1,5) and SUBSTRING(ADM_CD,9,2) != '00' and ADM_CD != ?"
				 	+"     ORDER BY DATE DESC"
					+"   ) C,"
				 	+"   (SELECT @ROWNUM := 0) R"
					+" ) D"
				 	+" WHERE D.ROWNUM > ? and D.ROWNUM <= ?+20";
				
		PreparedStatement pstmt = null;
		Connection conn = null;
		ResultSet rs = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, admCd);
			pstmt.setString(2, admCd);
			pstmt.setString(3, admCd);
			pstmt.setString(4, admCd);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			
			rs = pstmt.executeQuery();

			while(rs.next()) {
				int memoSeq = rs.getInt("MEMO_SEQ");
				String adm_Cd = rs.getString("ADM_CD");
				long date = rs.getLong("DATE");
				String content = rs.getString("CONTENT");
				String tag = rs.getString("TAG");
				String imgYn = rs.getString("IMG_YN");
				int imgSeq = rs.getInt("IMG_SEQ");
				String imgUrl = rs.getString("IMG_URL");
				
				System.out.println("memoSeq : "+memoSeq);
				System.out.println("adm_Cd : "+adm_Cd);
				System.out.println("date : "+date);
				System.out.println("content : "+content);
				System.out.println("tag : "+tag);
				System.out.println("imgYn : "+imgYn);
				System.out.println("imgSeq : "+imgSeq);
				System.out.println("imgUrl : "+imgUrl);
				
				BoardListBody.BoardDTO boardDto = new BoardListBody.BoardDTO();
				boardDto.imgFileList = new ArrayList<ImageInfoDTO>();
				
				boardDto.memoSeq = String.valueOf(memoSeq);
				boardDto.admCd = adm_Cd;
				boardDto.longDate = date;
				boardDto.contents = content;
				boardDto.tag = tag;
				boardDto.imgYn = imgYn;
				
				if(imgUrl != null && imgUrl.length() > 0) {
					ImageInfoDTO imgDto = new ImageInfoDTO();
					imgDto.imgSeq = imgSeq;
					imgDto.imgUrl = imgUrl;
					boardDto.imgFileList.add(imgDto);
				}
				
				body.custMemoList.add(boardDto);
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
		return body;
	}
}
