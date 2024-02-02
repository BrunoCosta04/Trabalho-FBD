import psycopg2 as pg
class Account:
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def verifyUsernamePassword(username, password, cursor):
        cursor.execute("""SELECT _password FROM ACCOUNT WHERE email = {0}; """.format(username))
        
        _pass = cursor.fetchall()
        
        if _pass != []:
            if password == _pass[0][0]:
                return True
            else: 
                return False
        else:
            return False
        
    # Encontra um usuario no banco_usuarios pelo seu username e retorna na forma de objeto
    def achaUsuario(username, cursor):
        cursor.execute("""SELECT * FROM ACCOUNT WHERE email = {0}; """.format(username))
        usuario = cursor.fetchone()

        return Account(usuario[0], usuario[1])
    
    # Valida o email, considerando a premissa que dois usuarios não pdoem possuir mesmo email
    def validateNewUser(email, cursor):
        cursor.execute(""" SELECT email FROM ACCOUNT """)
        if email in cursor.fetchall():
            return False
        else:
            return True
                
    # Compara os dois campos de senha para garantir que as senhas são iguais
    def validatePassword(password, rePassword):
        if password != rePassword:
            return False
        else:
            return True
    
    def createNewAccount(password, email, cursor):
        cursor.execute(""" INSERT INTO Account (email, _password) VALUES ({0},{1}) """.format("'" + email + "'","'"+password+"'"))
    
class User:
    def __init__(self, nome) -> None:
        self.nome = nome

    