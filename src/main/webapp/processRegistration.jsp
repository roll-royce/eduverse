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
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    int age = Integer.parseInt(request.getParameter("age"));
    String gender = request.getParameter("gender");
    String occupation = request.getParameter("occupation");
    String hashedPassword = PasswordUtil.hashPassword(password);

    try (Connection conn = getConnection()) {
        String query = "INSERT INTO users (username, email, password, phone, address, age, gender, occupation, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);
            pstmt.setInt(6, age);
            pstmt.setString(7, gender);
            pstmt.setString(8, occupation);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                response.sendRedirect("login.jsp?registered=success");
            } else {
                response.sendRedirect("register.jsp?error=registration_failed");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=system_error");
    }
%>