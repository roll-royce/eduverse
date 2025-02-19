package com.eduverse.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eduverse.dao.UserDAO;
import com.eduverse.dao.impl.UserDAOImpl;
import com.eduverse.model.User;
import com.eduverse.util.PasswordUtil;
import com.eduverse.util.ValidationUtil;

@WebServlet("/register")
public class UserRegistrationServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(UserRegistrationServlet.class.getName());
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Map<String, String> errors = new HashMap<>();
        
        try {
            // Validate input
            String username = ValidationUtil.sanitizeInput(request.getParameter("username"));
            String email = ValidationUtil.sanitizeInput(request.getParameter("email"));
            String password = request.getParameter("password");
            String phone = ValidationUtil.sanitizeInput(request.getParameter("phone"));
            String address = ValidationUtil.sanitizeInput(request.getParameter("address"));
            String gender = ValidationUtil.sanitizeInput(request.getParameter("gender"));
            String occupation = ValidationUtil.sanitizeInput(request.getParameter("occupation"));
            
            // Validate required fields
            if (!ValidationUtil.isValidUsername(username)) {
                errors.put("username", "Invalid username format");
            }
            if (!ValidationUtil.isValidEmail(email)) {
                errors.put("email", "Invalid email format");
            }
            if (!ValidationUtil.isValidPassword(password)) {
                errors.put("password", "Password must be at least 8 characters");
            }
            if (!ValidationUtil.isValidPhone(phone)) {
                errors.put("phone", "Invalid phone number");
            }

            int age;
            try {
                age = Integer.parseInt(request.getParameter("age"));
                if (age < 13 || age > 120) {
                    errors.put("age", "Age must be between 13 and 120");
                }
            } catch (NumberFormatException e) {
                errors.put("age", "Invalid age format");
                age = 0;
            }

            // Check if there are any validation errors
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                return;
            }

            // Check if user already exists
            if (userDAO.findByEmail(email) != null) {
                errors.put("email", "Email already registered");
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setPhone(phone);
            user.setAddress(address);
            user.setAge(age);
            user.setGender(gender);
            user.setOccupation(occupation);
            user.setStatus("ACTIVE");
            user.setRole("USER");

            // Save user
            if (userDAO.save(user)) {
                // Send welcome email
                sendWelcomeEmail(user.getEmail(), user.getUsername());
                
                // Redirect to login with success message
                response.sendRedirect(request.getContextPath() + 
                    "/login?registered=true&username=" + username);
            } else {
                throw new ServletException("Failed to create user account");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during registration", e);
            request.setAttribute("error", "Registration failed. Please try again later.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }

    private void sendWelcomeEmail(String email, String username) {
        // Implement email sending logic here
    }
}