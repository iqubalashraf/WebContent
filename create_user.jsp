<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
String jsonString = null;
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
    
    if(i==0){
    		 sql = "INSERT INTO users (user_id, auth_id, mobile_no, name, dob, gender, date_created, lat_lng, country, address, profile_pic, is_verified, last_time)"+
    		  	" VALUES( '"+ 
    		    user_id + "','" + auth_id + "','" + mobile_no + "','" + name + "','" + dob + "','"+ gender + "','" + date_created + "','" + lat_lng +"', '" + country + "','"+ address +" ',' ', " + is_verified +",'" + unix_time + "')";
    		 stmt.executeUpdate(sql);
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
