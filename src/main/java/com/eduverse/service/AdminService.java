package com.eduverse.service;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.eduverse.dao.UserDAO;
import com.eduverse.dao.BookDAO;
import com.eduverse.dao.OrderDAO;
import com.eduverse.dao.impl.UserDAOImpl;
import com.eduverse.dao.impl.BookDAOImpl;
import com.eduverse.dao.impl.OrderDAOImpl;
import com.eduverse.model.User;
import com.eduverse.exception.ResourceNotFoundException;
import com.eduverse.util.PasswordUtil;

public class AdminService {
    private final UserDAO userDAO;
    private final BookDAO bookDAO;
    private final OrderDAO orderDAO;

    public AdminService() {
        this.userDAO = new UserDAOImpl();
        this.bookDAO = new BookDAOImpl();
        this.orderDAO = new OrderDAOImpl();
    }

    public List<User> getAllUsers() {
        try {
            return userDAO.findAll();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching users: " + e.getMessage(), e);
        }
    }

    public Map<String, Object> getDashboardStats() {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", userDAO.countAll());
            stats.put("totalBooks", bookDAO.countAll());
            stats.put("totalOrders", orderDAO.countAll());
            stats.put("recentOrders", orderDAO.findRecentOrders(5));
            stats.put("topSellingBooks", bookDAO.findTopSelling(5));
            return stats;
        } catch (Exception e) {
            throw new RuntimeException("Error fetching dashboard stats: " + e.getMessage(), e);
        }
    }

    public User createUser(User user) {
        try {
            // Validate user data
            validateUserData(user);
            
            // Hash password before saving
            user.setPassword(PasswordUtil.hashPassword(user.getPassword()));
            
            // Set default role if not specified
            if (user.getRole() == null) {
                user.setRole("USER");
            }
            
            return userDAO.save(user);
        } catch (Exception e) {
            throw new RuntimeException("Error creating user: " + e.getMessage(), e);
        }
    }

    public User updateUser(User user) {
        try {
            // Check if user exists
            User existingUser = userDAO.findById(user.getId())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + user.getId()));
            
            // Update fields
            if (user.getUsername() != null) {
                existingUser.setUsername(user.getUsername());
            }
            if (user.getEmail() != null) {
                existingUser.setEmail(user.getEmail());
            }
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                existingUser.setPassword(PasswordUtil.hashPassword(user.getPassword()));
            }
            if (user.getRole() != null) {
                existingUser.setRole(user.getRole());
            }
            
            return userDAO.update(existingUser);
        } catch (Exception e) {
            throw new RuntimeException("Error updating user: " + e.getMessage(), e);
        }
    }

    public void deleteUser(Long userId) {
        try {
            if (!userDAO.delete(userId)) {
                throw new ResourceNotFoundException("User not found with id: " + userId);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error deleting user: " + e.getMessage(), e);
        }
    }

    private void validateUserData(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        if (user.getEmail() == null || !user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }
        if (user.getPassword() == null || user.getPassword().length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long");
        }
    }
}
