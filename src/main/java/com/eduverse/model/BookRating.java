package com.eduverse.model;

import java.sql.Timestamp;

public class BookRating {
    private int id;
    private int bookId;
    private int userId;
    private int rating;
    private String review;
    private Timestamp createdAt;

    // Getters
    public int getId() { return id; }
    public int getBookId() { return bookId; }
    public int getUserId() { return userId; }
    public int getRating() { return rating; }
    public String getReview() { return review; }
    public Timestamp getCreatedAt() { return createdAt; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setRating(int rating) { this.rating = rating; }
    public void setReview(String review) { this.review = review; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Constructors
    public BookRating() {}

    public BookRating(int bookId, int userId, int rating, String review) {
        this.bookId = bookId;
        this.userId = userId;
        this.rating = rating;
        this.review = review;
    }

    @Override
    public String toString() {
        return "BookRating{" +
                "id=" + id +
                ", bookId=" + bookId +
                ", userId=" + userId +
                ", rating=" + rating +
                '}';
    }
}