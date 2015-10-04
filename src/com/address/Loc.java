package com.address;

import java.util.ArrayList;

public class Loc {
    private double lt; // 위도
    private double lg; // 경도

    public double getLt() {
    	return lt;
    }
    
    public void setLt(double lt) {
    	this.lt = lt;
    }    
    
    public double getLg() {
    	return lg;
    }
    
    public void setLg(double lg) {
    	this.lg = lg;
    }

    public Loc(double lg, double lt)
    {
        this.lg = lg;
        this.lt = lt;
    }
    
    public boolean IsPointInPolygon(ArrayList<Loc> poly, Loc point)
	{
	    int i, j;
	    boolean c = false;
	    for (i = 0, j = poly.size() - 1; i < poly.size(); j = i++)
	    {
	        if ((((poly.get(i).lt <= point.lt) && (point.lt < poly.get(j).lt)) 
	                | ((poly.get(j).lt <= point.lt) && (point.lt < poly.get(i).lt))) 
	                && (point.lg < (poly.get(j).lg - poly.get(i).lg) * (point.lt - poly.get(i).lt) 
	                    / (poly.get(j).lt - poly.get(i).lt) + poly.get(i).lg))

	            c = !c;
	        
	    }
	    return c;
	}
}
