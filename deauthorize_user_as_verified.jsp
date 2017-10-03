<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
try{

    final String USER_NAME = "main_user_which_no_body_guess";
    final String USER_PASS = "password_should_be_secure_so_that_no_body_can_guess_it";
	final String NOT_VERIFIED = "0";
	final String VERIFIED = "1";
	String uid = request.getParameter("uid");
	String user_name = request.getParameter("user_name");
	String password = request.getParameter("password");
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
    	if(user_name.equals(USER_NAME) && password.equals(USER_PASS)){
    		String sql = "UPDATE UPDATE_ME_LIST SET UNIX_TIME='"+unix_time
        			+"', HAS_PROFILE_PIC="+ NOT_VERIFIED+ " ,HAS_VERIFIED_PROFILE_PIC="+NOT_VERIFIED+" WHERE UID= '"+ uid + "'";
        	stmt.executeUpdate(sql);
        	JSONObject obj = new JSONObject();
    	    obj.put("STATUS", "0");
    	    obj.put("MSG", "UPDATED SUCCESSFULLY");
    	    String jsonString = obj.toJSONString();
    	    out.print(jsonString);
    	}else{
    		JSONObject obj = new JSONObject();
    	    obj.put("STATUS", "5");
    	    obj.put("MSG", "INVALID USER NAME PASSWORD");
    	    String jsonString = obj.toJSONString();
    	    out.print(jsonString);
    	}
    	
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
