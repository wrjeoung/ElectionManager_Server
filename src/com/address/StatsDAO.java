package com.address;

import java.io.Serializable;

public class StatsDAO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int level;
	private String adm_cd;
	private float partner_yn;
	private float univ_over;
	private int pop_dnsity;
	private float aged_child_ratio;
	
	private float childhood_alimony;
	private float age_avg;
	
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
	public float getPartner_yn() {
		return partner_yn;
	}
	public void setPartner_yn(float partner_yn) {
		this.partner_yn = partner_yn;
	}
	public float getUniv_over() {
		return univ_over;
	}
	public void setUniv_over(float univ_over) {
		this.univ_over = univ_over;
	}
	public int getPop_dnsity() {
		return pop_dnsity;
	}
	public void setPop_dnsity(int pop_dnsity) {
		this.pop_dnsity = pop_dnsity;
	}
	public float getAged_child_ratio() {
		return aged_child_ratio;
	}
	public void setAged_child_ratio(float aged_child_ratio) {
		this.aged_child_ratio = aged_child_ratio;
	}
	public float getChildhood_alimony() {
		return childhood_alimony;
	}
	public void setChildhood_alimony(float childhood_alimony) {
		this.childhood_alimony = childhood_alimony;
	}
	public float getAge_avg() {
		return age_avg;
	}
	public void setAge_avg(float age_avg) {
		this.age_avg = age_avg;
	}
	
}
