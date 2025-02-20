package com.eduverse.dao;

import java.util.List;

import com.eduverse.model.Book;

public interface BookDAO extends BaseDAO<Book> {
    // Search and filter methods
    List<Book> findByCategory(String category) throws Exception;
    List<Book> findByAuthor(String author) throws Exception;
    List<Book> findByPriceRange(double minPrice, double maxPrice) throws Exception;
    List<Book> searchBooks(String query) throws Exception;
    
    // Featured and recent books
    List<Book> getRecentBooks(int limit) throws Exception;
    List<Book> getFeaturedBooks(int limit) throws Exception;
    List<Book> getBestsellingBooks(int limit) throws Exception;
    List<Book> findTopSelling(int limit);
    
    // User specific methods
    List<Book> getBooksByUser(int userId) throws Exception;
    List<Book> getPurchasedBooks(int userId) throws Exception;
    
    // Book management methods
    boolean updateStatus(int bookId, String status) throws Exception;
    boolean updateCoverImage(int bookId, String coverImagePath) throws Exception;
    boolean updateBookFile(int bookId, String filePath) throws Exception;
    
    // Statistics methods
    int getTotalBookCount() throws Exception;
    double getAverageBookPrice() throws Exception;
    int getBookCountByCategory(String category) throws Exception;
    
    // Validation methods
    boolean isBookTitleExists(String title) throws Exception;
    boolean isBookOwnedByUser(int bookId, int userId) throws Exception;
    
    // Batch operations
    boolean batchUpdatePrices(List<Book> books) throws Exception;
    boolean batchDeleteBooks(List<Integer> bookIds) throws Exception;
    
    // Advanced search
    List<Book> advancedSearch(String title, String author, String category, 
                             Double minPrice, Double maxPrice, String language) throws Exception;
    
    // Category management
    List<String> getAllCategories() throws Exception;
    List<String> getPopularCategories(int limit) throws Exception;

    List<Book> searchByKeyword(String keyword);
}