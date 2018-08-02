#!/bin/bash

######################################################################
#
# Script to emulate all the data expected to test the example
#
######################################################################

NUMPEDIDOS=50000
ITEMPORPEDIDO=5

# HINT:
# NUMPEDIDOS * ITEMPORPEDIDO * 2 = Total amount of data
# 
# Couldn't get a "fast result" (less than a minute) from the low-performance query with more than a million of rows. 
# The high-performance, even with 5 million it is possible to view a fast result inside a VM.
# 
# NOTE: This use case was running inside of a super fast server with far more resources than this VM.

psql -U postgres -d totvs_example << EOF
  --
  -- CONDIÇÃO DE PAGAMENTO
  --
  WITH CARGA_SE4 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS CODIGO,
      'C' || LPAD(AUTO_COD::text, 2, '0') AS CONPAG,
      '' AS D_E_L_E_T_
    FROM generate_series(1,40) AS AUTO_COD
  )
  INSERT INTO SE4010
    SELECT * FROM CARGA_SE4;
EOF

psql -U postgres -d totvs_example << EOF
  --
  -- TIPO DE ENTRADA E SAÍDA
  --
  WITH CARGA_SF4 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS CODIGO,
      CASE AUTO_COD % 10 WHEN 1 THEN '' 
                        ELSE 'S' 
        END AS ESTOQUE,
      '' AS D_E_L_E_T_
    FROM generate_series(1,400) AS AUTO_COD
  )
  INSERT INTO SF4010
    SELECT * FROM CARGA_SF4;
EOF

psql -U postgres -d totvs_example << EOF
  --
  -- CLIENTE
  --
  WITH CARGA_SA1 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS CODIGO,
      'Cliente' || LPAD(AUTO_COD::text, 4, '0') AS NOME,
      '' AS D_E_L_E_T_
    FROM generate_series(1,3000) AS AUTO_COD
  )
  INSERT INTO SA1010
    SELECT * FROM CARGA_SA1;
EOF

psql -U postgres -d totvs_example << EOF
  --
  -- PEDIDO DE VENDA
  --
  WITH CARGA_SC5 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS NUM,
      (AUTO_COD % 300 + 1) AS VEND1,
      'Obs do pedido ' || LPAD(AUTO_COD::text, 6, '0') AS OBSPED,
      to_char(now(), 'YYYYMMDD') AS PREVIST,
      (AUTO_COD % 10) AS XST05,
      CASE AUTO_COD % 2 WHEN 1 THEN 'A' 
                        ELSE 'B'
        END AS XFRET,
      CASE AUTO_COD % 7 WHEN 1 THEN 'PE' 
                        WHEN 2 THEN 'PAR' 
                        WHEN 3 THEN 'LIB' 
                        WHEN 4 THEN 'NAO' 
                        WHEN 5 THEN 'SEI' 
                        WHEN 6 THEN 'MA' 
                        ELSE 'IS' 
        END AS XFLAG,
      (AUTO_COD % 10) AS XSEP,
      CASE AUTO_COD % 100 
        WHEN 1 THEN '' -- considerando que apenas 1% dos pedidos não tinham nota
        ELSE 'NOT' || LPAD(AUTO_COD::text, 6, '0') END 
          AS NOTA,
      (AUTO_COD % 3000 + 1) AS CLIENT,
      CASE AUTO_COD % 2 WHEN 1 THEN 'N' 
                        ELSE '' 
          END AS TIPO,
      (AUTO_COD % 40 + 1) AS CONDPAG,
      '' AS D_E_L_E_T_
    FROM generate_series(1,$NUMPEDIDOS) AS AUTO_COD
  )
  INSERT INTO SC5010
    SELECT * FROM CARGA_SC5;
EOF

# HINT:
# This query needed to be divided due to the amount of data.
# It will take some minutes to finish this insert (more than 10 minutes depending on the numbers), even after this batch execution.

for ((i=1;i<=ITEMPORPEDIDO;i++))
do
psql -U postgres -d totvs_example << EOF
  --
  -- ITEM PEDIDO DE VENDA
  --
  WITH CARGA_SC6 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS NUM, -- considerando 250k de pedidos
      $i AS ITEM,
      'PROD-' || LPAD((AUTO_COD % 1500 + 1)::text, 6, '0') AS PRODUTO,
      CASE AUTO_COD % 2 WHEN 1 THEN '05' 
                        ELSE '' 
        END AS LOCAL,
      CASE AUTO_COD % 500 WHEN 1 THEN 'R'
                          ELSE ''
        END AS BLQ,
      40.0 AS QTDVEN,
      CASE AUTO_COD % 4 WHEN 1 THEN 0.0
                        WHEN 2 THEN 20.0
                        ELSE 40.0 -- 50% já foi entregue
        END AS QTDENT,
      20.0 AS PRCVEN,
      20.0 AS XQTD05,
      800.0 AS VALOR, -- 40 * 20
      CASE AUTO_COD % 2 WHEN 1 THEN 'PE' 
                        ELSE '' 
        END AS XFLAG,
      (AUTO_COD % 400 + 1) AS TES, -- quantidade simulada em CARGA_SF4
      '' AS D_E_L_E_T_
    FROM generate_series(1,$NUMPEDIDOS) AS AUTO_COD
  )
  INSERT INTO SC6010
    SELECT * FROM CARGA_SC6;
EOF
done

# HINT: same as previous

for ((i=1;i<=ITEMPORPEDIDO;i++))
do
psql -U postgres -d totvs_example << EOF
  --
  -- ITEM PEDIDO VENDA LIBERADO
  --
  WITH CARGA_SC9 AS (
    SELECT
      '  ' AS FILIAL,
      AUTO_COD AS PEDIDO, -- considerando 250k de pedidos
      $i AS ITEM,
      $i AS SEQUEN,
      'PROD-' || LPAD((AUTO_COD % 1500 + 1)::text, 6, '0') AS PRODUTO,
      CASE AUTO_COD % 100 WHEN 1 THEN '' -- considerando que apenas 1% dos pedidos não tinham nota
                          ELSE 'NOT' || LPAD(AUTO_COD::text, 6, '0') 
        END AS NFISCAL,
      CASE AUTO_COD % 10 WHEN 5 THEN '000'
                         ELSE ''
        END AS XLIST,
      CASE AUTO_COD % 2 WHEN 1 THEN '05' 
                        ELSE '' 
        END AS LOCAL,
      CASE AUTO_COD % 100 WHEN 99 THEN '01'
                          ELSE ''
        END AS BLCRED,
      '' AS D_E_L_E_T_
    FROM generate_series(1,$NUMPEDIDOS) AS AUTO_COD
  )
  INSERT INTO SC9010
    SELECT * FROM CARGA_SC9;
EOF
done
