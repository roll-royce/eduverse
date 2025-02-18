<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="javax.xml.bind.DatatypeConverter" %>
<%@ page import="java.util.Date" %>

<%!
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(password.getBytes("UTF-8"));
        return DatatypeConverter.printHexBinary(digest);
    }
    
    private void logLoginAttempt(Connection conn, int userId, String email, boolean success, String ipAddress) {
        try {
            String query = "INSERT INTO login_attempts (user_id, email, success, ip_address, attempt_time) VALUES (?, ?, ?, ?, NOW())";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId);
            pstmt.setString(2, email);
            pstmt.setBoolean(3, success);
            pstmt.setString(4, ipAddress);
            pstmt.executeUpdate();
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
    // Get client IP address for security logging
    String ipAddress = request.getHeader("X-FORWARDED-FOR");
    if (ipAddress == null) {
        ipAddress = request.getRemoteAddr();
    }

    try {
        // Input validation
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=missing_fields");
            return;
        }

        email = email.trim().toLowerCase();
        
        // Database connection with proper resource management
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/eduverse?useSSL=false",
                "root", "password")) {

            // Check for too many failed attempts
            String checkAttempts = "SELECT COUNT(*) FROM login_attempts WHERE email=? AND success=false AND attempt_time > DATE_SUB(NOW(), INTERVAL 30 MINUTE)";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkAttempts)) {
                checkStmt.setString(1, email);
                ResultSet attemptRs = checkStmt.executeQuery();
                if(attemptRs.next() && attemptRs.getInt(1) >= 5) {
                    response.sendRedirect("login.jsp?error=too_many_attempts");
                    return;
                }
            }

            // Check credentials
            String query = "SELECT id, username, password, active FROM users WHERE email=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, email);
                ResultSet rs = pstmt.executeQuery();

                if(rs.next()) {
                    String hashedPassword = hashPassword(password);
                    if(rs.getString("password").equals(hashedPassword)) {
                        // Check if account is active
                        if(!rs.getBoolean("active")) {
                            logLoginAttempt(conn, rs.getInt("id"), email, false, ipAddress);
                            response.sendRedirect("login.jsp?error=account_inactive");
                            return;
                        }

                        // Successful login
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("userEmail", email);
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("loginTime", new Date());

                        // Update last login time
                        String updateQuery = "UPDATE users SET last_login=NOW() WHERE id=?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                            updateStmt.setInt(1, rs.getInt("id"));
                            updateStmt.executeUpdate();
                        }

                        logLoginAttempt(conn, rs.getInt("id"), email, true, ipAddress);
                        response.sendRedirect("index.jsp");
                    } else {
                        logLoginAttempt(conn, rs.getInt("id"), email, false, ipAddress);
                        response.sendRedirect("login.jsp?error=invalid_credentials");
                    }
                } else {
                    logLoginAttempt(conn, 0, email, false, ipAddress);
                    response.sendRedirect("login.jsp?error=invalid_credentials");
                }
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=system_error");
    }
%>