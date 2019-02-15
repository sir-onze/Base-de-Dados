USE parking;

-- QUERY 1 : Quais foram os veículos que usaram o parque num determinado dia

DELIMITER $$

CREATE PROCEDURE veiculos (IN d DATETIME)
BEGIN
	SELECT matricula,nome
    FROM Veiculo
    INNER JOIN Reserva
    ON Reserva.Veiculo_matricula = Veiculo.matricula 
    INNER JOIN Cliente
    ON Cliente.idCliente=Veiculo.Cliente_idCliente
    WHERE d BETWEEN Reserva. data_inicio AND Reserva.data_fim;
	
        
END $$

CALL veiculos('2018-11-25 20:30:00');
DROP PROCEDURE veiculos;


-- QUERY 2 : Quais os parques com lugares liveres reserváveis num determinado distrito ?

DELIMITER $$

CREATE PROCEDURE parques_livres_zona (IN dist VARCHAR(16), IN cur_date DATETIME)
BEGIN
	
    SELECT DISTINCT idParque FROM Parque
    
    INNER JOIN( 
		SELECT Parque_idParque
		FROM LugaresParque
		WHERE(LugaresParque.id_lugar NOT IN 
			(SELECT id_lugar
			FROM LugaresParque
			INNER JOIN Reserva ON Reserva.LugaresParque_lugar = LugaresParque.id_lugar
			WHERE(NOW() BETWEEN Reserva.data_inicio AND Reserva.data_fim) && (Reserva.ativa = 1)))) AS tab_livres
	ON Parque.idParque = tab_livres.Parque_idParque
    WHERE Parque.distrito = dist;
    
END $$

CALL parques_livres_zona('Braga',NOW());
DROP PROCEDURE parques_livres_zona;

-- QUERY 3: Que lugares estão livres num determinado parque,  ?

DELIMITER $$

CREATE PROCEDURE lugares_livres_Parque(IN p_id INT, IN cur_date DATETIME)
BEGIN
    
    SELECT id_lugar, piso
    FROM LugaresParque
    WHERE(LugaresParque.Parque_idParque = p_id AND LugaresParque.id_lugar NOT IN
		(SELECT id_lugar
         FROM LugaresParque
         INNER JOIN Reserva
         ON Reserva.LugaresParque_lugar = LugaresParque.id_lugar
         WHERE(cur_date BETWEEN Reserva.data_inicio AND Reserva.data_fim) &&
			  (Reserva.ativa = 1)));
    
END $$

CALL lugares_livres_Parque(1,NOW());
DROP PROCEDURE lugares_livres_Parque;

-- QUERY 4: Quanto faturou a empresa num dado intervalo de tempo?

DELIMITER $$

CREATE PROCEDURE lucro_intervalado(IN d_inicio DATETIME, IN d_fim DATETIME)
BEGIN
	SELECT SUM(preco)
    FROM Reserva
    INNER JOIN Pagamento
    ON Reserva.Pagamento_idPagamento = Pagamento.idPagamento
    WHERE Reserva.data_inicio BETWEEN d_inicio AND d_fim;
	
END $$

CALL lucro_intervalado('2018-11-25 20:00:00','2018-11-25 23:30:00');
DROP PROCEDURE lucro_intervalado;