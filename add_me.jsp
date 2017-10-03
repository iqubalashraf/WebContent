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
	final String VERIFIED = "0";
	String country = request.getParameter("country");
	String age = request.getParameter("age");
	int age_in_int = Integer.parseInt(age);
	String dob = request.getParameter("date_of_birth");
	String gender = request.getParameter("gender");
	String hasProPic = request.getParameter("hasProfilePic");
	int hasProPic_int = Integer.parseInt(hasProPic);
	String hasVerProPic = request.getParameter("hasVerifiedProfilePic");
	int hasVerProPic_int = Integer.parseInt(hasProPic);
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String profile_pic_1 = request.getParameter("profile_pic");
	String profile_pic_1_thumb = request.getParameter("profile_pic_thumbnail");
	String profile_pic_2 = request.getParameter("profile_pic_2");
	String profile_pic_2_thumb = request.getParameter("profile_pic_2_thumbnail");
	String profile_pic_3 = request.getParameter("profile_pic_3");
	String profile_pic_3_thumb = request.getParameter("profile_pic_3_thumbnail");
	String profile_pic_main = request.getParameter("profile_pic_main");
	String profile_pic_main_thumb = request.getParameter("profile_pic_main_thumbnail");
	String uid = request.getParameter("uid");
	/* String unix_time = request.getParameter("unix_time"); */
	String unix_time = String.valueOf(new Date().getTime());
	String login_type = request.getParameter("login_type");
	
	if(uid.equals("")){
		JSONObject obj = new JSONObject();
	    obj.put("STATUS", "5");
	    obj.put("MSG", "UID NULL");
	    String jsonString = obj.toJSONString();
	    out.print(jsonString);	
	    return;
	}
	
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
    	String sql = "INSERT INTO UPDATE_ME_LIST (AGE, COUNTRY, DOB, GENDER, HAS_PROFILE_PIC, HAS_VERIFIED_PROFILE_PIC, ID, NAME, PROFILE_PIC_MAIN,"+
    		    " PROFILE_PIC_MAIN_THUMB, PROFILE_PIC_1, PROFILE_PIC_1_THUMB, PROFILE_PIC_2, PROFILE_PIC_2_THUMB, PROFILE_PIC_3, PROFILE_PIC_3_THUMB, UID, UNIX_TIME,"+
    		  	" LOGIN_TYPE)  VALUES("+
    		    age_in_int+",'"+country+"','"+dob+"','"+gender+"',"+hasProPic_int+","+hasVerProPic_int+",'"+id+"','"+name+"','"+profile_pic_main+"','"+profile_pic_main_thumb+
    		    "','"+profile_pic_1+"','"+profile_pic_1_thumb+"','"+profile_pic_2+"','"+profile_pic_2_thumb+"','"+profile_pic_3+
    		    "','"+profile_pic_3_thumb+"','"+uid+"','"+unix_time+"','"+login_type+"')";
    		    stmt.executeUpdate(sql);
    		    JSONObject obj = new JSONObject();
    		    obj.put("STATUS", "0");
    		    obj.put("MSG", "ADDED SUCCESSFULLY");
    		    String jsonString = obj.toJSONString();
    		    out.print(jsonString);
    }else{
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "4");
	    obj.put("MSG", "Already Exists");
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
