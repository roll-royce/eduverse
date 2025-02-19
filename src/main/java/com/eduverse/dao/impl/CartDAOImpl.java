package com.eduverse.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.eduverse.dao.CartDAO;
import com.eduverse.model.CartItem;
import com.eduverse.util.DatabaseUtil;

public class CartDAOImpl extends BaseDAOImpl implements CartDAO {


    @Override
    public boolean mergeAnonymousCart(int anonymousUserId, int registeredUserId) throws Exception, SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Update existing items
                String updateSql = "UPDATE cart_items " +
                                   "SET user_id = ? " +
                                   "WHERE user_id = ? AND status = 'ACTIVE'";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setInt(1, registeredUserId);
                    stmt.setInt(2, anonymousUserId);
                    stmt.executeUpdate();
                }
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                cartLogger.log(Level.SEVERE, "Error merging anonymous cart", e);
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public boolean batchUpdateCart(List<CartItem> cartItems) throws Exception {
        String sql = "UPDATE cart_items SET quantity = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    for (CartItem item : cartItems) {
                        stmt.setInt(1, item.getQuantity());
                        stmt.setString(2, item.getStatus());
                        stmt.setInt(3, item.getId());
                        stmt.addBatch();
                    }
                    int[] results = stmt.executeBatch();
                    conn.commit();
                    return results.length == cartItems.size();
                }
            } catch (SQLException e) {
                conn.rollback();
                cartLogger.log(Level.SEVERE, "Error in batch update of cart items", e);
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
    private static final Logger cartLogger = Logger.getLogger(CartDAOImpl.class.getName());

    @Override
    public List<CartItem> findByUserId(int userId) throws Exception {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE user_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                cartItems.add(mapResultSetToCartItem(rs));
            }
        }
        return cartItems;
    }

    @Override
    public boolean addToCart(int userId, int bookId) throws Exception {
        String sql = "INSERT INTO cart_items (user_id, book_id, quantity, status) " +
                     "VALUES (?, ?, 1, 'ACTIVE') " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean removeFromCart(int userId, int bookId) throws Exception {
        String sql = "UPDATE cart_items SET status = 'REMOVED' " +
                     "WHERE user_id = ? AND book_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean clearCart(int userId) throws Exception {
        String sql = "UPDATE cart_items SET status = 'REMOVED' " +
                     "WHERE user_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean isBookInCart(int userId, int bookId) throws Exception {
        String sql = "SELECT COUNT(*) FROM cart_items " +
                     "WHERE user_id = ? AND book_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    @Override
    public int getCartItemCount(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE user_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    @Override
    public double getCartTotal(int userId) throws Exception {
        String sql = "SELECT SUM(b.price * c.quantity) " +
                     "FROM cart_items c " +
                     "JOIN books b ON c.book_id = b.id " +
                     "WHERE c.user_id = ? AND c.status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    @Override
    public boolean moveToWishlist(int userId, int bookId) throws Exception {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Remove from cart
                removeFromCart(userId, bookId);
                
                // Add to wishlist
                String sql = "INSERT INTO wishlist (user_id, book_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, bookId);
                    stmt.executeUpdate();
                }
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                cartLogger.log(Level.SEVERE, "Error moving to wishlist", e);
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public boolean batchRemoveItems(int userId, List<Integer> bookIds) throws Exception {
        String sql = "UPDATE cart_items SET status = 'REMOVED' " +
                     "WHERE user_id = ? AND book_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    for (Integer bookId : bookIds) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, bookId);
                        stmt.addBatch();
                    }
                    int[] results = stmt.executeBatch();
                    conn.commit();
                    return results.length == bookIds.size();
                }
            } catch (SQLException e) {
                conn.rollback();
                cartLogger.log(Level.SEVERE, "Error in batch removal of items", e);
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    @Override
    public List<CartItem> getAbandonedCartItems(int hours) throws Exception {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.*, b.title, b.price FROM cart_items c " +
                     "JOIN books b ON c.book_id = b.id " +
                     "WHERE c.status = 'ACTIVE' " +
                     "AND c.created_at < DATE_SUB(NOW(), INTERVAL ? HOUR)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hours);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToCartItem(rs));
            }
        }
        return items;
    }

    @Override
    public int getActiveCartsCount() throws Exception {
        String sql = "SELECT COUNT(DISTINCT user_id) FROM cart_items WHERE status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    @Override
    public double getAverageCartValue() throws Exception {
        String sql = "SELECT AVG(cart_total) FROM (" +
                     "SELECT user_id, SUM(b.price * c.quantity) as cart_total " +
                     "FROM cart_items c " +
                     "JOIN books b ON c.book_id = b.id " +
                     "WHERE c.status = 'ACTIVE' " +
                     "GROUP BY c.user_id) as cart_totals";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }

    @Override
    public boolean validateCartItems(int userId) throws Exception {
        String sql = "UPDATE cart_items c " +
                     "LEFT JOIN books b ON c.book_id = b.id " +
                     "SET c.status = 'INVALID' " +
                     "WHERE c.user_id = ? " +
                     "AND c.status = 'ACTIVE' " +
                     "AND (b.id IS NULL OR b.status != 'ACTIVE')";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() >= 0;
        }
    }

    @Override
    public List<CartItem> getInvalidCartItems(int userId) throws Exception {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.*, b.title, b.price FROM cart_items c " +
                     "LEFT JOIN books b ON c.book_id = b.id " +
                     "WHERE c.user_id = ? AND c.status = 'INVALID'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToCartItem(rs));
            }
        }
        return items;
    }


    @Override
    public boolean updateCartItemTimestamp(int userId, int bookId) throws Exception {
        String sql = "UPDATE cart_items SET updated_at = NOW() " +
                     "WHERE user_id = ? AND book_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean clearExpiredCarts(int hours) throws Exception {
        String sql = "UPDATE cart_items SET status = 'EXPIRED' " +
                     "WHERE status = 'ACTIVE' " +
                     "AND updated_at < DATE_SUB(NOW(), INTERVAL ? HOUR)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hours);
            return stmt.executeUpdate() >= 0;
        }
    }

    // Implementing the required methods from BaseDAO
    @Override
    public CartItem findById(int id) throws Exception {
        // Implementation for finding a CartItem by ID
        return null; // Replace with actual implementation
    }

    @Override
    public List<CartItem> findAll() throws Exception {
        // Implementation for finding all CartItems
        return new ArrayList<>(); // Replace with actual implementation
    }

    @Override
    public boolean save(CartItem entity) throws Exception {
        // Implementation for saving a CartItem
        return false; // Replace with actual implementation
    }

    @Override
    public boolean update(CartItem entity) throws Exception {
        // Implementation for updating a CartItem
        return false; // Replace with actual implementation
    }

    @Override
    public boolean delete(int id) throws Exception {
        // Implementation for deleting a CartItem
        return false; // Replace with actual implementation
    }

    // Helper method to map ResultSet to CartItem object
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setStatus(rs.getString("status"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional book information if needed
        if (rs.getMetaData().getColumnCount() > 7) {
            item.setBookTitle(rs.getString("title"));
            item.setBookPrice(rs.getDouble("price"));
        }
        
        return item;
    }
}