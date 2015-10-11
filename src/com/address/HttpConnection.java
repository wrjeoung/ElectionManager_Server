package com.address;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

public class HttpConnection {
	public static String GetData(String strUrl) {
    	StringBuilder strResult = new StringBuilder("");
    	
        try {
            URL url = new URL(strUrl) ;
            HttpURLConnection urlConnection = null;
            
            if(url.getProtocol().toLowerCase().equals("https")) {
            	trustAllHosts();
            	
            	HttpsURLConnection https = (HttpsURLConnection) url.openConnection(); 
                https.setHostnameVerifier(DO_NOT_VERIFY); 
                urlConnection = https;
            } else {
            	urlConnection = (HttpURLConnection) url.openConnection();
            }
            
            
            urlConnection.setRequestMethod("GET");
            urlConnection.setConnectTimeout(10000);
            urlConnection.connect();
            
            if(urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
            	BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
            	
            	String inputLine;
            	while((inputLine = in.readLine()) != null) {
            		strResult.append(inputLine);
            	}
            } else {
            	strResult.append(urlConnection.getResponseCode());
            }
        } catch (MalformedURLException e) {
        	strResult.append(e.toString());
            e.printStackTrace();
        } catch (IOException e) {
        	strResult.append(e.toString());
            e.printStackTrace();
        }
        
        return strResult.toString();
    }
	
	public static String PostData(String strUrl, String strData) {
		StringBuilder strResult = new StringBuilder("");
		
		try {
			URL url = new URL(strUrl) ;
			HttpURLConnection urlConnection = null;
			
			if(url.getProtocol().toLowerCase().equals("https")) {
				trustAllHosts();
				
				HttpsURLConnection https = (HttpsURLConnection) url.openConnection(); 
			    https.setHostnameVerifier(DO_NOT_VERIFY); 
			    urlConnection = https;
			} else {
				urlConnection = (HttpURLConnection) url.openConnection();	
			}
			
			urlConnection.setDefaultUseCaches(false);                                           
			urlConnection.setDoInput(true);
			urlConnection.setDoOutput(true);
			urlConnection.setRequestMethod("POST");
			
			urlConnection.setRequestProperty("content-type", "application/x-www-form-urlencoded");
           
			OutputStreamWriter outStream = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
			PrintWriter writer = new PrintWriter(outStream);
			writer.write(strData.toString());
			writer.flush();
			
            if(urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {
             
				BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"));
				
				String inputLine;
	        	while((inputLine = in.readLine()) != null) {
	        		strResult.append(inputLine);
	        	}
            } else {
            	strResult.append(urlConnection.getResponseCode());
            }
		} catch (MalformedURLException e) {
			strResult.append(e.toString());
			e.printStackTrace();
        } catch (IOException e) {
        	strResult.append(e.toString());
        	e.printStackTrace();
        }
        
        return strResult.toString();
	}
	
	
	private static void trustAllHosts() { 
        // Create a trust manager that does not validate certificate chains 
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() { 
                public java.security.cert.X509Certificate[] getAcceptedIssuers() { 
                        return new java.security.cert.X509Certificate[] {}; 
                } 
 
                
                public void checkClientTrusted( 
                        java.security.cert.X509Certificate[] chain, 
                        String authType) 
                        throws java.security.cert.CertificateException { 
                    // TODO Auto-generated method stub                     
                } 
 
                 
                public void checkServerTrusted( 
                        java.security.cert.X509Certificate[] chain, 
                        String authType) 
                        throws java.security.cert.CertificateException { 
                    // TODO Auto-generated method stub                     
                } 
        } }; 
 
        // Install the all-trusting trust manager 
        try { 
                SSLContext sc = SSLContext.getInstance("TLS"); 
                sc.init(null, trustAllCerts, new java.security.SecureRandom()); 
                HttpsURLConnection 
                                .setDefaultSSLSocketFactory(sc.getSocketFactory()); 
        } catch (Exception e) { 
                e.printStackTrace(); 
        } 
    } 
     
    final static HostnameVerifier DO_NOT_VERIFY = new HostnameVerifier() {        
		
		public boolean verify(String arg0, SSLSession arg1) {
			// TODO Auto-generated method stub
			return true;
		} 
    };
}
