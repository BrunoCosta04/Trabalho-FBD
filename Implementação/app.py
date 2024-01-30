import user
import psycopg2 as pg
from flask import (
    Flask,
    g,
    jsonify,
    redirect,
    render_template,
    request,
    session,
    url_for
)


app = Flask(__name__, template_folder='view')
app.secret_key = 'secretkey'

nomeBaseDados = 'FBD'
senha = 'Mensageiro1324'

conection = pg.connect(host = 'localhost', dbname = nomeBaseDados, user = 'postgres', password = senha, port = 5432)
cursor = conection.cursor()


# Condere se existe uma sessão atualmente com um usuario válido, para prevenir que uma pessoa aleatoria entre diretamente no meio do sistema
@app.before_request
def before_request():
    if 'username' in session:
        usuario = user.Usuario.achaUsuario("'"+session['username']+"'", cursor)
        g.usuario = usuario

# Redireciona para tela de login
@app.route('/')
def initial():
    return redirect(url_for('login', tipo='ignore', mensagem='ignore'))

# Tela de login
@app.route('/login/<tipo>/<mensagem>', methods=['GET', 'POST'])
def login(tipo, mensagem):
    if request.method == 'POST': # Espera o usuário enviar dados
        session.pop('username', None)

        formulario = request.form.to_dict()
        username = formulario['username'] 
        password = formulario['password']

         # Verifica se usuario e senha concedem entrada
        if  user.Usuario.verifyUsernamePassword("'" + username + "'", password, cursor):
            session['username'] = username
             # Redireciona para pagina principal
             # tipo se relaciona a mensagem que podem ser mostradas na tela de menu
             # mensagem é a mensagem em si
            return redirect(url_for('menu', tipo='ignore', mensagem='ignore'))
        
        # Retorna para própria tela com mensagem de erro
        return render_template('login.html', tipo='negativo', mensagem='Senha e/ou usuario incorretos')
    
    # Renderiza a pagina inicialmente
    return render_template('login.html', tipo=tipo, mensagem=mensagem)

# Tela de menu
@app.route('/menu/<tipo>/<mensagem>', methods=['GET'])
def menu(tipo, mensagem):
    session.get('username')
    username = session['username']
    return render_template('menu.html', tipo = tipo, mensagem = mensagem )


