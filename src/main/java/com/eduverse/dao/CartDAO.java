package com.eduverse.dao;

import java.util.List;
import java.util.Optional;

import com.eduverse.model.CartItem;
import com.eduverse.model.Cart; // Ensure that the Cart class exists in this package or update the package name if it is different

/**
 * Interface for cart operations in the e-commerce system.
 */
public interface CartDAO extends BaseDAO<CartItem> {
    // User cart operations
    Optional<Cart> findByUserId(int userId) throws Exception;
    boolean addToCart(int userId, int bookId) throws Exception;
    boolean removeFromCart(int userId, int bookId) throws Exception;
    boolean clearCart(int userId) throws Exception;
    
    // Cart item management
    boolean isBookInCart(int userId, int bookId) throws Exception;
    int getCartItemCount(int userId) throws Exception;
    double getCartTotal(int userId) throws Exception;
    
    // Batch operations
    boolean moveToWishlist(int userId, int bookId) throws Exception;
    boolean batchRemoveItems(int userId, List<Integer> bookIds) throws Exception;
    
    // Cart validation
    boolean validateCartItems(int userId) throws Exception;
    List<CartItem> getInvalidCartItems(int userId) throws Exception;
    
    // Cart synchronization
    boolean mergeAnonymousCart(int anonymousUserId, int registeredUserId) throws Exception;
    boolean updateCartItemTimestamp(int userId, int bookId) throws Exception;
    
    // Cart analytics
    List<CartItem> getAbandonedCartItems(int hours) throws Exception;
    int getActiveCartsCount() throws Exception;
    double getAverageCartValue() throws Exception;
    
    // Bulk operations
    boolean batchUpdateCart(List<CartItem> cartItems) throws Exception;
    boolean clearExpiredCarts(int hours) throws Exception;
}