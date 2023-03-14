/*base de dados de uma empresa fict�cia com aplica��o de chaves prim�rias, estrangeiras e compostas, al�m de v�rias opera��es C.R.U.D (adaptado de https://www.youtube.com/watch?v=HXV3zeQKqGY) | database of a fictitious company with application of primary, foreign and composite keys, in addition to several C.R.U.D operations (adapted from https://www.youtube.com/watch?v=HXV3zeQKqGY)*/

/*cria��o da base de dados | creating the database*/

CREATE DATABASE mycompany;


/*cria��o e inser��o dos dados nas tabelas | creating and inserting the data into the tables*/
	

-- tabela de funcion�rios | employees table--

CREATE TABLE funcionarios (
idfunc INT IDENTITY (1,1) PRIMARY KEY,
nome VARCHAR (25),
sobrenome VARCHAR (25),
datadenascimento DATE,
sexo VARCHAR (1),
salario REAL,
idsup INT,
iddependencia INT);
	
	-- altera��o do nome da coluna 'iddependencia' na tabela funcionarios | renaming the 'iddependencia' column in employees table --
	EXEC sp_RENAME 'funcionarios.iddependencia', 'iddep', 'COLUMN'; 

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('Jo�o',	'Paulo',	'1987/12/11', 'M', 26000);

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('Manuel', 'Anast�cio', '1998/02/21', 'M', 176000),
('Joana', 'Tom�s', '1993/08/03', 'F', 123000),
('Maria', 'Kindambo', '1987/06/14', 'F', 119000),
('Marcolino', 'Filipe', '1967/09/15', 'M', 101000),
('Jos�', 'Sapassa', '1991/01/06', 'M', 136900),
('Kituxi', 'Manuel', '1983/01/01', 'F',	146200),
('Marcelina', 'Mendes', '1990/03/29', 'F', 155500),
('Abigail', 'Trovoada', '2004/03/03', 'F', 417590),
('Kituxi', 'Manuel', '1981/06/14', 'M', 174100);

INSERT INTO funcionarios (nome, sobrenome, datadenascimento, sexo, salario)
VALUES ('Louren�o',	'Camundai',	'1975/05/05', 'M', 183400),
('Nahari', 'Freitas', '1973/10/16',	'F', 192700),
('Lu�s', 'Brito', '1998/12/19', 'M', 202000),
('Almir', 'Proen�a', '1964/03/25', 'M',	211300),
('Nina', 'Abreu', '2003/03/03', 'F', 220600),
('Joelson',	'Filipe', '1999/07/14', 'M', 229900),
('Aline', 'Bunga', '1977/09/18', 'F', 239200),
('Raquel', 'Massoxi', '1986/08/17', 'F', 152960),
('Rui',	'Pemba', '1958/02/23', 'M',	383400),
('Of�lia', 'Muaca', '2005/04/29', 'F',195000);


		-- substitui��o de nomes duplicados| replacing duplicate names --
		UPDATE funcionarios
		SET nome = 'Am�lia' WHERE idfunc = 7;
		UPDATE funcionarios
		SET sobrenome = 'Saramago' WHERE idfunc = 7;

		-- declarando o 'idsup' como FOREIGN KEY na tabela de funcion�rios | declaring 'idsup' as FOREIGN KEY in employees table--
		ALTER TABLE funcionarios
		ADD FOREIGN KEY (idsup) REFERENCES funcionarios (idfunc);

		-- atualiza��o do atributo 'idsup' na tabela funcionarios | updating 'idsup' in the employees table --
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

		-- altera��o do nome da tabela de depend�ncia | renaming the branches table--
		EXEC sp_RENAME 'dependencia', 'dependencias';
				
		-- declarando o 'iddep' como FOREIGN KEY na tabela de funcion�rios | declaring 'idsup' as FOREIGN KEY in employees table--
		ALTER TABLE funcionarios ADD FOREIGN KEY (iddep)
		REFERENCES dependencias (iddep) ON DELETE SET NULL;

INSERT INTO dependencias (dependencia, idgestor, datainiciogestor)
VALUES ('Luanda', 9, '1998-02-11'),
('Huambo', 16, '2000-02-21'),
('Benguela', 17, '1999-11-13'),
('Sumbe', 19, '2007-06-21');

		-- atualiza��o da Foreign Key 'iddep' na tabela funcionarios | updating the Foreign Key 'iddep' in the employees table --	
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

		-- corre��o do nome da tabela de clientes de 'cliente' para 'clientes' | renaming the customers table from 'cliente' to 'clientes'--
		EXEC sp_RENAME 'cliente', 'clientes';

INSERT INTO clientes (cliente, iddep)
VALUES ('TrasCorp LDA',	100), ('AngoTI SA',	102),
('ZIcon SA', 101), ('Orizeu e Filhos LDA',	103),
('Cassandra LDA', 103), ('Boom LDA', 101),
('Cl�usia Sabores SA',	103);


-- tabela de relacionamentos entre funcion�rios e clientes | 'work with' relationship table between employees and customers --

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
(102, 'NCR', 'Pap�is'), (101, 'WORTEN', 'Router'), 
(100, 'BaobaBay', 'Telem�veis'), (100,	'WORTEN', 'Routers'),
(100, 'SISTEC', 'Teclados'), (101,	'NCR',	'Computadores'), 
(100, 'NCR', 'Teclados');



/* algumas opera��es entre tabelas | some C.R.U.D operations between the tables*/



-- que funcion�rio � gestor da depend�ncia de Luanda, qual a sua idade e o seu sal�rio, a quanto tempo trabalha como gestor, bem como os seus fornecedores, suprimentos e clientes | which employee is the manager of Luanda branch, how old is he/she and how much he/she earns; for how long does he/she work as manager and who are his/her suppliers, supply type and customers --

SELECT CONCAT (nome, ' ',sobrenome) AS 'Funcion�rio/a', DATEDIFF (year, datadenascimento, GETDATE()) AS 'Idade', Salario, datainiciogestor FROM funcionarios
RIGHT JOIN dependencias on funcionarios.idfunc=dependencias.idgestor WHERE dependencia='Luanda';
																OR
SELECT CONCAT (nome, ' ',sobrenome) AS 'Funcion�rio/a', DATEDIFF (year, datadenascimento, GETDATE()) AS 'Idade', Salario FROM funcionarios WHERE idfunc IN
	(SELECT idgestor FROM dependencias WHERE dependencia='Luanda');

SELECT DATEDIFF (year, datainiciogestor, GETDATE()) AS 'Anos como Gestor' FROM dependencias  WHERE dependencia ='Luanda';

SELECT fornecedor 'Fornecedores da Depend�ncia de Luanda', suprimento FROM fornecedores WHERE iddep IN 
	(SELECT iddep FROM dependencias WHERE dependencia = 'Luanda');

SELECT cliente 'Clientes da Depend�ncia de Luanda' FROM clientes WHERE iddep IN 
	(SELECT iddep FROM dependencias WHERE dependencia = 'Luanda');

-- que funcion�rios s�o gestores de depend�ncias | which employees are branch managers --

SELECT CONCAT (nome, ' ',sobrenome) AS 'Funcion�rio/a Gestor', dependencia FROM funcionarios
RIGHT JOIN dependencias on funcionarios.idfunc=dependencias.idgestor;

-- qual � o total de vendas, que cliente � o maior respons�vel por essas somas e com quanto ele contribui | find the total sales and the customer responsible for the highest income and how much is it--

SELECT SUM(vendas) 'Total de Vendas' FROM relacaoclientefuncionario;

SELECT cliente, vendas [Maior Venda] FROM clientes INNER JOIN relacaoclientefuncionario
ON clientes.idcliente=relacaoclientefuncionario.idcliente WHERE vendas IN 
	(SELECT MAX(vendas) FROM relacaoclientefuncionario);

-- qual � a depend�ncia com vendas mais baixas, e o seu valor? | which is the branch with the lowest sales and its income--
SELECT dependencia [Depend�ncia com Menor Venda], vendas FROM relacaoclientefuncionario LEFT JOIN dependencias
ON relacaoclientefuncionario.idfunc=dependencias.idgestor WHERE vendas IN
	(SELECT MIN (vendas) FROM relacaoclientefuncionario);

-- qual � a depend�ncia com vendas mais altas, e o seu valor? | which is the branch with the highest sales and its income --

SELECT dependencia [Depend�ncia com Mais Vendas], vendas FROM funcionarios INNER JOIN relacaoclientefuncionario
ON funcionarios.idfunc=relacaoclientefuncionario.idfunc 
	INNER JOIN dependencias ON funcionarios.iddep=dependencias.iddep WHERE vendas IN 
		(SELECT MAX (vendas) FROM relacaoclientefuncionario);

-- o nome em mai�sculas, a depend�ncia, o sal�rio e a idade do gestor da depend�ncia que tem a NCR como fornecedora | find the name in uppeer case, the brach, salary and how old is/are the manager(s) of the branch which have NCR as supplier--

SELECT UPPER (CONCAT (nome, ' ', sobrenome)) [Gestor NCR Supply], dependencia, salario, DATEDIFF (year, datadenascimento, GETDATE()) [Idade] FROM funcionarios INNER JOIN 
dependencias ON funcionarios.idfunc=dependencias.idgestor WHERE dependencias.iddep IN 
	(SELECT fornecedores.iddep FROM fornecedores WHERE fornecedor='NCR') ORDER BY salario DESC;

-- quantas funcion�rias tem sal�rios superiores a m�dia dos homens | how many female employees have higher salaries than the average of male employees? --

SELECT COUNT (salario) [Trabalhadoras com Sal�rio Acima da M�dia dos Homens] FROM funcionarios WHERE sexo = 'F' AND salario > (SELECT AVG(salario) FROM funcionarios	WHERE sexo = 'M'); 

-- quantas funcion�rias tem sal�rios superiores ao sal�rio mais baixo dos homens | how many female employees have higher salaries than the lower of a male employee? --

SELECT COUNT (salario) [Trabalhadoras com Sal�rio Acima do Sal�rio Mais Baixo Auferido por Homens] FROM funcionarios WHERE sexo = 'F' AND salario > (SELECT MIN(salario) FROM funcionarios	WHERE sexo = 'M'); 

-- quantas funcion�rias tem sal�rios superiores ao sal�rio mais alto dos homens | how many female employees have higher salaries than the higher of a male employee? --

SELECT COUNT (salario) [Trabalhadoras com Sal�rio Acima da M�dia dos Homens] FROM funcionarios WHERE sexo = 'F' AND salario > (SELECT MAX(salario) FROM funcionarios	WHERE sexo = 'M'); 

-- quantas funcion�rias tem sal�rios inferiores ao sal�rio mais alto dos homens | how many female employees have lower salaries than the higher of a male employee? --

SELECT COUNT (salario) [Trabalhadoras com Sal�rio Abaixo do M�ximo dos Homens] FROM funcionarios 
WHERE sexo = 'F' AND salario < (SELECT MAX(salario) FROM funcionarios	WHERE sexo = 'M'); 


-- Quantos homens tem menos de 26 anos | how many male employees are under 26 --

SELECT nome, COUNT (DATEDIFF(year,datadenascimento, CURRENT_TIMESTAMP)) [Quantidades de Homens com Menos de 26 Anos] FROM funcionarios 
WHERE sexo = 'M'
AND DATEDIFF(year,datadenascimento, CURRENT_TIMESTAMP)<26 GROUP BY nome;

-- que clientes geram vendas acima de 1M, quanto �, e quantas participa��es tem nesse valor? which customers generate sales above 1 Million, how much and how many shares do you have in that amount? --

SELECT cliente, COUNT(cliente) [Participa��es em Vendas >1M], SUM(vendas) [Total de Vendas] FROM clientes LEFT JOIN relacaoclientefuncionario
ON clientes.idcliente=relacaoclientefuncionario.idcliente GROUP BY cliente HAVING SUM(vendas)>1000000
ORDER BY [Total de Vendas] DESC;

-- que clientes geram vendas entre 1M e 30M, quanto �, e quantas participa��es tem nesse valor? which customers generate sales between 1 Million and 30 Million, how much and how many shares do you have in that amount? --

SELECT cliente, COUNT(cliente) [Participa��es em Vendas >1M], SUM(vendas) [Total de Vendas] FROM clientes LEFT JOIN relacaoclientefuncionario
ON clientes.idcliente=relacaoclientefuncionario.idcliente GROUP BY cliente HAVING SUM(vendas) BETWEEN 1000000 AND  3000000
ORDER BY [Total de Vendas] DESC;

-- quantas supervisoras tem mais de dois imediatos | how many female supervise more than two employees? --
	
SELECT COUNT(idsup) [Supervisoras com Mais de Dois Imediatos] FROM funcionarios WHERE sexo='F' AND idfunc IN
	(SELECT COUNT(idsup) FROM funcionarios GROUP BY idsup HAVING COUNT(idsup)>2);

-- quantos supervisores tem mais de um imediato, seus nomes, IDs, e Idades daqui a 30 anos | how many male supervise more than one employee, their names, IDS and how old they will be in thirty years? --
SELECT idsup [ID], nome [Supervisor], idfunc [N�mero de Imediatos], (DATEDIFF (year, datadenascimento, GETDATE())+30) [Idade Daqui a 30 anos] FROM funcionarios
WHERE sexo='M' AND idfunc IN
	(SELECT COUNT(idsup) FROM funcionarios GROUP BY idsup HAVING COUNT(idsup)>1);

-- que ano ser� quando o/a gestor/a da dependencia do Huambo tiver 70 anos? what year will it be when the manager of Huambo's branch turns 70?--

SELECT DATEPART (year, DATEADD (year, 70, datadenascimento)) [Ano Quando Gestor da Dependencia de Huambo Tiver 70 Anos] FROM funcionarios
WHERE idfunc IN 
	(SELECT idgestor FROM dependencias WHERE dependencia='Huambo');

-- que ano foi h� 30 anos atr�s, e quais funcion�rios j� eram nascidos? what year was thirty years ago and which employees were already born? --

SELECT DATEPART (year, DATEADD (year, -30, GETDATE())) [H� 30 Anos Foi:], CONCAT (nome, ' ', sobrenome) [J� Nascidos na Epoca], datadenascimento FROM funcionarios
WHERE datadenascimento< DATEADD (year, -30, GETDATE()); 


-- que funcion�rios tem o nome com A e O como iniciais? which employees have their name starting with 'A' and ending with 'O'? --
SELECT CONCAT (nome, ' ', sobrenome) [Nome Completo] FROM funcionarios WHERE nome LIKE 'A%' AND sobrenome LIKE '%O'

-- encontrar a rela��o de funcionarios que sejam homens e as que sejam mulheres com sal�rio acima de 150000 | find the list of male employees ande female employes with salaries above 150000 --
SELECT CONCAT (nome, ' ', sobrenome), datadenascimento, salario FROM funcionarios WHERE sexo='M'
UNION
SELECT CONCAT (nome, ' ', sobrenome), datadenascimento, salario FROM funcionarios WHERE sexo='F' AND salario>150000;

-- encontrar os IDs e os nomes dos funcion�rios se houver algum idgestor nas depenencias que n�o sejam Luanda, Huambo, Sumbe ou Benguela | find the IDs and names if there is any 'idgestor' not managing the Luanda, Huambo, Sume or Benguela branch --
SELECT idfunc, nome FROM funcionarios WHERE EXISTS
	(SELECT idgestor FROM dependencias WHERE dependencia NOT IN ('Luanda', 'Huambo', 'Sumbe', 'Benguela'));

-- divida os trabalhadores em categorias de sal�rio | divide the employees list according to their salaries --

SELECT CONCAT (nome, ' ', sobrenome) [Funcion�rio/a], salario,
	CASE WHEN salario<100000 THEN 'Funcion�rio N�o Qualificado'
	WHEN salario BETWEEN 101000 AND 150000 THEN 'T�cnico'
	WHEN salario BETWEEN 151000 AND 200000 THEN 'Superintendente'
	ELSE 'Chefe de Sec��o'
	END AS [Categoria]
FROM funcionarios ORDER BY salario ASC;

-- fazer a contagem descendente de linhas tendo o sal�rio como crit�rio para quando o funcion�rio for mulher e o seu nome n�o tiver A no final | list the results in descending order according to their salary for when the employee is a woman and her name does not end with an A--
SELECT ROW_NUMBER () OVER (ORDER BY salario DESC) [Linhas], salario, nome FROM funcionarios
WHERE sexo='F' AND nome NOT LIKE '%a';

-- ranquear em ordem ascendente os nomes tendo o 'idsup' como crit�rio para quando o funcion�rio for mulher |rank the results in ascending order according to their 'idsup' for when the employee is a woman--
SELECT RANK () OVER (ORDER BY idsup ASC) [Linhas], idsup, nome FROM funcionarios
WHERE sexo='F';

