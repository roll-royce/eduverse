<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/eduverse", "pie69", "pie69");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book List - EduVerse</title>
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
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .search-bar {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        .price-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #4CAF50;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .category-badge {
            background: #2196F3;
            color: white;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
        }
        .book-stats {
            font-size: 0.9rem;
            color: #666;
        }
        footer {
            margin-top: auto;
            padding: 20px 0;
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
                    <li class="nav-item"><a class="nav-link active" href="bookList.jsp"><i class="bi bi-journal-text"></i> Books</a></li>
                    <li class="nav-item"><a class="nav-link" href="uploadBook.jsp"><i class="bi bi-upload"></i> Upload</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp"><i class="bi bi-person-plus"></i> Register</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp"><i class="bi bi-box-arrow-in-right"></i> Login</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="text-center mb-4">Discover Books</h2>
        
        <!-- Search and Filter Section -->
        <div class="search-bar">
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="text" class="form-control" id="search" placeholder="Search by title or author">
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-tag"></i></span>
                        <select class="form-select" id="category">
                            <option value="">All Categories</option>
                            <option value="Fiction">Fiction</option>
                            <option value="Non-fiction">Non-fiction</option>
                            <option value="Science">Science</option>
                            <option value="Technology">Technology</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-sort-down"></i></span>
                        <select class="form-select" id="sort">
                            <option value="newest">Newest First</option>
                            <option value="price-low">Price: Low to High</option>
                            <option value="price-high">Price: High to Low</option>
                            <option value="title">Title: A-Z</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-2">
                    <button class="btn btn-primary w-100" onclick="filterBooks()">
                        <i class="bi bi-funnel"></i> Filter
                    </button>
                </div>
            </div>
        </div>

        <!-- Books Grid -->
        <div class="row" id="bookList">
            <%
                try (Connection conn = getConnection()) {
                    String query = "SELECT b.*, COUNT(DISTINCT r.id) as review_count, AVG(r.rating) as avg_rating " +
                                 "FROM books b LEFT JOIN book_ratings r ON b.id = r.book_id " +
                                 "GROUP BY b.id ORDER BY b.created_at DESC";
                    try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                        ResultSet rs = pstmt.executeQuery();
                        while (rs.next()) {
                            String title = rs.getString("title");
                            String author = rs.getString("author");
                            String description = rs.getString("description");
                            String category = rs.getString("category");
                            double price = rs.getDouble("price");
                            int reviewCount = rs.getInt("review_count");
                            double avgRating = rs.getDouble("avg_rating");
            %>
                            <div class="col-md-4 mb-4 book-item">
                                <div class="card h-100">
                                    <div class="price-badge">₹<%= String.format("%.2f", price) %></div>
                                    <div class="card-body">
                                        <h5 class="card-title text-primary"><%= title %></h5>
                                        <h6 class="card-subtitle mb-2 text-muted"><i class="bi bi-person"></i> <%= author %></h6>
                                        <span class="category-badge mb-2 d-inline-block"><%= category %></span>
                                        <p class="card-text text-truncate"><%= description %></p>
                                        <div class="book-stats mb-3">
                                            <i class="bi bi-star-fill text-warning"></i>
                                            <%= String.format("%.1f", avgRating > 0 ? avgRating : 0) %>
                                            <span class="ms-2">
                                                <i class="bi bi-chat-text"></i>
                                                <%= reviewCount %> reviews
                                            </span>
                                        </div>
                                        <div class="d-grid gap-2">
                                            <a href="bookDetails.jsp?id=<%= rs.getInt("id") %>" class="btn btn-outline-primary">
                                                <i class="bi bi-info-circle"></i> View Details
                                            </a>
                                        </div>
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

    <footer class="bg-dark text-white text-center py-3">
        <p class="mb-0">&copy; 2025 EduVerse. All Rights Reserved.</p>
    </footer>

    <script>
        function filterBooks() {
            const search = document.getElementById('search').value.toLowerCase();
            const category = document.getElementById('category').value;
            const sort = document.getElementById('sort').value;
            const books = document.getElementsByClassName('book-item');
            const booksArray = Array.from(books);

            booksArray.forEach(book => {
                const title = book.querySelector('.card-title').innerText.toLowerCase();
                const author = book.querySelector('.card-subtitle').innerText.toLowerCase();
                const bookCategory = book.querySelector('.category-badge').innerText;
                const price = parseFloat(book.querySelector('.price-badge').innerText.replace('₹', ''));

                const matchesSearch = title.includes(search) || author.includes(search);
                const matchesCategory = category === '' || bookCategory === category;
                book.style.display = matchesSearch && matchesCategory ? '' : 'none';
            });

            // Sort books
            const bookList = document.getElementById('bookList');
            const visibleBooks = booksArray.filter(book => book.style.display !== 'none');

            visibleBooks.sort((a, b) => {
                const priceA = parseFloat(a.querySelector('.price-badge').innerText.replace('₹', ''));
                const priceB = parseFloat(b.querySelector('.price-badge').innerText.replace('₹', ''));
                const titleA = a.querySelector('.card-title').innerText;
                const titleB = b.querySelector('.card-title').innerText;

                switch(sort) {
                    case 'price-low': return priceA - priceB;
                    case 'price-high': return priceB - priceA;
                    case 'title': return titleA.localeCompare(titleB);
                    default: return 0;
                }
            });

            visibleBooks.forEach(book => bookList.appendChild(book));
        }

        // Add event listeners for real-time filtering
        document.getElementById('search').addEventListener('input', filterBooks);
        document.getElementById('category').addEventListener('change', filterBooks);
        document.getElementById('sort').addEventListener('change', filterBooks);
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>