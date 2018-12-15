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
	
	String auth_id = request.getParameter("auth_id");

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
	JSONObject userInfo = new JSONObject();
	int i = 0;
    while(rs.next()){
   		i++;
   		userInfo.put("user_id", rs.getString("user_id"));
   		userInfo.put("auth_id", rs.getString("auth_id"));
    	userInfo.put("mobile_no", rs.getString("mobile_no"));
    	userInfo.put("name", rs.getString("name"));
   		userInfo.put("dob", rs.getString("dob"));
   		userInfo.put("gender", rs.getString("gender"));
   		userInfo.put("date_created", rs.getString("date_created"));
   		userInfo.put("country", rs.getString("country"));
    	userInfo.put("profile_pic", rs.getString("profile_pic"));
    	userInfo.put("is_verified", rs.getString("is_verified"));
    }
    
    if(i==0){
    		 JSONObject obj = new JSONObject();
    		 obj.put("STATUS", "0");
    		 obj.put("USER_STATUS", "NEW");
    		 obj.put("MSG", "NEW USER");
    		 jsonString = obj.toJSONString();
    		 out.print(jsonString);
    }else{
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "0");
	    obj.put("MSG", "OLD USER");
    	obj.put("USER_STATUS", "OLD");
    	obj.put("USER_INFO", userInfo);
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
