package com.eduverse.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.eduverse.dao.UserDAO;
import com.eduverse.model.User;
import com.eduverse.util.DatabaseUtil;
import com.eduverse.util.PasswordUtil;

public class UserDAOImpl extends BaseDAOImpl implements UserDAO {

    @Override
    public User findById(int id) throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public List<User> findAll() throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public boolean save(User user) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean update(User user) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean delete(int id) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public User findByUsername(String username) throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public User findByEmail(String email) throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public List<User> findByRole(String role) throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public boolean updateProfile(User user) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean updateProfileImage(int userId, String imagePath) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean updatePassword(int userId, String newPassword) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean validateCredentials(String username, String password) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean saveUserPreferences(int userId, Map<String, String> preferences) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public Map<String, String> getUserPreferences(int userId) throws Exception {
        // Implementation here
        return null;
    }

    @Override
    public boolean batchUpdateUsers(List<User> users) throws Exception {
        // Implementation here
        return false;
    }

    @Override
    public boolean resetLoginAttempts(String username) throws Exception {
        String sql = "UPDATE users SET login_attempts = 0 WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error resetting login attempts for username: " + username, e);
            throw e;
        }
    }

    @Override
    public List<String> getUserRoles(int userId) throws Exception {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT role FROM user_roles WHERE user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                roles.add(rs.getString("role"));
            }
            return roles;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting roles for user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public boolean verifyEmail(int userId, String token) throws Exception {
        String sql = "UPDATE users SET email_verified = true WHERE id = ? AND verification_token = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error verifying email for user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public List<User> getMostActiveUsers(int limit) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY last_login DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting most active users", e);
            throw e;
        }
    }

    @Override
    public boolean isEmailAvailable(String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking email availability: " + email, e);
            throw e;
        }
    }

    @Override
    public List<User> searchUsers(String keyword) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword + "%";
            stmt.setString(1, searchKeyword);
            stmt.setString(2, searchKeyword);
            stmt.setString(3, searchKeyword);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching users with keyword: " + keyword, e);
            throw e;
        }
    }

    @Override
    public boolean updateLoginAttempts(String username) throws Exception {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1 WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating login attempts for username: " + username, e);
            throw e;
        }
    }

    @Override
    public int getTotalUserCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total user count", e);
            throw e;
        }
    }

    @Override
    public boolean isUsernameAvailable(String username) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking username availability: " + username, e);
            throw e;
        }
    }

    @Override
    public int getActiveUserCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting active user count", e);
            throw e;
        }
    }

    @Override
    public boolean assignRole(int userId, String role) throws Exception {
        String sql = "INSERT INTO user_roles (user_id, role) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, role);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error assigning role to user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public boolean deactivateUser(int userId) throws Exception {
        String sql = "UPDATE users SET status = 'INACTIVE' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deactivating user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public boolean resetPassword(String email, String newPassword) throws Exception {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error resetting password for email: " + email, e);
            throw e;
        }
    }

    @Override
    public boolean batchDeleteUsers(List<Integer> userIds) throws Exception {
        String sql = "UPDATE users SET status = 'DELETED' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int userId : userIds) {
                stmt.setInt(1, userId);
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            for (int result : results) {
                if (result == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error batch deleting users", e);
            throw e;
        }
    }

    @Override
    public List<User> getUsersByRegistrationDate(Date startDate, Date endDate) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting users by registration date", e);
            throw e;
        }
    }

    @Override
    public boolean updateLastLogin(int userId) throws Exception {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating last login for user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public boolean activateUser(int userId) throws Exception {
        String sql = "UPDATE users SET status = 'ACTIVE' WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error activating user ID: " + userId, e);
            throw e;
        }
    }

    @Override
    public List<User> getRecentUsers(int limit) throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            return users;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting recent users", e);
            throw e;
        }
    }
        private static final Logger logger = Logger.getLogger(UserDAOImpl.class.getName());

        private User mapResultSetToUser(ResultSet rs) throws SQLException {
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setFullName(rs.getString("full_name"));
            user.setStatus(rs.getString("status"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setLastLogin(rs.getTimestamp("last_login"));
            return user;
        }
    }
