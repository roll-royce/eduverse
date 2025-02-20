package com.eduverse.service.impl;

import com.eduverse.dao.BookDAO;
import com.eduverse.dao.impl.BookDAOImpl;
import com.eduverse.model.Book;
import com.eduverse.exception.ResourceNotFoundException;
import com.eduverse.service.BookService;

import java.util.List;
import java.util.Optional;

public class BookServiceImpl implements BookService {
    private final BookDAO bookDAO;

    public BookServiceImpl() {
        this.bookDAO = new BookDAOImpl();
    }

    @Override
    public Book createBook(Book book) {
        validateBook(book);
        return bookDAO.save(book);
    }

    @Override
    public Book updateBook(Book book) {
        if (book.getId() == 0) {
            throw new IllegalArgumentException("Book ID cannot be null for update");
        }
        validateBook(book);
        return bookDAO.findById((long) book.getId())
                .map(existingBook -> bookDAO.update(book))
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + book.getId()));
    }

    @Override
    public void deleteBook(Long id) {
        if (!bookDAO.delete(id)) {
            throw new ResourceNotFoundException("Book not found with id: " + id);
        }
    }

    @Override
    public Book getBookById(Long id) {
        return bookDAO.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + id));
    }

    @Override
    public List<Book> getAllBooks() {
        return bookDAO.findAll();
    }

    @Override
    public List<Book> getBooksByCategory(String category) {
        try {
            return bookDAO.findByCategory(category);
        } catch (Exception e) {
            throw new RuntimeException("Error finding books by category", e);
        }
    }

    @Override
    public List<Book> searchBooks(String keyword) {
        return bookDAO.searchByKeyword(keyword);
    }

    @Override
    public List<Book> getTopSellingBooks(int limit) {
        return bookDAO.findTopSelling(limit);
    }

    private void validateBook(Book book) {
        if (book == null) {
            throw new IllegalArgumentException("Book cannot be null");
        }
        if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book title cannot be empty");
        }
        if (book.getPrice() < 0) {
            throw new IllegalArgumentException("Invalid book price");
        }
        if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
            throw new IllegalArgumentException("Book author cannot be empty");
        }
        if (book.getIsbn() == null || !book.getIsbn().matches("^\\d{13}$")) {
            throw new IllegalArgumentException("Invalid ISBN format");
        }
    }
}
