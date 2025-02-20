package com.eduverse.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.eduverse.model.User;
import com.eduverse.service.AdminService;
import com.eduverse.util.ResponseUtil;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private final AdminService adminService;
    private final ObjectMapper objectMapper;

    public AdminServlet() {
        this.adminService = new AdminService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);

        if (!isAdminAuthenticated(session)) {
            ResponseUtil.sendUnauthorized(response);
            return;
        }

        try {
            switch (pathInfo) {
                case "/users":
                    getAllUsers(response);
                    break;
                case "/dashboard":
                    getDashboardStats(response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);

        if (!isAdminAuthenticated(session)) {
            ResponseUtil.sendUnauthorized(response);
            return;
        }

        try {
            switch (pathInfo) {
                case "/user/create":
                    createUser(request, response);
                    break;
                case "/user/update":
                    updateUser(request, response);
                    break;
                case "/user/delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private boolean isAdminAuthenticated(HttpSession session) {
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    private void getAllUsers(HttpServletResponse response) throws IOException {
        ResponseUtil.sendJsonResponse(response, adminService.getAllUsers());
    }

    private void getDashboardStats(HttpServletResponse response) throws IOException {
        ResponseUtil.sendJsonResponse(response, adminService.getDashboardStats());
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = objectMapper.readValue(request.getReader(), User.class);
        User createdUser = adminService.createUser(user);
        ResponseUtil.sendJsonResponse(response, createdUser);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        User user = objectMapper.readValue(request.getReader(), User.class);
        User updatedUser = adminService.updateUser(user);
        ResponseUtil.sendJsonResponse(response, updatedUser);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        adminService.deleteUser(userId);
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }
}
