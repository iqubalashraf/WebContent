<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
try{
	final String NOT_VERIFIED = "0";
	final String VERIFIED = "1";
	String profile_pic_main = request.getParameter("profile_pic_main");
	String profile_pic_main_thumb = request.getParameter("profile_pic_main_thumbnail");
	String uid = request.getParameter("uid");
	/* String unix_time = request.getParameter("unix_time"); */
	String unix_time = String.valueOf(new Date().getTime());
	
	Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/S2S","root","AllAh@786");
    Statement stmt = conn.createStatement();
    String sql1 = "SELECT * FROM UPDATE_ME_LIST WHERE UID='"+ uid +"'";
    ResultSet rs = stmt.executeQuery(sql1);
    int i = 0;
    while(rs.next()){
        i++;
    }
    if(i==0){
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "4");
	    obj.put("MSG", "USER DOSN'T EXIST");
	    String jsonString = obj.toJSONString();
	    out.print(jsonString);
    }else{
    	String sql = "UPDATE UPDATE_ME_LIST SET UNIX_TIME='"+unix_time+"', PROFILE_PIC_MAIN='"+ profile_pic_main+ "' ,PROFILE_PIC_MAIN_THUMB='"+profile_pic_main_thumb
    			+"', HAS_PROFILE_PIC="+ VERIFIED+ " ,HAS_VERIFIED_PROFILE_PIC="+NOT_VERIFIED+" WHERE UID= '"+ uid + "'";
    	stmt.executeUpdate(sql);
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "0");
	    obj.put("MSG", "UPDATED SUCCESSFULLY");
	    String jsonString = obj.toJSONString();
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
