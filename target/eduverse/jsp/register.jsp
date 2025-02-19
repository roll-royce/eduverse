<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EduVerse</title>
    
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/register.css" rel="stylesheet">
</head>
<body class="page-background">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="bi bi-box-arrow-in-right"></i> Login
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Register Form -->
    <div class="container">
        <div class="register-container">
            <h2 class="text-center mb-4">Create an Account</h2>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <%= request.getParameter("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                    <label for="username">Username</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                    <label for="email">Email address</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password">Password</label>
                    <div id="passwordStrength" class="password-strength mt-1 d-none"></div>
                </div>

                <div class="form-floating mb-3">
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Phone" required>
                    <label for="phone">Phone</label>
                </div>

                <div class="form-floating mb-3">
                    <textarea class="form-control" id="address" name="address" placeholder="Address" style="height: 100px" required></textarea>
                    <label for="address">Address</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="age" name="age" placeholder="Age" min="13" max="120" required>
                    <label for="age">Age</label>
                </div>

                <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <div class="gender-select">
                        <input type="radio" class="btn-check" name="gender" id="male" value="male" required>
                        <label class="btn btn-outline-secondary" for="male">Male</label>

                        <input type="radio" class="btn-check" name="gender" id="female" value="female">
                        <label class="btn btn-outline-secondary" for="female">Female</label>

                        <input type="radio" class="btn-check" name="gender" id="other" value="other">
                        <label class="btn btn-outline-secondary" for="other">Other</label>
                    </div>
                </div>

                <div class="form-floating mb-4">
                    <input type="text" class="form-control" id="occupation" name="occupation" placeholder="Occupation" required>
                    <label for="occupation">Occupation</label>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2">
                    <i class="bi bi-person-plus"></i> Create Account
                </button>
            </form>

            <p class="text-center mt-3">
                Already have an account? 
                <a href="${pageContext.request.contextPath}/login" class="text-primary">Login here</a>
            </p>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer bg-dark text-white text-center py-3 mt-5">
        <div class="container">
            <p class="mb-0">&copy; 2025 EduVerse. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>