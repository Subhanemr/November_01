CREATE DATABASE MusicPlayer

USE MusicPlayer

CREATE TABLE [USERS](
	UserId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) DEFAULT 'XXX',
	Username VARCHAR(50) NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	Gender VARCHAR(50) NOT NULL
)

CREATE TABLE Artists(
	ArtistId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) DEFAULT 'XXX',
	Birthday  DATE,
	Gender VARCHAR(50) NOT NULL
)

CREATE TABLE Categories(
	CategoryId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Musics (
    MusicId INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(100),
    Duration INT,
    CategoryId INT,
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryID)
)

CREATE TABLE Playlist (
    PlaylistId INT PRIMARY KEY IDENTITY,
    MusicId INT,
    UserId INT,
    FOREIGN KEY (MusicId) REFERENCES Musics(MusicId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
)

CREATE TABLE MusicArtist (
    MusicId INT,
    ArtistId INT,
    FOREIGN KEY (MusicId) REFERENCES Musics(MusicId),
    FOREIGN KEY (ArtistId) REFERENCES Artists(ArtistId)
)

INSERT INTO Users ([Name], Surname, Username, [Password], Gender)
VALUES ('Ryan', 'Gosling', 'Driver', 'IamjustKen42', 'AttackHelicopter')

INSERT INTO Artists ([Name] , Birthday, Gender)
VALUES ('Vaganich', '1998-05-05', 'Croissant')

INSERT INTO Categories ([Name])
VALUES ('Post-Punk')

INSERT INTO Musics ([Name], Duration, CategoryID)
VALUES ('Toska', 295, 1)

INSERT INTO Playlist (MusicID, UserID)
VALUES (1, 1)

INSERT INTO MusicArtist (MusicID, ArtistID)
VALUES (1, 1)

CREATE VIEW SongInformation 
AS
SELECT m.[Name] SongName, 
	   m.Duration SongLengt,
	   c.[Name] Category,
	   CONCAT(a.[Name], ' ', a.Surname) Artist
FROM Musics m
JOIN Categories c ON m.CategoryID=c.CategoryId
JOIN MusicArtist ma ON m.MusicId=ma.MusicId
JOIN Artists a ON ma.ArtistId=a.ArtistId

SELECT * FROM SongInformation


--------------------------------------------------------------------------------
--Task 2 hisse

ALTER TABLE Musics ADD IsDeleted BIT DEFAULT 0

CREATE TRIGGER GetMusicAfterDelete
ON Musics
INSTEAD OF DELETE
AS
DECLARE @result BIT
DECLARE @id INT
SELECT @result = IsDeleted, @id=deleted.MusicId FROM deleted
IF (@result=0)
  BEGIN 
	UPDATE Musics SET IsDeleted = 1 WHERE MusicId=@id
  END
ELSE
  BEGIN
	DELETE FROM Musics WHERE MusicId=@id
  END


CREATE PROCEDURE usp_CreateMusic
    @Name VARCHAR(100),
    @Duration INT,
    @CategoryId INT
AS
  BEGIN
    INSERT INTO Musics ([Name], Duration, CategoryId)
    VALUES (@Name, @Duration, @CategoryId);
  END

CREATE PROCEDURE usp_CreateUser
    @Name VARCHAR(50),
    @Surname VARCHAR(50) = 'XXX',
    @Username VARCHAR(50),
    @Password VARCHAR(50),
    @Gender VARCHAR(50)
AS
  BEGIN
    INSERT INTO Users ([Name], Surname, Username, [Password], Gender)
    VALUES (@Name, @Surname, @Username, @Password, @Gender);
  END

CREATE PROCEDURE usp_CreateArtists
    @Name VARCHAR(50),
    @Surname VARCHAR(50) = 'XXX',
	@Birthday  DATE,
    @Gender VARCHAR(50)
AS
  BEGIN
    INSERT INTO Artists ([Name], Surname, Birthday, Gender)
    VALUES (@Name, @Surname, @Birthday, @Gender)
  END

CREATE PROCEDURE usp_CreateCategory
    @Name VARCHAR(50)
AS
  BEGIN
    INSERT INTO Categories ([Name])
    VALUES (@Name);
  END

CREATE FUNCTION GetNumberOfPlaysByUser(@UserId INT)
RETURNS INT
AS
  BEGIN
    DECLARE @NumberOfPlays INT;
    
    SELECT @NumberOfPlays = COUNT(*) FROM Playlist WHERE UserId = @UserId;
    
    RETURN @NumberOfPlays;
  END


EXEC usp_CreateUser 'Ken', 'Barbie', 'KenBarBie', 'HiBarbie243', 'Doll'

EXEC usp_CreateUser 'John', 'Wick', 'johnwick', 'GivemeAgun', 'Maschine'

EXEC usp_CreateUser 'Bob', 'King', 'KINGBOB', 'KINGbob324BANANA', 'Minion'

EXEC usp_CreateArtists 'Michael', 'Jackson', '1958-08-29', 'NiMale'

EXEC usp_CreateArtists 'Adele', 'Adkins', '1988-05-05', 'Female'

EXEC usp_CreateArtists 'Murad', 'Xaseddinov', '2003-05-25', 'Sensei'

EXEC usp_CreateCategory 'Pop'

EXEC usp_CreateCategory 'Rock'

EXEC usp_CreateMusic 'Thriller', 354, 2

EXEC usp_CreateMusic 'Hello', 258, 2

EXEC usp_CreateMusic 'Like Doll', 297, 3

INSERT INTO Playlist (MusicId, UserId)
VALUES
    (2, 2),
    (3, 3),
    (3, 1)

INSERT INTO MusicArtist (MusicId, ArtistId)
VALUES
    (2, 2),
    (3, 3),
    (4, 4)


DELETE FROM MusicArtist WHERE MusicId = 4
DELETE FROM Musics WHERE MusicId=4 


DECLARE @UserId INT = 3
DECLARE @NumberOfPlays INT
SELECT @NumberOfPlays = dbo.GetNumberOfPlaysByUser(@UserId)
SELECT @NumberOfPlays NumberOfPlays



--Optional

CREATE DATABASE [Library]

USE [Library]

CREATE TABLE Authors (
  Id INT PRIMARY KEY IDENTITY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) DEFAULT 'XXX',
)

CREATE TABLE Books (
  Id INT PRIMARY KEY IDENTITY,
  Title VARCHAR(100) NOT NULL,
  ISBN VARCHAR(13) DEFAULT '0000000000000',
  PublicationYear INT NOT NULL CHECK (PublicationYear BETWEEN 0 AND 2023),
)

CREATE TABLE Borrowers (
  Id INT PRIMARY KEY IDENTITY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) DEFAULT 'XXX',
  Email VARCHAR(100),
)

CREATE TABLE Checkouts (
  Id INT PRIMARY KEY IDENTITY,
  BookId INT,
  BorrowerId INT,
  CheckoutDate DATE NOT NULL,
  ReturnDate DATE,
  FOREIGN KEY (BookId) REFERENCES Books (Id),
  FOREIGN KEY (BorrowerId) REFERENCES Borrowers (Id)
)

CREATE TABLE BooksAuthors (
  BookId INT,
  AuthorId INT,
  FOREIGN KEY (BookId) REFERENCES Books (Id),
  FOREIGN KEY (AuthorId) REFERENCES Authors (Id)
)


INSERT INTO Authors (FirstName, LastName) VALUES
    ('Ryan', 'Gosling'),
    ('Patrick', 'Bateman')

INSERT INTO Books (Title, ISBN, PublicationYear) VALUES
    ('Drive', '1234567890123', 2020),
    ('American Psycho', '9876543210987', 2019)

INSERT INTO Borrowers (FirstName, LastName, Email) VALUES
    ('Mike', 'Tyson', 'mike@example.com'),
    ('Bob', 'King', 'kingbob@example.com')

INSERT INTO Checkouts (BookId, BorrowerId, CheckoutDate, ReturnDate) VALUES
    (1, 1, '2023-01-15', NULL),
    (2, 2, '2023-02-20', '2023-03-15')

INSERT INTO BooksAuthors (BookId, AuthorId) VALUES
    (1, 1),
    (2, 2)

CREATE VIEW CheckedOutBooks 
AS
SELECT 
  b.Title Book,
  CONCAT(a.FirstName, ' ', a.LastName) Author,
  CONCAT(r.FirstName, ' ', r.LastName) Borrower,
  c.CheckoutDate,
  c.ReturnDate
FROM Checkouts c
JOIN Books b ON b.Id = c.BookId
JOIN BooksAuthors ba ON ba.BookId = b.Id
JOIN Authors a ON a.Id = ba.AuthorId
JOIN Borrowers r ON r.Id = c.BorrowerId
WHERE c.ReturnDate IS NULL

SELECT * FROM CheckedOutBooks

CREATE FUNCTION BooksCheckedOutByBorrower (@BorrowerId INT)
RETURNS INT
AS
BEGIN
    DECLARE @NotReturnedBooks INT;

    SELECT @NotReturnedBooks = COUNT(*)
    FROM Checkouts
    WHERE BorrowerId = @BorrowerId AND (ReturnDate IS NULL OR ReturnDate > GETDATE());

    RETURN @NotReturnedBooks
END;

DECLARE @Result INT;
SET @Result = dbo.BooksCheckedOutByBorrower(1);

SELECT 'Not returned books of Borrower' ResultDescription, @Result 'Number of books not returned'


CREATE PROCEDURE CheckOutBook (
    @BookId INT,
    @BorrowerId INT,
    @CheckoutDate DATE,
    @ReturnDate DATE
)
AS
BEGIN
    INSERT INTO Checkouts (BookId, BorrowerId, CheckoutDate, ReturnDate)
    VALUES (@BookId, @BorrowerId, @CheckoutDate, @ReturnDate);

    DECLARE @NotReturnedBooks INT;
    SET @NotReturnedBooks = dbo.BooksCheckedOutByBorrower(@BorrowerId);

    SELECT 'Not returned books of Borrower' AS ResultDescription, @NotReturnedBooks AS 'Number of books not returned';
END

EXEC CheckOutBook @BookId = 1, @BorrowerId = 1, @CheckoutDate = '2023-04-01', @ReturnDate = NULL;







