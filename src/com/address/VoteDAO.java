package com.address;

import java.io.Serializable;

public class VoteDAO implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int level;
	private String adm_cd;
	private float v20th;
	private float v30th;
	private float v40th;
	private float v40th_under;
	private float v50th_over;
	private float v50th;
	private float v60th_over;
	
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public float getV20th() {
		return v20th;
	}
	public void setV20th(float v20th) {
		this.v20th = v20th;
	}
	public float getV30th() {
		return v30th;
	}
	public void setV30th(float v30th) {
		this.v30th = v30th;
	}
	public float getV40th() {
		return v40th;
	}
	public void setV40th(float v40th) {
		this.v40th = v40th;
	}
	public float getV40th_under() {
		return v40th_under;
	}
	public void setV40th_under(float v40th_under) {
		this.v40th_under = v40th_under;
	}
	public float getV50th_over() {
		return v50th_over;
	}
	public void setV50th_over(float v50th_over) {
		this.v50th_over = v50th_over;
	}
	public float getV50th() {
		return v50th;
	}
	public void setV50th(float v50th) {
		this.v50th = v50th;
	}
	public float getV60th_over() {
		return v60th_over;
	}
	public void setV60th_over(float v60th_over) {
		this.v60th_over = v60th_over;
	}
	public String getAdm_cd() {
		return adm_cd;
	}
	public void setAdm_cd(String adm_cd) {
		this.adm_cd = adm_cd;
	}
	
}
