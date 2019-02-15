INSERT INTO Cliente 
	(idCliente, nome)
	VALUES
		(1,'Marcela Lima'), (2,'Eduardo Semanas'), (3,'António Ciclopes'),
		(4,'Ricardo Saqueador'), (5,'Tiago Tombado'), (6,'Ricardo Furacão'),
        (7,'Bruno Ferrero'), (8,'Ricardo Tymoschuckanela'), (9,'Filipe Pitbull'),
        (10,'Marco Cigano'), (11,'José Parteiro'), (12,'Ricardo Zagueiro'),
        (13,'João Rico'), (14,'Inês Real'), (15,'Shaman Porela');
        
INSERT INTO Veiculo
	(matricula, tipo, Cliente_idCliente)
    VALUES
		('03-03-LD', 1, 1), ('04-04-SM', 1, 2), ('06-06-SK', 1, 3),
	    ('08-08-SQ', 1, 4), ('11-46-QJ', 1, 5), ('16-16-FC', 1, 6),
	    ('47-41-IP', 1, 7), ('19-19-TM', 1, 8), ('30-30-PQ', 1, 9),
	    ('31-31-FC', 2, 10), ('32-32-BK', 1, 11),('33-33-ZG', 1, 12),
        ('35-35-MF', 2, 13), ('36-36-NK', 2, 14), ('37-37-SH', 2, 15);
        
    
INSERT INTO Parque
	(idParque,capacidade,distrito,cidade)
    VALUES
    (1,0,'Braga','Braga'),
    (2,0,'Braga','Barcelos'),
    (3,0,'Porto','Gaia');

INSERT INTO LugaresParque
	(id_lugar, piso, ocupado, Parque_idParque)
    VALUES
				-- PARQUE 1 --
	-- PISO 0 --
    (1,0,1,1),(2,0,0,1),(3,0,0,1),(4,0,1,1), 
    -- PISO 1 --
	(5,1,0,1),(6,1,0,1),(7,1,0,1),(8,1,0,1),
    -- PISO 2 --
    (9,2,0,1),(10,2,0,1),(11,2,0,1),(12,2,0,1),
    -- PISO 3 --
    (13,3,0,1),(14,3,0,1),(15,3,0,1),(16,3,0,1),
    
				-- PARQUE 2 --
	-- PISO 0 --
    (17,0,1,2),(18,0,0,2),(19,0,1,2),(20,0,1,2),
    -- PISO 1 --
    (21,1,1,2),(22,1,0,2),(23,1,0,2),(24,1,0,2),
    -- PISO 2 --
    (25,2,1,2),(26,2,0,2),(27,2,0,2),(28,2,0,2),
    -- PISO 3 --
    (29,3,1,2),(30,3,0,2),(31,3,0,2),(32,3,0,2),

				-- PARQUE 3 --    
	-- PISO 0 --
    (33,0,1,3),(34,0,1,3),(35,0,1,3),(36,0,1,3),
    -- PISO 1 --
    (37,1,1,3),(38,1,0,3),(39,1,0,3),(40,1,0,3),
    -- PISO 2 --
    (41,2,1,3),(42,2,0,3),(43,2,0,3),(44,2,0,3),
    -- PISO 3 --
    (45,3,1,3),(46,3,0,3),(47,3,0,3),(48,3,0,3);
    
INSERT INTO Pagamento (idPagamento, preco, taxa, multa)
VALUES (1,0.5,0.2,0);

INSERT INTO Reserva
	(idReserva,data_inicio, data_fim, Pagamento_idPagamento, Veiculo_matricula, LugaresParque_lugar, ativa)
    VALUES
    
    -- RESERVAS NO PARQUE 1 --
    (1,'2018-11-25 18:20:00','2018-11-25 18:30:00', 1, '03-03-LD', 1, 1),
    (2,'2018-11-25 18:20:00','2018-11-25 18:40:00', 2, '06-06-SK', 2, 0),
    (3,'2018-11-25 18:40:00','2018-11-25 18:50:00', 3, '08-08-SQ', 2, 0),
    (4,'2018-11-26 01:30:00','2018-11-26 02:30:00', 4, '11-46-QJ', 2, 1),
    (5,'2018-11-26 01:20:00','2018-11-26 02:55:00', 5, '16-16-FC', 9, 1),
    (6,'2018-11-26 01:30:00','2018-11-26 02:35:00', 6, '47-41-IP', 13, 0),

	-- RESERVAS NO PARQUE 2 --
    
    (7,'2018-11-25 19:20:00','2018-11-25 19:30:00', 7, '19-19-TM', 17, 1),
    (8,'2018-11-25 19:20:00','2018-11-25 19:40:00', 8, '30-30-PQ', 18, 1),
    (9,'2018-11-25 19:20:00','2018-11-25 19:50:00', 9, '31-31-FC', 19, 1),
    (10,'2018-11-25 19:20:00','2018-11-25 19:40:00', 10, '32-32-BK', 21, 1),
    (11,'2018-11-25 19:20:00','2018-11-25 19:45:00', 11, '33-33-ZG', 25, 1),
    (12,'2018-11-25 19:20:00','2018-11-25 19:45:00', 12, '35-35-MF', 29, 0),
    
    -- RESERVAS NO PARQUE 3 --
    
    (13,'2018-11-25 20:20:00','2018-11-25 20:30:00', 13, '36-36-NK', 33, 1),
    (14,'2018-11-25 20:20:00','2018-11-25 20:30:00', 14, '37-37-SH', 34, 1),
    (15,'2018-11-25 20:20:00','2018-11-25 20:35:00', 15, '03-03-LD', 35, 1),
    (16,'2018-11-25 20:20:00','2018-11-25 20:40:00', 16, '04-04-SM', 37, 1),
    (17,'2018-11-25 20:20:00','2018-11-25 20:45:00', 17, '30-30-PQ', 41, 1),
    (18,'2018-11-25 20:20:00','2018-11-25 20:45:00', 18, '06-06-SK', 45, 1);
    
    
    
SELECT idReserva, data_inicio, data_fim, Pagamento_idPagamento, Veiculo_matricula, LugaresParque_lugar, ativa
FROM Reserva;

SELECT idParque, capacidade, distrito, cidade
FROM Parque;

SELECT matricula, tipo, Cliente_idCliente
FROM Veiculo;

SELECT idPagamento, taxa, preco, multa
FROM Pagamento;

SELECT id_lugar,piso,ocupado,Parque_idParque
FROM LugaresParque;