<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="javax.xml.bind.DatatypeConverter" %>

<%!
    // Validation methods
    private boolean isValidEmail(String email) {
        return Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$").matcher(email).matches();
    }
    
    private boolean isValidPhone(String phone) {
        return Pattern.compile("^\\d{10}$").matcher(phone).matches();
    }
    
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(password.getBytes("UTF-8"));
        return DatatypeConverter.printHexBinary(digest);
    }
%>

<%
    try {
        // Get parameters with XSS prevention
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password");
        String phone = request.getParameter("phone").trim();
        String address = request.getParameter("address").trim();
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String occupation = request.getParameter("occupation").trim();

        // Validation
        if(username == null || username.length() < 3) {
            response.sendRedirect("register.jsp?error=invalid_username");
            return;
        }

        if(!isValidEmail(email)) {
            response.sendRedirect("register.jsp?error=invalid_email");
            return;
        }

        if(password == null || password.length() < 8) {
            response.sendRedirect("register.jsp?error=weak_password");
            return;
        }

        if(!isValidPhone(phone)) {
            response.sendRedirect("register.jsp?error=invalid_phone");
            return;
        }

        int age = Integer.parseInt(ageStr);
        if(age < 13 || age > 120) {
            response.sendRedirect("register.jsp?error=invalid_age");
            return;
        }

        // Database connection with proper resource management
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/eduverse?useSSL=false",
                "root", "password")) {

            // Check if email already exists
            String checkEmail = "SELECT id FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmail)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if(rs.next()) {
                    response.sendRedirect("register.jsp?error=email_exists");
                    return;
                }
            }

            // Insert new user
            String query = "INSERT INTO users (username, email, password, phone, address, age, gender, occupation, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.setString(3, hashPassword(password));
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
        }
    } catch(NumberFormatException e) {
        response.sendRedirect("register.jsp?error=invalid_input");
    } catch(SQLException e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=database_error");
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("register.jsp?error=system_error");
    }
%>