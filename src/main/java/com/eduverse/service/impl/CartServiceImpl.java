package com.eduverse.service.impl;

import com.eduverse.dao.CartDAO;
import com.eduverse.dao.BookDAO;
import com.eduverse.model.Cart;
import com.eduverse.model.CartItem;
import com.eduverse.model.Book;
import com.eduverse.service.CartService;
import com.eduverse.exception.ResourceNotFoundException;

import java.util.List;

public class CartServiceImpl implements CartService {
    private final CartDAO cartDAO;
    private final BookDAO bookDAO;

    public CartServiceImpl(CartDAO cartDAO, BookDAO bookDAO) {
        this.cartDAO = cartDAO;
        this.bookDAO = bookDAO;
    }

    @Override
    public Cart getCartByUserId(Long userId) {
        return cartDAO.findByUserId(userId.intValue())
            .orElseThrow(() -> new ResourceNotFoundException("Cart not found for user: " + userId));
    }

    @Override
    public void addItemToCart(Long userId, Long bookId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero");
        }

        Book book = bookDAO.findById(bookId)
            .orElseThrow(() -> new ResourceNotFoundException("Book not found: " + bookId));

        Cart cart = cartDAO.findByUserId(userId)
            .orElseGet(() -> createNewCart(userId));

        CartItem existingItem = cart.getItems().stream()
            .filter(item -> item.getBookId().equals(bookId))
            .findFirst()
            .orElse(null);

        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(bookId, quantity, book.getPrice());
            cart.addItem(newItem);
        }

        cartDAO.save(cart);
    }

    @Override
    public void removeItemFromCart(Long userId, Long bookId) {
        Cart cart = getCartByUserId(userId);
        cart.removeItem(bookId);
        cartDAO.save(cart);
    }

    @Override
    public void updateCartItemQuantity(Long userId, Long bookId, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero");
        }

        Cart cart = getCartByUserId(userId);
        cart.updateItemQuantity(bookId, quantity);
        cartDAO.save(cart);
    }

    @Override
    public void clearCart(Long userId) {
        Cart cart = getCartByUserId(userId);
        cart.clearItems();
        cartDAO.save(cart);
    }

    @Override
    public double getCartTotal(Long userId) {
        Cart cart = getCartByUserId(userId);
        return cart.getItems().stream()
            .mapToDouble(item -> item.getPrice().doubleValue() * item.getQuantity())
            .sum();
    }

    @Override
    public List<CartItem> getCartItems(Long userId) {
        Cart cart = getCartByUserId(userId);
        return cart.getItems();
    }

    private Cart createNewCart(Long userId) {
        Cart cart = new Cart(userId);
        return cartDAO.save(cart);
    }
}
