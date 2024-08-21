## Challenge Engineer - SQL - Camila Kaori Ito
Data: 19/08/2024

### Criação de Tabelas

##### Arquivos:

- [create_tables.sql](create_tables.sql)

- [DER.dbml](DER.dbml)

##### Descrição de tabelas:

1. Customer

    Tabela que armazena informações dos usuários, com atributos como email,nome, sobrenome, sexo, endereço, data de nascimento e telefone.

1. Category

    Tabela que armazena as categorias dos itens, com atributos como descrição e path.

1. Item

    Tabela que armazena os produtos, com atributos como nome, descrição, preço, estado, data de baixa e uma chave estrangeira para a categoria.

1. Order

    Tabela que armazena as transações de compra, com atributos como data da ordem e uma chave estrangeira para o cliente.

1. Order_Item

    Tabela de relacionamento entre Order e Item, com atributos como quantidade e preço do item na ordem.

#### Relacionamentos

1. Um Customer pode fazer várias Orders.
1. Uma Order pode conter vários Items.
1. Um Item pertence a uma Category.

### Querys

arquivo:

[respostas_negocio](respostas_negocio.sql)

1. Listar os usuários que fazem aniversário hoje e cuja quantidade de vendas realizadas em janeiro de 2020 seja superior a 1500.

    Foi construída uma CTE(Common Table Expression) (VendasJaneiro2020) para calcular a quantidade de vendas realizadas em janeiro de 2020 por cada cliente. Em seguida, a consulta principal seleciona os clientes que fazem aniversário hoje e que realizaram mais de 1500 vendas em janeiro de 2020.

2. Para cada mês de 2020, solicita-se o top 5 de usuários que mais venderam ($) na categoria Celulares.

    Foi construída uma CTE (Vendas) para calcular as vendas mensais de 2020 na categoria que contém na descrição "Celular" ou "Smartphone" e classificar os clientes por valor total transacionado. A consulta principal seleciona os top 5 clientes para cada mês.

3. Preencher uma nova tabela com o preço e status dos Itens ao final do dia (Stored Procedure).

    Foi criada uma nova tabela para armazenar o histórico dos itens.
    Foi criada uma Stored Procedure (AtualizarItemHistory) que insere o estado atual dos itens na tabela de histórico.

