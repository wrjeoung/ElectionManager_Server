package memo;

import java.io.Serializable;
import java.util.ArrayList;

import memo.BoardListBody.BoardDTO;

/**
 * Created by juhyukkim on 2015. 11. 22..
 */
public class BoardListBody extends ResponseBody {
	public ArrayList<BoardDTO> custMemoList;

    public static class BoardDTO implements Serializable {
    	public BoardDTO() {}
        public BoardDTO(BoardDTO dto){
            longDate = dto.longDate;
            admCd = dto.admCd;
            memoSeq = dto.memoSeq;
            contents = dto.contents;
            tag = dto.tag;
            imgYn = dto.imgYn;
        }

        public long longDate;
        public String admCd;
        public String memoSeq;
        public String contents;
        public String tag;
        public String imgYn;
        public ArrayList<ImageInfoDTO> imgFileList;

        public String imgShow;
    }
}
