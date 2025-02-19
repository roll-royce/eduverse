-- Create database
CREATE DATABASE IF NOT EXISTS eduverse;
USE eduverse;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS book_ratings;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    profile_image VARCHAR(255),
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    status ENUM('ACTIVE', 'INACTIVE', 'DELETED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_role (role)
);

-- Create books table
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    cover_image VARCHAR(255),
    file_path VARCHAR(255) NOT NULL,
    category VARCHAR(50),
    language VARCHAR(50) DEFAULT 'English',
    format VARCHAR(10) DEFAULT 'PDF',
    pages INT,
    publisher VARCHAR(100),
    publication_date DATE,
    isbn VARCHAR(13),
    user_id INT,
    status ENUM('ACTIVE', 'INACTIVE', 'DELETED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_category (category),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_created_at (created_at),
    INDEX idx_author (author),
    INDEX idx_title (title),
    INDEX idx_language (language)
);

-- Create book_ratings table
CREATE TABLE book_ratings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    status ENUM('ACTIVE', 'DELETED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_user_book_rating (user_id, book_id),
    INDEX idx_rating (rating),
    INDEX idx_status (status)
);

-- Create purchases table
CREATE TABLE purchases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING',
    transaction_id VARCHAR(100),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_purchase_date (purchase_date)
);

-- Create cart_items table
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id),
    UNIQUE KEY unique_user_book (user_id, book_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- Create some sample data
INSERT INTO users (username, email, password, full_name, role) VALUES
('admin', 'admin@eduverse.com', '$2a$10$XgK.zzzz', 'Admin User', 'ADMIN'),
('user1', 'user1@eduverse.com', '$2a$10$XgK.yyyy', 'Test User 1', 'USER');

-- Set character set and collation
ALTER DATABASE eduverse CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Optimize tables
ANALYZE TABLE users, books, book_ratings, purchases, cart_items;