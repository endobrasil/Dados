--Criação do DB
CREATE DATABASE Desafio1;
USE Desafio1 ;

-- criação da tabela cliente
CREATE TABLE Cliente (
  id INT NOT NULL AUTO_INCREMENT,
  cpf CHAR(11) NULL,
  endereco VARCHAR(45) NULL,
  m_nome_inicial VARCHAR(3) NULL COMMENT 'A inicial do nome do meio',
  p_nome VARCHAR(10) NOT NULL COMMENT 'Primeiro nome do nosso cliente\n',
  s_nome VARCHAR(45) NULL COMMENT 'Sobre Nome\nAdicionar constraint de unicidade para (nome completo) unique (Nome, M, Sobrenome)',
  nascimento DATE NULL,
  cnpj CHAR(15) NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX identificacao_UNIQUE (cpf ASC) VISIBLE,
  UNIQUE INDEX cnpj_UNIQUE (cnpj ASC) VISIBLE);


-- criação da tabela produto
CREATE TABLE Produto (
  id INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(45) NULL,
  valor DECIMAL NOT NULL,
  categoria ENUM("Eletrônico", "Vestimenta", "brnquedos", "Alimento", "Moveis") NOT NULL,
  dimensoes VARCHAR(45) NULL,
  avaliacao FLOAT NULL DEFAULT 0,
  classificacao_kids TINYINT NULL DEFAULT 0,
  PRIMARY KEY (id));

-- criação da tabela fornecedor
CREATE TABLE Fornecedor (
  id INT NOT NULL AUTO_INCREMENT,
  razao_social VARCHAR(45) NOT NULL,
  cnpj CHAR(15) NOT NULL,
  contato VARCHAR(15) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX cnpj_UNIQUE (cnpj ASC) VISIBLE);

-- criação da tabela vedendor
CREATE TABLE Terceiro_Vendedor(
  id INT NOT NULL AUTO_INCREMENT,
  razao_social VARCHAR(45) NOT NULL,
  local VARCHAR(45) NULL,
  nome_fantasia VARCHAR(45) NULL,
  endereco VARCHAR(45) NULL,
  cnpj CHAR(15) NULL,
  cpf CHAR(11) NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX razao_social_UNIQUE (razao_social ASC) VISIBLE,
  UNIQUE INDEX cnpj_UNIQUE (cnpj ASC) VISIBLE,
  UNIQUE INDEX cpf_UNIQUE (cpf ASC) VISIBLE);


-- criação da tabela estoque
CREATE TABLE Estoque (
  id INT NOT NULL AUTO_INCREMENT,
  local VARCHAR(45) NOT NULL,
  quantidade INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id));


-- Criação da tabela pagamento
CREATE TABLE Pagamento (
  id INT NOT NULL AUTO_INCREMENT,
  tipo ENUM("Boleto", "Cartão", "Dois catões", "pix") NULL,
  valor FLOAT NOT NULL,
  status TINYINT NULL DEFAULT 0,
  validade DATE NOT NULL,
  PRIMARY KEY (id));

-- Relacionamento pedido
CREATE TABLE Pedido (
  id INT NOT NULL AUTO_INCREMENT,
  status ENUM("Em andamento", "Processando", "Enviado", "Entregue", "Cancelado", "Em processamento") NOT NULL DEFAULT 'Em processamento',
  descricao VARCHAR(252) NULL,
  frete FLOAT NULL DEFAULT 0,
  Cliente_id INT NOT NULL,
  Pagamento_id INT NOT NULL,
  codido_rastreio VARCHAR(18) NULL,
  PRIMARY KEY (id, Cliente_id),
  INDEX fk_Pedido_Cliente1_idx (Cliente_id ASC) VISIBLE,
  INDEX fk_Pedido_Pagamento1_idx (Pagamento_id ASC) VISIBLE,
  UNIQUE INDEX codido_rastreio_UNIQUE (codido_rastreio ASC) VISIBLE,
  CONSTRAINT fk_Pedido_Cliente1
    FOREIGN KEY (Cliente_id)
    REFERENCES Cliente(id),
  CONSTRAINT fk_Pedido_Pagamento1
    FOREIGN KEY (Pagamento_id)
    REFERENCES Pagamento (id));


-- Relacionamento dos produtos disponibilizados por fornecedores
CREATE TABLE Disponibiliza_Produto (
  Produto_id INT NOT NULL,
  Fornecedor_id INT NOT NULL,
  PRIMARY KEY (Produto_id, Fornecedor_id),
  INDEX fk_Produto_por_Fornecedor_Fornecedor1_idx (Fornecedor_id ASC) VISIBLE,
  INDEX fk_Produto_por_Fornecedor_Produto_idx (Produto_id ASC) VISIBLE,
  CONSTRAINT fk_Produto_has_Fornecedor_Produto
    FOREIGN KEY (Produto_id)
    REFERENCES Produto(id),
  CONSTRAINT fk_Produto_por_Fornecedor_Fornecedor1
    FOREIGN KEY (Fornecedor_id)
    REFERENCES Fornecedor(id));


-- Relacionamento dos produtos em estoque
CREATE TABLE Produto_em_Estoque (
  Produto_id INT NOT NULL,
  Estoque_id INT NOT NULL,
  quantidade INT NULL,
  PRIMARY KEY (Produto_id, Estoque_id),
  INDEX fk_Produto_em_Estoque_Estoque1_idx (Estoque_id ASC) VISIBLE,
  INDEX fk_Produto_em_Estoque_Produto1_idx (Produto_id ASC) VISIBLE,
  CONSTRAINT fk_Produto_em_Estoque_Produto1
    FOREIGN KEY (Produto_id)
    REFERENCES Produto(id),
  CONSTRAINT fk_Produto_em_Estoque_Estoque1
    FOREIGN KEY (Estoque_id)
    REFERENCES Estoque(id));


-- Relacionamento dos produtos por vendedores
CREATE TABLE Produto_por_Vendedor (
  Vendedor_id INT NOT NULL,
  Produto_id INT NOT NULL,
  quantidade INT NULL,
  PRIMARY KEY (Vendedor_id, Produto_id),
  INDEX fk_Terceiro_Vendedor_por_Produto_Produto1_idx (Produto_id ASC) VISIBLE,
  INDEX fk_Terceiro_Vendedor_por_Produto_Terceiro_Vendedor1_idx (Vendedor_id ASC) VISIBLE,
  CONSTRAINT fk_Terceiro_Vendedor_com_Produto_Terceiro_Vendedor1
    FOREIGN KEY (Vendedor_id)
    REFERENCES Terceiro_Vendedor(id),
  CONSTRAINT fk_Terceiro_Vendedor_com_Produto_Produto1
    FOREIGN KEY (Produto_id)
    REFERENCES Produto(id));


-- Relacionamento dos produtos em um pedido
CREATE TABLE IF NOT EXISTS Produto_Pedido (
  Produto_id INT NOT NULL,
  Pedido_id INT NOT NULL,
  quantidade INT NULL,
  status ENUM("Disponível", "Fora de estoque") NULL DEFAULT 'Disponível',
  PRIMARY KEY (Produto_id, Pedido_id),
  INDEX fk_Produto_no_Pedido_Pedido1_idx (Pedido_id ASC) VISIBLE,
  INDEX fk_Produto_no_Pedido_Produto1_idx (Produto_id ASC) VISIBLE,
  CONSTRAINT fk_Produto_no_Pedido_Produto1
    FOREIGN KEY (Produto_id)
    REFERENCES Produto (id),
  CONSTRAINT fk_Produto_has_Pedido_Pedido1
    FOREIGN KEY (Pedido_id)
    REFERENCES Pedido (id));


-- Inserção da dados nas tabelas

-- Clientes pessoas físicas
insert into Cliente(cpf, p_nome, endereco, m_nome_inicial, s_nome, nascimento)value
('68974155961'," Cliente 1 "," Rua: 1  "," C1  "," Sobre 1 ",' 2000-01-31  '),
('78965412387'," Cliente 2 "," Rua: 2  "," C2  "," Sobre 2 ",' 1985-03-14  '),
('98725896314'," Cliente 3 "," Rua: 3  "," C3  "," Sobre 3 ",' 1987-08-15  '),
('45698712024'," Cliente 4 "," Rua: 4  "," C4  "," Sobre 4 ",' 2006-12-15  '),
('45695184412'," Cliente 5 "," Rua: 5  "," C5  "," Sobre 5 ",' 2005-09-18  ');


-- Clientes pessoas jurídica
insert into Cliente(cnpj, p_nome, endereco)value
('123954567898745'," Empresa 1 "," Rua: 6"),
('214565498654987'," Empresa 2 "," Rua: 7  "),
('987956546232100 '," Empresa 3 "," Rua: 8  "),
('123004561278945 '," Empresa 4 "," Rua: 9  "),
('369858521474100 '," Empresa 5 "," Rua: 10 ");


-- Cadastro de Fornecedores
insert into Fornecedor(cnpj, razao_social, contato) value
('123954471898741'," Fornecedor 1  "," 85140014  "),
('217895498654972'," Fornecedor 2  "," 98652247  "),
('987956546232563'," Fornecedor 3  "," 45998765  "),
('123004564564504'," Fornecedor 4  "," 45889981  "),
('369858521447415'," Fornecedor 5  "," 85967412  ");


-- Cadastro de Terceiro Vendedor PF
insert into Terceiro_Vendedor(razao_social,local,nome_fantasia,endereco,cpf) value
("  Vendedor 1  "," Local 1 "," Cliente 1 "," Rua 1 ",'68974155961'),
("  Vendedor 2  "," Local 2 "," Cliente 2 "," Rua 2 ",'78965412387'),
("  Vendedor 3  "," Local 3 "," Cliente 3 "," Rua 3 ",'98725896314'),
("  Vendedor 4  "," Local 4 "," Cliente 4 "," Rua 4 ",'45698712024'),
("  Vendedor 5  "," Local 5 "," Cliente 5 "," Rua 5 ",'45695184412');


-- Cadastro de Terceiro Vendedor PJ
insert into Terceiro_Vendedor(razao_social,local,nome_fantasia,endereco,cnpj) value
("  Vendedor 6  "," Local 6 "," Empresa 1 "," Rua 6 ",'123954567898745'),
("  Vendedor 7  "," Local 7 "," Empresa 2 "," Rua 7 ",'214565498654987'),
("  Vendedor 8  "," Local 8 "," Empresa 3 "," Rua 8 ",'987956546232100'),
("  Vendedor 9  "," Local 9 "," Empresa 4 "," Rua 9 ",'123004561278945'),
("  Vendedor 10 "," Local 10  "," Empresa 5 "," Rua 10  ",'369858521474100'),
("  Vendedor 11 "," Local 11 ", " Empresa 6 "," Rua 11 ",'123954471898741'),
("  Vendedor 12 "," Local 12 ", " Empresa 7 "," Rua 12 ",'217895498654972'),
("  Vendedor 13 "," Local 13 ", " Empresa 8 "," Rua 13 ",'123004564564504');


-- Cadastro de Produtos
insert into Produto(descricao, valor, categoria, dimensoes, avaliacao, classificacao_kids) value
("  Produto 1 ",  42  , 'Eletrônico'  ,"  14 x 15 x 78  ",  8 , 0 ),
("  Produto 2 ",  16  , 'Vestimenta'  ,"  15 x 15 x 78  ",  8 , 1 ),
("  Produto 3 ",  92  , 'brinquedos',"  16 x 15 x 78  ",  5 , 0 ),
("  Produto 4 ",  82  , 'Alimento' ,"  17 x 15 x 78  ",  10  , 1 ),
("  Produto 5 ",  87  , 'Moveis'  ,"  18 x 15 x 78  ",  3 , 0 ),
("  Produto 6 ",  21  , 'Eletrônico'  ,"  19 x 15 x 78  ",  2 , 0 ),
("  Produto 7 ",  45  , 'Vestimenta'  ,"  20 x 15 x 78  ",  4 , 0 ),
("  Produto 8 ",  25  , 'brinquedos',"  21 x 15 x 78  ",  9 , 0 ),
("  Produto 9 ",  63  , 'Alimento' ,"  22 x 15 x 78  ",  8 , 0 ),
("  Produto 10  ",  5 , 'Moveis'  ,"  23 x 15 x 78  ",  6 , 1 );


-- Cadastro de Estoque
insert into Estoque(local, quantidade) values
("  Local 1 ",  525 ),
("  Local 2 ",  882 ),
("  Local 3 ",  355 ),
("  Local 4 ",  670 ),
("  Local 5 ",  812 ),
("  Local 6 ",  444 ),
("  Local 7 ",  564 ),
("  Local 8 ",  428 ),
("  Local 9 ",  561 ),
("  Local 10  ",  757 );


-- Cadastro dos pagamentos
insert into Pagamento(tipo, valor,status,validade) values
("Boleto",  5 , 0 , '2023-12-30'  ),
("Cartão",  18  , 1 , '2023-01-30'  ),
("Dois Catões",  56  , 0 , '2023-08-30'  ),
("pix",  91  , 1 , '2023-09-30'  ),
("Boleto",  27  , 1 , '2023-12-30'  ),
("Cartão",  92  , 1 , '2023-12-10'  ),
("Dois Catões",  79  , 0 , '2023-10-10'  ),
("pix",  19  , 0 , '2023-11-13'  ),
("Boleto",  42  , 1 , '2023-09-16'  ),
("Cartão",  98  , 0 , '2023-05-03'  );



-- Cadastro de produtos por vendedor
insert into Produto_por_Vendedor values
( 3 , 2 , 53  ),
( 4 , 10  , 16  ),
( 6 , 2 , 58  ),
( 3 , 1 , 60  ),
( 5 , 7 , 87  ),
( 5 , 5 , 42  ),
( 8 , 1 , 41  ),
( 2 , 3 , 22  ),
( 6 , 4 , 68  ),
( 10  , 2 , 28  );

-- Cadastro do produto em estoque
insert into Produto_em_Estoque values
( 3 , 2 , 53  ),
( 4 , 10  , 16  ),
( 6 , 2 , 58  ),
( 3 , 1 , 60  ),
( 5 , 7 , 87  ),
( 5 , 5 , 42  ),
( 8 , 1 , 41  ),
( 2 , 3 , 22  ),
( 6 , 4 , 68  ),
( 10  , 2 , 28  );


-- Produto no pedido
insert into Produto_Pedido(status, quantidade, Produto_id, Pedido_id) values
( 'Fora de estoque' , 16  , 4 , 8 ),
( 'Disponível'  , 28  , 5 , 1  ),
( 'Disponível'  , 7 , 8 , 10  ),
( 'Disponível'  , 22  , 7 , 17  ),
( 'Disponível'  , 0 , 9 , 15  ),
( 'Fora de estoque' , 28  , 2 , 11  ),
( 'Fora de estoque' , 29  , 7 , 4 ),
( 'Fora de estoque' , 22  , 10  , 20  ),
( 'Disponível'  , 7 , 2 , 1  ),
( 'Disponível'  , 5 , 4 , 1 ),
( 'Disponível'  , 3 , 9 , 10  ),
( 'Fora de estoque' , 9 , 9 , 8 ),
( 'Fora de estoque' , 30  , 9 , 11  ),
( 'Disponível'  , 30  , 2 , 17  ),
( 'Disponível'  , 11  , 10  , 10  ),
( 'Disponível'  , 11  , 10  , 14  ),
( 'Fora de estoque' , 27  , 2 , 7 ),
( 'Disponível'  , 9 , 9 , 17  ),
( 'Disponível'  , 4 , 6 , 10  ),
( 'Disponível'  , 22  , 5 , 18  ),
( 'Disponível'  , 20  , 2 , 16  ),
( 'Fora de estoque' , 23  , 9 , 3 ),
( 'Disponível'  , 27  , 5 , 7 ),
( 'Disponível'  , 9 , 1 , 12  ),
( 'Disponível'  , 25  , 3 , 11  ),
( 'Disponível'  , 5 , 6 , 3 ),
( 'Fora de estoque' , 18  , 4 , 9 ),
( 'Fora de estoque' , 22  , 8 , 12  ),
( 'Fora de estoque' , 29  , 3 , 1 ),
( 'Disponível'  , 24  , 7 , 3 ),
( 'Disponível'  , 22  , 10  , 5 ),
( 'Disponível'  , 25  , 4 , 17  ),
( 'Fora de estoque' , 23  , 3 , 8 ),
( 'Fora de estoque' , 14  , 5 , 16  ),
( 'Disponível'  , 1 , 3 , 2 ),
( 'Disponível'  , 1 , 6 , 14  ),
( 'Disponível'  , 17  , 8 , 8 ),
( 'Fora de estoque' , 27  , 3 , 10  ),
( 'Disponível'  , 28  , 4 , 21  ),
( 'Disponível'  , 10  , 10  , 12  ),
( 'Disponível'  , 26  , 8 , 19  ),
( 'Disponível'  , 10  , 9 , 18  );

-- Pedidos 
insert into Pedido (status, descricao, frete, Cliente_id, Pagamento_id, codido_rastreio) values

( 'Em andamento'  ,"  Pedido 01 ",  29  , 4 , 2 ,"  72393600  br  "),
( 'Processando' ,"  Pedido 02 ",  25  , 3 , 1 ,"  66382194  us  "),
( 'Enviado' ,"  Pedido 03 ",  20  , 1 , 10  ,"  33086931  kx  "),
( 'Entregue'  ,"  Pedido 04 ",  21  , 8 , 8 ,"  53970456  uk  "),
( 'Cancelado' ,"  Pedido 05 ",  14  , 2 , 6 ,"  17956524  br  "),
( 'Em processamento'  ,"  Pedido 06 ",  15  , 8 , 3 ,"  7131913 us  "),
( 'Em andamento'  ,"  Pedido 07 ",  8 , 3 , 3 ,"  63559628  kx  "),
( 'Processando' ,"  Pedido 08 ",  11  , 4 , 4 ,"  41209668  uk  "),
( 'Enviado' ,"  Pedido 09 ",  6 , 5 , 8 ,"  46469602  br  "),
( 'Entregue'  ,"  Pedido 10 ",  20  , 1 , 2 ,"  52159606  us  "),
( 'Cancelado' ,"  Pedido 11 ",  29  , 5 , 9 ,"  91786918  kx  "),
( 'Em processamento'  ,"  Pedido 12 ",  29  , 1 , 4 ,"  77176955  uk  "),
( 'Em andamento'  ,"  Pedido 13 ",  5 , 8 , 6 ,"  28276212  br  "),
( 'Processando' ,"  Pedido 14 ",  1 , 1 , 9 ,"  47672868  us  "),
( 'Enviado' ,"  Pedido 15 ",  17  , 9 , 7 ,"  30745988  kx  "),
( 'Entregue'  ,"  Pedido 16 ",  5 , 5 , 9 ,"  62228249  uk  "),
( 'Cancelado' ,"  Pedido 17 ",  13  , 6 , 10  ,"  46700001  br  "),
( 'Em processamento'  ,"  Pedido 18 ",  14  , 6 , 5 ,"  13213436  us  "),
( 'Em andamento'  ,"  Pedido 19 ",  14  , 9 , 2 ,"  22876059  kx  "),
( 'Processando' ,"  Pedido 20 ",  1 , 2 , 2 ,"  89140456  uk  "),
( 'Processando' ,"  Pedido 21 ",  15  , 10  , 8 ,"  11077791  ln  ");

-- Cadastro dos fornecedores para os produtos
insert into Disponibiliza_Produto values
( 5 , 3 ),
( 5 , 5 ),
( 10  , 1 ),
( 1 , 3 ),
( 10  , 5 ),
( 6 , 3 ),
( 1 , 5 ),
( 6 , 2 ),
( 1 , 1 ),
( 6 , 1 );



-- Selecionado todos os clientes
  select * from Cliente


-- Uma consulta que responde a pergunta:
-- "Quais os clientes que moram em uma determinada localidade?"
-- com o intúito de fazer uma promoção nesta localidade
select * from Cliente where endereco like "%Rua: 1%"


-- Uma consulta que responde a pergunta:
-- "Quais os clientes que moram em uma determinada localidade?"
-- com o intúito de fazer uma promoção nesta localidade ordenando 
-- de forma decrescente a idade, que será o foco desta promoção
 select * from Cliente 
 where endereco like "%Rua:%" order by nascimento desc


 -- Uma consulta que responde a pergunta:
 -- Qual a média dos valores por categoria com as piores avaliações e
 -- onde o valor deste produto ultrapassa 80?"
  select p.categoria as 'Categoria' , avg(p.valor) as "média dos valores", avg(p.avaliacao) as 'média das piores avaliações' 
from Produto p
where p.avaliacao<=5
group by p.categoria
having avg(p.valor)>80
order by p.categoria desc

 
-- Uma consulta que responde a pergunta:
-- "revela qual produto cada cliente comprou?"
select c.p_nome as cliente, p.descricao as produto
from Pedido p
inner join Cliente c on p.Cliente_id = c.id
order by cliente

-- Uma consulta que responde as perguntas:
-- "quanto cada cliente esta gastando com os fretes? 
-- Quem é o cliente que mais gasta?"
select c.p_nome as cliente, sum(p.frete) as "soma dos fretes"
from Pedido p
inner join Cliente c on p.Cliente_id = c.id
group by cliente
order by sum(p.frete) desc


--Quantos pedidos foram feitos por cada cliente? 
select c.p_nome as cliente, count(*) as "Quantidade de pedidos"
from Pedido p
inner join Cliente c on p.Cliente_id = c.id
group by cliente
order by count(*) desc


-- Algum vendedor também é fornecedor? 
select f.razao_social as Fornecedor, v.nome_fantasia as Vendedor
from Fornecedor f
inner join Terceiro_Vendedor v on f.cnpj = v.cnpj


-- Relação de produtos fornecedores e estoques; 
select p.descricao as produto, f.razao_social as fornecedor, sum(pe.quantidade)
from Produto p
inner join Disponibiliza_Produto dp on p.id=dp.Produto_id
inner join Fornecedor f on f.id = dp.Fornecedor_id
inner join Produto_em_Estoque pe on p.id=pe.Produto_id
group by produto, fornecedor
order by produto, fornecedor


-- Relação de nomes dos fornecedores e nomes dos produtos; 
select f.razao_social as fornecedor, p.descricao as produto
from Produto p
inner join Disponibiliza_Produto dp on p.id=dp.Produto_id
inner join Fornecedor f on f.id = dp.Fornecedor_id
order by fornecedor



