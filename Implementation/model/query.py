import psycopg2 as pg

# Nome dos planos com contas com mais de 3 usuarios
def planosMais3Users(cursor):
    cursor.execute(""" select planName, n_users
                        from _Plan natural join _Subscription natural join 
				            (select email, count(*) as n_users
				                    from _User group by email having count(*) > 3);
				  """)
    return [desc[0] for desc in cursor.description], cursor.fetchall()

# Quantidade de titulos com atores que ganharam Oscar por categoria
def quantidadeOscarPorCategoria(cursor):
    cursor.execute("""select count(*) as n_titulos_com_oscar, categoryName
                        from category natural join title natural join (select titleid from
							acts natural join worker
							where oscar = True)
                        group by categoryName""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()

# Atualizar o status de pagamento de subscriptions que tem plano premium e cartao visa
def atualizaStatusPagamentoPremiumVisa(cursor):
    cursor.execute("""update _Subscription
                        set paymentStatus = 'Paid'
                        where exists ( select planid
				                        from _Plan
				                        where planName = 'Plano Premium' and
				                        _Subscription.planid = _Plan.planid and
				                        exists ( select email 
							                from creditCard
							                where cardBrand = 'Visa' and
							                _Subscription.email = creditCard.email))
""")

    # fazer commit no app

# Remove as visualizações de todos os usuários de uma conta com pagamento atrasado e plano premium
def removeVisualizaAtrasadoPremium(cursor):
    cursor.execute("""delete from watches 
                    where exists ( select email 
				        from _Subscription natural join _Plan
				        where  paymentStatus = 'Unpaid' and 
			  			    planName = 'Plano Premium' and
						    watches.email = _Subscription.email
						    )""")
    # fazer commit no app

# Os usuários que ja assistiram a titulos com nota igual ou menor a 6
def achaUsuariosAssistiramNota6(cursor):
    cursor.execute("""select email, userName
                        from watches natural join _content
                        where not exists ( select titleid
					    from title 
					    where rating > 6 and
					    _content.titleid = title.titleid)""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()

# Quantidade de visualizações e nome dos conteúdos assistidos por contas básicas
def quantidadeVisuNomeBasica(cursor):
    cursor.execute("""select titleName, count(*) as n_watches 
                    from title natural join _content
                    where contentid in 
	                (select contentid from watches 
	 	            where email in (select email from basicAccounts))
                    group by titleName;""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()

# Contas basicas que estão com o pagamento atrasado
def contasBasicasAtrasadas(cursor):
    cursor.execute("""select email
                        from _Subscription
                        where email in (select email from basicAccounts)
	                    and paymentStatus = 'Unpaid';""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()

# As categorias que tom hanks ja atuou em
def categoriasComTomHanks(cursor):
    cursor.execute("""select categoryName , titleName
                            from title 
                            where titleid in (select titleid
				            from acts natural join worker
				  	        where workername = 'Tom Hanks');""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()



def adicionaAssinaturaRuim(cursor):
    cursor.execute("""INSERT INTO _Subscription ( signingDate, paymentStatus, durationSub, email, planID) VALUES
( '2024-01-01', 'Paid', 12, 'vini@example.com', 1)""")
    cursor.execute("""select * from _subscription""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()
    
    



def adicionaAssinaturaBoa(cursor):
    cursor.execute("""INSERT INTO _Subscription ( signingDate, paymentStatus, durationSub, email, planID) VALUES
( '2030-03-01', 'Paid', 12, 'vini@example.com', 1)""")
    cursor.execute("""select * from _subscription""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()
    


def selectAssinaturas(cursor):
    cursor.execute("""select * from _subscription""")

    return [desc[0] for desc in cursor.description], cursor.fetchall()
