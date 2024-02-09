----------------------------------------------//---------------------------------------------------------------------
-- Para criação das tabelas não foi utilizada nenhuma ferramenta de criação automática.

-- ATRIBUTOS
-- Para atributos obrigatórios foi utlizada a clausula NOT NULL, enquanto não obrigatórios não foi.
-- Para atributos compostos foram criadas tabelas secundárias contendo as informações.

-- RELACIONAMENTOS N-M
-- Para este tipo de relacionamento foram utilizadas tabelas próprias que representam os relacionamentos.

-- RELACIONAMETOS 0-1, 0-N, 1-1 e 1-N
-- Para estes tipos de relacionamento foram criadas colunas adicionais contendo chaves estrangeiras para identificação da relação, a fusão não foi efetuada pois
-- o grupo prezou pela separação dos dados, desejando encontrar esses com maior facilidade.

-- ESPICIALIZAÇÕES
-- Para estes casos foi tratado como relações do tipo 1-1
----------------------------------------------//---------------------------------------------------------------------
-- Account
DROP TABLE IF EXISTS Account CASCADE;

CREATE TABLE Account (
	-- Utiliza-se o email como chave primária por ser o identificador externo de conta, e não se
	-- viu a nescessidade da criação de uma nova chave interna para isso.
	email VARCHAR(80) PRIMARY KEY,
	_password VARCHAR(25)
	);
	
-- CreditCard
DROP TABLE IF EXISTS CreditCard CASCADE;

CREATE TABLE CreditCard (
	cardNumber VARCHAR(16) PRIMARY KEY,
	-- Utiliza-se este atributo como chave primária por ser, no mundo fisico, o identificador normal de cartões
	securityCode VARCHAR(3),
	cardBrand VARCHAR(30),
	cardName VARCHAR(100),
	email VARCHAR(20) NOT NULL,
	FOREIGN KEY (email) REFERENCES Account
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


-- Plan
--São os diferentes tipos de planos do Netflix.
DROP TABLE IF EXISTS _Plan CASCADE;

CREATE TABLE _Plan (
	planID INTEGER PRIMARY KEY,
	-- Utiliza-se este tributo como chave primária por ser um identificador de tamanho pequeno e facil utilização
	planName VARCHAR(30) NOT NULL,
	fee NUMERIC(5, 2) NOT NULL
);



-- _Subscription
--Armazena informações tanto da conta que esta atrelada, quanto do tipo de plano que representa.
--Uma subscription é uma relação entre uma conta, que assinou um plano, em um momento.
--Uma conta pode ter várias assinaturas desde que em períodos diretentes. Precisa acabar uma para começar outra.
--Mas mesmo assinaturas ja terminadas continuam sendo armazenadas para fins de histórico.
DROP TABLE IF EXISTS _Subscription CASCADE;


CREATE TABLE _Subscription (
	planID INTEGER,
	signingDate date,
	paymentStatus VARCHAR(20),
	durationSub smallint,
	email VARCHAR(80) ,
	PRIMARY KEY (signingDate, email) ,
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
	(email VARCHAR(80) NOT NULL REFERENCES Account
		ON UPDATE CASCADE 
	 	ON DELETE CASCADE,
	userName VARCHAR(20),
	 
	PRIMARY KEY (email, userName));
	-- Utiliza-se essa chave como primária pois o usuário será apenas unico dentro de tal conta, 
	-- portanto fazendo a conferencia juntamente com a cração e garantindo a unicidade

DROP TABLE IF EXISTS Watches CASCADE;


-- Category

DROP TABLE IF EXISTS Category CASCADE;

CREATE TABLE Category (
	-- Utiliza-se o nome da categoria como chave primária por ser o identificador em mundo fisico dela, e não se
	-- viu a nescessidade da criação de uma nova chave interna para isso.
	categoryName VARCHAR(20) PRIMARY KEY);



--Worker 
--Can be a actor or director, each title has only one director and many actor as much as needed.
DROP TABLE IF EXISTS Worker CASCADE;

CREATE TABLE Worker(
	workerID INTEGER PRIMARY KEY,
	-- Utiliza-se este tributo como chave primária por ser um identificador de tamanho pequeno e facil utilização
	oscar BOOLEAN,
	workerName VARCHAR(50)
);




DROP TABLE IF EXISTS Title Cascade;

CREATE TABLE Title(
	titleID INTEGER PRIMARY KEY,
	-- Utiliza-se este tributo como chave primária por ser um identificador de tamanho pequeno e facil utilização
	titleName VARCHAR(50),
	yearProd INTEGER,
	synopsis VARCHAR(250),
	rating SMALLINT,
	categoryName VARCHAR(20) NOT NULL,
	director INTEGER NOT NULL,
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
	-- Utiliza-se este tributo como chave primária por ser um identificador de tamanho pequeno e facil utilização
	duration TIME,
	titleID INTEGER NOT NULL,
	FOREIGN KEY (titleID) REFERENCES Title(titleID)	
);



-- Watches, the relashionship between content and user. 
CREATE TABLE Watches (
    email VARCHAR(80),
    userName VARCHAR(20),
    contentID INTEGER,
    stopTime TIME, -- Use TIME type to store only hour and minute
	PRIMARY KEY (email, userName, contentID),
	
	-- Utiliza-se essa chave como primária pois a visualização será apenas unica dentro de tal usuário pertencente a tal conta, 
	-- portanto fazendo a conferencia juntamente com a cração e garantindo a unicidade
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
	
	-- Utiliza-se essa chave como primária pois a atuação de tal ator será apenas unica dentro de tal titulo, 
	-- portanto fazendo a conferencia juntamente com a cração e garantindo a unicidade
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
	-- Utiliza-se este tributo como chave primária por ser um identificador de tamanho pequeno e facil utilização
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
	
	-- Utiliza-se essa chave como primária pois o episódio será apenas unico dentro de tal serie, 
	-- portanto fazendo a conferencia juntamente com a cração e garantindo a unicidade
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
INSERT INTO Account (email, _password) VALUES 
('joaopedro@gmail.com', 'password9'),
('vini@example.com', 'password1'),
('bruno@example.com', 'password2'),
('vinicius@example.com', 'password3'),
('bcosta@example.com', 'password4'),
('vpiacini@example.com', 'password5');

-- Inserindo exemplos na tabela 
INSERT INTO CreditCard (cardNumber, securityCode, cardBrand, cardName, email) VALUES 
('1234567890123456', '123', 'Visa', 'John Doe', 'vpiacini@example.com'),
('9876543210987654', '456', 'Mastercard', 'Jane Smith', 'vpiacini@example.com'),
('1111222233334444', '789', 'American Express', 'Bob Johnson', 'bcosta@example.com'),
('5555666677778888', '321', 'Discover', 'Alice Brown', 'joaopedro@gmail.com'),
('9999000011112222', '654', 'Visa', 'Charlie Green', 'joaopedro@gmail.com');

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
('2024-01-20', 'Paid', 24, 'vpiacini@example.com', 1),
('2024-01-20', 'Unpaid', 24, 'joaopedro@gmail.com', 1);

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

-- Inserindo exemplos na tabela Acts
INSERT INTO Acts (workerID, titleID) VALUES 
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(2, 4),
(2, 1),
(3, 2),
(3, 4),
(3, 5),
(4, 1),
(4, 2),
(4, 4),
(5, 2),
(5, 1),
(5, 4);

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