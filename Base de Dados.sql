
----------------------------------------------//---------------------------------------------------------------------
-- CreditCard
--Armazena as informaçoes do atributo composto.
DROP TABLE IF EXISTS CreditCard CASCADE;

CREATE TABLE CreditCard (
	cardNumber INTEGER PRIMARY KEY,
	securityCode VARCHAR(3),
	cardBrand VARCHAR(30),
	cardName VARCHAR(100)
);


-- Account
 --Armazena a informação de 1 só cartão atrelado a conta.
 
 
DROP TABLE IF EXISTS Account CASCADE;

CREATE TABLE Account (
	email VARCHAR(80) PRIMARY KEY,
	_password VARCHAR(25),
	cardNumber INTEGER,
	FOREIGN KEY (cardNumber) REFERENCES CreditCard(cardNumber)
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
	subcriptionID INTEGER,
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
DROP TABLE IF EXISTS Worker ;

CREATE TABLE Worker(
	workerID INTEGER PRIMARY KEY,
	oscar BOOLEAN,
	workerName VARCHAR(50)
);





DROP TABLE IF EXISTS Title Cascade;

CREATE TABLE Title(
	titleID INTEGER PRIMARY KEY,
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
