# 🛒 E-commerce Database - Desafio DIO

Repositório dedicado à entrega do desafio **"Construindo seu Primeiro Projeto Lógico de Banco de Dados"** da plataforma DIO. O projeto consiste em modelar e implementar um sistema de E-commerce robusto, focando em integridade de dados e processos logísticos.

---

## 📂 Estrutura do Repositório

O projeto está dividido entre os arquivos originais do curso e o refinamento proposto para o desafio:

| Arquivo | Descrição |
| --- | --- |
| 📄 `DESAFIO_EER_Diagram.pdf` | **Diagrama EER** final com os refinamentos aplicados. |
| 📜 `DIO_DESAFIO.sql` | Script completo: Esquema relacional, inserção de dados e queries de teste. |
| 📄 `DIO_EER_Diagram.pdf` | Diagrama base replicado durante as aulas. |
| 📜 `DIO_esquema_relacional_sql.sql` | Script de criação do banco de dados base. |
| 📜 `DIO_queries_and_data_insertion.sql` | Exemplos de inserção e consultas do curso. |

---

## 🛠️ Refinamentos Implementados

Para elevar o nível de realismo do sistema, foram realizadas modificações estruturais nas tabelas base:

### 👥 Clientes (PF & PJ)

* **Unificação de Perfis:** Adição do campo `type_client` (ENUM) para distinguir Pessoa Física de Pessoa Jurídica.
* **Flexibilidade de Documentação:** Suporte aos campos `CPF` e `CNPJ` na mesma tabela.
* **Integridade:** Constraints `unique_cpf_client` e `unique_cnpj_client` para garantir unicidade documental.

### 🚚 Entrega (Módulo Novo)

* **Rastreabilidade:** Criação da tabela `delivery` para gerenciar o status do envio (`Postado`, `Em trânsito`, `Entregue`).
* **Controle Logístico:** Campo obrigatório `trackingCode` para acompanhamento do cliente.
* **Relacionamento:** Vínculo direto `1:1` ou `1:N` com a tabela de Pedidos (`idOrder`).

### 💳 Pagamentos Diversificados

* **Multi-pagamento:** Agora vinculado diretamente ao pedido (`idOrder`), permitindo que o cliente utilize mais de um método para fechar a conta.
* **Modernização:** Inclusão do método **Pix** no ENUM de tipos de pagamento.

### 📦 Gestão de Estoque

* **Precisão Logística:** Refinamento da tabela `storageLocation` para incluir posições exatas como "Prateleira A1" ou "Setor de Móveis".
* **Otimização:** Nomenclatura de colunas e constraints ajustadas para facilitar `JOINs` entre fornecedores e produtos.

---

## 🔍 Exemplos de Consultas (Queries)

O arquivo `DIO_DESAFIO.sql` inclui queries complexas que validam a estrutura, tais como:

* Recuperação de quantos pedidos foram realizados por cliente.
* Verificação de estoque por localidade e categoria.
* Filtro de clientes que realizaram pagamentos acima de determinado valor.
* Status de entrega detalhado por pedido.

---

## 🎓 Instrutor & Instituição

* **Curso:** Klabin - Excel e Power BI Dashboards 2026
* **Plataforma:** [DIO (Digital Innovation One)](https://web.dio.me/track/klabin-excel-e-power-bi-dashboards-2026)

---

> **Dica:** Para executar o projeto, basta rodar o script `DIO_DESAFIO.sql` em seu ambiente MySQL para criar o schema, popular os dados e visualizar os resultados das análises.
