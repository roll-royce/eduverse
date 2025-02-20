package com.eduverse.service;

import com.eduverse.model.Cart; // Ensure that the Cart class exists in this package
import com.eduverse.model.CartItem;
import java.util.List;

public interface CartService {
    Cart getCartByUserId(Long userId);
    void addItemToCart(Long userId, Long bookId, int quantity);
    void removeItemFromCart(Long userId, Long bookId);
    void updateCartItemQuantity(Long userId, Long bookId, int quantity);
    void clearCart(Long userId);
    double getCartTotal(Long userId);
    List<CartItem> getCartItems(Long userId);
}
