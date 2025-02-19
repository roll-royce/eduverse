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
%>