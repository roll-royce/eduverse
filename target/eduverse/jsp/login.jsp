<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EduVerse</title>
    
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body class="login-page">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-book"></i> EduVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/books">
                            <i class="bi bi-collection"></i> Books
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register">
                            <i class="bi bi-person-plus"></i> Register
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Login Form -->
    <div class="container">
        <div class="login-container">
            <h2 class="text-center mb-4">Welcome Back</h2>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate>
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                    <label for="email">Email address</label>
                </div>

                <div class="form-floating mb-3">
                    <div class="password-wrapper">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                        <span class="toggle-password">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <label for="password">Password</label>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember">
                    <label class="form-check-label" for="remember">Remember me</label>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-3">
                    <i class="bi bi-box-arrow-in-right"></i> Login
                </button>

                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">
                        Forgot your password?
                    </a>
                </div>

                <div class="text-center my-3">
                    <span class="text-muted">Or continue with</span>
                </div>

                <div class="social-login">
                    <button type="button" class="btn btn-outline-dark">
                        <i class="bi bi-google"></i>
                    </button>
                    <button type="button" class="btn btn-outline-dark">
                        <i class="bi bi-facebook"></i>
                    </button>
                    <button type="button" class="btn btn-outline-dark">
                        <i class="bi bi-github"></i>
                    </button>
                </div>

                <div class="text-center mt-4">
                    Don't have an account? 
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none">
                        Create one
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer bg-dark text-white text-center py-3">
        <div class="container">
            <p class="mb-0">&copy; 2025 EduVerse. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>