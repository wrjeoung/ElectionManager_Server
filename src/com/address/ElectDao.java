package com.address;

public class ElectDao {
	
	//LEVEL, ADM_CD, SUM(6TH) AS 6TH, SUM(19TH) AS 19TH, SUM(18TH_1) AS 18TH_1, SUM(18TH_2) AS 18TH_2
	private int level;		
	private String adm_cd;
	private float avg;
	private float f6th;
	private float f19th;
	private float f18th_1;
	private float f18th_2;
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
	public float getAvg() {
		return avg;
	}
	public void setAvg(float avg) {
		this.avg = avg;
	}
	public float getF6th() {
		return f6th;
	}
	public void setF6th(float f6th) {
		this.f6th = f6th;
	}
	public float getF19th() {
		return f19th;
	}
	public void setF19th(float f19th) {
		this.f19th = f19th;
	}
	public float getF18th_1() {
		return f18th_1;
	}
	public void setF18th_1(float f18th_1) {
		this.f18th_1 = f18th_1;
	}
	public float getF18th_2() {
		return f18th_2;
	}
	public void setF18th_2(float f18th_2) {
		this.f18th_2 = f18th_2;
	}
}
