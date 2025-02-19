package com.eduverse.util;

import java.util.regex.Pattern;
import org.apache.commons.text.StringEscapeUtils;

public class ValidationUtil {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern USERNAME_PATTERN = 
        Pattern.compile("^[a-zA-Z0-9_]{3,20}$");
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^\\d{10}$");

    public static String sanitizeInput(String input) {
        if (input == null) return "";
        return StringEscapeUtils.escapeHtml4(input.trim());
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone).matches();
    }
}