use Desafio1

select * from Cliente

select * from Cliente where endereco like "%Rua:%" order by nascimento desc

select p.categoria as 'Categoria' , avg(p.valor) as "média dos valores", avg(p.avaliacao) as 'média das piores avaliações' 
from Produto p
where p.avaliacao<=5
group by p.categoria
having avg(p.valor)>80
order by p.categoria desc

select c.p_nome as cliente, count(*) as "Quantidade de pedidos"
from Pedido p
inner join Cliente c on p.Cliente_id = c.id
group by cliente
order by count(*) desc

desc Fornecedor
select f.razao_social as Fornecedor, v.nome_fantasia as Vendedor
from Fornecedor f
inner join Terceiro_Vendedor v on f.cnpj = v.cnpj

select * 
from Terceiro_Vendedor v 

insert into Terceiro_Vendedor(razao_social,local,nome_fantasia,endereco,cnpj) value
("Vendedor 14","Local 16","Empresa 16","Rua 6 ",'123954471898741');

insert into Terceiro_Vendedor(razao_social,local,nome_fantasia,endereco,cnpj) value 
("  Vendedor 12 "," Local 12 ", " Empresa 7 "," Rua 12 ",'217895498654972'),
("  Vendedor 13 "," Local 13 ", " Empresa 8 "," Rua 13 ",'123004564564504');


select p.descricao as produto, f.razao_social as fornecedor, sum(pe.quantidade)
from Produto p
inner join Disponibiliza_Produto dp on p.id=dp.Produto_id
inner join Fornecedor f on f.id = dp.Fornecedor_id
inner join Produto_em_Estoque pe on p.id=pe.Produto_id
group by produto, fornecedor
order by produto, fornecedor



select f.razao_social as fornecedor, p.descricao as produto
from Produto p
inner join Disponibiliza_Produto dp on p.id=dp.Produto_id
inner join Fornecedor f on f.id = dp.Fornecedor_id
order by fornecedor