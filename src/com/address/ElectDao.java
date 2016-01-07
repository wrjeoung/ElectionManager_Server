package com.address;

public class ElectDao {
	
	//LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2
	private int level;		
	private String adm_cd;
	private String avg;
	private String f6th;
	private String f19th;
	private String f18th_1;
	private String f18th_2;
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public String getAdm_cd() {
		return adm_cd;
	}
	public void setAdm_cd(String adm_cd) {
		this.adm_cd = adm_cd;
	}
	public String getAvg() {
		return avg;
	}
	public void setAvg(String avg) {
		this.avg = avg;
	}
	public String getF6th() {
		return f6th;
	}
	public void setF6th(String f6th) {
		this.f6th = f6th;
	}
	public String getF19th() {
		return f19th;
	}
	public void setF19th(String f19th) {
		this.f19th = f19th;
	}
	public String getF18th_1() {
		return f18th_1;
	}
	public void setF18th_1(String f18th_1) {
		this.f18th_1 = f18th_1;
	}
	public String getF18th_2() {
		return f18th_2;
	}
	public void setF18th_2(String f18th_2) {
		this.f18th_2 = f18th_2;
	}
	
}
