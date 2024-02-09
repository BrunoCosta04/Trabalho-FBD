from model import (
    query,
    user
)

import psycopg2 as pg

from flask import (
    Flask,
    g,
    redirect,
    render_template,
    request,
    session,
    url_for
)


app = Flask(__name__, template_folder='view')
app.secret_key = 'secretkey'


nomeBaseDados = 'Netflix'
senha = 'Sulamericana1'

conection = pg.connect(host = 'localhost', dbname = nomeBaseDados, user = 'postgres', password = senha, port = 5432)
cursor = conection.cursor()

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
        if  user.Account.verifyUsernamePassword("'" + username + "'", password, cursor):
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

#Tela para cadastro de novo usuário
@app.route('/novoUsuario', methods=['GET', 'POST'])
def novoUsuario():
    if request.method == 'POST': #espera o usuário enviar dados
        formulario = request.form.to_dict()
        email = formulario['email']
        senha = formulario['password']
        re_senha = formulario['repassword']

        novoUsername = user.Account.validateNewUser(email, cursor)
        senhasIguais = user.Account.validatePassword(senha, re_senha)

        if novoUsername and senhasIguais:
            user.Account.createNewAccount( senha, email, cursor)
            conection.commit()
            return redirect(url_for('login', tipo = 'positivo', mensagem = 'Usuário criado com sucesso!!'))
        else:
            return render_template('novoUsuario.html',
                                errorUsermaneExists = not novoUsername,
                                errorPassowrdsDontMatch = not senhasIguais)
    return render_template('novoUsuario.html')

@app.route('/consultas', methods=['GET', 'POST'])
def consultas():
    header = []
    tabela = []
    if request.method == 'POST':

        formulario = request.form.to_dict()
        escolha = formulario['escolha']

        if escolha == '1':
            header, tabela = query.planosMais3Users(cursor)
        
        if escolha == '2':
            header, tabela = query.quantidadeOscarPorCategoria(cursor)

        if escolha == '3':
            query.atualizaStatusPagamentoPremiumVisa(cursor)
            conection.commit()

        if escolha == '4':
            query.removeVisualizaAtrasadoPremium(cursor)
            conection.commit()

        if escolha == '5':
            header, tabela = query.achaUsuariosAssistiramNota6(cursor)

        if escolha == '6':
            header, tabela = query.quantidadeVisuNomeBasica(cursor)

        if escolha == '7':
            header, tabela = query.contasBasicasAtrasadas(cursor)

        if escolha == '8':
            header, tabela = query.categoriasComTomHanks(cursor)

        if escolha == '9':
            header, tabela = query.adicionaAssinaturaRuim(cursor)
        if escolha == '10':
            header, tabela = query.adicionaAssinaturaBoa(cursor)
        if escolha == '11':
            header, tabela = query.selectAssinaturas(cursor)

    return render_template('consultas.html', header=header,  tabela=tabela)