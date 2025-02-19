-- Insert sample books
INSERT INTO books (
    title, author, description, price, category, 
    language, format, pages, publisher, publication_date, 
    isbn, user_id, file_path
) 
VALUES 
(
    'Java Programming', 'John Smith', 'Comprehensive Java guide', 
    29.99, 'Programming', 'English', 'PDF', 450, 
    'Tech Books', '2024-01-15', '9781234567890', 1,
    '/books/java-programming.pdf'
),
(
    'Python Basics', 'Sarah Johnson', 'Python for beginners', 
    24.99, 'Programming', 'English', 'PDF', 300, 
    'Code Press', '2024-02-01', '9789876543210', 1,
    '/books/python-basics.pdf'
),
(
    'Web Development', 'Mike Brown', 'Full-stack development guide', 
    34.99, 'Web', 'English', 'PDF', 500, 
    'Dev Books', '2024-01-20', '9784567891230', 1,
    '/books/web-development.pdf'
);

-- Verify books are inserted before adding related data
SELECT @java_book_id := id FROM books WHERE title = 'Java Programming' LIMIT 1;
SELECT @python_book_id := id FROM books WHERE title = 'Python Basics' LIMIT 1;
SELECT @web_book_id := id FROM books WHERE title = 'Web Development' LIMIT 1;

-- Insert sample ratings
INSERT INTO book_ratings (book_id, user_id, rating, review) 
VALUES 
(@java_book_id, 2, 5, 'Excellent book for Java learners'),
(@python_book_id, 2, 4, 'Good introduction to Python');

-- Insert sample purchases
INSERT INTO purchases (user_id, book_id, price, payment_status, transaction_id) 
VALUES 
(2, @java_book_id, 29.99, 'COMPLETED', 'TRX123456'),
(2, @python_book_id, 24.99, 'COMPLETED', 'TRX123457');

-- Insert sample cart items
INSERT INTO cart_items (user_id, book_id, quantity) 
VALUES 
(2, @web_book_id, 1);

-- Verify data
SELECT 'Books' as table_name, COUNT(*) as count FROM books
UNION ALL
SELECT 'Ratings', COUNT(*) FROM book_ratings
UNION ALL
SELECT 'Purchases', COUNT(*) FROM purchases
UNION ALL
SELECT 'Cart Items', COUNT(*) FROM cart_items;