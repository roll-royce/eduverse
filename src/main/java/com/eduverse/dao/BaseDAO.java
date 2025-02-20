package com.eduverse.dao;

import java.util.List;
import java.util.Optional;

public interface BaseDAO<T> {
    T save(T entity);
    T update(T entity);
    boolean delete(Long id);
    Optional<T> findById(Long id);
    List<T> findAll();
    long countAll();
}