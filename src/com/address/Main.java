package com.address;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class Main {
	
	public static void main(String[] args)
	{
		System.out.println(getAddressToPosition("경기도 부천시 소사구 괴안동 104 트윈파크"));
	}
	
	
	public static double [] getAddressToPosition(String korAddress) {
		String urlStr;
		HttpURLConnection connection = null;
		BufferedReader reader = null;
		StringBuilder stringBuilder;
		double position[];
		
		try {
			urlStr = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=" + URLEncoder.encode(korAddress, "utf-8");
			URL url = new URL(urlStr);
			
			connection = (HttpURLConnection) url.openConnection();
			connection.setReadTimeout(1000);
			// read the output from the server
			
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				stringBuilder = new StringBuilder();
	 
				String line = null;
				while ((line = reader.readLine()) != null)
				{
					stringBuilder.append(line + "\n");
				}
				
				Object obj = JSONValue.parse(stringBuilder.toString());
				System.out.println(obj);
				JSONObject location = (JSONObject) obj;
				JSONArray arr = (JSONArray) location.get("results");
				
				location = (JSONObject) arr.get(0);
				location = (JSONObject) location.get("geometry");
				location = (JSONObject) location.get("location");
				
				position = new double[2];
				
				position[0] = Double.parseDouble(String.valueOf(location.get("lat")));
				position[1] = Double.parseDouble(String.valueOf(location.get("lng")));
				
				
			} else {
				position = null;
			}
		} catch (IOException e) {
			position = null;
			e.printStackTrace();
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return position;
	}	
}
