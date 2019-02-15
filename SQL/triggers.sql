USE parking;
    
DELIMITER ||

DROP TRIGGER IF EXISTS geraPagamentoCliente;

CREATE TRIGGER geraPagamentoCliente
AFTER INSERT ON Reserva
FOR EACH ROW
BEGIN
    DECLARE tipo_veiculo INT;
    DECLARE pagamento_id INT;
    DECLARE tempo FLOAT;
    DECLARE tx_1 FLOAT;
	DECLARE tx_2 FLOAT;
    
    SET tx_1 = 1.2;
	SET tx_2 = 1.5; 
	SET tipo_veiculo = tipoveiculo(NEW.idReserva);
    SET tempo = tempoveiculo(NEW.idReserva);
	
    IF (tipo_veiculo = 1) THEN
		INSERT INTO Pagamento (idPagamento,taxa, preco, multa)
				VALUES (idPagamento, tx_1-1, tx_1*0.1*tempo, 0);
	ELSE 
		INSERT INTO Pagamento (idPagamento,taxa, preco, multa)
				VALUES (idPagamento, tx_2-1, tx_2*0.1*tempo, 0);
	END IF;    
END ||

DELIMITER $$

DROP TRIGGER IF EXISTS updateCapacidade;
CREATE TRIGGER updateCapacidade
AFTER INSERT ON LugaresParque
FOR EACH ROW
BEGIN
	UPDATE Parque
    SET capacidade = capacidade + 1
    WHERE Parque.idParque = NEW.Parque_idParque;
END  $$