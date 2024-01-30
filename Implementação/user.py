import psycopg2 as pg
class Account:
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def verifyUsernamePassword(username, password, cursor):
        cursor.execute("""SELECT _password FROM ACCOUNT WHERE email = {0}; """.format(username))

        _pass = cursor.fetchone()[0]
        if _pass != None:
            if password == _pass:
                return True
            else: 
                return False
        else:
            return False
        
    # Encontra um usuario no banco_usuarios pelo seu username e retorna na forma de objeto
    def achaUsuario(username, cursor):
        cursor.execute("""SELECT * FROM ACCOUNT WHERE email = {0}; """.format(username))
        usuario =cursor.fetchone()

        return usuario
    
class User:
    def __init__(self, nome) -> None:
        self.nome = nome

    