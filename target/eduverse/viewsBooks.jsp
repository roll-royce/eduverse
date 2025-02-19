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
    <title>View Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>Books Library</h1>
        <div class="row">
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
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>