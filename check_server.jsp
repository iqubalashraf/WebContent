<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.*" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
try{
    conn.close();
	JSONObject obj = new JSONObject();
    obj.put("STATUS", "3"); 
    obj.put("MSG", "Hello");
    String jsonString = obj.toJSONString();
    out.print(jsonString);
}catch (Exception e){
	if(conn != null){
		conn.close();
	}

    JSONObject obj = new JSONObject();
    obj.put("STATUS", "3"); 
    obj.put("MSG", "error");
    String jsonString = obj.toJSONString();
    out.print(jsonString);

}

%>
