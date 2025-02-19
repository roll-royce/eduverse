package com.eduverse.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestDataHelper {
    
    public static void cleanupTestData() throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Clean up in reverse order of dependencies
                cleanTable(conn, "cart_items");
                cleanTable(conn, "purchases");
                cleanTable(conn, "book_ratings");
                cleanTable(conn, "books");
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }
    
    private static void cleanTable(Connection conn, String tableName) throws SQLException {
        String sql = "DELETE FROM " + tableName + " WHERE 1=1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        }
    }

    public static void verifyDataIntegrity() throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Verify foreign key relationships
            verifyForeignKeys(conn, "cart_items", "book_id", "books", "id");
            verifyForeignKeys(conn, "purchases", "book_id", "books", "id");
            verifyForeignKeys(conn, "book_ratings", "book_id", "books", "id");
        }
    }

    private static void verifyForeignKeys(Connection conn, String childTable, 
            String childColumn, String parentTable, String parentColumn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + childTable + " c " +
                    "LEFT JOIN " + parentTable + " p " +
                    "ON c." + childColumn + " = p." + parentColumn + " " +
                    "WHERE p." + parentColumn + " IS NULL";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new SQLException("Found orphaned records in " + childTable);
            }
        }
    }
}