package com.address;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class GeoUtil {
	
	private static final String CONSUMER_KEY = "d7b1e5c419cd4e9baebd";
	private static final String CONSUMER_SECRET = "7d11a8fddbb5477c89d6";
	
	public static JSONObject getAddressFromPoint(double cox,double coy) {
		String urlStr;
		HttpURLConnection urlConnection = null; 
		BufferedReader reader = null; 
		StringBuilder stringBuilder; 
		
		JSONObject result = new JSONObject();
		final String accessToken = getAccessToken(CONSUMER_KEY,CONSUMER_SECRET);
		
		try { 
			urlStr = "https://sgisapi.kostat.go.kr/OpenAPI3/addr/rgeocode.json?accessToken="+accessToken+"&x_coor="+cox+"&y_coor="+coy+"&addr_type=20"; 
			URL url = new URL(urlStr);
			
            if(url.getProtocol().toLowerCase().equals("https")) {
            	trustAllHosts();
            	
            	HttpsURLConnection https = (HttpsURLConnection) url.openConnection(); 
                https.setHostnameVerifier(DO_NOT_VERIFY); 
                urlConnection = https;
            } else {
            	urlConnection = (HttpURLConnection) url.openConnection();	
            }
            urlConnection = (HttpURLConnection) url.openConnection(); 
            urlConnection.setRequestMethod("GET");
            urlConnection.setConnectTimeout(10000);
            urlConnection.connect();
	
			if (urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) { 
				//reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
				reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(),"utf-8"));
				stringBuilder = new StringBuilder(); 
		
				String line = null; 
				while ((line = reader.readLine()) != null) 
				{ 
					stringBuilder.append(line + "\n"); 
				}
				
				Object obj = JSONValue.parse(stringBuilder.toString()); 
				//System.out.println("obj = "+obj); 
				JSONObject jsonObj = (JSONObject) obj;
				String errMsg = (String) jsonObj.get("errMsg");
				
				if(!errMsg.equals("Success")) {
					System.out.println("address convert error");
					return null;
				}
				
				JSONArray jArray = (JSONArray) jsonObj.get("result");
				result = (JSONObject) jArray.get(0);
				
			} else {
				result = null;
			}
		} catch (IOException e) { 
			result = null;
			e.printStackTrace(); 
		} finally { 
			if (urlConnection != null) { 
				urlConnection.disconnect(); 
			} 
		} 

		return result; 
	}
	
	
	public static String getAccessToken(String consumer_key, String consumer_secret) {
		String urlStr; 
		HttpURLConnection urlConnection = null; 
		BufferedReader reader = null; 
		StringBuilder stringBuilder; 
		
		String accessToken = null;

		try { 
			urlStr = "https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json?consumer_key="+consumer_key+"&consumer_secret="+consumer_secret; 
			URL url = new URL(urlStr);
			
            if(url.getProtocol().toLowerCase().equals("https")) {
            	trustAllHosts();
            	
            	HttpsURLConnection https = (HttpsURLConnection) url.openConnection(); 
                https.setHostnameVerifier(DO_NOT_VERIFY); 
                urlConnection = https;
            } else {
            	urlConnection = (HttpURLConnection) url.openConnection();	
            }
            urlConnection = (HttpURLConnection) url.openConnection(); 
            urlConnection.setRequestMethod("GET");
            urlConnection.setConnectTimeout(10000);
            urlConnection.connect();
	
			if (urlConnection.getResponseCode() == HttpURLConnection.HTTP_OK) { 
				//reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
				reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(),"utf-8"));
				stringBuilder = new StringBuilder(); 
		
				String line = null; 
				while ((line = reader.readLine()) != null) 
				{ 
					stringBuilder.append(line + "\n"); 
				}
				
				Object obj = JSONValue.parse(stringBuilder.toString()); 
				System.out.println("obj = "+obj); 
				JSONObject jsonObj = (JSONObject) obj;
				String errMsg = (String) jsonObj.get("errMsg");
				
				if(!errMsg.equals("Success")) {
					System.out.println("error");
					return null;
				}
				
				JSONObject result = (JSONObject) jsonObj.get("result");
				accessToken = (String) result.get("accessToken");
			} 
		} catch (IOException e) { 
			accessToken = null; 
			e.printStackTrace(); 
		} finally { 
			if (urlConnection != null) { 
				urlConnection.disconnect(); 
			} 
		} 
		System.out.println("accessToken = "+accessToken);
		return accessToken; 
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
