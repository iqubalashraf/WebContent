
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject" %>
<%@page import="java.math.*" %>

<%
	try{
		String userName = request.getParameter("USERNAME");
		Class.forName("com.mysql.jdbc.Driver");
	    //Open Connection
	    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/BINBASKET","root","#786AllAh@786");
	    //System.out.println("Works"+userPhoneNo+passWord);
	    Statement stmt = conn.createStatement();
	    
	    //ResultSet rs = stmt.executeQuery(sql);
	    //String pass= "null";
	    //String name=null;
	    JSONObject obj = new JSONObject();
	    //while(rs.next()){
	        //pass = rs.getString("PASSWORD");
	    //}
	    if(true){
	        obj.put("STATUS", "0");
	        String sql = "SELECT * FROM "+userName;
	        ResultSet rs1 = stmt.executeQuery(sql);
	        int i = 0;
	        while(rs1.next()){
	        	System.out.println("Execute");
	        	String latitude = rs1.getString("LATITUDE");
	        	String longitude = rs1.getString("LONGITUDE");
	        	String date = rs1.getString("DATE");
	        	String time = rs1.getString("TIME");
	        	obj.put("LATITUDE"+Integer.toString(i), latitude);
	        	obj.put("LONGITUDE"+Integer.toString(i),longitude );
	        	obj.put("DATE"+Integer.toString(i), date);
	        	obj.put("TIME"+Integer.toString(i), time);
	        	i++;
	        }
	        obj.put("MAX", i);
	        String jsonString = obj.toJSONString();
	        out.print(jsonString);
	    }
	}catch (SQLException e) {
	    // Other SQL Exception
		System.out.println(e.getMessage());
		JSONObject obj = new JSONObject();
	    obj.put("STATUS", "3");
	    String jsonString = obj.toJSONString();
	    out.print(jsonString);
	}catch (Exception e){
		System.out.println(e.getMessage());
		JSONObject obj = new JSONObject();
	    obj.put("STATUS", "4");
	    String jsonString = obj.toJSONString();
	    out.print(jsonString);
	}
%>