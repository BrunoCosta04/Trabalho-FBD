import psycopg2 as pg

nomeBaseDados = 'FBD'
senha = 'Mensageiro1324'

conection = pg.connect(host = 'localhost', dbname = nomeBaseDados, user = 'postgres', password = senha, port = 5432)
cursor = conection.cursor()

teste = "'vini@example.com'"
cursor.execute("""SELECT * FROM ACCOUNT WHERE email = {0}; """.format(teste))

name = [desc[0] for desc in cursor.description]
password = cursor.fetchall()[0]
print(name, password)

conection.commit()

cursor.close()
conection.close()