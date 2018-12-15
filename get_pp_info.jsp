<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONArray" %>
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
    String user_id = request.getParameter("user_id");

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
    
    if(i>0){
            sql = "SELECT auth_id FROM users WHERE user_id='"+ user_id +"'";
            rs = stmt.executeQuery(sql);
            if(rs.next()){
                String auth_id_friend = rs.getString("auth_id");
                sql = "SELECT * FROM user_pics WHERE auth_id='"+ auth_id_friend +"'";
                rs = stmt.executeQuery(sql);
                JSONObject userInfo = new JSONObject();
                
                if(rs.next()){
                userInfo.put("ppm", rs.getString("ppm"));
                userInfo.put("ppmt", rs.getString("ppmt"));
                userInfo.put("pp1", rs.getString("pp1"));
                userInfo.put("pp1t", rs.getString("pp1t"));
                userInfo.put("pp2", rs.getString("pp2"));
                userInfo.put("pp2t", rs.getString("pp2t"));
                userInfo.put("pp3", rs.getString("pp3"));
                userInfo.put("pp3t", rs.getString("pp3t"));

                }

                JSONObject obj = new JSONObject();
                obj.put("STATUS", "0");
                obj.put("MSG", "SUCCESS");
                obj.put("USER_PP_INFO", userInfo);
                jsonString = obj.toJSONString();
                out.print(jsonString);
            
            }else{
            JSONObject obj = new JSONObject();
             obj.put("STATUS", "0");
             obj.put("MSG", "USER ID NOT exists");
             jsonString = obj.toJSONString();
             out.print(jsonString);
            }
    		 
    }else{
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "0");
	    obj.put("MSG", "AUTH FAILS");
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
