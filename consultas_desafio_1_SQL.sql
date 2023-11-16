-- Candidato: Raniery Alves Vasconcelos

--Valor total das vendas e dos fretes por produto e ordem de venda:
select 
	data asc,
	produtoid,
	sum(valorliquido) as valor_total_vendas,
	sum(valorfrete) as valor_total_fretes
from sales_details 
inner join sales on
sales_details.cupomid = sales.cupomid
group by data, produtoid
order by data asc

--Valor de venda por tipo de produto:
select 
	produtoid,
	sum(valorliquido) as valor_total_vendas
from sales_details 
inner join sales on
sales_details.cupomid = sales.cupomid
group by produtoid
order by produtoid asc

--Quantidade e valor das vendas por dia, mês, ano:
create view quantidade_e_valor_vendas_dia as(
	select 
		produtoid,
		date_trunc('day', data) as por_dia,
		quantidade as qtd_dia,
		sum(valorliquido) as valor_total_vendas	
	from sales_details 
	inner join sales on
	sales_details.cupomid = sales.cupomid
	group by data, produtoid, quantidade
	order by data, produtoid asc
)

create view quantidade_e_valor_vendas_mes as(
	select 
		produtoid,
		date_trunc('month', data) as por_mes,
		quantidade as qtd_mes,
		sum(valorliquido) as valor_total_vendas	
	from sales_details 
	inner join sales on
	sales_details.cupomid = sales.cupomid
	group by data, produtoid, quantidade
	order by data, produtoid asc
)

create view quantidade_e_valor_vendas_ano as(
	select 
		produtoid,
		date_trunc('year', data) as por_ano,
		quantidade as qtd_ano,
		sum(valorliquido) as valor_total_vendas	
	from sales_details 
	inner join sales on
	sales_details.cupomid = sales.cupomid
	group by data, produtoid, quantidade
	order by data, produtoid asc
)

select *
from
	quantidade_e_valor_vendas_dia inner join
		quantidade_e_valor_vendas_mes on
		quantidade_e_valor_vendas_dia.produtoid = quantidade_e_valor_vendas_mes.produtoid
	inner join
	quantidade_e_valor_vendas_ano on
		quantidade_e_valor_vendas_mes.produtoid = quantidade_e_valor_vendas_ano.produtoid

--Lucro dos meses:
select 
	date_trunc('month', data) as por_mes,
	sum(valorliquido) as valor_total_vendas	
from sales_details 
inner join sales on
sales_details.cupomid = sales.cupomid
group by data
order by data

--Venda por produto:
select 
	produtoid,
	sum(quantidade) as quantidade_total,
	sum(valor) as valor_bruto_total_vendas,
	sum(valorliquido) as valor_liquido_total_vendas,
	sum(valorfrete) as valor_total_fretes
from sales_details 
inner join sales on
sales_details.cupomid = sales.cupomid
group by produtoid
order by produtoid asc

--Venda por cliente, cidade do cliente e estado:
create view vendas_por_cliente as (
	select
		customer_details.clienteid,
		sum(valor) as valor_bruto_total_vendas_por_cliente,
		sum(valorliquido) as valor_liquido_total_vendas_por_cliente,
		sum(valorfrete) as valor_total_fretes_por_cliente
	from sales
		inner join sales_details on
			sales.cupomid = sales_details.cupomid
		inner join
			customer_details on
			sales.clienteid = customer_details.clienteid
	group by customer_details.clienteid
	order by customer_details.clienteid asc
)

create view vendas_por_cidade_do_cliente as (
	select
		customer_details.cidade,
		sum(valor) as valor_bruto_total_vendas_por_cidade_do_cliente,
		sum(valorliquido) as valor_liquido_total_vendas_por_cidade_do_cliente,
		sum(valorfrete) as valor_total_fretes_por_cidade_do_cliente
	from sales
		inner join sales_details on
			sales.cupomid = sales_details.cupomid
		inner join
			customer_details on
			sales.clienteid = customer_details.clienteid
	group by customer_details.cidade
	order by customer_details.cidade asc
)

create view vendas_por_estado_do_cliente as (
	select
		customer_details.pais,
		sum(valor) as valor_bruto_total_vendas_por_estado_do_cliente,
		sum(valorliquido) as valor_liquido_total_vendas_por_estado_do_cliente,
		sum(valorfrete) as valor_total_fretes_por_estado_do_cliente
	from sales
		inner join sales_details on
			sales.cupomid = sales_details.cupomid
		inner join
			customer_details on
			sales.clienteid = customer_details.clienteid
	group by customer_details.pais
	order by customer_details.pais asc
)

select *
from vendas_por_cliente

select *
from vendas_por_cidade_do_cliente

select *
from vendas_por_estado_do_cliente

--Média de produtos vendidos:
select 
	produtoid,
	avg(quantidade) as quantidade_média_produtos_vendidos
from sales_details 
inner join sales on
sales_details.cupomid = sales.cupomid
group by produtoid
order by produtoid asc

--Média de compras que um cliente faz:
select 
	customer_details.clienteid,
	sum(quantidade)/count(date_trunc('day', data)) as media_compras	
from sales
	inner join sales_details on
		sales.cupomid = sales_details.cupomid
	inner join
		customer_details on
		sales.clienteid = customer_details.clienteid
group by customer_details.clienteid
order by customer_details.clienteid asc