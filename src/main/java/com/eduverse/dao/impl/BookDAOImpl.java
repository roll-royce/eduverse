package com.eduverse.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;

import org.apache.commons.lang3.StringUtils;

import com.eduverse.dao.BookDAO;
import com.eduverse.model.Book;
import com.eduverse.util.DatabaseUtil;

public class BookDAOImpl extends BaseDAOImpl implements BookDAO {

    @Override
    public Book findById(int id) throws Exception {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        }
        return null;
    }

    @Override
    public List<Book> findAll() throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'ACTIVE' ORDER BY created_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public boolean save(Book book) throws Exception {
        String sql = "INSERT INTO books (title, author, description, price, cover_image, " +
                     "file_path, category, language, format, pages, publisher, publication_date, " +
                     "isbn, user_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setBookParameters(stmt, book);
            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        book.setId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        return false;
    }

    @Override
    public boolean update(Book book) throws Exception {
        String sql = "UPDATE books SET title=?, author=?, description=?, price=?, cover_image=?, " +
                     "file_path=?, category=?, language=?, format=?, pages=?, publisher=?, " +
                     "publication_date=?, isbn=?, status=? WHERE id=?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            setBookParameters(stmt, book);
            stmt.setInt(15, book.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws Exception {
        String sql = "UPDATE books SET status='DELETED' WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public List<Book> findByCategory(String category) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE category = ? AND status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> findByAuthor(String author) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE author LIKE ? AND status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + author + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> findByPriceRange(double minPrice, double maxPrice) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE price BETWEEN ? AND ? AND status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, minPrice);
            stmt.setDouble(2, maxPrice);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    // Helper method to map ResultSet to Book object
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setDescription(rs.getString("description"));
        book.setPrice(rs.getDouble("price"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setFilePath(rs.getString("file_path"));
        book.setCategory(rs.getString("category"));
        book.setLanguage(rs.getString("language"));
        book.setFormat(rs.getString("format"));
        book.setPages(rs.getInt("pages"));
        book.setPublisher(rs.getString("publisher"));
        book.setPublicationDate(rs.getDate("publication_date"));
        book.setIsbn(rs.getString("isbn"));
        book.setUserId(rs.getInt("user_id"));
        book.setStatus(rs.getString("status"));
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        return book;
    }

    // Helper method to set parameters in PreparedStatement
    private void setBookParameters(PreparedStatement stmt, Book book) throws SQLException {
        stmt.setString(1, book.getTitle());
        stmt.setString(2, book.getAuthor());
        stmt.setString(3, book.getDescription());
        stmt.setDouble(4, book.getPrice());
        stmt.setString(5, book.getCoverImage());
        stmt.setString(6, book.getFilePath());
        stmt.setString(7, book.getCategory());
        stmt.setString(8, book.getLanguage());
        stmt.setString(9, book.getFormat());
        stmt.setInt(10, book.getPages());
        stmt.setString(11, book.getPublisher());
        stmt.setDate(12, book.getPublicationDate());
        stmt.setString(13, book.getIsbn());
        stmt.setInt(14, book.getUserId());
        stmt.setString(15, book.getStatus());
    }

    @Override
    public List<Book> searchBooks(String query) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'ACTIVE' AND " +
                     "(title LIKE ? OR author LIKE ? OR description LIKE ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> getRecentBooks(int limit) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'ACTIVE' " +
                     "ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> getFeaturedBooks(int limit) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, COUNT(p.id) as purchase_count " +
                     "FROM books b " +
                     "LEFT JOIN purchases p ON b.id = p.book_id " +
                     "WHERE b.status = 'ACTIVE' " +
                     "GROUP BY b.id " +
                     "ORDER BY purchase_count DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> getBestsellingBooks(int limit) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, COUNT(p.id) as sales_count " +
                     "FROM books b " +
                     "LEFT JOIN purchases p ON b.id = p.book_id " +
                     "WHERE b.status = 'ACTIVE' AND p.payment_status = 'COMPLETED' " +
                     "GROUP BY b.id " +
                     "ORDER BY sales_count DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public List<Book> getBooksByUser (int userId) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE user_id = ? AND status != 'DELETED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public boolean updateStatus(int bookId, String status) throws Exception {
        String sql = "UPDATE books SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public int getTotalBookCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM books WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    @Override
    public List<String> getAllCategories() throws Exception {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM books WHERE status = 'ACTIVE' ORDER BY category";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        }
        return categories;
    }

    @Override
    public List<String> getPopularCategories(int limit) throws Exception {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT b.category, COUNT(*) as book_count " +
                     "FROM books b " +
                     "WHERE b.status = 'ACTIVE' " +
                     "GROUP BY b.category " +
                     "ORDER BY book_count DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        }
        return categories;
    }

    @Override
    public boolean isBookTitleExists(String title) throws Exception {
        String sql = "SELECT COUNT(*) FROM books WHERE title = ? AND status != 'DELETED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    @Override
    public boolean isBookOwnedByUser (int bookId, int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM books WHERE id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    @Override
    public boolean batchUpdatePrices(List<Book> books) throws Exception {
        String sql = "UPDATE books SET price = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            try {
                for (Book book : books) {
                    stmt.setDouble(1, book.getPrice());
                    stmt.setInt(2, book.getId());
                    stmt.addBatch();
                }
                int[] results = stmt.executeBatch();
                conn.commit();
                return results.length == books.size();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public boolean batchDeleteBooks(List<Integer> bookIds) throws Exception {
        String sql = "UPDATE books SET status = 'DELETED' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            try {
                for (Integer id : bookIds) {
                    stmt.setInt(1, id);
                    stmt.addBatch();
                }
                int[] results = stmt.executeBatch();
                conn.commit();
                return results.length == bookIds.size();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public List<Book> getPurchasedBooks(int userId) throws Exception {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM books b " +
                     "INNER JOIN purchases p ON b.id = p.book_id " +
                     "WHERE p.user_id = ? AND p.payment_status = 'COMPLETED'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }

    @Override
    public boolean updateCoverImage(int bookId, String coverImagePath) throws Exception {
        String sql = "UPDATE books SET cover_image = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, coverImagePath);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateBookFile(int bookId, String filePath) throws Exception {
        String sql = "UPDATE books SET file_path = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, filePath);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public double getAverageBookPrice() throws Exception {
        String sql = "SELECT AVG(price) FROM books WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    @Override
    public int getBookCountByCategory(String category) throws Exception {
        String sql = "SELECT COUNT(*) FROM books WHERE category = ? AND status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Additional utility methods for error handling and validation
    @Override
    protected void logSQLError(String method, String sql, Exception e) {
        logger.log(Level.SEVERE, "Error in {0}: {1}", new Object[]{method, e.getMessage()});
        logger.log(Level.SEVERE, "SQL: {0}", sql);
        logger.log(Level.SEVERE, "Stack trace:", e);
    }

    @Override
    protected void beginTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.setAutoCommit(false);
        }
    }

    @Override
    protected void commitTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.commit();
        }
    }

    @Override
    protected void rollbackTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.rollback();
        }
    }

    @Override
    protected void endTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.setAutoCommit(true);
        }
    }

    // Advanced search method
    @Override
    public List<Book> advancedSearch(String title, String author, String category, 
                                      Double minPrice, Double maxPrice, String language) throws Exception {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE status = 'ACTIVE'");
        List<Object> params = new ArrayList<>();

        if (StringUtils.isNotBlank(title)) {
            sql.append(" AND title LIKE ?");
            params.add("%" + title + "%");
        }
        if (StringUtils.isNotBlank(author)) {
            sql.append(" AND author LIKE ?");
            params.add("%" + author + "%");
        }
        if (StringUtils.isNotBlank(category)) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        if (StringUtils.isNotBlank(language)) {
            sql.append(" AND language = ?");
            params.add(language);
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }
}