-- LibSphere Library Management System
-- MySQL 8.0.16+ / InnoDB
-- Run top to bottom in MySQL Workbench.

CREATE DATABASE IF NOT EXISTS libsphere;
USE libsphere;

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    bio TEXT NULL
) ENGINE=InnoDB;

CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    publication_year INT NOT NULL,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_books_isbn_length CHECK (CHAR_LENGTH(isbn) = 13),
    CONSTRAINT chk_books_year CHECK (publication_year BETWEEN 1450 AND 2100),
    CONSTRAINT chk_books_total_copies CHECK (total_copies >= 1),
    CONSTRAINT chk_books_available_copies CHECK
        (available_copies >= 0 AND available_copies <= total_copies),
    CONSTRAINT fk_books_category FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Book_Authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id)
        REFERENCES Books(book_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id)
        REFERENCES Authors(author_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    membership_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_members_status CHECK
        (status IN ('Active', 'Suspended', 'Expired'))
) ENGINE=InnoDB;

CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Issued',
    CONSTRAINT chk_loans_status CHECK
        (status IN ('Issued', 'Returned', 'Overdue')),
    CONSTRAINT chk_loans_due_date CHECK (due_date >= loan_date),
    CONSTRAINT chk_loans_return_date CHECK
        (return_date IS NULL OR return_date >= loan_date),
    CONSTRAINT chk_loans_status_return CHECK
        ((status = 'Returned' AND return_date IS NOT NULL) OR
         (status IN ('Issued', 'Overdue') AND return_date IS NULL)),
    CONSTRAINT fk_loans_book FOREIGN KEY (book_id)
        REFERENCES Books(book_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_loans_member FOREIGN KEY (member_id)
        REFERENCES Members(member_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

USE libsphere;

INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Computer Science'),
(2, 'Fiction'),
(3, 'History'),
(4, 'Business'),
(5, 'Science');

INSERT INTO Authors (author_id, first_name, last_name, bio) VALUES
(1, 'Robert C.', 'Martin', 'Software engineering author known for Clean Code.'),
(2, 'Andrew', 'Hunt', 'Software developer and co-author of The Pragmatic Programmer.'),
(3, 'David', 'Thomas', 'Software developer and co-author of The Pragmatic Programmer.'),
(4, 'George', 'Orwell', 'English novelist and essayist.'),
(5, 'Yuval Noah', 'Harari', 'Historian and author of Sapiens.'),
(6, 'Jane', 'Austen', 'English novelist.'),
(7, 'Andrew S.', 'Tanenbaum', 'Computer scientist and textbook author.'),
(8, 'Frederick P.', 'Brooks Jr.', 'Computer scientist and software project management author.'),
(9, 'Stephen', 'Hawking', 'Theoretical physicist and science author.');

INSERT INTO Books (book_id, title, isbn, category_id, publication_year, total_copies, available_copies) VALUES
(1, 'Clean Code', '9780132350884', 1, 2008, 5, 3),
(2, 'The Pragmatic Programmer', '9780201616224', 1, 1999, 4, 3),
(3, 'Nineteen Eighty-Four', '9780451524935', 2, 1949, 6, 5),
(4, 'Sapiens', '9780062316097', 3, 2011, 4, 4),
(5, 'Pride and Prejudice', '9780141439518', 2, 1813, 3, 2),
(6, 'Computer Networks', '9780132126953', 1, 2012, 5, 4),
(7, 'The Mythical Man-Month', '9780201835953', 4, 1975, 3, 3),
(8, 'A Brief History of Time', '9780553380163', 5, 1988, 4, 4);

INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1),
(2, 2), (2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9);

INSERT INTO Members (member_id, first_name, last_name, email, phone, membership_date, status) VALUES
(1, 'Asha', 'Rao', 'asha.rao@example.edu', '+91-9000000001', '2026-01-10', 'Active'),
(2, 'Rahul', 'Menon', 'rahul.menon@example.edu', '+91-9000000002', '2026-02-02', 'Active'),
(3, 'Priya', 'Sharma', 'priya.sharma@example.edu', '+91-9000000003', '2026-02-15', 'Active'),
(4, 'Karthik', 'Iyer', 'karthik.iyer@example.edu', '+91-9000000004', '2026-03-01', 'Active'),
(5, 'Meera', 'Nair', 'meera.nair@example.edu', '+91-9000000005', '2026-03-18', 'Active'),
(6, 'Vikram', 'Das', 'vikram.das@example.edu', '+91-9000000006', '2026-04-05', 'Suspended');

INSERT INTO Loans (loan_id, book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, 1, '2026-10-01', '2026-10-15', NULL, 'Overdue'),
(2, 1, 2, '2026-10-20', '2026-11-03', NULL, 'Issued'),
(3, 2, 3, '2026-10-05', '2026-10-19', NULL, 'Overdue'),
(4, 3, 4, '2026-10-10', '2026-10-24', NULL, 'Issued'),
(5, 5, 5, '2026-10-21', '2026-11-04', NULL, 'Issued'),
(6, 6, 1, '2026-10-22', '2026-11-05', NULL, 'Issued'),
(7, 1, 3, '2026-08-01', '2026-08-15', '2026-08-12', 'Returned'),
(8, 2, 4, '2026-07-02', '2026-07-16', '2026-07-14', 'Returned'),
(9, 3, 1, '2026-06-10', '2026-06-24', '2026-06-20', 'Returned'),
(10, 4, 2, '2026-09-05', '2026-09-19', '2026-09-15', 'Returned'),
(11, 5, 3, '2026-09-08', '2026-09-22', '2026-09-21', 'Returned'),
(12, 7, 6, '2026-08-20', '2026-09-03', '2026-09-01', 'Returned'),
(13, 8, 5, '2026-07-15', '2026-07-29', '2026-07-25', 'Returned'),
(14, 6, 4, '2026-09-12', '2026-09-26', '2026-09-23', 'Returned');

-- ============================================================
-- ASSIGNMENT 8: BASIC SQL QUERIES
-- ============================================================

-- Query 1: Filter active members using WHERE
SELECT member_id, first_name, last_name, status
FROM Members
WHERE status = 'Active'
ORDER BY first_name;

-- Query 2: Sort the newest publication years first
SELECT title, publication_year
FROM Books
ORDER BY publication_year DESC
LIMIT 5;

-- Query 3: Count titles in each category with GROUP BY
SELECT c.category_name, COUNT(b.book_id) AS title_count
FROM Categories AS c
LEFT JOIN Books AS b ON b.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY title_count DESC, c.category_name;

-- Query 4: Keep only categories with at least two titles using HAVING
SELECT c.category_name, COUNT(b.book_id) AS title_count
FROM Categories AS c
JOIN Books AS b ON b.category_id = c.category_id
GROUP BY c.category_id, c.category_name
HAVING COUNT(b.book_id) >= 2
ORDER BY title_count DESC, c.category_name;

-- Query 5: Demonstrate COUNT, SUM, AVG, MIN, and MAX
SELECT COUNT(*) AS title_count,
       SUM(total_copies) AS total_stock,
       AVG(total_copies) AS average_stock_per_title,
       MIN(publication_year) AS oldest_publication_year,
       MAX(publication_year) AS newest_publication_year
FROM Books;

-- Query 6: Count current loans that are not yet returned
SELECT COUNT(*) AS open_loan_count
FROM Loans
WHERE status IN ('Issued', 'Overdue');

-- Query 7: Apply a WHERE filter to recent titles, then sort
SELECT title, publication_year
FROM Books
WHERE publication_year >= 2000
ORDER BY publication_year DESC;

-- ============================================================
-- ASSIGNMENT 9: ADVANCED SQL QUERIES
-- ============================================================

-- Report 1: Open-loan register using INNER JOINs
SELECT l.loan_id, b.title,
       CONCAT(m.first_name, ' ', m.last_name) AS member_name,
       l.loan_date, l.due_date, l.status
FROM Loans AS l
JOIN Books AS b ON b.book_id = l.book_id
JOIN Members AS m ON m.member_id = l.member_id
WHERE l.status IN ('Issued', 'Overdue')
ORDER BY l.due_date, l.loan_id;

-- Report 2: List each title, its category, and its author(s)
SELECT b.book_id, b.title, c.category_name,
       GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name)
                    ORDER BY a.last_name SEPARATOR ', ') AS author_list
FROM Books AS b
JOIN Categories AS c ON c.category_id = b.category_id
LEFT JOIN Book_Authors AS ba ON ba.book_id = b.book_id
LEFT JOIN Authors AS a ON a.author_id = ba.author_id
GROUP BY b.book_id, b.title, c.category_name
ORDER BY b.book_id;

-- Report 3: Titles with more than one recorded loan (correlated subquery)
SELECT b.title,
       (SELECT COUNT(*) FROM Loans AS l WHERE l.book_id = b.book_id) AS loan_count
FROM Books AS b
WHERE (SELECT COUNT(*) FROM Loans AS l WHERE l.book_id = b.book_id) > 1
ORDER BY loan_count DESC, b.title;

-- Report 4: Members who have at least one overdue loan (EXISTS subquery)
SELECT m.member_id, CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM Members AS m
WHERE EXISTS (
    SELECT 1 FROM Loans AS l
    WHERE l.member_id = m.member_id AND l.status = 'Overdue'
)
ORDER BY m.member_id;

-- Report 5: Number of recorded loan transactions by category
SELECT c.category_name, COUNT(l.loan_id) AS loan_transactions
FROM Categories AS c
LEFT JOIN Books AS b ON b.category_id = c.category_id
LEFT JOIN Loans AS l ON l.book_id = b.book_id
GROUP BY c.category_id, c.category_name
ORDER BY loan_transactions DESC, c.category_name;

-- Report 6: Members whose recorded loan count is above the per-member average
SELECT m.member_id,
       CONCAT(m.first_name, ' ', m.last_name) AS member_name,
       COUNT(l.loan_id) AS loan_count
FROM Members AS m
JOIN Loans AS l ON l.member_id = m.member_id
GROUP BY m.member_id, m.first_name, m.last_name
HAVING COUNT(l.loan_id) > (
    SELECT AVG(member_counts.loan_count)
    FROM (
        SELECT COUNT(*) AS loan_count
        FROM Loans
        GROUP BY member_id
    ) AS member_counts
)
ORDER BY loan_count DESC, m.member_id;

-- Report 7: Inventory view - copies currently unavailable for checkout
SELECT title, total_copies, available_copies,
       (total_copies - available_copies) AS copies_not_available
FROM Books
ORDER BY book_id;

-- Report 8: Titles whose stock exceeds the average stock per title
SELECT title, total_copies
FROM Books
WHERE total_copies > (SELECT AVG(total_copies) FROM Books)
ORDER BY total_copies DESC, title;
