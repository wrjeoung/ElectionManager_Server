package com.address;


//`TITLE`,`KIND`,`CT_AREA`,`SUMMARY`,`CONTENT`,`PROGRESS_PROCESS`,`RESULT`,`ETC`,`GROUPCD`,`IMG_YN`
public class BusinessDTO {
	
	private int bn_seq;
	private String title = "";
	private String bkname = "";
	private String groupname = "";
	private String groupcd = "";
	private String ct_area = "";
	private String progress_process =  "";
	private String result = "";
	private String etc  = "";
	private String img_yn =  "";
	private String content = "";
	private int img_seq;
	private String img_url = "";
	private String kind = "";
	private String summary = "";

	public int getBn_seq() {
		return bn_seq;
	}
	public void setBn_seq(int bn_seq) {
		this.bn_seq = bn_seq;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getBkname() {
		return bkname;
	}
	public void setBkname(String bkname) {
		this.bkname = bkname;
	}
	public String getGroupname() {
		return groupname;
	}
	public void setGroupname(String groupname) {
		this.groupname = groupname;
	}
	public String getGroupcd() {
		return groupcd;
	}
	public void setGroupcd(String groupcd) {
		this.groupcd = groupcd;
	}
	public String getCt_area() {
		return ct_area;
	}
	public void setCt_area(String ct_area) {
		this.ct_area = ct_area;
	}
	public String getProgress_process() {
		return progress_process;
	}
	public void setProgress_process(String progress_process) {
		this.progress_process = progress_process;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public String getImg_yn() {
		return img_yn;
	}
	public void setImg_yn(String img_yn) {
		this.img_yn = img_yn;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getImg_seq() {
		return img_seq;
	}
	public void setImg_seq(int img_seq) {
		this.img_seq = img_seq;
	}
	public String getImg_url() {
		return img_url;
	}
	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	
}
