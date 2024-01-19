----------------------------------------------//---------------------------------------------------------------------
 -- Account
DROP TABLE IF EXISTS Account CASCADE;

CREATE TABLE Account (
	email VARCHAR(80) PRIMARY KEY,
	_password VARCHAR(25));


INSERT INTO Account
VALUES 
	('exemplo@gmail.com', 'senha123'),
	('teste@gmail.com', 'pa55word');


SELECT *
FROM Account;

-- Subscription

DROP TABLE IF EXISTS _Subscription CASCADE;

CREATE TABLE _Subscription (
	signingDate date,
	paymentStatus VARCHAR(20),
	durationSub smallint
);

-- Plan

DROP TABLE IF EXISTS Plan CASCADE;

CREATE TABLE Plan (
	plan VARCHAR(100) PRIMARY KEY,
	fee NUMERIC(5, 2)
);

-- CreditCard

DROP TABLE IF EXISTS CreditCard CASCADE;

CREATE TABLE CreditCard (
	cardNumber VARCHAR(19) PRIMARY KEY,
	securityCode VARCHAR(3),
	cardBrand VARCHAR(30),
	cardName VARCHAR(100));


SELECT *
FROM CreditCard;

-- User

DROP TABLE IF EXISTS _User CASCADE;

CREATE TABLE _User
	(email VARCHAR(80) REFERENCES ACCOUNT 
		ON UPDATE CASCADE 
	 	ON DELETE CASCADE,
	username VARCHAR(20),
	 
	PRIMARY KEY (email, username));


INSERT INTO _User
VALUES  
	('exemplo@gmail.com', 'Vini'),
	('exemplo@gmail.com', 'Sara'),
	('teste@gmail.com', 'Vini');

SELECT *
FROM _User;

-- Content

DROP TABLE IF EXISTS _Content CASCADE;

CREATE TABLE _Content(
	contentID varchar (20) PRIMARY KEY,
	synopsis varchar (1000),
	title VARCHAR(100),
	yearProdution timestamp
);


INSERT INTO _Content
VALUES 
	('00000000000000000001','aquele filme que o personagem faz aquela coisa','Aquele la','1/12/2022'),
	('00000000000000000002','o outro que eles fazem outras coisas em outro lugar','O outro','1/1/2022'),
	('00000000000000000003','','','1/1/2022'),
	('00000000000000000004','','','1/1/2018'),
	('00000000000000000005','','','1/1/2017');


SELECT *
FROM _Content;

-- Category

DROP TABLE IF EXISTS Category CASCADE;

CREATE TABLE Category (
	categoryName VARCHAR(20) PRIMARY KEY);


INSERT INTO Category
VALUES  
	('ação'),
	('aventura'),
	('comedia'),
	('drama'),
	('terror');


SELECT *
FROM Category;

--Watches

DROP TABLE IF EXISTS Watches CASCADE;

CREATE TABLE Watches(
	username VARCHAR(20),
	email VARCHAR(80),
	FOREIGN KEY (email, username)
		REFERENCES _USER 
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	contentID VARCHAR(20) 
		REFERENCES _Content
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	
	PRIMARY KEY (username, email, contentID),
	_timestamp timestamp
);

INSERT INTO Watches
VALUES 
	('Vini', 'teste@gmail.com', '00000000000000000001', '22/12/2023 15:15');


SELECT *
FROM Watches;

--Crew

DROP TABLE IF EXISTS Crew CASCADE;

CREATE TABLE Crew(
	contentID VARCHAR(20) PRIMARY KEY
		REFERENCES _CONTENT
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	DIRECTOR VARCHAR(100)
);

SELECT *
FROM CREW;

-- Cast

DROP TABLE IF EXISTS _Cast CASCADE;

CREATE TABLE _Cast(
	contentID VARCHAR(20) PRIMARY KEY
		REFERENCES Crew
		ON UPDATE CASCADE
		ON DELETE CASCADE);
	
--Movie

DROP TABLE IF EXISTS Movie CASCADE;

CREATE TABLE Movie(
	contentID varchar(20) 
		REFERENCES _Content
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	movieDur TIME
);


SELECT *
FROM Movie;

-- Series

DROP TABLE IF EXISTS Series CASCADE;

CREATE TABLE SERIES(
	contentID varchar(20) PRIMARY KEY
		REFERENCES _Content
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	numSeasons smallint
);


SELECT *
FROM SERIES;

--Season

DROP TABLE IF EXISTS Season CASCADE;

CREATE TABLE Season(
	contentID VARCHAR(20)
		REFERENCES Series
		ON UPDATE CASCADE 
		ON DELETE CASCADE,
	SEASONID smallint,
	PRIMARY KEY (contentID,	seasonID),
	numEpisodes int
);


SELECT *
FROM Season;

--Episode

DROP TABLE IF EXISTS Episode CASCADE;

CREATE TABLE Episode(
	episodeID smallint,
	contentID VARCHAR(20),
	seasonID smallint,
	FOREIGN KEY (contentID, SEASONID)
		REFERENCES SEASON
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	episodeDur TIME,
	episodeTitle VARCHAR(50),
	description VARCHAR(200),
	PRIMARY KEY (contentID, seasonID, episodeID)
);


SELECT *
FROM Episode;