--  1. Listar os usuários que fazem aniversário hoje e cuja quantidade de vendas realizadas em janeiro de 2020 seja superior a 1500.

--  Utiliza uma CTE (VendasJaneiro2020) para calcular a quantidade de vendas 
-- realizadas em janeiro de 2020 por cada cliente. Em seguida, a consulta principal 
-- seleciona os clientes que fazem aniversário hoje e que realizaram mais de 1500 vendas em janeiro de 2020.
WITH VendasJaneiro2020 AS (
    SELECT 
        O.customer_id,
        COUNT(O.order_id) AS quantidade_vendas
    FROM Order O
    JOIN order_item OI ON O.order_id = OI.order_id
    WHERE 
        O.data_order BETWEEN '2020-01-01' AND '2020-01-31'
    GROUP BY O.customer_id
    HAVING COUNT(O.order_id) > 1500
)
SELECT 
    C.nome, 
    C.sobrenome, 
    C.email
FROM Customer C
JOIN VendasJaneiro2020 VJ ON C.customer_id = VJ.customer_id
WHERE 
    MONTH(C.data_nascimento) = MONTH(CURDATE()) 
    AND DAY(C.data_nascimento) = DAY(CURDATE());

-- 2. Para cada mês de 2020, solicita-se o top 5 de usuários que mais venderam ($) na categoria Celulares.

-- Utiliza uma CTE (Vendas) para calcular as vendas mensais de 2020 na categoria "Celulares" 
-- e classificar os clientes por valor total transacionado. A consulta principal seleciona os top 5 clientes para cada mês.
WITH Vendas AS (
    SELECT 
        DATE_FORMAT(O.data_order, '%Y-%m') AS mes_ano,
        C.customer_id,
        C.nome, 
        C.sobrenome, 
        COUNT(O.order_id) AS quantidade_vendas,
        SUM(OI.quantidade) AS quantidade_produtos_vendidos,
        SUM(OI.preco * OI.quantidade) AS valor_total_transacionado,
        ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(O.data_order, '%Y-%m') ORDER BY SUM(OI.preco * OI.quantidade) DESC) AS rank
    FROM Order O
    JOIN Customer C ON O.customer_id = C.customer_id
    JOIN order_item OI ON O.order_id = OI.order_id
    JOIN Item I ON OI.item_id = I.item_id
    JOIN Category CA ON I.category_id = CA.category_id
    WHERE 
        YEAR(O.data_order) = 2020 
        AND (CA.descricao LIKE '%Celular%' OR CA.descricao LIKE '%Smartphone%')
    GROUP BY mes_ano, C.customer_id
)
SELECT 
    mes_ano, 
    nome, 
    sobrenome, 
    quantidade_vendas, 
    quantidade_produtos_vendidos, 
    valor_total_transacionado
FROM Vendas
WHERE 
    rank <= 5;

--3. Preencher uma nova tabela com o preço e status dos Itens ao final do dia (Stored Procedure).


-- Nova tabela para armazenar o histórico dos itens
CREATE TABLE ItemHistory (
    item_id INT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    preco DECIMAL(10, 2),
    status ENUM('ativo', 'inativo'),

    PRIMARY KEY (item_id, data_registro)
);
-- Agendar a stored procedure para executar diariamente
-- Selecionar o status atual dos itens e inserir esses dados na tabela de histórico (ItemHistory).
CREATE PROCEDURE UpdateItemHistory()
BEGIN
    -- Insere o status atual dos itens na tabela de histórico

    INSERT INTO ItemHistory (item_id, preco, status)
        SELECT 
            item_id, 
            preco, 
            status
        FROM 
            Item
END //
