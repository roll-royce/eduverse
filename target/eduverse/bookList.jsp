<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book List - EduVerse</title>
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
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <h2 class="text-center">Available Books</h2>
        <div class="row mb-4">
            <div class="col-md-4">
                <input type="text" class="form-control" id="search" placeholder="Search by title or author">
            </div>
            <div class="col-md-4">
                <select class="form-control" id="category">
                    <option value="">All Categories</option>
                    <option value="Fiction">Fiction</option>
                    <option value="Non-fiction">Non-fiction</option>
                    <option value="Science">Science</option>
                    <option value="Technology">Technology</option>
                </select>
            </div>
            <div class="col-md-4">
                <button class="btn btn-primary w-100" onclick="filterBooks()">Filter</button>
            </div>
        </div>
        <div class="row" id="bookList">
            <%
                try (Connection conn = getConnection()) {
                    String query = "SELECT * FROM books";
                    try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                        ResultSet rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String title = rs.getString("title");
                            String author = rs.getString("author");
                            String description = rs.getString("description");
                            String category = rs.getString("category");
                            double price = rs.getDouble("price");
                            String filePath = rs.getString("file_path");
            %>
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= title %></h5>
                                        <h6 class="card-subtitle mb-2 text-muted"><%= author %></h6>
                                        <p class="card-text"><%= description %></p>
                                        <p class="card-text"><strong>Category:</strong> <%= category %></p>
                                        <p class="card-text"><strong>Price:</strong> $<%= price %></p>
                                        <a href="bookDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary">View Details</a>
                                    </div>
                                </div>
                            </div>
            <%
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
    <footer class="footer bg-dark text-white text-center py-3">
        <p>&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>
    <script>
        function filterBooks() {
            const search = document.getElementById('search').value.toLowerCase();
            const category = document.getElementById('category').value;
            const bookList = document.getElementById('bookList');
            const books = bookList.getElementsByClassName('col-md-4');

            for (let i = 0; i < books.length; i++) {
                const title = books[i].getElementsByClassName('card-title')[0].innerText.toLowerCase();
                const author = books[i].getElementsByClassName('card-subtitle')[0].innerText.toLowerCase();
                const bookCategory = books[i].getElementsByClassName('card-text')[2].innerText.split(': ')[1];

                if ((title.includes(search) || author.includes(search)) && (category === '' || bookCategory === category)) {
                    books[i].style.display = '';
                } else {
                    books[i].style.display = 'none';
                }
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>