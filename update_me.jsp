<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>


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
	
	String auth_id = request.getParameter("auth_id");
    String unix_time = String.valueOf(new Date().getTime());

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

    String gender = "";
    String name = "";
    String last_time = "";

    if(rs.next()){
    	gender = rs.getString("gender");
    	name = rs.getString("name");
    	last_time = rs.getString("last_time");
	}

    sql = "UPDATE users SET last_time='" + unix_time + "' WHERE auth_id= '"+ auth_id + "'";
    //Statement stmt2 = conn.createStatement();
    stmt.executeUpdate(sql);
	JSONObject obj = new JSONObject();
    
    obj.put("Time ", unix_time + "    " + last_time + "   " + String.valueOf(new Date().getTime() - Long.parseLong(last_time)));

    if("female".equalsIgnoreCase(gender)){
    		if( (new Date().getTime() - Long.parseLong(last_time)) > 1800000 ){
                sql = "SELECT * FROM users WHERE gender = 'male' ORDER BY last_time DESC LIMIT 200";
                rs = stmt.executeQuery(sql);
                while(rs.next()){
                    Statement stmt2 = conn.createStatement();
                	//String fcm_token = "SELECT * FROM fcm_tokens WHERE user_id = '1556417474369'";
                    String fcm_token = "SELECT * FROM fcm_tokens WHERE user_id='"+ rs.getString("user_id") +"'";
                	ResultSet token = stmt2.executeQuery(fcm_token);
                	if(token.next()){
            			deviceRegistrationId = token.getString("token");
            			if(!deviceRegistrationId.equals("")){
            				try{
                				int responseCode = -1;
                				String responseBody = null;
                				HashMap<String, String> dataMap = new HashMap<String, String>();
                				JSONObject payloadObject = new JSONObject();

                				dataMap.put("\"name\"", "\""+ name + "(Female) came online\"");
                				dataMap.put("\"uid\"", "\"admin\""); 
                				dataMap.put("\"message\"", "\"new user\""); 
                				dataMap.put("\"type\"", "\"3\""); 
                				dataMap.put("\"viewType\"", "\"0\""); 
                				dataMap.put("\"unix_time\"", "\""+ unix_time + "\""); 
                                dataMap.put("\"country\"", "\"Let's start conversation\"");

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
                				}else{
                    				InputStreamReader inputStream = new InputStreamReader(httpURLConnection.getInputStream());
                    				BufferedReader bReader = new BufferedReader(inputStream);
             
                    				StringBuilder sb = new StringBuilder();
                    				String line = null;
                    				while((line = bReader.readLine()) != null){
                       		 			sb.append(line);
                    				}
                    				responseBody = sb.toString();
                				}
                
            				}catch(Exception e){
            				}
        				}
        			}
        		}
        	}
        }
    
    obj.put("MSG", "SUCCESSFULLY");
    jsonString = obj.toJSONString();
    out.print(jsonString);

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
