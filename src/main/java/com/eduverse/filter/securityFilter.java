package com.eduverse.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.eduverse.util.JWTUtil;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(SecurityFilter.class);
    private static final String[] PUBLIC_PATHS = {
        "/login", "/register", "/css/", "/js/", "/images/",
        "/error/", "/api/public/"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("SecurityFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        try {
            // CORS headers
            httpResponse.setHeader("Access-Control-Allow-Origin", "*");
            httpResponse.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
            httpResponse.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
            
            // Security headers
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
            httpResponse.setHeader("X-Frame-Options", "DENY");
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
            httpResponse.setHeader("Content-Security-Policy", 
                "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';");

            // Check if path is public
            if (isPublicPath(path)) {
                chain.doFilter(request, response);
                return;
            }

            // Session check
            HttpSession session = httpRequest.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                // Check JWT token if session is not present
                String token = httpRequest.getHeader("Authorization");
                if (token != null && token.startsWith("Bearer ")) {
                    token = token.substring(7);
                    if (JWTUtil.validateToken(token)) {
                        chain.doFilter(request, response);
                        return;
                    }
                }
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                return;
            }

            // CSRF protection
            if (isPostRequest(httpRequest)) {
                String csrfToken = httpRequest.getHeader("X-CSRF-TOKEN");
                String sessionToken = (String) session.getAttribute("csrfToken");
                if (csrfToken == null || !csrfToken.equals(sessionToken)) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                    return;
                }
            }

            // Role-based access control
            if (path.startsWith("/admin") && !"ADMIN".equals(session.getAttribute("userRole"))) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            chain.doFilter(request, response);

        } catch (Exception e) {
            logger.error("Security filter error: ", e);
            httpResponse.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public void destroy() {
        logger.info("SecurityFilter destroyed");
    }

    private boolean isPublicPath(String path) {
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }

    private boolean isPostRequest(HttpServletRequest request) {
        return "POST".equalsIgnoreCase(request.getMethod());
    }
}
