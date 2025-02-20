package com.eduverse.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.eduverse.model.User;

public class AdminServiceTest {
    private AdminService adminService;

    @BeforeEach
    void setUp() {
        adminService = new AdminService();
    }

    @Test
    void testCreateUser() {
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        user.setPassword("password123");

        User created = adminService.createUser(user);
        assertNotNull(created);
        assertNotNull(created.getId());
        assertEquals("testuser", created.getUsername());
    }
}