package com.address;
import java.sql.*;

public class DBBean {
	
	final String driver ="com.mysql.jdbc.Driver"; 
	final String url = "jdbc:mysql://222.122.149.161:3306/VoteBank";
	final String userid = "votebank";
	final String passwd = "#uri0.";
	
	private Connection con = null;
	
	public DBBean()
	{
		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url,userid,passwd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public Connection getConnection()
	{
		return con;
	}
}
