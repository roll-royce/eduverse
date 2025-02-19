package com.eduverse.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Book {
    private int id;
    private String title;
    private String author;
    private String description;
    private double price;
    private String coverImage;
    private String filePath;
    private String category;
    private String language;
    private String format;
    private int pages;
    private String publisher;
    private Date publicationDate;
    private String isbn;
    private int userId;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Getters
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public String getCoverImage() { return coverImage; }
    public String getFilePath() { return filePath; }
    public String getCategory() { return category; }
    public String getLanguage() { return language; }
    public String getFormat() { return format; }
    public int getPages() { return pages; }
    public String getPublisher() { return publisher; }
    public Date getPublicationDate() { return publicationDate; }
    public String getIsbn() { return isbn; }
    public int getUserId() { return userId; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setTitle(String title) { this.title = title; }
    public void setAuthor(String author) { this.author = author; }
    public void setDescription(String description) { this.description = description; }
    public void setPrice(double price) { this.price = price; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public void setCategory(String category) { this.category = category; }
    public void setLanguage(String language) { this.language = language; }
    public void setFormat(String format) { this.format = format; }
    public void setPages(int pages) { this.pages = pages; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public void setPublicationDate(Date publicationDate) { this.publicationDate = publicationDate; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setStatus(String status) { this.status = status; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Constructor with required fields
    public Book(String title, String author, double price, String filePath) {
        this.title = title;
        this.author = author;
        this.price = price;
        this.filePath = filePath;
        this.status = "ACTIVE";
        this.language = "English";
        this.format = "PDF";
    }

    // Default constructor
    public Book() {}

    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                '}';
    }
}