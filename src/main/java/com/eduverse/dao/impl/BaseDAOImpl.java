package com.eduverse.dao.impl;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class BaseDAOImpl {
    protected static final Logger logger = Logger.getLogger(BaseDAOImpl.class.getName());

    protected void logSQLError(String method, String sql, Exception e) {
        logger.log(Level.SEVERE, "Error in {0}: {1}", new Object[]{method, e.getMessage()});
        logger.log(Level.SEVERE, "SQL: {0}", sql);
        logger.log(Level.SEVERE, "Stack trace:", e);
    }

    protected void beginTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.setAutoCommit(false);
        }
    }

    protected void commitTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.commit();
        }
    }

    protected void rollbackTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.rollback();
        }
    }

    protected void endTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.setAutoCommit(true);
        }
    }
}