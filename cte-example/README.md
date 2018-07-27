[English](#dramatically-increase-your-database-performance) | [Português](#aumente-drasticamente-a-performance-do-seu-banco-de-dados)

# Dramatically increase your database performance

Real example using CTE (Common Table Expression) to decrease the runtime of a query drastically. Most of the structure was preserved to respect TOTVS' ERP (Enterprise Resource Planning) project format.

The whole example will be emulated using **PostgreSQL**, my preferred database. But the real case was solved under **MySQL Server**. Considering that CTE is supported on most of the databases, you decide which flavor you want to choose.

## Prerequisites

There are some prerequisites do execute the full automation of this example.

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

All steps covered here can be applied to your project to increase your productivity.

## Time to run!

To reproduce this example, `clone` this project and type `vagrant up` over the terminal.

```
$ clone cte-example
$ cd cte-example
$ vagrant up
```

That's it! Now you have a fully configured database with all the data you need to play with this use case. And if you want to understand more about how this automation was built, subscribe to a 3 emails course about software automation [here](https://cyborgdeveloper.tech/), **for FREE**. Learn how to use Vagrant to boost your local productivity.

## Time to play!

To avoid accessing the machine (`vagrant ssh`) and then reaching the database, type the command below to get straight to the database. *WARN: this is only possible due to `pg_hba.conf` modification to allow any connection. This configuration is **insecure**, but it is acceptable for development purposes.*

```
vagrant ssh -c "psql -U postgres -d totvs_example"
```

You can also connect to the database using a visual tool like **pgAdmin**. From the tool, create a server using the IP ```192.168.33.10``` (already configured on Vagrantfile) and the default port ```5432```. *WARN: this is only possible due to `postgresql.conf` modification to listen to any type of IP. Again, this configuration is **insecure**, but it is acceptable for development purposes.*

### Queries

There are multiple ways to execute the same task here so that you can test the performance of both queries. Choose the one that fits best for you.

#### Terminal

Avoid accessing the virtual machine executing the queries using the SSH command.

```
vagrant ssh -c "psql -U postgres -d totvs_example -f /vagrant/queries/low-performance-query.sql"
vagrant ssh -c "psql -U postgres -d totvs_example -f /vagrant/queries/high-performance-query.sql"
```

Or access the virtual machine and execute queries from Ubuntu terminal. Just need to type ```vagrant ssh```, and you are in! And yes, it is the same commands used previously.

```
psql -U postgres -d totvs_example -f /vagrant/queries/low-performance-query.sql
psql -U postgres -d totvs_example -f /vagrant/queries/high-performance-query.sql
```

You can check all files from the example at ```/vagrant``` (they are all synchronized from your root folder, where the Vagrantfile is located).

#### Postgres Database

If you prefer the visual tools, open the queries files and execute them. Otherwise, run them inside of PostgreSQL database using the commands below:

```
\i /vagrant/queries/low-performance-query.sql 
\i /vagrant/queries/high-performance-query.sql
```

## CTE Docs

- [PostgreSQL](https://www.postgresql.org/docs/9.1/static/queries-with.html) (the foundation for this example)
- [SQL Server](https://dev.mysql.com/doc/refman/8.0/en/with.html)
- ... (***TODO** other supported databases*)

# Aumente drasticamente a performance do seu banco de dados

**TODO...**

## Sumário TOTVS

Sumário para facilitar o entendimento de todos os códigos contidos nos nomes de tabelas e colunas.

_Obs. 1: Alguns nomes de colunas são ainda mais estranhos devido a limitação de tamanho de 10 caracteres._

_Obs. 2: Boa parte do campos são no formato texto (String), apenas quantidades e valores monetários são armazenados no formato numérico._

_Obs. 3: Nas exclusões lógicas, ```''``` (branco) é um dado válido e ```'*'``` é um dado apagado._

### SC5010 - Pedido de Venda
* **C5_NUM** - Número Pedido *(PK)*
* **C5_FILIAL** - Filial *(PK)*
* **C5_VEND1** - Representante
* **C5_OBSPED** - Observação Pedido
* **C5_PREVIST** - Data Prevista
* **C5_XST05** - Status 1
* **C5_XFRET** - Frete
* **C5_XFLAG** - Status 2
* **C5_XSEP** - Status 3
* **C5_NOTA** - Número Nota Fiscal
* **C5_CLIENT** - Cliente
* **C5_TIPO** - Tipo Pedido
* **C5_CONDPAG** - Condição de Pagamento
* **D_E_L_E_T_** - Apagado (exclusão lógica)

### SA1010 - Cliente
* **A1_COD** - Código *(PK)*
* **A1_FILIAL** - Filial *(PK)*
* **A1_NOME** - Nome
* **D_E_L_E_T_** - Apagado (exclusão lógica)

### SC6010 - Item Pedido Venda
* **C6_NUM** - Código *(PK)*
* **C6_FILIAL** - Filial *(PK)*
* **C6_ITEM** - Item (linha) *(PK)*
* **C6_PRODUTO** - Código Produto
* **C6_LOCAL** - Estoque
* **C6_BLQ** - Bloqueado
* **C6_QTDVEN** - Quantidade Vendida
* **C6_QTDENT** - Quantidade Entrega
* **C6_PRCVEN** - Preço Venda
* **C6_XQTD05** - Quantidade Estoque
* **C6_VALOR** - Valor Total Item
* **C6_XFLAG** - Status
* **C6_TES** - Tipo Entraga Saída
* **D_E_L_E_T_** - Apagado (exclusão lógica)

### SC9010 - Item Pedido Venda Liberado
* **C9_PEDIDO** - Código *(PK)*
* **C9_FILIAL** - FILIAL *(PK)*
* **C9_ITEM** - Item (linha) *(PK)*
* **C9_SEQUEN** - Sequência *(PK)*
* **C9_PRODUTO** - Código Produto
* **C9_NFISCAL** - Nota Fiscal
* **C9_XLIST** - Lista (nem sei mais o que seria isso...)
* **C9_LOCAL** - Estoque
* **C9_BLCCRED** - Bloqueio Crédito
* **D_E_L_E_T_** - Apagado (exclusão lógica)

### SF4010 - Tipo Entrada Saída
* **F4_FILIAL** - Filial *(PK)*
* **F4_CODIGO** - Código *(PK)*
* **F4_ESTOQUE** - Estoque
* **D_E_L_E_T_** - Apagado (exclusão lógica)

### SE4010 - Condição Pagamento
* **E4_FILIAL** - Filial *(PK)*
* **E4_CODIGO** - Código *(PK)*
* **E4_COND** - Condição de Pagamento
* **D_E_L_E_T_** - Apagado (exclusão lógica)
