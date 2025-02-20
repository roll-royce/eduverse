package com.eduverse.dao;

import com.eduverse.model.Order;
import java.util.List;

public interface OrderDAO extends BaseDAO<Order> {
    List<Order> findRecentOrders(int limit);
    List<Order> findByUserId(Long userId);
}