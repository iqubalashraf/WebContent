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
    String ppm = request.getParameter("ppm");
    String ppmt = request.getParameter("ppmt");

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

    String sql = "SELECT * FROM user_pics WHERE auth_id='"+ auth_id +"'";
    ResultSet rs = stmt.executeQuery(sql);

	int i = 0;
    while(rs.next()){
   		i++;
    }
    
    if(i==0){

            String addQuery = "INSERT INTO user_pics (auth_id, ppm, ppmt, pp1, pp1t, pp2, pp2t, pp3, pp3t)"+
                " VALUES( '"+ 
                auth_id + "','" + ppm + "','" + ppmt + "','','' ,'','','','')";
             stmt.executeUpdate(addQuery);
    		 JSONObject obj = new JSONObject();
    		 obj.put("STATUS", "0");
    		 obj.put("MSG", "Added");
    		 jsonString = obj.toJSONString();
    		 out.print(jsonString);
    }else{
        String updateQuery = "UPDATE user_pics SET ppm='" + ppm + "', ppmt='"+ ppmt +
                "' WHERE auth_id= '"+ auth_id + "'";
        stmt.executeUpdate(updateQuery);
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "0");
	    obj.put("MSG", "Updated");
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
