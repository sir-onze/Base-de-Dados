-- VIEW COM INFORMAÇOES RELATIVAS AO CLIENTE --

CREATE VIEW v_Cliente AS
SELECT idCliente AS 'ID Cliente',
			   nome AS 'Nome do Cliente',
	           matricula AS 'Matrícula',
               tipo AS 'Tipo de Veículo'
FROM Cliente 
INNER JOIN Veiculo
ON Cliente.idCliente = Veiculo.Cliente_idCliente
ORDER BY idCliente;


SELECT * FROM v_Cliente;
DROP VIEW v_Cliente;

-- VIEW COM AS RESERVAS DE CADA CLIENTE --

CREATE VIEW r_Cliente AS
SELECT idCliente AS 'ID Cliente',
	    nome AS 'Nome do Cliente',
	    veic.matricula AS 'Matrícula',
        veic.tipo AS 'Tipo de Veículo',
        res.idReserva AS 'ID Reserva',
        res.data_inicio AS 'Data de Entrada',
        res.data_fim AS 'Data de Saída',
        pag.preco AS 'Preço',
        pag.taxa AS 'Taxa',
        pag.multa AS 'Multa'
FROM Cliente
INNER JOIN Veiculo AS veic ON Cliente.idCliente = veic.Cliente_idCliente
INNER JOIN Reserva AS res ON veic.matricula = res.Veiculo_matricula
INNER JOIN Pagamento As pag ON res.Pagamento_idPagamento = pag.idPagamento
ORDER BY idCliente;

SELECT * FROM r_Cliente;
DROP VIEW r_Cliente;

-- VIEW COM AS INFORMAÇOES RELATIVAS A UM PARQUE --

CREATE VIEW v_Parque AS
SELECT DISTINCT Parque_idParque AS 'ID Parque',
			   park.distrito AS 'Distrito',
			   park.cidade AS 'Cidade',
               park.capacidade AS 'Capacidade'
FROM LugaresParque
INNER JOIN Parque AS park ON LugaresParque.Parque_idParque = park.idParque
ORDER BY Parque_idParque;

SELECT * FROM v_Parque;
DROP VIEW v_Parque;


-- VIEW COM AS INFORMAÇOES DOS LUGARES LIVRES DOS PARQUES --
CREATE VIEW v_Lugares AS
SELECT  Parque_idParque AS 'ID Parque',
				id_lugar AS 'Lugar',
			    piso AS 'Piso',
                park.distrito AS 'Distrito',
			    park.cidade AS 'Cidade'
FROM LugaresParque
INNER JOIN Parque AS park ON LugaresParque.Parque_idParque = park.idParque
WHERE (LugaresParque.ocupado = 0)
ORDER BY Parque_idParque;


SELECT * FROM v_Lugares;
DROP VIEW v_Lugares;