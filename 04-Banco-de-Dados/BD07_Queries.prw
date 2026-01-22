// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD07
Exemplos práticos de queries SQL

Funções abordadas:
- TcQuery() - executar query
- DbUseArea() - abrir query
- TCGenQry() - gerar query
- (ALIAS)->(DbCloseArea()) - fechar query
- Queries para relatórios

@type User Function
@author Felipi Marques
@since 19/12/2025

@example
U_BD07()
/*/

User Function BD07()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Queries SQL", ;
                     "1-Conceito de query" + CRLF + ;
                     "2-Query simples" + CRLF + ;
                     "3-Query com filtros" + CRLF + ;
                     "4-Relatório de vendas" + CRLF + ;
                     "5-Top 10 clientes" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                fEx01()
            Case nOpc == 2
                fEx02()
            Case nOpc == 3
                fEx03()
            Case nOpc == 4
                fEx04()
            Case nOpc == 5
                fEx05()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Conceito de Query
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? QUERY SQL" + CRLF + CRLF
    
    cMsg += "Consulta SQL direto no banco" + CRLF
    cMsg += "Mais rápido que navegação registro a registro" + CRLF + CRLF
    
    cMsg += "ESTRUTURA:" + CRLF
    cMsg += "cQuery := 'SELECT campo1, campo2 '" + CRLF
    cMsg += "cQuery += 'FROM tabela '" + CRLF
    cMsg += "cQuery += 'WHERE condicao'" + CRLF + CRLF
    
    cMsg += "cQuery := ChangeQuery(cQuery)" + CRLF
    cMsg += "DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),'TRB',.T.,.T.)" + CRLF + CRLF
    
    cMsg += "While !TRB->(Eof())" + CRLF
    cMsg += "   // Processar" + CRLF
    cMsg += "   TRB->(DbSkip())" + CRLF
    cMsg += "EndDo" + CRLF + CRLF
    
    cMsg += "TRB->(DbCloseArea())" + CRLF + CRLF
    
    cMsg += "QUANDO USAR:" + CRLF
    cMsg += "• Relatórios" + CRLF
    cMsg += "• Consultas complexas" + CRLF
    cMsg += "• Muito volume de dados" + CRLF
    cMsg += "• JOINs entre tabelas" + CRLF + CRLF
    
    cMsg += "?? Query é mais performática!"
    
    MsgInfo(cMsg, "Conceito Query")
Return

/*
EXEMPLO 2: Query Simples
*/
Static Function fEx02()
    Local cQuery := ""
    Local cMsg := ""
    Local nCont := 0
    
    cMsg := "?? QUERY SIMPLES" + CRLF + CRLF
    
    // Monta query
    cQuery := "SELECT A1_COD, A1_LOJA, A1_NOME, A1_EST "
    cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY A1_NOME"
    
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T.)
    
    If !TRB->(Eof())
        cMsg += "=== CLIENTES ===" + CRLF
        
        While !TRB->(Eof()) .And. nCont < 10
            nCont++
            cMsg += cValToChar(nCont) + ". "
            cMsg += AllTrim(TRB->A1_COD) + "/" + AllTrim(TRB->A1_LOJA) + " - "
            cMsg += AllTrim(TRB->A1_NOME) + CRLF
            TRB->(DbSkip())
        EndDo
        
        While !TRB->(Eof())
            nCont++
            TRB->(DbSkip())
        EndDo
        
        cMsg += CRLF + "Total: " + cValToChar(nCont) + " clientes" + CRLF + CRLF
        cMsg += "?? Query retornou registros ordenados"
    Else
        cMsg += "? Nenhum cliente encontrado"
    EndIf
    
    TRB->(DbCloseArea())
    
    MsgInfo(cMsg, "Query Simples")
Return

/*
EXEMPLO 3: Query com Filtros
*/
Static Function fEx03()
    Local cQuery := ""
    Local cEstado := "SP"
    Local cMsg := ""
    Local nCont := 0
    
    cMsg := "?? QUERY COM FILTROS" + CRLF + CRLF
    cMsg += "Estado: " + cEstado + CRLF + CRLF
    
    // Query filtrada
    cQuery := "SELECT A1_COD, A1_LOJA, A1_NOME, A1_MUN "
    cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' "
    cQuery += "  AND A1_EST = '" + cEstado + "' "
    cQuery += "  AND (A1_MSBLQL IS NULL OR A1_MSBLQL <> '1') "
    cQuery += "ORDER BY A1_NOME"
    
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T.)
    
    If !TRB->(Eof())
        cMsg += "=== CLIENTES FILTRADOS ===" + CRLF
        
        While !TRB->(Eof())
            nCont++
            
            If nCont <= 8
                cMsg += AllTrim(TRB->A1_COD) + " - " + AllTrim(TRB->A1_NOME) + CRLF
                cMsg += "   " + AllTrim(TRB->A1_MUN) + CRLF
            EndIf
            
            TRB->(DbSkip())
        EndDo
        
        If nCont > 8
            cMsg += "... mais " + cValToChar(nCont - 8) + " clientes" + CRLF
        EndIf
        
        cMsg += CRLF + "Total: " + cValToChar(nCont) + CRLF + CRLF
        cMsg += "?? WHERE filtra no banco (rápido)"
    Else
        cMsg += "? Nenhum cliente em " + cEstado
    EndIf
    
    TRB->(DbCloseArea())
    
    MsgInfo(cMsg, "Query Filtros")
Return

/*
EXEMPLO 4: Relatório de Vendas
*/
Static Function fEx04()
    Local cQuery := ""
    Local cMsg := ""
    Local nTotal := 0
    Local nCont := 0
    
    cMsg := "?? RELATÓRIO DE VENDAS" + CRLF + CRLF
    
    // Query com JOIN
    cQuery := "SELECT C5_NUM, C5_CLIENTE, A1_NOME, C5_EMISSAO, "
    cQuery += "       (SELECT SUM(C6_VALOR) "
    cQuery += "        FROM " + RetSqlName("SC6") + " SC6 "
    cQuery += "        WHERE C6_FILIAL = C5_FILIAL "
    cQuery += "          AND C6_NUM = C5_NUM "
    cQuery += "          AND SC6.D_E_L_E_T_ = ' ') AS TOTAL "
    cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
    cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 "
    cQuery += "   ON A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "  AND A1_COD = C5_CLIENTE "
    cQuery += "  AND A1_LOJA = C5_LOJACLI "
    cQuery += "  AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += "WHERE SC5.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY C5_EMISSAO DESC"
    
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T.)
    
    If !TRB->(Eof())
        cMsg += "=== PEDIDOS ===" + CRLF
        
        While !TRB->(Eof()) .And. nCont < 5
            nCont++
            
            cMsg += cValToChar(nCont) + ". Pedido " + AllTrim(TRB->C5_NUM) + CRLF
            cMsg += "   Cliente: " + AllTrim(TRB->A1_NOME) + CRLF
            cMsg += "   Data: " + DToC(SToD(TRB->C5_EMISSAO)) + CRLF
            cMsg += "   Valor: R$ " + Transform(Val(TRB->TOTAL), "@E 999,999.99") + CRLF
            
            nTotal += Val(TRB->TOTAL)
            
            TRB->(DbSkip())
        EndDo
        
        While !TRB->(Eof())
            nTotal += Val(TRB->TOTAL)
            nCont++
            TRB->(DbSkip())
        EndDo
        
        If nCont > 5
            cMsg += "... mais " + cValToChar(nCont - 5) + " pedidos" + CRLF
        EndIf
        
        cMsg += CRLF + "=== TOTAIS ===" + CRLF
        cMsg += "Pedidos: " + cValToChar(nCont) + CRLF
        cMsg += "Valor: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
        
        cMsg += "?? Query com JOIN e subquery"
    Else
        cMsg += "? Nenhum pedido encontrado"
    EndIf
    
    TRB->(DbCloseArea())
    
    MsgInfo(cMsg, "Relatório Vendas")
Return

/*
EXEMPLO 5: Top 10 Clientes
*/
Static Function fEx05()
    Local cQuery := ""
    Local cMsg := ""
    Local nCont := 0
    
    cMsg := "?? TOP 10 CLIENTES" + CRLF + CRLF
    
    // Query com agregação
    cQuery := "SELECT TOP 10 C5_CLIENTE, A1_NOME, "
    cQuery += "       COUNT(*) AS PEDIDOS, "
    cQuery += "       SUM((SELECT SUM(C6_VALOR) "
    cQuery += "            FROM " + RetSqlName("SC6") + " SC6 "
    cQuery += "            WHERE C6_FILIAL = C5_FILIAL "
    cQuery += "              AND C6_NUM = C5_NUM "
    cQuery += "              AND SC6.D_E_L_E_T_ = ' ')) AS TOTAL "
    cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
    cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 "
    cQuery += "   ON A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "  AND A1_COD = C5_CLIENTE "
    cQuery += "  AND A1_LOJA = C5_LOJACLI "
    cQuery += "  AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += "WHERE SC5.D_E_L_E_T_ = ' ' "
    cQuery += "GROUP BY C5_CLIENTE, A1_NOME "
    cQuery += "ORDER BY TOTAL DESC"
    
    cQuery := ChangeQuery(cQuery)
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T.)
    
    If !TRB->(Eof())
        cMsg += "=== RANKING ===" + CRLF
        
        While !TRB->(Eof())
            nCont++
            
            cMsg += cValToChar(nCont) + "º "
            cMsg += AllTrim(TRB->A1_NOME) + CRLF
            cMsg += "   Pedidos: " + AllTrim(TRB->PEDIDOS) + CRLF
            cMsg += "   Total: R$ " + Transform(Val(TRB->TOTAL), "@E 999,999.99") + CRLF
            
            TRB->(DbSkip())
        EndDo
        
        cMsg += CRLF + "?? Query com GROUP BY e TOP 10"
    Else
        cMsg += "? Nenhum pedido para análise"
    EndIf
    
    TRB->(DbCloseArea())
    
    MsgInfo(cMsg, "Top 10")
Return
