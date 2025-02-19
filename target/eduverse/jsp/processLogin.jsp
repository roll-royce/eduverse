<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.example.eduverse.util.PasswordUtil" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try (Connection conn = getConnection()) {
        String query = "SELECT * FROM users WHERE email=?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (PasswordUtil.checkPassword(password, hashedPassword)) {
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userEmail", email);
                    response.sendRedirect("index.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=1");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>