package memo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
	
	public String GetBoardList(String admCd, String offset){
		BoardListBody body = new BoardListBody();
	
		
		System.out.println("admCd:"+admCd);
		System.out.println("offset:"+offset);
		
		String sql = "SELECT * FROM BOARD "
				+ " where SUBSTRING(ADM_CD,1,7) = SUBSTRING(?,1,7) and SUBSTRING(ADM_CD,9,2) != '00'";
				 
				
		PreparedStatement pstmt = null;
		Connection conn = null;
		
		try{
			
			DBBean dbbean = new DBBean();
			conn = dbbean.getConnection();
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(sql);
			
			//pstmt.setInt(1, Integer.parseInt(memoSeq));
			//pstmt.setString(2, imgShow);
			
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
