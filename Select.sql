--------------------------------------------//----------------------------------

--Pesquisas
-- 8 consultas uteis que envolvem 3 tabelas


--A)No mínimo duas delas devem necessitar serem respondidas com a cláusula group by (isto é, a resposta deve 
--combinar atributos e totalizações sobre grupos ). Dentre essas, pelo menos uma deve incluir também a cláusula 
--Having.

-- 1
-- nome dos planos com contas com mais de 3 usuarios


select planName, n_users
from _Plan natural join
_Subscription natural join 
				  (select email, count(*) as n_users
				   from _User group by email having count(*) > 3);
				  

--Adicionais para conferencia
--select * from Account
--select * from _Subscription
--select * from _Plan
--select * from _User

-- 1
-- nome e quantidade de usuarios dos planos com contas com mais de 3 usuarios
-- 2
-- quantidade de titulos com atores com oscar por categoria
select count(*) as n_titulos_com_oscar, categoryName
from category natural join title natural join (select titleid from
											   acts natural join worker
											   where oscar = True)
group by categoryName

--Adicionais para conferencia
--select * from Acts
--select * from Worker
--select * from Category
--select * from Title

--No mínimo duas delas devem necessitar serem respondidas com subconsulta (isto é, não existe formulação 
--equivalente usando apenas joins);

-- 3    atualizar o status de pagamento de subscriptions que tem plano premium e cartao visa.
update _Subscription
set paymentStatus = 'Paid'
where exists ( select planid
				from _Plan
				where planName = 'Plano Premium' and
				_Subscription.planid = _Plan.planid and
				exists ( select email 
							from creditCard
							where cardBrand = 'Visa' and
							_Subscription.email = creditCard.email))


-- 4    remove as visualizações de todos os uruários de uma conta com pagamento atrasado e plano premium

delete from watches 
where exists ( select email 
				from _Subscription natural join _Plan
				where  paymentStatus = 'Unpaid' and 
			  			planName = 'Plano Premium' and
						watches.email = _Subscription.email
						)



--No mínimo uma delas (diferente das consultas acima) deve necessitar do operador NOT EXISTS para 
--responder questões do tipo TODOS ou NENHUM que <referencia> (isto é, não existe formulação
--equivalente usando simplesmente joins ou subconsultas com (NOT) IN ou demais operadores relacionais)

-- 5 usuário que não assistiu nenhum conteúdo com rating acima de 8




--No mínimos duas consultas devem utilizar a visão definida no item anterior.
-- ## Item2.a) Definir uma visão útil a seu universo de discurso, envolvendo no mínimo 2 tabelas. 


-- 6


-- 7

-- Acho que a ultima é livre (?)
-- 8 - As categorias que tom hanks ja atuou em:


select categoryName , titleName
from title 
where titleid in (select titleid
				  from acts natural join worker
				  	where workername = 'Tom Hanks'
					
)





