package com.eduverse.dao;

import java.util.List;

public interface BaseDAO<T> {
    // Find a single entity by its primary key
    T findById(int id) throws Exception;
    
    // Retrieve all entities of type T
    List<T> findAll() throws Exception;
    
    // Create a new entity
    boolean save(T entity) throws Exception;
    
    // Update an existing entity
    boolean update(T entity) throws Exception;
    
    // Delete an entity by its ID (or mark as deleted)
    boolean delete(int id) throws Exception;
}