<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.*" %>
<%@page import="java.math.*" %>
<%@page import="java.util.Date" %>
<%@page import="org.springframework.dao.DataIntegrityViolationException" %>
<%
Connection conn = null;
try{
	
	String uid = request.getParameter("uid");
	String friend_uid = request.getParameter("friend_uid");
	String unix_time = String.valueOf(new Date().getTime());
	
	Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/S2S","root","AllAh@786");
    Statement stmt = conn.createStatement();
    String sql1 = "SELECT * FROM UPDATE_ME_LIST WHERE UID='"+ uid +"'";
    ResultSet rs1 = stmt.executeQuery(sql1);
    int i = 0;
    while(rs1.next()){
        i++;
    }
    if(i==0){
    	JSONObject obj = new JSONObject();
	    obj.put("STATUS", "4");
	    obj.put("MSG", "USER DOSN'T EXIST");
	    String jsonString = obj.toJSONString();
	    out.print(jsonString);
    }else{
    	String sql2 = "UPDATE UPDATE_ME_LIST SET UNIX_TIME='"+unix_time+"' WHERE UID= '"+ uid + "'";
    	stmt.executeUpdate(sql2);
    	String sql = "SELECT * FROM UPDATE_ME_LIST WHERE UID = '"+ friend_uid + "'";
    	ResultSet rs = stmt.executeQuery(sql);
    	JSONArray jsonArray = new JSONArray();
    	i =0;
    	while(rs.next()){
    		JSONObject obj = new JSONObject();
    		obj.put("age", rs.getString("AGE"));
    		obj.put("country", rs.getString("COUNTRY"));
    		obj.put("date_of_birth", rs.getString("DOB"));
    		obj.put("gender", rs.getString("GENDER"));
    		obj.put("hasProfilePic", rs.getString("HAS_PROFILE_PIC"));
    		obj.put("hasVerifiedProfilePic", rs.getString("HAS_VERIFIED_PROFILE_PIC"));
    		obj.put("id", rs.getString("ID"));
    		obj.put("name", rs.getString("NAME"));
    		obj.put("profile_pic_main", rs.getString("PROFILE_PIC_MAIN"));
    		obj.put("profile_pic_main_thumbnail", rs.getString("PROFILE_PIC_MAIN_THUMB"));
    		obj.put("profile_pic", rs.getString("PROFILE_PIC_1"));
    		obj.put("profile_pic_thumbnail", rs.getString("PROFILE_PIC_1_THUMB"));
    		obj.put("profile_pic_2", rs.getString("PROFILE_PIC_2"));
    		obj.put("profile_pic_2_thumbnail", rs.getString("PROFILE_PIC_2_THUMB"));
    		obj.put("profile_pic_3", rs.getString("PROFILE_PIC_3"));
    		obj.put("profile_pic_3_thumbnail", rs.getString("PROFILE_PIC_3_THUMB"));
    		obj.put("uid", rs.getString("UID"));
    		obj.put("unix_time", rs.getString("UNIX_TIME"));
    		obj.put("login_type", rs.getString("LOGIN_TYPE"));
    		jsonArray.add(i, obj);
    		i++;
    	}
	    String jsonArrayString = jsonArray.toJSONString();
	    JSONObject obj = new JSONObject();
	    obj.put("STATUS", "0");
	    obj.put("MSG", "SUCCESSFULLY");
	    obj.put("LIST", jsonArray);
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
