import psycopg2 as pg

nomeBaseDados = 'FBD'
senha = 'Mensageiro1324'


class Usuario:
    def __init__(self, username, password, grupo, email, nome, creditos):
        self.username = username
        self.password = password
        self.grupo = grupo #grupo do usuario que decide quanto do sistema ele tem acesso
        self.email = email
        self.nome = nome #nome real do usuario
        self.creditos = creditos #monetario utilizado internamente


    def verifyUsernamePassword(username, password, cursor):
        
        
        cursor.execute("""SELECT _password FROM ACCOUNT WHERE email = {0}; """.format(username))
        if cursor.fetchone() != None:
            _pass = cursor.fetchone()[0]

            if password == _pass:
                return True
            else: 
                return False
        else:
            return False
        
    # Encontra um usuario no banco_usuarios pelo seu username e retorna na forma de objeto
    def achaUsuario(username, cursor):
        cursor.execute("""SELECT * FROM ACCOUNT WHERE email = {0}; """.format(username))
        return cursor.fetchall()