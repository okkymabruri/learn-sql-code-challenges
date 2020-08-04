--1 Add new books to the library
SELECT * FROM Books WHERE Title Like '%Dracula%';

SELECT COUNT(b.Title) FROM Loans l
LEFT JOIN Books b ON l.BookID=b.BookID
WHERE b.Title Like '%Dracula%' AND l.ReturnedDate IS NULL;

SELECT
	(SELECT COUNT(b.Title) FROM Books b WHERE b.Title Like '%Dracula%')
	-
	(SELECT COUNT(b.Title) FROM Loans l
	LEFT JOIN Books b ON l.BookID=b.BookID
	WHERE b.Title Like '%Dracula%' AND l.ReturnedDate IS NULL)
AS AvailableBooks;

--2 Run a report to see what books are due back
INSERT INTO Books (Title, Author, Published, Barcode) VALUES
	('Dracula', 'Bram Stoker', 1897, 4819277482),
	("Gullivers's Travels", 'Jonathan Swift', 1729, 4899254401);

--3 Check out books
INSERT INTO Loans (BookID, PatronID, LoanDate, DueDate) VALUES
	((SELECT BookID FROM Books WHERE Barcode=2855934983),
	 (SELECT PatronID FROM Patrons WHERE Email='jvaan@wisdompets.com'),
	  '2020-08-25', '2020-09-08'),
	((SELECT BookID FROM Books WHERE Barcode=4043822646),
	 (SELECT PatronID FROM Patrons WHERE Email='jvaan@wisdompets.com'),
	  '2020-08-25', '2020-09-08');

SELECT p.FirstName, p.LastName, p.Email, b.Title, l.LoanDate, l.DueDate FROM Loans l
	LEFT JOIN Books b ON l.BookID=b.BookID
	LEFT JOIN Patrons p ON l.PatronID=p.PatronID
	ORDER BY LoanDate DESC;

--4 Check for books due back
SELECT l.DueDate, l.ReturnedDate, p.FirstName, p.LastName, p.Email, b.Title FROM Loans l
	LEFT JOIN Books b ON l.BookID=b.BookID
	LEFT JOIN Patrons p ON l.PatronID=p.PatronID
	WHERE l.DueDate='2020-07-13' AND l.ReturnedDate IS NULL;

--5 Return books to the library
UPDATE Loans
	SET ReturnedDate='2020-06-05'
	WHERE BookID=(SELECT BookID FROM Books WHERE Barcode=6435968624) AND
	ReturnedDate IS NULL;

--6 Encourage patrons to check out books
SELECT COUNT(l.PatronID) AS LoanCount, p.FirstName, p.LastName, p.Email FROM Loans l
	LEFT JOIN Books b ON l.BookID=b.BookID
	LEFT JOIN Patrons p ON l.PatronID=p.PatronID
	GROUP BY l.PatronID ORDER BY LoanCount LIMIT 10;

--7 Find books to feature for an event
SELECT b.Title, b.Author, b.Published FROM Books b
	LEFT JOIN Loans l ON l.BookID=b.BookID
	WHERE (b.Published BETWEEN 1889 AND 1900) AND l.DueDate IS NOT NULL
	GROUP BY b.Title ORDER BY b.Title;

--8 Book statistics
SELECT Published, COUNT(DISTINCT(Title)) AS PublishedBookCount FROM Books
	GROUP BY Published ORDER BY PublishedBookCount DESC;

SELECT COUNT(l.BookID) AS FavoriteBook, b.Title, b.Author, b.Published FROM Loans l
	LEFT JOIN Books b ON l.BookID=b.BookID
	GROUP BY b.Title ORDER BY FavoriteBook DESC LIMIT 5;