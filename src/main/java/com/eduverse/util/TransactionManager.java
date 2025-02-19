package com.eduverse.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.function.Function;

public class TransactionManager {
    public static <T> T executeInTransaction(Connection conn, Function<Connection, T> operation) throws SQLException {
        boolean autoCommit = conn.getAutoCommit();
        try {
            conn.setAutoCommit(false);
            T result = operation.apply(conn);
            conn.commit();
            return result;
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(autoCommit);
        }
    }
}