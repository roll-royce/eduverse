<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/path/to/your/database.accdb");
    }
%>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try (Connection conn = getConnection()) {
        String query = "SELECT * FROM users WHERE email=? AND password=?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password); // In production, use password hashing

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userEmail", email);
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>