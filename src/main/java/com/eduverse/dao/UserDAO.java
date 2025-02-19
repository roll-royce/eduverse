package com.eduverse.dao;

import java.util.List;

import com.eduverse.model.User;

public interface UserDAO extends BaseDAO<User> {
    // Authentication methods
    User findByUsername(String username) throws Exception;
    User findByEmail(String email) throws Exception;
    boolean validateCredentials(String username, String password) throws Exception;
    boolean updatePassword(int userId, String newPassword) throws Exception;
    boolean resetPassword(String email, String resetToken) throws Exception;
    
    // User management
    List<User> findByRole(String role) throws Exception;
    boolean updateProfile(User user) throws Exception;
    boolean updateProfileImage(int userId, String imagePath) throws Exception;
    boolean activateUser(int userId) throws Exception;
    boolean deactivateUser(int userId) throws Exception;
    
    // User statistics
    int getTotalUserCount() throws Exception;
    int getActiveUserCount() throws Exception;
    List<User> getRecentUsers(int limit) throws Exception;
    List<User> getMostActiveUsers(int limit) throws Exception;
    
    // User validation
    boolean isUsernameAvailable(String username) throws Exception;
    boolean isEmailAvailable(String email) throws Exception;
    boolean verifyEmail(int userId, String verificationToken) throws Exception;
    
    // User search and filtering
    List<User> searchUsers(String query) throws Exception;
    List<User> getUsersByRegistrationDate(java.sql.Date startDate, java.sql.Date endDate) throws Exception;
    
    // Bulk operations
    boolean batchUpdateUsers(List<User> users) throws Exception;
    boolean batchDeleteUsers(List<Integer> userIds) throws Exception;
    
    // Role management
    boolean assignRole(int userId, String role) throws Exception;
    List<String> getUserRoles(int userId) throws Exception;
    
    // Session management
    boolean updateLastLogin(int userId) throws Exception;
    boolean updateLoginAttempts(String username) throws Exception;
    boolean resetLoginAttempts(String username) throws Exception;
    
    // User preferences
    boolean saveUserPreferences(int userId, java.util.Map<String, String> preferences) throws Exception;
    java.util.Map<String, String> getUserPreferences(int userId) throws Exception;
}