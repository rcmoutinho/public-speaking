EXPLAIN ANALYZE 
WITH TABLE_PEDIDO AS ( 
  SELECT 
    SC5.C5_NUM     AS PED, 
    SC5.C5_VEND1   AS REPRES, 
    SC5.C5_OBSPED  AS OBS, 
    SC5.C5_PREVIST AS PREV, 
    SC5.C5_XST05   AS ST, 
    SC5.C5_XFRET   AS FRET, 
    SC5.C5_CLIENT  AS C5CLIENT, 
    SC5.C5_CONDPAG AS C5CONDPAG 
  FROM SC5010 SC5 
  WHERE (SC5.C5_XFLAG  = 'PE' OR SC5.C5_XFLAG = 'PAR' OR SC5.C5_XFLAG = 'LIB') 
    AND (SC5.C5_XSEP   = '' OR SC5.C5_XSEP ='1') 
    AND SC5.C5_NOTA    = '' 
    AND SC5.C5_TIPO    = 'N'
    AND SC5.D_E_L_E_T_ = '' 
    AND NOT EXISTS ( 
      SELECT 1 
        FROM SC9010
        WHERE C9_FILIAL  = '  '
        AND C9_PEDIDO    = SC5.C5_NUM 
        AND D_E_L_E_T_   = '' 
        AND C9_BLCRED   <> '' 
        AND C9_NFISCAL   = '' 
        AND C9_BLCRED   <> '10' 
    )

), TABLE_QUANTIDADE AS (
  SELECT 
    C6_NUM    AS C6NUM, 
    C6_QTDVEN AS C6QTDVEN, 
    C6_QTDENT AS C6QTDENT, 
    C6_PRCVEN AS C6PRCVEN, 
    C6_XQTD05 AS C6XQTD05, 
    C6_VALOR  AS C6VALOR,
    C6_XFLAG  AS C6XFLAG, 
    C6_LOCAL  AS C6LOCAL, 
    C6_TES    AS C6TES 
  FROM SC6010 C6, SC9010 C9
  WHERE C6_NUM                       = C9_PEDIDO 
    AND C6.C6_PRODUTO                = C9.C9_PRODUTO 
    AND C9.C9_NFISCAL                = '' 
    AND C9.C9_XLIST                  = '' 
    AND C6.D_E_L_E_T_                = '' 
    AND C9.D_E_L_E_T_                = '' 
    AND C6_BLQ                      <> 'R' 
    AND C9_LOCAL                     = '05' 
    AND (C6_QTDVEN - C6_QTDENT)      > 0
    AND (
         C6_XFLAG                    = 'PE' 
         OR 
         C6_LOCAL                    = '05'
        )

), TABLE_ITENS_C6 AS (
  SELECT 
    C6NUM                                                            AS NUM, 
    C6TES                                                            AS C6TES, 
    SUM( (C6QTDVEN-C6QTDENT) )                                       AS QTDFAL, 
    SUM( (C6QTDVEN-C6QTDENT) * C6PRCVEN )                            AS VALFAL, 
    SUM( ( (C6QTDVEN-C6QTDENT) * C6PRCVEN) - (C6XQTD05 * C6PRCVEN) ) AS VALOR, 
    SUM(C6VALOR)                                                     AS TOT 
  FROM TABLE_QUANTIDADE
  GROUP BY C6NUM, C6TES 
)
SELECT DISTINCT 
  T_PEDIDO.PED      AS PED, 
  T_PEDIDO.REPRES   AS REPRES, 
  SA1.A1_NOME       AS NOME, 
  T_ITENS_C6.QTDFAL AS QTDFAL,
  T_ITENS_C6.VALFAL AS VALFAL, 
  T_ITENS_C6.VALOR  AS VALOR, 
  SE4.E4_COND       AS COND, 
  T_PEDIDO.OBS      AS OBS, 
  T_PEDIDO.PREV     AS PREV, 
  T_PEDIDO.ST       AS ST, 
  T_PEDIDO.FRET     AS FRET, 
  T_ITENS_C6.TOT    AS TOT 
FROM 
  TABLE_PEDIDO   AS T_PEDIDO, 
  TABLE_ITENS_C6 AS T_ITENS_C6, 
  SA1010         AS SA1,
  SF4010         AS SF4,
  SE4010         AS SE4 
WHERE T_ITENS_C6.NUM  = T_PEDIDO.PED 
  AND SA1.A1_FILIAL   = '  ' 
  AND SA1.D_E_L_E_T_  = '' 
  AND SA1.A1_COD      = T_PEDIDO.C5CLIENT 
  AND SF4.F4_FILIAL   = '  ' 
  AND SF4.F4_ESTOQUE  = 'S' 
  AND SF4.D_E_L_E_T_  = '' 
  AND SF4.F4_CODIGO   = T_ITENS_C6.C6TES 
  AND SE4.E4_FILIAL   = '  ' 
  AND SE4.D_E_L_E_T_  = '' 
  AND SE4.E4_CODIGO   = T_PEDIDO.C5CONDPAG 
ORDER BY 
  SA1.A1_NOME;