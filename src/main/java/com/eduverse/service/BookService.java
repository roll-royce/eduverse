package com.eduverse.service;

import java.util.List;

import com.eduverse.model.Book;

public interface BookService {
    Book createBook(Book book);
    Book updateBook(Book book);
    void deleteBook(Long id);
    Book getBookById(Long id);
    List<Book> getAllBooks();
    List<Book> getBooksByCategory(String category);
    List<Book> searchBooks(String keyword);
    List<Book> getTopSellingBooks(int limit);
}
