USE parking

-- PROCEDURE: INSERIR LUGAR NUM PARQUE -- 

DELIMITER $$

CREATE PROCEDURE inserirLugar (
    IN flr INT,
    IN lug INT,
    IN p_ID INT)
    
BEGIN 
	DECLARE Erro BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET Erro = 1;
    START TRANSACTION;

INSERT INTO LugaresParque (id_lugar, piso, ocupado, Parque_idParque)
			VALUES (lug, flr, 0, p_ID);

IF Erro
THEN ROLLBACK;
ELSE COMMIT;
END IF;
END $$

-- TESTE --
CALL inserirLugar(1,9,1);
DROP PROCEDURE inserirLugar;

-- RESULTADOS --
SELECT id_lugar,piso,ocupado,Parque_idParque
FROM LugaresParque;

SELECT idParque, capacidade, distrito, cidade
FROM Parque;

-- -- -- -- -- -- -- -- -- 

-- PROCEDURE: Check-In de uma dada reserva num parque

DELIMITER $$

CREATE PROCEDURE checkIN (IN reserva_id INT)
    
BEGIN
	DECLARE lugar_id INT;
    SET lugar_id = (SELECT LugaresParque_lugar FROM Reserva WHERE Reserva.idReserva=reserva_id);
    
	UPDATE LugaresParque
    SET ocupado = 1
    WHERE id_lugar = lugar_id;
END$$

-- TESTE --
CALL checkIN(5);
DROP PROCEDURE checkIN;

-- RESULTADOS --
SELECT id_lugar,piso,ocupado,Parque_idParque
FROM LugaresParque;

----

DELIMITER $$

CREATE PROCEDURE calculaMulta(reserva_id INT)
BEGIN
	DECLARE tempo_final DATETIME;
	DECLARE tempo FLOAT;
	DECLARE mlt FLOAT;
    DECLARE paga_id INT;
	
	SET tempo_final = (SELECT data_fim FROM Reserva WHERE Reserva.idReserva=reserva_id);
	SET tempo =(SELECT TIMESTAMPDIFF(MINUTE, tempo_final, NOW()));
    SET paga_id = (SELECT Pagamento_idPagamento FROM Reserva WHERE `idReserva` = reserva_id);
    
    IF (tempo >= 0) THEN
		SET mlt = tempo*0.10;
	ELSE 
		SET mlt = 0;
        
    END IF;
    
	UPDATE Pagamento
    SET Pagamento.multa = mlt
    WHERE Pagamento.idPagamento = paga_id;
    
END$$

-- -- -- -- -- -- -- -- -- -- -- -- 

-- PROCEDURE: Check-Out de uma dada reserva num parque
DELIMITER $$

CREATE PROCEDURE checkOUT (IN reserva_id INT)
    
BEGIN

	DECLARE lugar_id INT;
    DECLARE paga_id INT;
    DECLARE m FLOAT;
	
    SET lugar_id = (SELECT LugaresParque_lugar FROM Reserva WHERE `idReserva` = reserva_id);
   
	UPDATE LugaresParque
    SET LugaresParque.ocupado = 0
    WHERE LugaresParque.id_lugar = lugar_id;
    
    CALL calculaMulta(reserva_id);

END$$

-- TESTE --
CALL checkOUT(1);
DROP PROCEDURE checkOUT;

-- RESULTADOS --
SELECT idPagamento, taxa, preco, multa
FROM Pagamento;

SELECT id_lugar,piso,ocupado,Parque_idParque
FROM LugaresParque;

DROP PROCEDURE calculaMulta;

SELECT idReserva, data_inicio, data_fim, Pagamento_idPagamento, Veiculo_matricula, LugaresParque_lugar, ativa
FROM Reserva;