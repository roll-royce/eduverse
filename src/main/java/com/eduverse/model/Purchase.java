package com.eduverse.model;

import java.sql.Timestamp;

public class Purchase {
    private int id;
    private int userId;
    private int bookId;
    private double price;
    private String paymentStatus;
    private Timestamp purchaseDate;

    // Getters
    public int getId() { return id; }
    public int getUserId() { return userId; }
    public int getBookId() { return bookId; }
    public double getPrice() { return price; }
    public String getPaymentStatus() { return paymentStatus; }
    public Timestamp getPurchaseDate() { return purchaseDate; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setPrice(double price) { this.price = price; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public void setPurchaseDate(Timestamp purchaseDate) { this.purchaseDate = purchaseDate; }

    // Constructors
    public Purchase() {}

    public Purchase(int userId, int bookId, double price) {
        this.userId = userId;
        this.bookId = bookId;
        this.price = price;
        this.paymentStatus = "PENDING";
    }

    @Override
    public String toString() {
        return "Purchase{" +
                "id=" + id +
                ", userId=" + userId +
                ", bookId=" + bookId +
                ", price=" + price +
                ", status='" + paymentStatus + '\'' +
                '}';
    }
}