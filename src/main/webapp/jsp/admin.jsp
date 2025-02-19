<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

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

    String action = request.getParameter("action");
    String message = "";

    if ("deleteBook".equals(action)) {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        try (Connection conn = getConnection()) {
            String query = "DELETE FROM books WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, bookId);
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    message = "Book deleted successfully.";
                } else {
                    message = "Failed to delete book.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "An error occurred. Please try again.";
        }
    } else if ("deleteUser".equals(action)) {
        int userId = Integer.parseInt(request.getParameter("userId"));
        try (Connection conn = getConnection()) {
            String query = "DELETE FROM users WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, userId);
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    message = "User deleted successfully.";
                } else {
                    message = "Failed to delete user.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "An error occurred. Please try again.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - EduVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
        }
        .container {
            margin-top: 50px;
        }
        .card {
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
        <h2 class="text-center">Admin Panel</h2>
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>
        <div class="row">
            <div class="col-md-6">
                <h3>Manage Books</h3>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = getConnection()) {
                                String query = "SELECT * FROM books";
                                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                                    ResultSet rs = pstmt.executeQuery();
                                    while (rs.next()) {
                                        int bookId = rs.getInt("id");
                                        String title = rs.getString("title");
                                        String author = rs.getString("author");
                                        String category = rs.getString("category");
                                        double price = rs.getDouble("price");
                        %>
                        <tr>
                            <td><%= title %></td>
                            <td><%= author %></td>
                            <td><%= category %></td>
                            <td>$<%= price %></td>
                            <td>
                                <a href="editBook.jsp?id=<%= bookId %>" class="btn btn-warning btn-sm">Edit</a>
                                <a href="admin.jsp?action=deleteBook&bookId=<%= bookId %>" class="btn btn-danger btn-sm">Delete</a>
                            </td>
                        </tr>
                        <%
                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <h3>Manage Users</h3>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = getConnection()) {
                                String query = "SELECT * FROM users";
                                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                                    ResultSet rs = pstmt.executeQuery();
                                    while (rs.next()) {
                                        int userId = rs.getInt("id");
                                        String username = rs.getString("username");
                                        String email = rs.getString("email");
                                        String phone = rs.getString("phone");
                        %>
                        <tr>
                            <td><%= username %></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                            <td>
                                <a href="editUser.jsp?id=<%= userId %>" class="btn btn-warning btn-sm">Edit</a>
                                <a href="admin.jsp?action=deleteUser&userId=<%= userId %>" class="btn btn-danger btn-sm">Delete</a>
                            </td>
                        </tr>
                        <%
                                    }
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>