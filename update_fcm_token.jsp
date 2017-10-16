<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
try{
	String fcm_token = request.getParameter("fcm_token");
	String uid = request.getParameter("uid");
	String unix_time = String.valueOf(new Date().getTime());
	Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/S2S","root","AllAh@786");
    Statement stmt = conn.createStatement();
    
	String sql = "SELECT * FROM FCM_TOKENS WHERE UID='"+ uid +"'";
	ResultSet rs = stmt.executeQuery(sql);
	int i = 0;
    while(rs.next()){
        i++;
    }
    if(i==0){
    	sql = "INSERT INTO FCM_TOKENS(UID, TOKEN) VALUES('"+uid+"','"+fcm_token+"')";
    	stmt.executeUpdate(sql);
    }else{
    	sql = "UPDATE FCM_TOKENS SET TOKEN='"+fcm_token+"' WHERE UID= '"+ uid + "'";
    	stmt.executeUpdate(sql);
    }
    sql = "UPDATE UPDATE_ME_LIST SET UNIX_TIME='"+unix_time+"' WHERE UID= '"+ uid + "'";
	stmt.executeUpdate(sql);
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "0");
    obj.put("MSG", "TOKEN UPDATED SUCCESSFULLY");
    String jsonString = obj.toJSONString();
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
    String jsonString = obj.toJSONString();
    out.print(jsonString);
} catch (SQLException e) {
	if(conn != null){
		conn.close();
	}
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "2");
    obj.put("MSG", e.getMessage());
    String jsonString = obj.toJSONString();
    out.print(jsonString);
}catch (Exception e){
	if(conn != null){
		conn.close();
	}
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "3"); 
    obj.put("MSG", e.getMessage());
    String jsonString = obj.toJSONString();
    out.print(jsonString);
}

%>
