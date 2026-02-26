DROP DATABASE ecommerce_desafio;
CREATE DATABASE ecommerce_desafio;
USE ecommerce_desafio;

-- 1. Cliente (Centralizado PF/PJ)
CREATE TABLE clients(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3),
    Lname VARCHAR(20),
    Address VARCHAR(100),
    type_client ENUM('PF', 'PJ') NOT NULL,
    CPF CHAR(11),
    CNPJ CHAR(14),
    CONSTRAINT unique_cpf_client UNIQUE(CPF),
    CONSTRAINT unique_cnpj_client UNIQUE(CNPJ)
);

-- 2. Produto
CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    classification_kids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10) -- Dimensões
);

-- 3. Pedido
CREATE TABLE orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    ordersStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

-- 4. Pagamentos (Permite múltiplos pagamentos por pedido)
CREATE TABLE payments(
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    typePayment ENUM('Boleto','Cartão','Pix'),
    paymentValue FLOAT,
    CONSTRAINT fk_payment_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- 5. Entrega (Status e Rastreio)
CREATE TABLE delivery(
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    deliveryStatus ENUM('Processando', 'Postado', 'Em trânsito', 'Entregue') DEFAULT 'Processando',
    trackingCode VARCHAR(45) NOT NULL,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- 6. Estoque e Fornecedores
CREATE TABLE productStorage(
    idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

CREATE TABLE supplier(
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL UNIQUE,
    contact CHAR(11) NOT NULL
);

CREATE TABLE seller(
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(45),
    CNPJ CHAR(15) UNIQUE,
    CPF CHAR(11) UNIQUE,
    location VARCHAR(255),
    contact CHAR(11) NOT NULL
);

create table productSeller(
    idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct), -- Chave primária composta
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product_seller foreign key (idPproduct) references product(idProduct)
);

CREATE TABLE productOrder(
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível','Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

CREATE TABLE productSupplier(
    idPsSupplier INT,
    idPsProduct INT,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

CREATE TABLE storageLocation(
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    FOREIGN KEY (idLstorage) REFERENCES productStorage(idProductStorage)
);

-- Inserindo Clientes (PF e PJ)
INSERT INTO clients (Fname, Minit, Lname, Address, type_client, CPF, CNPJ) VALUES
('Ricardo', 'A', 'Silva', 'Rua Laranjeiras 29, RJ', 'PF', '12345678901', NULL),
('Julia', 'S', 'Paiva', 'Rua Alameda 40, SP', 'PF', '98765432109', NULL),
('TechStore', 'M', 'LTDA', 'Av Paulista 1500, SP', 'PJ', NULL, '12345678000199'),
('Roberto', 'G', 'Mendes', 'Rua das Flores 10, MG', 'PF', '45678912300', NULL),
('OfficeDesign', 'S', 'SA', 'Av Central 10, SC', 'PJ', NULL, '99887766000122');

-- Inserindo Produtos
INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('Fone Bluetooth', false, 'Eletrônico', 4.5, NULL),
('Carrinho HotWheels', true, 'Brinquedos', 5, NULL),
('Camiseta Algodão', false, 'Vestimenta', 3.8, 'G'),
('Microondas 20L', false, 'Eletrônico', 4.0, NULL),
('Cadeira Gamer', false, 'Móveis', 4.9, NULL);

-- Inserindo Pedidos
INSERT INTO orders (idOrderClient, ordersStatus, orderDescription, sendValue) VALUES
(1, 'Confirmado', 'Compra site', 10),
(2, 'Confirmado', 'Compra app', 20),
(3, 'Em processamento', 'Pedido corporativo', 0),
(4, 'Confirmado', 'Compra site', 15),
(1, 'Confirmado', 'Segunda compra', 10);

-- Inserindo Itens do Pedido
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity) VALUES
(1, 1, 1), (5, 1, 1), -- Ricardo comprou Fone e Cadeira
(2, 2, 3),            -- Julia comprou 3 Carrinhos
(4, 3, 10),           -- TechStore comprou 10 Microondas
(3, 4, 2),            -- Roberto comprou 2 Camisetas
(1, 5, 1);            -- Ricardo comprou outro Fone

-- Inserindo Pagamentos (Exemplo de pagamento dividido no pedido 1)
INSERT INTO payments (idOrder, typePayment, paymentValue) VALUES
(1, 'Cartão', 200.00),
(1, 'Pix', 50.00),      -- Pedido 1 teve dois pagamentos
(2, 'Cartão', 120.00),
(3, 'Boleto', 4500.00),
(4, 'Pix', 80.00),
(5, 'Cartão', 150.00);

-- Inserindo Entregas
INSERT INTO delivery (idOrder, deliveryStatus, trackingCode) VALUES
(1, 'Entregue', 'ABC12345'),
(2, 'Em trânsito', 'XYZ98765'),
(3, 'Processando', 'DOC00011'),
(4, 'Postado', 'BRA55443'),
(5, 'Processando', 'ABC12346');

-- Inserindo Fornecedores e Estoque
INSERT INTO supplier (SocialName, CNPJ, contact) VALUES 
('Eletrônicos Brasil', '11222333000100', '119998877'),
('Brinquedos S.A', '44555666000111', '118887766');

INSERT INTO productStorage (storageLocation, quantity) VALUES 
('Depósito Central - SP', 1000),
('Filial - RJ', 500);

-- Vinculando produtos aos locais de estoque
-- idLproduct (Produto), idLstorage (Depósito), localização específica
INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
(1, 1, 'Prateleira A1'), -- Fone Bluetooth no Depósito Central
(2, 1, 'Corredor Infantil'), -- Carrinho no Depósito Central
(3, 2, 'Setor Vestuário'), -- Camiseta na Filial RJ
(4, 1, 'Eletro pesados'), -- Microondas no Depósito Central
(5, 2, 'Setor Móveis'); -- Cadeira Gamer na Filial RJ

-- Quantos pedidos cada cliente fez?
SELECT 
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    c.type_client AS Tipo,
    COUNT(o.idOrder) AS Total_Pedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
ORDER BY Total_Pedidos DESC;

-- Relação de Produtos, Estoque e Localização
SELECT 
    p.Pname AS Produto,
    p.category AS Categoria,
    ps.quantity AS Quantidade_Disponivel,
    ps.storageLocation AS Local
FROM product p
INNER JOIN storageLocation sl ON p.idProduct = sl.idLproduct
INNER JOIN productStorage ps ON sl.idLstorage = ps.idProductStorage;

-- Clientes que gastaram mais de 200 reais
SELECT 
    c.Fname AS Cliente,
    SUM(pay.paymentValue) AS Total_Gasto
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
JOIN payments pay ON o.idOrder = pay.idOrder
GROUP BY c.idClient
HAVING Total_Gasto > 200
ORDER BY Total_Gasto DESC;

-- Status de Entrega detalhado por Cliente
SELECT 
    c.Fname AS Cliente,
    o.idOrder AS Numero_Pedido,
    d.deliveryStatus AS Status_Entrega,
    d.trackingCode AS Rastreio
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
JOIN delivery d ON o.idOrder = d.idOrder
WHERE d.deliveryStatus <> 'Entregue';