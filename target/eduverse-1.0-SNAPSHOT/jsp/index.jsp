<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<%
    String userName = "";
    if (session.getAttribute("userId") != null) {
        int userId = (Integer) session.getAttribute("userId");
        try (Connection conn = getConnection()) {
            String query = "SELECT username FROM users WHERE id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                pstmt.setInt(1, userId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    userName = rs.getString("username");
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
    <title>EduVerse - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
        }
        .hero {
            text-align: center;
            padding: 50px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }
        .footer {
            background-color: #343a40;
            color: white;
            text-align: center;
            padding: 10px;
            margin-top: 30px;
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
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="hero">
            <h1>Welcome <%= userName %> to EduVerse</h1>
            <p>Discover, upload, and sell e-books easily.</p>
            <a href="bookList.jsp" class="btn btn-primary">Explore Books</a>
            <a href="uploadBook.jsp" class="btn btn-success">Upload Your Book</a>
        </div>
        <div class="row mt-5">
            <%
                try (Connection conn = getConnection()) {
                    String query = "SELECT * FROM books LIMIT 15";
                    try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                        ResultSet rs = pstmt.executeQuery();
                        int count = 0;
                        while (rs.next()) {
                            String title = rs.getString("title");
                            String author = rs.getString("author");
                            String description = rs.getString("description");
                            String category = rs.getString("category");
                            double price = rs.getDouble("price");
                            String filePath = rs.getString("file_path");
                            if (count % 3 == 0) {
                                out.println("<div class='row'>");
                            }
            %>
                            <div class="col-md-4">
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= title %></h5>
                                        <h6 class="card-subtitle mb-2 text-muted"><%= author %></h6>
                                        <p class="card-text"><%= description %></p>
                                        <p class="card-text"><strong>Category:</strong> <%= category %></p>
                                        <p class="card-text"><strong>Price:</strong> $<%= price %></p>
                                        <a href="<%= filePath %>" class="btn btn-primary" download>Download PDF</a>
                                    </div>
                                </div>
                            </div>
            <%
                            if (count % 3 == 2) {
                                out.println("</div>");
                            }
                            count++;
                        }
                        if (count == 0) {
                            out.println("<div class='col-md-4'><div class='card mb-4'><div class='card-body'><h5 class='card-title'>Books coming soon</h5></div></div></div>");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
    <footer class="footer">
        <p>&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>