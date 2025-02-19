package com.eduverse.model;

import java.sql.Timestamp;

public class CartItem {
    private int id;
    private int userId;
    private int bookId;
    private Timestamp addedAt;
    
    // Additional fields for cart display
    private Book book;
    private double totalPrice;

    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public int getBookId() { return bookId; }
    public Timestamp getAddedAt() { return addedAt; }
    public Book getBook() { return book; }
    public double getTotalPrice() { return totalPrice; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setAddedAt(Timestamp addedAt) { this.addedAt = addedAt; }
    public void setBook(Book book) { 
        this.book = book;
        if(book != null) {
            this.totalPrice = book.getPrice();
        }
    }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    // Constructors
    public CartItem() {}

    public CartItem(int userId, int bookId) {
        this.userId = userId;
        this.bookId = bookId;
    }

    public CartItem(int userId, Book book) {
        this.userId = userId;
        this.bookId = book.getId();
        this.book = book;
        this.totalPrice = book.getPrice();
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", userId=" + userId +
                ", bookId=" + bookId +
                ", bookTitle='" + (book != null ? book.getTitle() : "N/A") + '\'' +
                ", price=" + totalPrice +
                '}';
    }

    // Utility methods
    public boolean hasBook() {
        return book != null;
    }

    public String getBookTitle() {
        return book != null ? book.getTitle() : "Unknown Book";
    }

    public String getBookAuthor() {
        return book != null ? book.getAuthor() : "Unknown Author";
    }

    public String getFormattedPrice() {
        return String.format("₹%.2f", totalPrice);
    }

    public String getFormattedDate() {
        return addedAt != null ? addedAt.toString() : "N/A";
    }
}