-- Criação da tabela de Clientes
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    sobrenome VARCHAR(255) NOT NULL,
    sexo CHAR(1),
    endereco VARCHAR(255),
    data_nascimento DATE,
    telefone VARCHAR(20)
);

-- Criação da tabela Categorias
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL
);

-- Criação da tabela Itens
CREATE TABLE Item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    status ENUM('ativo', 'inativo') DEFAULT 'ativo',
    data_referencia DATE,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Criação da tabela Pedidos
CREATE TABLE Order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    data_order DATE NOT NULL,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Criação da tabela Order_Item (tabela de relacionamento entre Order e Item)
CREATE TABLE Order_Item (
    order_id INT,
    item_id INT,
    quantidade INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES Order(order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);
