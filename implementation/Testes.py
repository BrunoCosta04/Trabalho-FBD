import psycopg2 as pg

nomeBaseDados = 'FBD'
senha = 'Mensageiro1324'

conection = pg.connect(host = 'localhost', dbname = nomeBaseDados, user = 'postgres', password = senha, port = 5432)
cursor = conection.cursor()

teste = "'vini@example.com'"
cursor.execute("""SELECT _password FROM ACCOUNT WHERE email = {0}; """.format(teste))

password = cursor.fetchone()[0]
print(password)

conection.commit()

cursor.close()
conection.close()