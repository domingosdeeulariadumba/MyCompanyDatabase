/*base de dados de uma empresa fictícia com aplicação de chaves primárias, estrangeiras e compostas, além de várias operações C.R.U.D (adaptado de https://www.youtube.com/watch?v=HXV3zeQKqGY) | database of a fictitious company with application of primary, foreign and composite keys, in addition to several C.R.U.D operations (adapted from https://www.youtube.com/watch?v=HXV3zeQKqGY)*/

/*criação da base de dados | creating the database*/

CREATE DATABASE mycompany;


/*criação e inserção dos dados nas tabelas | creating and inserting the data into the tables*/
	

-- tabela de funcionários | employees table--

CREATE TABLE funcionarios (
idfunc INT IDENTITY (1,1) PRIMARY KEY,
nome VARCHAR (25),
sobrenome VARCHAR (25),
datadenascimento DATE,
sexo VARCHAR (1),
salario REAL,
idsup INT,
iddependencia INT);
	
	-- alteração do nome da coluna 'iddependencia' na tabela funcionarios | renaming the 'iddependencia' column in employees table --
	EXEC sp_RENAME 'funcionarios.iddependencia', 'iddep', 'COLUMN'; 

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('João',	'Paulo',	'1987/12/11', 'M', 26000);

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('Manuel', 'Anastácio', '1998/02/21', 'M', 176000),
('Joana', 'Tomás', '1993/08/03', 'F', 123000),
('Maria', 'Kindambo', '1987/06/14', 'F', 119000),
('Marcolino', 'Filipe', '1967/09/15', 'M', 101000),
('José', 'Sapassa', '1991/01/06', 'M', 136900),
('Kituxi', 'Manuel', '1983/01/01', 'F',	146200),
('Marcelina', 'Mendes', '1990/03/29', 'F', 155500),
('Abigail', 'Trovoada', '2004/03/03', 'F', 417590),
('Kituxi', 'Manuel', '1981/06/14', 'M', 174100);

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('Lourenço',	'Camundai',	'1975/05/05', 'M', 183400),
('Nahari', 'Freitas', '1973/10/16',	'F', 192700),
('Luís', 'Brito', '1998/12/19', 'M', 202000),
('Almir', 'Proença', '1964/03/25', 'M',	211300),
('Nina', 'Abreu', '2003/03/03', 'F', 220600),
('Joelson',	'Filipe', '1999/07/14', 'M', 229900),
('Aline', 'Bunga', '1977/09/18', 'F', 239200),
('Raquel', 'Massoxi', '1986/08/17', 'F', 152960),
('Rui',	'Pemba', '1958/02/23', 'M',	383400),
('Ofília', 'Muaca', '2005/04/29', 'F',195000);

		-- atualização do atributo 'idsup' na tabela funcionarios | updating 'idsup' in the employees table --
		UPDATE funcionarios
		SET idsup = 9 WHERE idfunc IN (1, 7, 8, 15, 16, 17, 18, 19);
		UPDATE funcionarios
		SET idsup = 1 WHERE idfunc = 20;
		UPDATE funcionarios
		SET idsup = 16 WHERE idfunc IN (2, 3, 4, 6);
		UPDATE funcionarios
		SET idsup = 17 WHERE idfunc IN (10, 11, 12, 14);
		UPDATE funcionarios
		SET idsup = 19 WHERE idfunc IN (5, 13);

		
-- tabela de dependencias | branches table--

CREATE TABLE dependencia (
iddep INT IDENTITY (100,1) PRIMARY KEY,
dependencia VARCHAR (30),
idgestor INT,
datainiciogestor DATE,
FOREIGN KEY (idgestor) REFERENCES funcionarios (idfunc) ON DELETE SET NULL);

		-- alteração do nome da tabela de dependência | renaming the branches table--
		EXEC sp_RENAME 'dependencia', 'dependencias';

		-- declarando o 'idsup' como FOREIGN KEY na tabela de funcionários | declaring 'idsup' as FOREIGN KEY in employees table--
		ALTER TABLE funcionarios
		ADD FOREIGN KEY (idsup) REFERENCES funcionarios (idfunc);

		-- declarando o 'iddep' como FOREIGN KEY na tabela de funcionários | declaring 'idsup' as FOREIGN KEY in employees table--
		ALTER TABLE funcionarios ADD FOREIGN KEY (iddep)
		REFERENCES dependencias (iddep) ON DELETE SET NULL;

INSERT INTO dependencias (dependencia, idgestor, datainiciogestor)
VALUES ('Luanda', 9, '1998-02-11'),
('Huambo', 16, '2000-02-21'),
('Benguela', 17, '1999-11-13'),
('Sumbe', 19, '2007-06-21');

		-- atualização da Foreign Key 'iddep' na tabela funcionarios | updating the Foreign Key 'iddep' in the employees table --	
		UPDATE funcionarios
		SET iddep = 100 WHERE idsup IN (9, 1);
		UPDATE funcionarios
		SET iddep = 100 WHERE idfunc = 9;
		UPDATE funcionarios
		SET iddep = 101 WHERE idsup = 16;
		UPDATE funcionarios
		SET iddep = 102 WHERE idsup = 17;
		UPDATE funcionarios
		SET iddep = 103 WHERE idsup = 19;


-- tabela de clientes | customers table--

CREATE TABLE cliente (
idcliente INT IDENTITY (200,1) PRIMARY KEY,
cliente VARCHAR (35),
iddep INT,
FOREIGN KEY (iddep) REFERENCES dependencias (iddep) ON DELETE SET NULL);

		-- correção do nome da tabela de clientes de 'cliente' para 'clientes' | renaming the customers table from 'cliente' to 'clientes'--
		EXEC sp_RENAME 'cliente', 'clientes';

INSERT INTO clientes (cliente, iddep)
VALUES ('TrasCorp LDA',	100), ('AngoTI SA',	102),
('ZIcon SA', 101), ('Orizeu e Filhos LDA',	103),
('Cassandra LDA', 103), ('Boom LDA', 101),
('Cléusia Sabores SA',	103);


-- tabela de relacionamentos entre funcionários e clientes | 'work with' relationship table between employees and customers --

CREATE TABLE relacaoclientefuncionario (
idfunc INT,
idcliente INT,
vendas REAL,
PRIMARY KEY (idfunc, idcliente),
FOREIGN KEY (idfunc) REFERENCES funcionarios (idfunc) ON DELETE CASCADE,
FOREIGN KEY (idcliente) REFERENCES clientes (idcliente) ON DELETE CASCADE);

INSERT INTO relacaoclientefuncionario (idfunc, idcliente, vendas)
VALUES (3, 200, 1965000), (7, 201, 303005), (19, 202, 4536800),
(13, 203, 4840068), (9,	206, 25968), (7, 204, 7411868),
(1,	206, 697768), (8, 205, 9983668), (8,	201, 1269568);


-- tabela de fornecedores | suppliers table--

CREATE TABLE fornecedores (
iddep INT,
fornecedor VARCHAR (30),
suprimento VARCHAR (35),
FOREIGN KEY (iddep) REFERENCES dependencias (iddep) ON DELETE CASCADE);

INSERT INTO fornecedores (iddep, fornecedor, suprimento)
VALUES (100, 'NCR',	'Computadores'), (103, 'SISTEC', 'CPUs'),
(102, 'NCR', 'Papéis'), (101, 'WORTEN', 'Router'), 
(100, 'BaobaBay', 'Telemóveis'), (100,	'WORTEN', 'Routers'),
(100, 'SISTEC', 'Teclados'), (101,	'NCR',	'Computadores'), 
(100, 'NCR', 'Teclados');



/* algumas operações entre tabelas | some C.R.U.D operations between the tables*/
