CREATE DATABASE mechanic;
USE mechanic;

CREATE TABLE usuario (
  idUsuario INT primary key auto_increment,
  nomeCompleto VARCHAR(60),
  email VARCHAR(60),
  senha VARCHAR(45),
  telefone CHAR(12)
);

SELECT idUsuario FROM usuario WHERE nomeCompleto = 'a' and email = 'a' and senha = 1234;
CREATE TABLE oficina (
  idOficina INT primary key auto_increment,
  fkUsuario INT,
  CONSTRAINT fkOficinaUsuario FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
  nome VARCHAR(60),
  cnpj CHAR(14)
);

INSERT INTO usuario VALUES
  (DEFAULT, 'Roberto Cruz Dias', 'roberto@flexcars.com', '123@#Roberto', '11922346211'),
  (DEFAULT, 'Francisco Geosmar', 'geo@reformadora.com', '123@#Geosmar', '11951347866');

INSERT INTO oficina VALUES 
  (DEFAULT, 1, 'Flex Mecanica', '11222333000199'),
  (DEFAULT, 2, 'Geosmar Reformadora', '22555333000177');

-- Select para ver o Dono e suas oficinas
SELECT u.nomeCompleto as Dono,
  u.email as 'E-mail',
  u.senha as Senha,
  o.nome as Oficina,
  o.cnpj as CNPJ
  FROM oficina as o
  JOIN usuario as u
  ON o.fkUsuario = u.idUsuario;

-- Sessão dos dados de Software da Oficina;
CREATE TABLE empresa (
  idEmpresa INT primary key auto_increment,
  razaoSocial CHAR(60),
  cnpj CHAR(14),
  fkDono INT,
  CONSTRAINT fkEmpresaCliente FOREIGN KEY (fkDono) REFERENCES cliente(idCliente)
)

CREATE TABLE cliente (
  idCliente INT primary key auto_increment,
  fkOficina INT,
  CONSTRAINT fkOficinaCliente FOREIGN KEY (fkOficina) REFERENCES oficina(idOficina),
  nome VARCHAR(60),
  email VARCHAR(60),
  telefone CHAR(12),
  cpf CHAR(11) UNIQUE
);

INSERT INTO empresa (razaoSocial, cnpj) VALUES 
('Alpha Tech Solutions', '12345678000101'),
('Beta Innovators', '23456789000102'),
('Gamma Enterprises', '34567890000103'),
('Delta Dynamics', '45678900000104');

select * from empresa;

SELECT * from empresa as e 
  RIGHT join cliente as c 
  on e.fkDono = c.idCliente;

-- Clientes com empresa
INSERT INTO cliente (fkEmpresa, fkOficina, nome, email, telefone) VALUES 
(1, 1, 'João Almeida', 'joao.almeida@example.com', '11987654321'),
(2, 1, 'Mariana Silva', 'mariana.silva@example.com', '21987654322'),
(3, 2, 'Pedro Rocha', 'pedro.rocha@example.com', '31987654323'),
(4, 2, 'Larissa Costa', 'larissa.costa@example.com', '41987654324');

-- Clientes sem empresa
INSERT INTO cliente (fkEmpresa, fkOficina, nome, email, telefone) VALUES 
(NULL, 2, 'Rafael Mendes', 'rafael.mendes@example.com', '51987654325'),
(NULL, 1, 'Julia Martins', 'julia.martins@example.com', '61987654326');


SELECT * from cliente;
-- Select para ver 
SELECT c.nome as Cliente,
  c.email as 'E-mail',
  c.telefone as Telefone,
  IFNULL(e.razaoSocial, 'Sem empresa') as Empresa,
  IFNULL(e.cnpj, '') as CNPJ
  FROM cliente as c
  LEFT JOIN empresa as e
  ON c.fkEmpresa = e.idEmpresa;

CREATE TABLE veiculo (
  idVeiculo INT primary key auto_increment,
  fkCliente INT,
  CONSTRAINT fkVeiculoCliente FOREIGN KEY (fkCliente) REFERENCES cliente(idCliente),
  marca VARCHAR(45),
  modelo VARCHAR(45),
  ano YEAR,
  placa CHAR(7)
);

SELECT * from veiculo;

-- Veículos associados a clientes
INSERT INTO veiculo (fkCliente, marca, modelo, ano, placa) VALUES 
(1, 'Toyota', 'Corolla', 2019, 'ABC1234'),
(2, 'Honda', 'Civic', 2020, 'DEF5678'),
(3, 'Ford', 'Focus', 2018, 'GHI9012'),
(4, 'Chevrolet', 'Cruze', 2021, 'JKL3456'),
(2, 'Hyundai', 'Elantra', 2017, 'MNO7890'),
(3, 'Nissan', 'Sentra', 2016, 'PQR1234');

-- Veículos sem associação a clientes
INSERT INTO veiculo (fkCliente, marca, modelo, ano, placa) VALUES 
(NULL, 'Volkswagen', 'Jetta', 2015, 'STU5678'),
(NULL, 'Kia', 'Optima', 2014, 'VWX9012'),
(NULL, 'Mazda', '3', 2013, 'YZA3456'),
(NULL, 'Subaru', 'Impreza', 2012, 'BCD7890');

select * from veiculo;

-- Associando hospedagens a alguns veículos
SELECT v.idVeiculo,
  CONCAT(v.marca, ' - ', v.modelo,', ', v.ano, ' (',v.placa,')') as Veiculo,
  h.dataEntrada as Entrada,
  h.dataSaida as Saída
  FROM veiculo as v
  JOIN hospedagem as h
  ON h.fkVeiculo = v.idVeiculo;

SELECT c.nome as Cliente,
  c.email as 'E-mail',
  IFNULL(e.razaoSocial, 'Sem empresa') as Empresa,
  IFNULL(e.cnpj, 'Sem CNPJ') as CNPJ,
  GROUP_CONCAT(IFNULL(CONCAT(v.marca, ' - ', v.modelo,', ', v.ano, ' (',v.placa,')'), 'Sem veículo')) as Veículo,
  IFNULL(h.dataEntrada, '') as 'Data de Entrada',
  IFNULL(h.dataSaida, '') as 'Data de Saída',
  IFNULL(h.nomeMotorista, '') as 'Motorista',
  IFNULL(h.rg, '') as 'RG do Motorista', 
  IFNULL(h.cpf, '') as 'CPF do Motorista'
  FROM cliente as c
  left JOIN empresa as e
  ON c.fkEmpresa = e.idEmpresa
  left JOIN veiculo as v
  ON v.fkCliente = c.idCliente
  left JOIN hospedagem as h
  ON h.fkVeiculo = v.idVeiculo
  GROUP BY c.nome, c.email, e.razaoSocial, e.cnpj, h.dataEntrada, h.dataSaida, h.nomeMotorista,h.rg, h.cpf
  ORDER BY h.dataEntrada desc;


-- Sistema de Orçamentos
CREATE TABLE orcamento (
  idOrcamento INT primary key auto_increment,
  dataLancamento DATE,
  orcStatus CHAR(9),
  CONSTRAINT chkStatus CHECK (orcStatus in ('Pendente', 'Aprovado', 'Concluido')),
  fkVeiculo INT,
  CONSTRAINT fkOrcamentoVeiculo FOREIGN KEY (fkVeiculo) REFERENCES veiculo(idVeiculo)
)

CREATE TABLE servico (
  idServico INT PRIMARY KEY AUTO_INCREMENT,
  descricao VARCHAR(100)
);

CREATE TABLE historico (
  idHistorico INT AUTO_INCREMENT,
  fkServico INT,
  fkOrcamento INT,
  -- fkVeiculo INT,
  CONSTRAINT pkComposta PRIMARY KEY (idHistorico, fkServico, fkOrcamento),
  CONSTRAINT fkHistoricoServico FOREIGN KEY (fkServico) REFERENCES servico(idServico),
  CONSTRAINT fkHistoricoOrcamento FOREIGN KEY (fkOrcamento) REFERENCES orcamento(idOrcamento),
  -- CONSTRAINT fkHistoricoVeiculo FOREIGN KEY (fkVeiculo) REFERENCES veiculo(idVeiculo),
  valor FLOAT,
  tipo CHAR(15),
  CONSTRAINT chkTipo CHECK (tipo in ('Funilaria', 'Pintura', 'Mecanica'))
)

INSERT INTO orcamento VALUES 
  (default, '2024-01-11', 'Pendente'),
  (default, '2024-01-11', 'Pendente'),
  (default, '2024-01-11', 'Concluido');

SELECT  * FROM oficina;

SELECT idCliente, nome FROM cliente WHERE fkOficina = ;

INSERT INTO cliente (fkOficina, nome, email, telefone) VALUES
(1, 'Carlos Ferreira', 'carlos.ferreira@example.com', '11987654321'),
(1, 'Ana Souza', 'ana.souza@example.com', '21987654322'),
(1, 'Miguel Oliveira', 'miguel.oliveira@example.com', '31987654323'),
(1, 'Beatriz Santos', 'beatriz.santos@example.com', '41987654324'),
(1, 'Lucas Almeida', 'lucas.almeida@example.com', '51987654325');


INSERT INTO servico VALUES 
  (DEFAULT, 1, 'Porta Lateral LD Motorista (Azul/Prata/Verniz)'),
  (DEFAULT, 1, 'Troca da Direção'),
  (DEFAULT, 2, 'Parachoque Dianteiro'),
  (DEFAULT, 2, 'Parachoque Dianteiro (Azul/Verniz)'),
  (DEFAULT, 3, 'Parachoque Traseiro (Vermelho/Preto/Verniz)'),
  (DEFAULT, 3, 'Parachoque Dianteiro (Vermelho/Preto/Verniz)'),
  (DEFAULT, 3, 'Porta Dianteiro LExLD (Vermelho/Preto/Verniz)'),
  (DEFAULT, 3, 'Troca da bomba de gasolina'),
  (DEFAULT, 1, 'Porta Lateral LD Passageiro (Azul/Prata/Verniz)');

INSERT INTO historico VALUES
  (DEFAULT, 1, 1, 300, 'Pintura'),
  (DEFAULT, 2, 1, 600, 'Mecanica'),
  (DEFAULT, 3, 2, 350, 'Funilaria'),
  (DEFAULT, 4, 2, 300, 'Pintura'),
  (DEFAULT, 5, 3, 300, 'Pintura'),
  (DEFAULT, 6, 3, 300, 'Pintura'),
  (DEFAULT, 7, 3, 750, 'Pintura'),
  (DEFAULT, 8, 3, 500, 'Mecanica'),
  (DEFAULT, 9, 1, 300, 'Pintura');

# Mostra o Veículo, Serviços, Data e Status do Orçameto e Total de Custo
SELECT CONCAT(v.marca, ' ',v.modelo, ' ', v.ano) as Veiculo,
  GROUP_CONCAT(s.descricao) as Serviço,
  CONCAT(o.dataLancamento, ' - ', o.Orcstatus) as Orçamento,
  SUM(his.valor) as Total
  FROM veiculo as v
  JOIN servico as s
  ON s.fkVeiculo = v.idVeiculo
  JOIN historico as his
  ON his.fkServico = s.idServico
  JOIN orcamento as o
  ON his.fkOrcamento = o.idOrcamento
  GROUP BY v.marca, v.modelo, v.ano, o.dataLancamento, o.OrcStatus;  

# Mostra o Status do Orçamento do Veículo, Serviços e o Custo Total
SELECT o.orcStatus as Status, 
  CONCAT(v.marca, ' ',v.modelo, ' ', v.ano) as veiculo,
  CONCAT('R$',(SUM(his.valor))) as total,
  GROUP_CONCAT(s.descricao) as serviços
  FROM veiculo as v
  JOIN orcamento as o
  ON o.fkVeiculo = v.idVeiculo
  JOIN historico as his 
  ON his.fkOrcamento = o.idOrcamento
  JOIN servico as s
  ON his.fkServico = s.idServico
  WHERE v.fkCliente = 4
  GROUP BY o.orcStatus, v.marca, v.modelo, v.ano

  SELECT c.nome as Cliente, o.orcStatus as Status, o.dataLancamento as Data, CONCAT(v.marca, ' ',v.modelo, ' ', v.ano) as veiculo,CONCAT('R$',(SUM(his.valor))) as total,GROUP_CONCAT(s.descricao) as serviços FROM veiculo as v JOIN orcamento as o ON o.fkVeiculo = v.idVeiculo JOIN historico as his ON his.fkOrcamento = o.idOrcamento JOIN servico as s ON his.fkServico = s.idServico JOIN cliente as c ON v.fkCliente = c.idCliente WHERE c.fkOficina = 1 GROUP BY c.nome, o.orcStatus, o.dataLancamento, v.marca, v.modelo, v.ano;

SELECT IFNULL(CONCAT('R$',SUM(his.valor)), 'Sem orçamentos/serviços concluidos') as TotalConcluido 
FROM historico as his 
JOIN orcamento as o 
ON his.fkOrcamento = o.idOrcamento 
WHERE o.OrcStatus = 'Pendente';

select COUNT(c.idCliente) as TotalC,
  COUNT(v.idVeiculo) as TotalV
  FROM cliente as c
  LEFT JOIN veiculo as v
  ON v.fkCliente = c.idCliente
  WHERE fkOficina = ${};

SELECT * FROM servico;

SELECT idOrcamento FROM orcamento WHERE fkVeiculo = 7 and dataLancamento = '1231-02-04';
# Comandos para o cadastro de orçamento
INSERT INTO orcamento(fkVeiculo, dataLancamento, status) VALUES (${fkVeiculo}, ${dtLanc}, 'Pendente'); 

SELECT idOrcamento from orcamento where fkOrcamento = ${fkVeiculo} and dataLancamento = ${dataOrcamento};

SELECT * FROM cliente as c LEFT JOIN veiculo as v  ON v.fkCliente = c.idCliente;

INSERT INTO servico(descricao) VALUES (${descricao}); 

SELECT idServico from servico;
INSERT INTO historico(fkOrcamento, fkServico, valor, tipo) VALUES (${Orcamento}, ${fkServico}, ${valor}, ${tipo}) 
-- }

select * from servico;
select * from historico;

-- Grafico de Barra
select his.tipo as servico, COUNT(his.tipo) as total, SUM(his.valor) as valor FROM historico as his JOIN orcamento as o ON his.fkOrcamento = o.idOrcamento JOIN veiculo as v  ON o.fkVeiculo = v.idVeiculo JOIN cliente as c ON v.fkCliente = c.idCliente WHERE c.fkOficina = 1 GROUP BY his.tipo ORDER BY his.tipo asc;

SELECT * FROM orcamento JOIN historico as his on his.fkOrcamento = orcamento.idOrcamento join servico as s on his.fkServico = s.idServico;

delete from orcamento;
-- Selecionar os ID's dos serviços
SELECT * from servico as s JOIN historico as his ON his.fkServico = s.idServico;
/* 
SERVICO 44, 59, 58 E 57
 */

-- Deletar do historico onde as fk é o Id do Orçamento
DELETE FROM historico WHERE fkOrcamento = 96;

-- Deletar aonde o ID é dos serviços selecionados com base no orçamento
DELETE FROM servico WHERE idServico = 38; 
DELETE FROM servico WHERE idServico = 39; 
DELETE FROM servico WHERE idServico = 17; 
DELETE FROM servico WHERE idServico = 18 

-- E por final, deletar o orçamento 
DELETE FROM orcamento WHERE idOrcamento = 96; 