package com.eduverse.util;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ResponseUtil {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static void sendJsonResponse(HttpServletResponse response, Object data) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getOutputStream(), data);
    }

    public static void sendUnauthorized(HttpServletResponse response) 
            throws IOException {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Admin access required");
    }
}