CREATE DATABASE LibraryManagement;

USE LibraryManagement;
-- Members Table
CREATE TABLE Members(
MemberID INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Address VARCHAR(100)
);

-- AUTHOR Table
CREATE TABLE Author (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    AuthorName VARCHAR(50) NOT NULL,
    Nationality VARCHAR(50)
);

-- GENRE Table
CREATE TABLE Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(50) NOT NULL UNIQUE
);

-- BOOK Table
CREATE TABLE BOOK (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    CopiesAvailable INT NOT NULL DEFAULT 0,
    GenreID INT NOT NULL,
    AuthorID INT NOT NULL,
    FOREIGN KEY (GenreID) REFERENCES GENRE(GenreID),
    FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID)
);   

-- BORROWING Table
CREATE TABLE BorrowingTransactions(
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    BorrowingDate DATE,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,  -- NULL if not returned
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES BOOK(BookID)
);
ALTER TABLE author RENAME COLUMN Nationality TO Biography;
ALTER TABLE author MODIFY biography VARCHAR(100);
INSERT INTO AUTHOR (AuthorName, Biography) VALUES
('GeorgeOrwell', 'English novelist and essayist known for dystopian fiction.'),
('Harper Lee', 'American novelist best known for To Kill a Mockingbird.'),
('F. Scott Fitzgerald', 'American novelist of the Jazz Age.'),
('Jane Austen', 'English novelist known for her six major novels.'),
('J.R.R. Tolkien', 'English writer, poet, philologist, and academic.');

INSERT INTO GENRE (GenreName) VALUES
('Fiction'),
('Non-Fiction'),
('Fantasy'),
('Mystery' ),
('Romance');

INSERT INTO BOOK (Title, CopiesAvailable, GenreID, AuthorID) VALUES
('1984', 3, 1, 1),  -- Fiction, Orwell
('To Kill a Mockingbird', 5, 1, 2),  -- Fiction, Lee
('The Great Gatsby', 2, 1, 3),  -- Fiction, Fitzgerald
('Pride and Prejudice', 4, 5, 4),  -- Romance, Austen
('The Hobbit', 6, 3, 5);  -- Fantasy, Tolkien

INSERT INTO MEMBERs (Name, Address) VALUES
('John Smith', '123 Main St, Anytown'),
('Sarah Johnson','456 Oak Ave, Somewhere'),
('Michael Brown', '789 Pine Rd, Nowhere'),
('Emily Davis','321 Elm St, Elsewhere'),
('David Wilson','654 Cedar Ln, Anywhere');

INSERT INTO borrowingtransactions (MemberID, BookID, BorrowingDate, DueDate, ReturnDate) VALUES
(1, 1, '2026-03-01', '2026-03-06', '2026-03-05'),  -- John borrowed 1984, returned early
(2, 2, '2026-03-03', '2026-03-08', NULL),      -- Sarah borrowed To Kill a Mockingbird, not returned
(3, 3, '2026-03-05', '2026-03-10', '2026-03-12'),  -- Michael borrowed Gatsby, returned late
(4, 4, '2026-03-07', '2026-03-12', '2026-03-11'),  -- Emily borrowed Pride and Prejudice, returned on time
(5, 5, '2026-03-09', '2026-03-14', NULL);      -- David borrowed The Hobbit, not returned

select * from borrowingtransactions;

SELECT *
FROM BorrowingTrancasctions br 
INNER JOIN BOOK b ON br.BookID = b.BookID
INNER JOIN Members m ON m.MemberID=br.MemberID
WHERE br.MemberID = 5  -- Replace 5 with desired member ID
ORDER BY br.BorrowingDate DESC;
-- 2. Display overdue books
-- Query to find currently overdue books (not yet returned)
SELECT 
    br.TransactionID,
    m.Name, 
    b.Title,
    br.BorrowingDate,
    br.DueDate,
    DATEDIFF(CURDATE(), br.DueDate) AS DaysOverdue
FROM borrowingTransactions br
JOIN MEMBERs m ON br.MemberID = m.MemberID
JOIN book b ON br.BookID = b.BookID
WHERE br.DueDate < CURDATE() 
  AND br.ReturnDate IS NULL
ORDER BY br.DueDate ASC;

-- all books borrowed by a particular member
SELECT 
 b.BookID,
    b.Title,
    m.Name,
    br.BorrowingDate,
    br.DueDate,
    br.ReturnDate
FROM BorrowingTransactions br 
INNER JOIN BOOK b ON br.BookID = b.BookID
INNER JOIN Members m ON m.MemberID=br.MemberID
WHERE br.MemberID = 5 ; -- Replace 5 with desired member ID

-- books available in a specific category
SELECT  
	b.BookID,
    b.Title,
    a.AuthorName,
    b.CopiesAvailable,
    g.GenreName
FROM BOOK b
INNER JOIN AUTHOR a ON b.AuthorID = a.AuthorID
INNER JOIN GENRE g ON b.GenreID = g.GenreID
WHERE g.GenreName = 'Fiction'  -- Replace 'Fiction' with desired genre
  AND b.CopiesAvailable > 0  -- Only show books with available copies
ORDER BY b.Title ASC;
