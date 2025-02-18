<!-- filepath: /c:/Users/Yashv/eduverse/src/main/webapp/testConnection.jsp -->
<%@ page import="java.sql.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<%
    try (Connection conn = getConnection()) {
        out.println("Connection successful!");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Connection failed: " + e.getMessage());
    }
%>