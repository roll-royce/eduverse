<!-- filepath: /c:/Users/Yashv/eduverse/src/main/webapp/bookDetails.jsp -->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/eduverse", "pie69", "pie69");
    }
%>

<%
    int bookId = 0;
    try {
        bookId = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("bookList.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Details - EduVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container {
            margin-top: 50px;
            flex: 1;
        }
        .book-cover {
            max-width: 100%;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .price-tag {
            background: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 1.2rem;
            display: inline-block;
            margin: 10px 0;
        }
        .review-card {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .star-rating {
            color: #ffc107;
        }
        .book-meta {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="bi bi-book"></i> EduVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="bookList.jsp"><i class="bi bi-journal-text"></i> Books</a></li>
                    <li class="nav-item"><a class="nav-link" href="uploadBook.jsp"><i class="bi bi-upload"></i> Upload</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp"><i class="bi bi-person-plus"></i> Register</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="bi bi-box-arrow-in-right"></i> Login</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <%
            try (Connection conn = getConnection()) {
                String query = "SELECT b.*, u.username as seller_name, " +
                             "COUNT(DISTINCT r.id) as review_count, AVG(r.rating) as avg_rating " +
                             "FROM books b " +
                             "LEFT JOIN users u ON b.user_id = u.id " +
                             "LEFT JOIN book_ratings r ON b.id = r.book_id " +
                             "WHERE b.id = ? " +
                             "GROUP BY b.id";
                             
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setInt(1, bookId);
                    ResultSet rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
        %>
                        <div class="row">
                            <div class="col-md-4">
                                <img src="<%= rs.getString("cover_image") != null ? rs.getString("cover_image") : "images/default-book.jpg" %>" 
                                     alt="<%= rs.getString("title") %>" class="book-cover mb-3">
                                <div class="price-tag">
                                    ₹<%= String.format("%.2f", rs.getDouble("price")) %>
                                </div>
                                <div class="d-grid gap-2">
                                    <button onclick="addToCart(<%= bookId %>)" class="btn btn-success btn-lg">
                                        <i class="bi bi-cart-plus"></i> Add to Cart
                                    </button>
                                    <button onclick="addToWishlist(<%= bookId %>)" class="btn btn-outline-primary">
                                        <i class="bi bi-heart"></i> Add to Wishlist
                                    </button>
                                </div>
                            </div>
                            
                            <div class="col-md-8">
                                <div class="book-meta">
                                    <h2><%= rs.getString("title") %></h2>
                                    <p class="text-muted">By <%= rs.getString("author") %></p>
                                    <div class="mb-3">
                                        <span class="badge bg-primary"><%= rs.getString("category") %></span>
                                        <span class="ms-2 star-rating">
                                            <%
                                                double avgRating = rs.getDouble("avg_rating");
                                                for(int i = 1; i <= 5; i++) {
                                            %>
                                                <i class="bi bi-star<%= avgRating >= i ? "-fill" : "" %>"></i>
                                            <% } %>
                                            <span class="text-muted">(<%= rs.getInt("review_count") %> reviews)</span>
                                        </span>
                                    </div>
                                    <h5>Description</h5>
                                    <p><%= rs.getString("description") %></p>
                                    <hr>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5>Book Details</h5>
                                            <ul class="list-unstyled">
                                                <li><strong>Format:</strong> <%= rs.getString("format") %></li>
                                                <li><strong>Language:</strong> <%= rs.getString("language") %></li>
                                                <li><strong>Published:</strong> <%= rs.getDate("created_at") %></li>
                                                <li><strong>Seller:</strong> <%= rs.getString("seller_name") %></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <!-- Reviews Section -->
                                <h4>Reviews</h4>
                                <%
                                    String reviewQuery = "SELECT r.*, u.username FROM book_ratings r " +
                                                       "JOIN users u ON r.user_id = u.id " +
                                                       "WHERE r.book_id = ? ORDER BY r.created_at DESC LIMIT 5";
                                    try (PreparedStatement reviewStmt = conn.prepareStatement(reviewQuery)) {
                                        reviewStmt.setInt(1, bookId);
                                        ResultSet reviewRs = reviewStmt.executeQuery();
                                        
                                        while(reviewRs.next()) {
                                %>
                                            <div class="review-card">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6><%= reviewRs.getString("username") %></h6>
                                                        <div class="star-rating">
                                                            <% for(int i = 1; i <= 5; i++) { %>
                                                                <i class="bi bi-star<%= reviewRs.getInt("rating") >= i ? "-fill" : "" %>"></i>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    <small class="text-muted">
                                                        <%= reviewRs.getTimestamp("created_at") %>
                                                    </small>
                                                </div>
                                                <p class="mt-2 mb-0"><%= reviewRs.getString("review") %></p>
                                            </div>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>
        <%
                    } else {
                        response.sendRedirect("bookList.jsp");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <div class="alert alert-danger">
                    Error loading book details. Please try again later.
                </div>
        <%
            }
        %>
    </div>

    <footer class="bg-dark text-white text-center py-3">
        <p class="mb-0">&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCart(bookId) {
            // Add your cart functionality here
            alert('Book added to cart!');
        }

        function addToWishlist(bookId) {
            // Add your wishlist functionality here
            alert('Book added to wishlist!');
        }
    </script>
</body>
</html>