-------------------------------------//-----------------------------------
-- população das tabelas

-- Inserindo exemplos na tabela 
INSERT INTO CreditCard (cardNumber, securityCode, cardBrand, cardName, email) VALUES 
('1234567890123456', '123', 'Visa', 'John Doe', 'vini@example.com'),
('9876543210987654', '456', 'Mastercard', 'Jane Smith', 'bruno@example.com'),
('1111222233334444', '789', 'American Express', 'Bob Johnson', 'vinicius@example.com'),
('5555666677778888', '321', 'Discover', 'Alice Brown', 'vpiacini@example.com'),
('9999000011112222', '654', 'Visa', 'Charlie Green', 'joaopedro@gmail.com');

-- Inserindo exemplos na tabela 
INSERT INTO Account (email, _password, cardNumber) VALUES 
('vini@example.com', 'password1', '1234567890123456'),
('bruno@example.com', 'password2', '9876543210987654'),
('vinicius@example.com', 'password3', '1111222233334444'),
('bcosta@example.com', 'password4', '5555666677778888'),
('vpiacini@example.com', 'password5', '9999000011112222');

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
INSERT INTO Title (titleID, yearProd, synopsis, rating, categoryName, director) VALUES
(1, 2020, 'A story about friendship', 8, 'Drama', 1),
(2, 2019, 'An action-packed adventure', 7, 'Action', 2),
(3, 2021, 'A thrilling mystery', 9, 'Thriller', 3),
(4, 2018, 'A romantic comedy', 6, 'Romance', 4),
(5, 2022, 'An animated fantasy', 8, 'Animation', 5);

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
