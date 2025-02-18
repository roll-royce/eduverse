<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Upload E-Book - EduVerse</title>
    <link rel="stylesheet" href="css/style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <%
    // Check if user is logged in
    if(session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if(ServletFileUpload.isMultipartContent(request)) {
        try {
            // Configure upload settings
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 1024 * 3); // 3MB
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(1024 * 1024 * 50); // 50MB max file size

            // Parse the request
            List<FileItem> items = upload.parseRequest(request);

            String title = "";
            String author = "";
            String category = "";
            String description = "";
            String fileName = "";
            
            // Process form fields
            for(FileItem item : items) {
                if(item.isFormField()) {
                    switch(item.getFieldName()) {
                        case "bookTitle":
                            title = item.getString("UTF-8");
                            break;
                        case "bookAuthor":
                            author = item.getString("UTF-8");
                            break;
                        case "category":
                            category = item.getString("UTF-8");
                            break;
                        case "description":
                            description = item.getString("UTF-8");
                            break;
                    }
                } else {
                    // Process file upload
                    String contentType = item.getContentType();
                    if(contentType != null && (contentType.equals("application/pdf") || 
                       contentType.equals("application/epub+zip"))) {
                        
                        fileName = new File(item.getName()).getName();
                        String uploadPath = getServletContext().getRealPath("/") + "uploads/";
                        File uploadDir = new File(uploadPath);
                        
                        if(!uploadDir.exists()) {
                            uploadDir.mkdir();
                        }

                        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                        File file = new File(uploadPath + uniqueFileName);
                        item.write(file);

                        // Database connection
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/eduverse",
                            "root", "password"
                        );

                        String query = "INSERT INTO books (title, author, category, description, file_path, user_id, upload_date) VALUES (?, ?, ?, ?, ?, ?, NOW())";
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        pstmt.setString(1, title);
                        pstmt.setString(2, author);
                        pstmt.setString(3, category);
                        pstmt.setString(4, description);
                        pstmt.setString(5, "uploads/" + uniqueFileName);
                        pstmt.setInt(6, (Integer)session.getAttribute("userId"));

                        pstmt.executeUpdate();
                        conn.close();

                        response.sendRedirect("index.jsp?uploaded=success");
                        return;
                    } else {
                        response.sendRedirect("uploadBook.jsp?error=invalidfile");
                        return;
                    }
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("uploadBook.jsp?error=upload");
            return;
        }
    }
    %>

    <div class="container">
        <h2>Upload E-Book</h2>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-danger">
                <% if(request.getParameter("error").equals("invalidfile")) { %>
                    Only PDF and EPUB files are allowed.
                <% } else { %>
                    An error occurred during upload. Please try again.
                <% } %>
            </div>
        <% } %>

        <form action="uploadBook.jsp" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="bookTitle">Book Title:</label>
                <input type="text" name="bookTitle" id="bookTitle" required>
            </div>

            <div class="form-group">
                <label for="bookAuthor">Author:</label>
                <input type="text" name="bookAuthor" id="bookAuthor" required>
            </div>

            <div class="form-group">
                <label for="category">Category:</label>
                <select name="category" id="category" required>
                    <option value="">Select Category</option>
                    <option value="textbook">Textbook</option>
                    <option value="novel">Novel</option>
                    <option value="reference">Reference</option>
                    <option value="academic">Academic</option>
                    <option value="other">Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea name="description" id="description" rows="4" required></textarea>
            </div>

            <div class="form-group">
                <label for="bookFile">Select Book File (PDF or EPUB):</label>
                <input type="file" name="bookFile" id="bookFile" accept=".pdf,.epub" required>
            </div>

            <button type="submit" class="btn btn-primary">Upload Book</button>
        </form>
    </div>

    <script>
        document.getElementById('bookFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if(file.size > 50 * 1024 * 1024) {
                alert('File size should not exceed 50MB');
                this.value = '';
            }
        });
    </script>
</body>
</html>