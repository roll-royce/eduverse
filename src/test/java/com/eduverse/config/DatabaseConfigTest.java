package com.eduverse.config;

import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;
import org.junit.jupiter.api.Test;

public class DatabaseConfigTest {
    
    @Test
    public void testDatabaseConnection() {
        try (Connection conn = DatabaseConfig.getDataSource().getConnection()) {
            assertTrue(conn.isValid(1));
            System.out.println("Database connection successful!");
        } catch (Exception e) {
            fail("Database connection failed: " + e.getMessage());
        }
    }
}