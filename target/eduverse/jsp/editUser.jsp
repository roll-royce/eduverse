<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<%
    if (session.getAttribute("userId") == null || !session.getAttribute("userRole").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = Integer.parseInt(request.getParameter("id"));
    String username = "";
    String email = "";
    String phone = "";
    String address = "";
    int age = 0;
    String gender = "";
    String occupation = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        username = request.getParameter("username");
        email = request.getParameter("email");
        phone = request.getParameter("phone");
        address = request.getParameter("address");
        age = Integer.parseInt(request.getParameter("age"));
        gender = request.getParameter("gender");
        occupation = request.getParameter("occupation");

        try (Connection conn = getConnection()) {
            String query = "UPDATE users SET username=?, email=?, phone=?, address=?, age=?, gender=?, occupation=? WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, address);
                pstmt.setInt(5, age);
                pstmt.setString(6, gender);
                pstmt.setString(7, occupation);
                pstmt.setInt(8, userId);

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("admin.jsp?message=User updated successfully.");
                } else {
                    request.setAttribute("errorMessage", "Failed to update user.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
        }
    } else {
        try (Connection conn = getConnection()) {
            String query = "SELECT * FROM users WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, userId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    username = rs.getString("username");
                    email = rs.getString("email");
                    phone = rs.getString("phone");
                    address = rs.getString("address");
                    age = rs.getInt("age");
                    gender = rs.getString("gender");
                    occupation = rs.getString("occupation");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - EduVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
        }
        .container {
            max-width: 600px;
            margin-top: 50px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">EduVerse</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="bookList.jsp">Books</a></li>
                    <li class="nav-item"><a class="nav-link" href="uploadBook.jsp">Upload</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="admin.jsp">Admin</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <h2 class="text-center">Edit User</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="editUser.jsp?id=<%= userId %>" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">Phone</label>
                <input type="text" class="form-control" id="phone" name="phone" value="<%= phone %>" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <textarea class="form-control" id="address" name="address" rows="3" required><%= address %></textarea>
            </div>
            <div class="mb-3">
                <label for="age" class="form-label">Age</label>
                <input type="number" class="form-control" id="age" name="age" value="<%= age %>" required>
            </div>
            <div class="mb-3">
                <label for="gender" class="form-label">Gender</label>
                <input type="text" class="form-control" id="gender" name="gender" value="<%= gender %>" required>
            </div>
            <div class="mb-3">
                <label for="occupation" class="form-label">Occupation</label>
                <input type="text" class="form-control" id="occupation" name="occupation" value="<%= occupation %>" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update User</button>
        </form>
    </div>
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>