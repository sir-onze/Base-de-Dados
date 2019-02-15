import mysql
import mysql.connector as con
from mysql.connector import errorcode
from pymongo import MongoClient
from bson.decimal128 import Decimal128
# -*- coding: utf-8 -*-

def connectToSQL():
    try:
        connection = con.connect(user="root", database="parking",password="@Tiagob12")
        print("Ligado a parking")
        return connection
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Username ou Password errados")
            return

        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Erro na Base de Dados\n")
            return
        else:
            print(err)
            return

def connectToMongo():
    client = MongoClient("localhost", 27017)
    mongodb = client["parking"]

    if "parking" in client.list_database_names():
        print("Base de Dados Mongo ja existia, dropped para nova criacao\n")
        # SE JA EXISTIA A BD AO EXECUTAR O SCRIPT, FAZ DROP DELA
        client.drop_database("parking")
    return mongodb




def insertReservas(mysqld, mongodb):
    cursor = mysqld.cursor()
    MongoDoc = getReservas(cursor)
    InsertResult = mongodb.reserva.insert_many(MongoDoc)
    print("     Id's inseridos: ", InsertResult.inserted_ids, "\n")



def getReservas(cursor):
    reservaQuery = "SELECT R.idReserva, R.data_inicio, R.data_fim, R.ativa,P.preco,P.taxa, P.multa, L.id_lugar,L.piso,L.Parque_idParque, C.nome, V.matricula,V.tipo " \
            	"FROM Reserva AS R " \
            	"INNER JOIN LugaresParque AS L ON R.LugaresParque_lugar = L.id_lugar " \
            	"INNER JOIN Pagamento AS P ON R.Pagamento_idPagamento = P.idPagamento " \
            	"INNER JOIN Veiculo AS V ON R.Veiculo_matricula = V.matricula " \
            	"INNER JOIN Cliente AS C ON V.Cliente_idCliente = C.idCliente "

    cursor.execute(reservaQuery)
    reservaRes = cursor.fetchall()

    resList = []
    numberReservas = 0

    for reserva in reservaRes:
        ID = reserva[0]
        Inicio = reserva[1]
        Fim = reserva[2]
        Estado = reserva[3]
        Preco = reserva[4]
        Taxa = reserva[5]
        Multa = reserva[6]
        Lugar = reserva[7]
        Piso = reserva[8]
        Parque = reserva[9]
        Cliente = reserva[10]
        Matricula = reserva[11]
        Tipo = reserva[12]

        ResDoc = {"_id": ID,
                   "datainicio": Inicio,
                   "datafim": Fim,
                   "estado": Estado,
                   "lugar": Lugar,
                   "piso": Piso,
                   "parque": Parque,
                   "Cliente": {"nome":Cliente},
                   "Veiculo":{"matricula":Matricula,"tipo":Tipo},
                   "Pagamento":{"preco":Preco,"multa":Multa,"taxa":Taxa}
                   }
        resList.append(ResDoc)

    return resList



def insertParques(mysqld, mongodb):
    cursor = mysqld.cursor()
    MongoDoc = getParques(cursor)
    InsertResult = mongodb.parque.insert_many(MongoDoc)
    print("     Id's inseridos: ", InsertResult.inserted_ids, "\n")



def getParques(cursor):
    parqueQuery = "SELECT P.idParque, P.distrito, P.cidade, P.capacidade " \
            	  "FROM Parque AS P " 
            	

    cursor.execute(parqueQuery)
    parqueRes = cursor.fetchall()

    parqueList = []
    numberParques = 0

    for parque in parqueRes:
        ID = parque[0]
        Distrito = parque[1]
        Cidade = parque[2]
        Capacidade = parque[3]
       	Lugares = getLugares(cursor,ID)
   

        ResDoc = {"id": ID,
                   "distrito": Distrito,
                   "cidade": Cidade,
                   "capacidade": Capacidade,
                   "Lugares": Lugares}

        parqueList.append(ResDoc)

    return parqueList

def getLugares(cursor,Parqueid):
	lug = "SELECT L.id_lugar, L.piso, L.ocupado " \
	      "FROM LugaresParque AS L " \
	      "WHERE L.Parque_idParque="+str(Parqueid)

	cursor.execute(lug)
	lugares = cursor.fetchall()
	
	lugList = []
      
	for lugar in lugares:
		Lugar = lugar[0]
		Piso = lugar[1]
		Ocupado = lugar[2]

		lugaresDoc = {"ID_Lugar": Lugar,
					  "piso": Piso,
					  "ocupado": Ocupado
					  }

		lugList.append(lugaresDoc)
	

	return lugList

def main():
    # CONECTAR BASE DE DADOS SQL
    mysqld = connectToSQL()

    # CONECTAR BASE DE DADOS MONGO
    mongodb = connectToMongo()

    # ADICIONAR RESERVAS A COLECAO EM MONGO
    insertReservas(mysqld, mongodb)

    # ADICIONAR PARQUES A COLECAO EM MONGO
    insertParques(mysqld,mongodb)
  

# Iniciar Programa
if __name__ == "__main__":
    main()