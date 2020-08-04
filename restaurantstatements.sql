--1
SELECT FirstName, LastName, Email FROM Customers ORDER BY LastName;

--2
DROP TABLE IF EXISTS AnniversaryAttendees;
CREATE TABLE AnniversaryAttendees (
  CustomerID INT,
  PartySize INT,
  PRIMARY KEY (CustomerID)
);

--3
SELECT * FROM Dishes ORDER BY Price;
SELECT * FROM Dishes WHERE Type='Appetizer' OR Type='Beverage'
  ORDER BY Type;
  SELECT * FROM Dishes WHERE Type != 'Beverage' ORDER BY Type;

--4
DELETE FROM Customers WHERE CustomerID >= 101;

INSERT INTO Customers (FirstName, LastName, Email, Address, City, State, Phone, Birthday)
  VALUES ('Okky', 'Mabruri', 'okkymabrur@gmail.com', 'Ngusikan Jombang', 'Jombang', 'ID', '574-644-0767', '1996-04-01');

SELECT * FROM Customers ORDER BY CustomerID DESC;

--5
SELECT * FROM Customers WHERE FirstName='Taylor' AND LastName='Jenkins';

UPDATE Customers
  SET Address='74 Pine St.', City='New York', State='NY'
  WHERE CustomerID=26;

--6
DELETE FROM Customers WHERE CustomerID=4;

--7
INSERT INTO AnniversaryAttendees (CustomerID, PartySize)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email LIKE 'atapley2j%'), 4);
SELECT * FROM AnniversaryAttendees;

--8
SELECT c.CustomerID, c.FirstName, c.LastName, r.PartySize, r.Date
  FROM Customers c
  JOIN Reservations r ON c.CustomerID=r.CustomerID
  WHERE c.LastName LIKE 'Ste%n' ORDER BY r.Date DESC;

--9 Take a Reservations
SELECT * FROM Customers WHERE Email='smac@rouxacademy.com';

INSERT INTO Customers (FirstName, LastName, Email, Phone)
  VALUES ('Sam','McAdams','smac@rouxacademy.com','(555) 555-1212');
INSERT INTO Reservations (CustomerID, Date, PartySize)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='smac@rouxacademy.com'),'2020-07-06 18:00:00', 5);
SELECT c.FirstName, c.LastName, c.Email, c.Phone, r.PartySize FROM Customers c
  JOIN Reservations r ON c.CustomerID=r.CustomerID
  WHERE Email='smac@rouxacademy.com';

--10 Take a delivery order
SELECT * FROM Customers WHERE LastName='Hundey' AND Address like '6939%';

INSERT INTO Orders (CustomerID, OrderDate)
	VALUES (70, '2020-08-04 11:00:00');
SELECT * FROM Orders WHERE CustomerID=70 ORDER BY OrderDate DESC;

INSERT INTO OrdersDishes (OrderID, DishID) VALUES
	(1001, (SELECT DishID FROM Dishes WHERE Name='House Salad')),
	(1001, (SELECT DishID FROM Dishes WHERE Name='Mini Cheeseburgers')),
	(1001, (SELECT DishID FROM Dishes WHERE Name='Tropical Blue Smoothie'));

SELECT sum(d.Price) FROM OrdersDishes od
	LEFT JOIN Dishes d ON od.DishID=d.DishID
	WHERE od.OrderID=1001;

--11
SELECT * FROM Customers c
	LEFT JOIN Dishes d on c.FavoriteDish=d.DishID
	WHERE c.FirstName='Cleo';

UPDATE Customers
	SET FavoriteDish=(SELECT DishID FROM Dishes WHERE Name='Quinoa Salmon Salad')
	WHERE FirstName='Cleo';

--12
SELECT count(o.OrderID) NumberOrders, c.FirstName, c.LastName, c.Email FROM Orders o
LEFT JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY c.CustomerID
ORDER BY NumberOrders DESC LIMIT 5;