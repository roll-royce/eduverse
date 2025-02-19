<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<%!
    private Connection getConnection() throws Exception {
        Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
        return DriverManager.getConnection("jdbc:ucanaccess://C:/Users/Yashv/OneDrive/Desktop/eduverse.accdb");
    }
%>

<%
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);

            List<String> titles = new ArrayList<>();
            List<String> authors = new ArrayList<>();
            List<String> descriptions = new ArrayList<>();
            List<String> categories = new ArrayList<>();
            List<Double> prices = new ArrayList<>();
            List<String> fileNames = new ArrayList<>();

            for(FileItem item : items) {
                if(item.isFormField()) {
                    switch(item.getFieldName()) {
                        case "title[]":
                            titles.add(item.getString());
                            break;
                        case "author[]":
                            authors.add(item.getString());
                            break;
                        case "description[]":
                            descriptions.add(item.getString());
                            break;
                        case "category[]":
                            categories.add(item.getString());
                            break;
                        case "price[]":
                            prices.add(Double.parseDouble(item.getString()));
                            break;
                    }
                } else {
                    String fileName = item.getName();
                    String uploadPath = getServletContext().getRealPath("/") + "uploads/";
                    File uploadDir = new File(uploadPath);
                    if(!uploadDir.exists()) uploadDir.mkdir();

                    item.write(new File(uploadPath + fileName));
                    fileNames.add("uploads/" + fileName);
                }
            }

            try (Connection conn = getConnection()) {
                String query = "INSERT INTO books (title, author, description, category, price, file_path, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    for(int i = 0; i < titles.size(); i++) {
                        pstmt.setString(1, titles.get(i));
                        pstmt.setString(2, authors.get(i));
                        pstmt.setString(3, descriptions.get(i));
                        pstmt.setString(4, categories.get(i));
                        pstmt.setDouble(5, prices.get(i));
                        pstmt.setString(6, fileNames.get(i));
                        pstmt.setInt(7, (Integer)session.getAttribute("userId"));
                        pstmt.addBatch();
                    }
                    pstmt.executeBatch();
                }
            }

            response.sendRedirect("index.jsp?uploaded=1");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("uploadBook.jsp?error=upload_failed");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Books - EduVerse</title>
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
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <h2 class="text-center">Upload Your Books</h2>
        <form action="uploadBook.jsp" method="post" enctype="multipart/form-data">
            <div id="bookUploadContainer">
                <div class="book-upload">
                    <div class="mb-3">
                        <label for="title" class="form-label">Book Title</label>
                        <input type="text" class="form-control" id="title" name="title[]" required>
                    </div>
                    <div class="mb-3">
                        <label for="author" class="form-label">Author</label>
                        <input type="text" class="form-control" id="author" name="author[]" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description[]" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-control" id="category" name="category[]" required>
                            <option value="Fiction">Fiction</option>
                            <option value="Non-fiction">Non-fiction</option>
                            <option value="Science">Science</option>
                            <option value="Technology">Technology</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">Price (INR)</label>
                        <input type="number" class="form-control" id="price" name="price[]" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="bookFile" class="form-label">Upload E-Book</label>
                        <input type="file" class="form-control" id="bookFile" name="bookFile[]" required>
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-secondary" onclick="addBookUpload()">Add Another Book</button>
            <button type="submit" class="btn btn-primary w-100 mt-3">Upload Books</button>
        </form>
    </div>
    <script>
        function addBookUpload() {
            const container = document.getElementById('bookUploadContainer');
            const bookUpload = document.querySelector('.book-upload').cloneNode(true);
            container.appendChild(bookUpload);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>