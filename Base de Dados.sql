----------------------------------------------//---------------------------------------------------------------------
-- Account
 
DROP TABLE IF EXISTS Account CASCADE;

CREATE TABLE Account (
	email VARCHAR(80) PRIMARY KEY,
	_password VARCHAR(25),
	cardNumber VARCHAR(16)	
	);
	
-- CreditCard
--Armazena as informaçoes do atributo composto.
DROP TABLE IF EXISTS CreditCard CASCADE;

CREATE TABLE CreditCard (
	cardNumber VARCHAR(16) PRIMARY KEY,
	securityCode VARCHAR(3),
	cardBrand VARCHAR(30),
	cardName VARCHAR(100),
	email VARCHAR(20),
	FOREIGN KEY (email) REFERENCES Account
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


-- Plan
--São os diferentes tipos de planos do Netflix.
DROP TABLE IF EXISTS _Plan CASCADE;

CREATE TABLE _Plan (
	planID INTEGER PRIMARY KEY,
	planName VARCHAR(30),
	fee NUMERIC(5, 2)
);



-- _Subscription
--Armazena informações tanto da conta que esta atrelada, quanto do tipo de plano que representa.
--Uma subscription é uma relação entre uma conta, que assinou um plano, em um momento.
--Uma conta pode ter várias assinaturas desde que em períodos diretentes. Precisa acabar uma para começar outra.
--Mas mesmo assinaturas ja terminadas continuam sendo armazenadas para fins de histórico.
DROP TABLE IF EXISTS _Subscription CASCADE;


CREATE TABLE _Subscription (
	signingDate date,
	paymentStatus VARCHAR(20),
	durationSub smallint,
	email VARCHAR(80),
	planID INTEGER,
	FOREIGN KEY (email) REFERENCES Account(email)
	ON UPDATE CASCADE 
	ON DELETE CASCADE,
	FOREIGN KEY (planID) REFERENCES _Plan(planID)
	ON UPDATE CASCADE 
	ON DELETE CASCADE
);



-- User
--É unico dentro de uma conta, porém tem informações próprias sobre ele. Informações de conteúdo assistido, por exemplo.
DROP TABLE IF EXISTS _User CASCADE;

CREATE TABLE _User
	(email VARCHAR(80) REFERENCES Account
		ON UPDATE CASCADE 
	 	ON DELETE CASCADE,
	userName VARCHAR(20),
	 
	PRIMARY KEY (email, userName));


DROP TABLE IF EXISTS Watches CASCADE;


-- Category

DROP TABLE IF EXISTS Category CASCADE;

CREATE TABLE Category (
	categoryName VARCHAR(20) PRIMARY KEY);



--Worker 
--Can be a actor or director, each title has only one director and many actor as much as needed.
DROP TABLE IF EXISTS Worker CASCADE;

CREATE TABLE Worker(
	workerID INTEGER PRIMARY KEY,
	oscar BOOLEAN,
	workerName VARCHAR(50)
);




DROP TABLE IF EXISTS Title Cascade;

CREATE TABLE Title(
	titleID INTEGER PRIMARY KEY,
	titleName VARCHAR(50),
	yearProd INTEGER,
	synopsis VARCHAR(250),
	rating SMALLINT,
	categoryName VARCHAR(20),
	director INTEGER,
	FOREIGN KEY  (director) REFERENCES Worker(workerID)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
 	FOREIGN KEY (categoryName) REFERENCES Category(categoryName)
        ON UPDATE CASCADE
        ON DELETE SET NULL
	
);



-- Content
--This table brings together the entities Movie, Episode and content.
DROP TABLE IF EXISTS _Content CASCADE;

CREATE TABLE _Content(
	contentID INTEGER PRIMARY KEY,
	duration TIME,
	titleID INTEGER,
	FOREIGN KEY (titleID) REFERENCES Title(titleID)	
);



-- Watches, the relashionship between content and user. 
CREATE TABLE Watches (
    email VARCHAR(80),
    userName VARCHAR(20),
    contentID INTEGER,
    stopTime TIME, -- Use TIME type to store only hour and minute
	PRIMARY KEY (email, userName, contentID),
    FOREIGN KEY (email, userName) REFERENCES _User(email, userName)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (contentID) REFERENCES _Content(contentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);





--Acts
-- não precisa
DROP TABLE IF EXISTS Acts CASCADE;

CREATE TABLE Acts (
	workerID INTEGER,
	titleID INTEGER,
	PRIMARY KEY (titleID, workerID),
    FOREIGN KEY (titleID) REFERENCES Title(titleID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
    FOREIGN KEY (workerID) REFERENCES Worker(workerID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);






-- Series

DROP TABLE IF EXISTS Series CASCADE;

CREATE TABLE Series(
	seriesID INTEGER PRIMARY KEY
		REFERENCES Title(titleID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	numSeasons SMALLINT
);


--Belongs
--relacionamento de pertencimento de episódios a uma série
DROP TABLE IF EXISTS Belongs;

CREATE 	TABLE Belongs(
	seriesID INTEGER,
	episodeID INTEGER,
	season SMALLINT,
	
	PRIMARY KEY (seriesID, episodeID),
	FOREIGN KEY (episodeID)	REFERENCES _Content(contentID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,	
	FOREIGN KEY (seriesID)	REFERENCES Title(titleID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	
);

-------------------------------------//-----------------------------------
-- população das tabelas


-- Inserindo exemplos na tabela 
INSERT INTO Account (email, _password, cardNumber) VALUES 
('joaopedro@gmail.com', 'password9', '9999000011112222'),
('vini@example.com', 'password1', '1234567890123456'),
('bruno@example.com', 'password2', '9876543210987654'),
('vinicius@example.com', 'password3', '9911222233334444'),
('bcosta@example.com', 'password4', '5555666677778888'),
('vpiacini@example.com', 'password5', '0099000011112222');

-- Inserindo exemplos na tabela _Plan
INSERT INTO _Plan (planID, planName, fee) VALUES 
(1, 'Plano Básico', 9.99),
(2, 'Plano Premium', 19.99);

-- Inserindo exemplos na tabela 
INSERT INTO _Subscription ( signingDate, paymentStatus, durationSub, email, planID) VALUES
( '2024-01-01', 'Paid', 12, 'vini@example.com', 1),
( '2024-01-05', 'Unpaid', 6, 'bruno@example.com', 2),
( '2024-01-10', 'Paid', 3, 'vinicius@example.com', 1),
( '2024-01-15', 'Unpaid', 1, 'bcosta@example.com', 2),
('2024-01-20', 'Paid', 24, 'vpiacini@example.com', 1);

-- Inserindo exemplos na tabela 
INSERT INTO _User (email, userName) VALUES 
('vini@example.com', 'vini'),
('vini@example.com', 'bruno'),
('vini@example.com', 'user2'),
('vini@example.com', 'sara'),
('bruno@example.com', 'bruno'),
('bruno@example.com', 'user2');

-- Inserindo exemplos na tabela 
INSERT INTO Category (categoryName) VALUES 
('Animation'),
('Romance'),
('Thriller'),
('Action'),
('Drama');

-- Inserindo exemplos na tabela 
INSERT INTO Worker (workerID, oscar, workerName) VALUES
(1, true, 'Tom Hanks'),
(2, true, 'Meryl Streep'),
(3, false, 'Leonardo DiCaprio'),
(4, true, 'Julia Roberts'),
(5, false, 'Brad Pitt');

-- Inserindo exemplos na tabela 
INSERT INTO Title (titleID,titleName, yearProd, synopsis, rating, categoryName, director) VALUES
(1,'I Love my Friends', 2020, 'A story about friendship', 8, 'Drama', 1),
(2,'Guardians of the Galaxy', 2019, 'An action-packed adventure', 7, 'Action', 2),
(3,'The twilight', 2021, 'A thrilling mystery', 9, 'Thriller', 3),
(4,'How to lose a man in 10 days', 2018, 'A romantic comedy', 6, 'Romance', 4),
(5,'Star Wars', 2022, 'An animated fantasy', 8, 'Animation', 5);

-- Inserindo exemplos na tabela 
INSERT INTO _Content (contentID, duration, titleID) VALUES
(1, '02:30:00', 1),
(2, '01:45:00', 2),
(3, '01:55:00', 3),
(4, '02:10:00', 4),
(5, '01:50:00', 5);

-- Inserindo exemplos na tabela Watches
INSERT INTO Watches (email, userName, contentID, stopTime) VALUES
('vini@example.com', 'vini', 1, '01:45:00'),
('vini@example.com', 'user2', 2, '01:15:00'),
('bruno@example.com', 'user2', 3, '01:30:00'),
('vini@example.com', 'sara', 4, '02:00:00'),
('bruno@example.com', 'bruno', 5, '01:20:00');


-- Inserindo exemplos na tabela 
INSERT INTO CreditCard (cardNumber, securityCode, cardBrand, cardName, email) VALUES 
('1234567890123456', '123', 'Visa', 'John Doe', 'vini@example.com'),
('9876543210987654', '456', 'Mastercard', 'Jane Smith', 'bruno@example.com'),
('9911222233334444', '789', 'American Express', 'Bob Johnson', 'vinicius@example.com'),
( '0099000011112222', '321', 'Discover', 'Alice Brown', 'vpiacini@example.com'),
('9999000011112222', '654', 'Visa', 'Charlie Green', 'joaopedro@gmail.com');


-- Inserindo exemplos na tabela Acts
INSERT INTO Acts (workerID, titleID) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserindo exemplos na tabela Series
INSERT INTO Series (seriesID, numSeasons) VALUES 
(1, 5),
(2, 3),
(3, 8),
(4, 6),
(5, 4);

-- Inserindo exemplos na tabela Belongs
INSERT INTO Belongs (seriesID, episodeID, season) VALUES 
(1, 1, 1),
(1, 2, 1),
(2, 3, 1),
(2, 4, 1),
(3, 5, 1);

--------------------------------------------//----------------------------------

--Pesquisas
-- 8 consultas uteis que envolvem 3 tabelas


--A)No mínimo duas delas devem necessitar serem respondidas com a cláusula group by (isto é, a resposta deve 
--combinar atributos e totalizações sobre grupos ). Dentre essas, pelo menos uma deve incluir também a cláusula 
--Having.

-- 1
-- nome dos planos com contas com mais de 3 usuarios


select planName
from _Plan 
where planid in (select planid from
				  _Subscription
				   where email in (select email
								   from _User group by email
								   having count(*) > 3
								   )
				  );
				  

--Adicionais para conferencia
--select * from Account
--select * from _Subscription
--select * from _Plan
--select * from _User

-- 2

--No mínimo duas delas devem necessitar serem respondidas com subconsulta (isto é, não existe formulação 
--equivalente usando apenas joins);

-- 3


-- 4

--No mínimo uma delas (diferente das consultas acima) deve necessitar do operador NOT EXISTS para 
--responder questões do tipo TODOS ou NENHUM que <referencia> (isto é, não existe formulação
--equivalente usando simplesmente joins ou subconsultas com (NOT) IN ou demais operadores relacionais)

-- 5

--No mínimos duas consultas devem utilizar a visão definida no item anterior.


-- 6


-- 7

-- Acho que a ultima é livre (?)
-- 8 
