<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>

<%@page import="java.math.*" %>
<%@page import="java.io.BufferedReader" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.InputStream" %>
<%@page import="java.io.InputStreamReader" %>
<%@page import="java.io.OutputStream" %>
<%@page import="java.net.URL" %>
<%@page import="java.util.HashMap" %>
<%@page import="javax.net.ssl.HttpsURLConnection" %>
<%@page import="org.apache.http.HttpStatus" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
String jsonString = null;
final String FCM_URL = "https://fcm.googleapis.com/fcm/send";
final String FCM_SERVER_API_KEY    = "AIzaSyCo_4MyWkbe18wlN2NSlXUaSb5oqjRiugo";
String deviceRegistrationId =  "";
try{
	
	final int NOT_VERIFIED = 0;
	final int VERIFIED = 1;
	final String MY_SQL_PATH = "jdbc:mysql://localhost/s2s";
	final String MY_SQL_USER_NAME = "ashrafs2smain";
	final String MY_SQL_PASS = "NoidA@123";

	String unix_time = String.valueOf(new Date().getTime());
	
	String user_id =  String.valueOf(new Date().getTime());
	String auth_id = request.getParameter("auth_id");
	String mobile_no = request.getParameter("mobile_no");
	String name = request.getParameter("name");
	String dob = request.getParameter("dob");
	String gender = request.getParameter("gender");
	String date_created = user_id;
	String country = request.getParameter("country");
	String lat_lng = request.getParameter("lat_lng");
	String address = request.getParameter("address");

	int is_verified = NOT_VERIFIED;

	if(auth_id.equals("")){
		JSONObject obj = new JSONObject();
	    obj.put("STATUS", "5");
	    obj.put("MSG", "UID NULL");
	    jsonString = obj.toJSONString();
	    out.print(jsonString);	
	    return;
	}

	Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection(MY_SQL_PATH, MY_SQL_USER_NAME, MY_SQL_PASS);
    Statement stmt = conn.createStatement();

    String sql = "SELECT * FROM users WHERE auth_id='"+ auth_id +"'";
    ResultSet rs = stmt.executeQuery(sql);
	
	int i = 0;
    while(rs.next()){
        i++;
    }
    
    if(i>=0){
    		 /*sql = "INSERT INTO users (user_id, auth_id, mobile_no, name, dob, gender, date_created, lat_lng, country, address, profile_pic, is_verified, last_time)"+
    		  	" VALUES( '"+ 
    		    user_id + "','" + auth_id + "','" + mobile_no + "','" + name + "','" + dob + "','"+ gender + "','" + date_created + "','" + lat_lng +"', '" + country + "','"+ address +" ',' ', " + is_verified +",'" + unix_time + "')";
    		 stmt.executeUpdate(sql);*/
    		 

    		if(/*"female".equalsIgnoreCase(gender)*/ true){
                sql = "SELECT * FROM users WHERE gender = 'male' ORDER BY last_time DESC LIMIT 100";
                rs = stmt.executeQuery(sql);
                while(rs.next()){

                	String fcm_token = "SELECT * FROM fcm_tokens WHERE user_id='"+ rs.getString("user_id") +"'";
                	ResultSet token = stmt.executeQuery(fcm_token);
                	if(token.next()){
            			deviceRegistrationId = token.getString("token");
            			if(!deviceRegistrationId.equals("")){
            				try{
                				int responseCode = -1;
                				String responseBody = null;
                				HashMap<String, String> dataMap = new HashMap<String, String>();
                				JSONObject payloadObject = new JSONObject();

                				dataMap.put("\"name\"", "\"New user join " + name + "\"");
                				dataMap.put("\"uid\"", "\"admin\""); 
                				dataMap.put("\"message\"", "\"new user\""); 
                				dataMap.put("\"type\"", "\"3\""); 
                				dataMap.put("\"viewType\"", "\"0\""); 
                				dataMap.put("\"unix_time\"", "\""+ unix_time + "\""); 
                 
                				JSONObject data = new JSONObject(dataMap);;
                				payloadObject.put("data", data);
                				payloadObject.put("to", deviceRegistrationId);
                
                				byte[] postData =  payloadObject.toString().getBytes();

                				URL url = new URL(FCM_URL);
                				HttpsURLConnection httpURLConnection = (HttpsURLConnection)url.openConnection();

                //set timeputs to 10 seconds
                				httpURLConnection.setConnectTimeout(10000);
                				httpURLConnection.setReadTimeout(10000);

                				httpURLConnection.setDoOutput(true);
                				httpURLConnection.setUseCaches(false);
                				httpURLConnection.setRequestMethod("POST");
                				httpURLConnection.setRequestProperty("Content-Type", "application/json");
                				httpURLConnection.setRequestProperty("Content-Length", Integer.toString(postData.length));
                				httpURLConnection.setRequestProperty("Authorization", "key="+FCM_SERVER_API_KEY);
                				OutputStream out1 = httpURLConnection.getOutputStream();
                				out1.write(postData);
                				out1.close();
                				responseCode = httpURLConnection.getResponseCode();
                //success
                				if (responseCode == HttpStatus.SC_OK){
                    				InputStreamReader inputStream = new InputStreamReader(httpURLConnection.getInputStream());
                    				BufferedReader bReader = new BufferedReader(inputStream);
             		
                    				StringBuilder sb = new StringBuilder();
                    				String line = null;
                    				while((line = bReader.readLine()) != null){
                        				sb.append(line);
                    				}
                    				JSONObject obj = new JSONObject();
                    				obj.put("STATUS", "7");
                    				obj.put("MSG", responseBody);
                    				jsonString = obj.toJSONString();
                    				out.print(jsonString);
                    				responseBody = sb.toString();
                    				System.out.println("FCM message sent : " + responseBody);
                				}else{
                    				InputStreamReader inputStream = new InputStreamReader(httpURLConnection.getInputStream());
                    				BufferedReader bReader = new BufferedReader(inputStream);
             
                    				StringBuilder sb = new StringBuilder();
                    				String line = null;
                    				while((line = bReader.readLine()) != null){
                       		 			sb.append(line);
                    				}
                    				responseBody = sb.toString();
                    				JSONObject obj = new JSONObject();
                    				obj.put("STATUS", "6");
                    				obj.put("MSG", responseBody);
                    				jsonString = obj.toJSONString();
                    				out.print(jsonString);
                    				System.out.println("Sending FCM request failed for regId: " + deviceRegistrationId + " response: " + responseBody);
                				}
                
            				}catch(Exception e){
                				JSONObject obj = new JSONObject();
                				obj.put("STATUS", "5");
                				obj.put("MSG", e.getMessage());
                				jsonString = obj.toJSONString();
                				out.print(jsonString);
            				}
        				}
        			}
        		}
        	}
        JSONObject obj = new JSONObject();
    	obj.put("STATUS", "0");
    	obj.put("user_id", user_id);
    	obj.put("MSG", "ADDED SUCCESSFULLY");
        jsonString = obj.toJSONString();
    	out.print(jsonString);
    }else{
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "4");
	    obj.put("MSG", "Already Exists");
	    jsonString = obj.toJSONString();
	    out.print(jsonString);
    }
    if(conn != null){
		conn.close();
	}
  	
}catch(SQLIntegrityConstraintViolationException e){
	if(conn != null){
		conn.close();
	}
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "1");
    obj.put("MSG", e.getMessage());
    jsonString = obj.toJSONString();
    out.print(jsonString);
} catch (SQLException e) {
	if(conn != null){
		conn.close();
	}
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "2");
    obj.put("MSG", e.getMessage());
    jsonString = obj.toJSONString();
    out.print(jsonString);
}catch (Exception e){
	if(conn != null){
		conn.close();
	}
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "3"); 
    obj.put("MSG", e.getMessage());
    jsonString = obj.toJSONString();
    out.print(jsonString);
}

%>
