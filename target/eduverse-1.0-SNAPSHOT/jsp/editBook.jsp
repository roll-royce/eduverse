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

    int bookId = Integer.parseInt(request.getParameter("id"));
    String title = "";
    String author = "";
    String description = "";
    String category = "";
    double price = 0.0;
    String filePath = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        title = request.getParameter("title");
        author = request.getParameter("author");
        description = request.getParameter("description");
        category = request.getParameter("category");
        price = Double.parseDouble(request.getParameter("price"));
        filePath = request.getParameter("filePath");

        try (Connection conn = getConnection()) {
            String query = "UPDATE books SET title=?, author=?, description=?, category=?, price=?, file_path=? WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setString(1, title);
                pstmt.setString(2, author);
                pstmt.setString(3, description);
                pstmt.setString(4, category);
                pstmt.setDouble(5, price);
                pstmt.setString(6, filePath);
                pstmt.setInt(7, bookId);

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("admin.jsp?message=Book updated successfully.");
                } else {
                    request.setAttribute("errorMessage", "Failed to update book.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
        }
    } else {
        try (Connection conn = getConnection()) {
            String query = "SELECT * FROM books WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, bookId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    title = rs.getString("title");
                    author = rs.getString("author");
                    description = rs.getString("description");
                    category = rs.getString("category");
                    price = rs.getDouble("price");
                    filePath = rs.getString("file_path");
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
    <title>Edit Book - EduVerse</title>
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
        <h2 class="text-center">Edit Book</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="editBook.jsp?id=<%= bookId %>" method="post">
            <div class="mb-3">
                <label for="title" class="form-label">Book Title</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= title %>" required>
            </div>
            <div class="mb-3">
                <label for="author" class="form-label">Author</label>
                <input type="text" class="form-control" id="author" name="author" value="<%= author %>" required>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3" required><%= description %></textarea>
            </div>
            <div class="mb-3">
                <label for="category" class="form-label">Category</label>
                <select class="form-control" id="category" name="category" required>
                    <option value="Fiction" <%= "Fiction".equals(category) ? "selected" : "" %>>Fiction</option>
                    <option value="Non-fiction" <%= "Non-fiction".equals(category) ? "selected" : "" %>>Non-fiction</option>
                    <option value="Science" <%= "Science".equals(category) ? "selected" : "" %>>Science</option>
                    <option value="Technology" <%= "Technology".equals(category) ? "selected" : "" %>>Technology</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="price" class="form-label">Price (INR)</label>
                <input type="number" class="form-control" id="price" name="price" step="0.01" value="<%= price %>" required>
            </div>
            <div class="mb-3">
                <label for="filePath" class="form-label">File Path</label>
                <input type="text" class="form-control" id="filePath" name="filePath" value="<%= filePath %>" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update Book</button>
        </form>
    </div>
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>