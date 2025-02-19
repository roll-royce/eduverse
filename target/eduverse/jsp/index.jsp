/index.jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eduverse.util.DatabaseUtil" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduVerse - Your Digital Book Marketplace</title>
    
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    
    <!-- Meta tags -->
    <meta name="description" content="EduVerse - Discover, upload, and sell e-books easily">
    <meta name="keywords" content="ebooks, digital books, education, online learning">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-book"></i> EduVerse
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/books">
                            <i class="bi bi-collection"></i> Browse Books
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                            <i class="bi bi-grid"></i> Categories
                        </a>
                    </li>
                </ul>
                <div class="d-flex">
                    <c:choose>
                        <c:when test="${sessionScope.userId != null}">
                            <div class="dropdown">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle"></i> ${userName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-books">My Books</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary me-2">Login</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="hero-title">Welcome to EduVerse</h1>
            <p class="lead mb-4">Your premier destination for digital learning resources</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-light btn-lg">
                    <i class="bi bi-search"></i> Explore Books
                </a>
                <a href="${pageContext.request.contextPath}/upload" class="btn btn-outline-light btn-lg">
                    <i class="bi bi-cloud-upload"></i> Upload Your Book
                </a>
            </div>
        </div>
    </section>

    <!-- Featured Books -->
    <section class="container">
        <h2 class="text-center mb-4">Featured Books</h2>
        <div class="row g-4">
            <c:forEach var="book" items="${featuredBooks}" varStatus="loop">
                <div class="col-md-4">
                    <div class="book-card card h-100">
                        <div class="card-body">
                            <span class="category-badge float-end">${book.category}</span>
                            <h5 class="card-title">${book.title}</h5>
                            <h6 class="card-subtitle mb-2 text-muted">${book.author}</h6>
                            <p class="card-text">${book.description}</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="price-tag">$${book.price}</span>
                                <a href="${pageContext.request.contextPath}/download/${book.id}" 
                                   class="btn btn-primary download-btn"
                                   data-bs-toggle="tooltip" 
                                   title="Download PDF">
                                    <i class="bi bi-download"></i> Download PDF
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>About EduVerse</h5>
                    <p>Your trusted platform for digital educational resources.</p>
                </div>
                <div class="col-md-4">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                        <li><a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></li>
                    </ul>
                </div>
                <div class="col-md-4">
                    <h5>Connect With Us</h5>
                    <div class="social-links">
                        <a href="#" class="text-white me-2"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="text-white me-2"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="text-white"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>
            <hr class="mt-4 mb-4">
            <p class="text-center mb-0">&copy; 2025 EduVerse. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>