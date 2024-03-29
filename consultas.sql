--------------------------------------------//----------------------------------
--2a)
drop view if exists basicAccounts;

create view basicAccounts as
select email
from _subscription natural join _plan
where planname = 'Plano Básico';

select * from basicAccounts;

--Consultas
-- 8 consultas uteis que envolvem 3 tabelas


--	No mínimo duas delas devem necessitar serem respondidas com a cláusula group by (isto é, a resposta deve 
--	combinar atributos e totalizações sobre grupos ). Dentre essas, pelo menos uma deve incluir também a cláusula Having.

-- 1
-- Nome dos planos com contas com mais de 3 usuarios


select planName, n_users
from _Plan natural join
_Subscription natural join 
				  (select email, count(*) as n_users
				   from _User group by email having count(*) > 3);
				  

--Tabelas utilizadas (para conferencia)
--select * from Account
--select * from _Subscription
--select * from _Plan
--select * from _User

-- 2
-- Quantidade de titulos com atores que ganharam Oscar por categoria
select count(*) as n_titulos_com_oscar, categoryName
from category natural join title natural join (select titleid from
											   acts natural join worker
											   where oscar = True)
group by categoryName

--Tabelas utilizadas (para conferencia)
--select * from Acts
--select * from Worker
--select * from Category
--select * from Title

--	No mínimo duas delas devem necessitar serem respondidas com subconsulta (isto é, não existe formulação 
--	equivalente usando apenas joins);

-- 3    
-- Atualizar o status de pagamento de subscriptions que tem plano premium e cartao visa.
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

--Tabelas utilizadas (para conferencia)
--select * from creditCard
--select * from _Subscription
--select * from _Plan


-- 4
-- Remove as visualizações de todos os usuários de uma conta com pagamento atrasado e plano premium

delete from watches 
where exists ( select email 
				from _Subscription natural join _Plan
				where  paymentStatus = 'Unpaid' and 
			  			planName = 'Plano Premium' and
						watches.email = _Subscription.email
						)

--Tabelas utilizadas (para conferencia)
--select * from Watches
--select * from _Subscription
--select * from _Plan

--	No mínimo uma delas (diferente das consultas acima) deve necessitar do operador NOT EXISTS para 
--	responder questões do tipo TODOS ou NENHUM que <referencia> (isto é, não existe formulação
--	equivalente usando simplesmente joins ou subconsultas com (NOT) IN ou demais operadores relacionais)

-- 5 Os usuários que ja assistiram a titulos com nota igual ou menor a 6.
select email, userName
from watches natural join _content
where not exists ( select titleid
					from title 
					where rating > 6 and
					_content.titleid = title.titleid)



--	No mínimos duas consultas devem utilizar a visão definida no item anterior.

-- 6
-- Quantidade de visualizações e nome dos conteúdos assistidos por contas básicas
select titleName, count(*) as n_watches 
from title natural join _content
where contentid in 
	(select contentid from watches 
	 	where email in (select email from basicAccounts))
group by titleName;

--Tabelas utilizadas (para conferencia)
--select * from Title
--select * from Watches
--select * from _Content
--select * from basicAccounts

-- 7
-- Contas basicas que estão com o pagamento atrasado
select email
from _Subscription
where email in (select email from basicAccounts)
	  and paymentStatus = 'Unpaid';

--Tabelas utilizadas (para conferencia)
-- select * from Account;
-- select * from _Plan;
-- select * from basicAccounts;
-- select * from _subscription;


-- Consulta Livre
-- 8 - As categorias que tom hanks ja atuou em:

select categoryName , titleName
from title 
where titleid in (select titleid
				  from acts natural join worker
				  	where workername = 'Tom Hanks');


--Tabelas utilizadas (para conferencia)
--select * from Title
--select * from Acts
--select * from Worker