-- criacao to banco de dados em sí
CREATE DATABASE supermercado;

-- criação da tabela customer
CREATE TABLE customer (
	cpf int NOT NULL,
	name varchar(255),
	date_of_birth date,
	salary_range varchar(255),
	phone varchar(255),
	PRIMARY KEY (cpf)
);

-- criação da tabela category
CREATE TABLE category (
	id int NOT NULL,
	parent_id int,
	name varchar(255),
	PRIMARY KEY (id),
	FOREIGN KEY (parent_id) REFERENCES category(id)
);

-- criação da tabela product
CREATE TABLE product (
	id int NOT NULL,
	category int NOT NULL,
	name varchar(255),
	brand varchar(255),
	price float,
	PRIMARY KEY (id),
	FOREIGN KEY (category) REFERENCES category(id)
);

-- criação da tabela purchase
CREATE TABLE purchase (
	cpf int NOT NULL,
	id int NOT NULL,
	date date NOT NULL,
	quantity int NOT NULL, -- não existe uma compra de 0 unidades...
	PRIMARY KEY (cpf, id, date),
	FOREIGN KEY (cpf) REFERENCES customer(cpf),
	FOREIGN KEY (id) REFERENCES product(id)
);

-- criação da tabela recommendation
CREATE TABLE recommendation (
	cpf int NOT NULL,
	id int NOT NULL,
	date date NOT NULL,
	quantity int NOT NULL, -- não existe uma recomendação de 0 unidades...
	PRIMARY KEY (cpf, id, date),
	FOREIGN KEY (cpf) REFERENCES customer(cpf),
	FOREIGN KEY (id) REFERENCES product(id)
);
