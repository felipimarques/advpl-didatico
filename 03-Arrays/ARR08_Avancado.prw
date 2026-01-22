// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR08
Exemplos práticos de filtros e transformações

Tópicos abordados:
- Filtrar dados com condições
- Transformar valores (map)
- Reduzir arrays (reduce)
- Combinar arrays
- Operações complexas

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR08()
/*/

User Function ARR08()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Filtros e Transformações", ;
                     "1-Filtrar produtos ativos" + CRLF + ;
                     "2-Transformar moeda" + CRLF + ;
                     "3-Calcular comissões" + CRLF + ;
                     "4-Consolidar vendas" + CRLF + ;
                     "5-Dashboard gerencial" + CRLF + ;
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
EXEMPLO 1: Filtrar Produtos Ativos com Estoque
*/
Static Function fEx01()
    Local aProdutos := {}
    Local aFiltrados := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? FILTRAR PRODUTOS" + CRLF + CRLF
    
    // Produtos cadastrados
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00, 10, .T.})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00, 0, .T.})
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00, 5, .F.})
    aAdd(aProdutos, {"PA004", "MONITOR", 850.00, 8, .T.})
    
    cMsg += "Total produtos: " + cValToChar(Len(aProdutos)) + CRLF + CRLF
    
    // Filtra: ativos E com estoque
    For nI := 1 To Len(aProdutos)
        If aProdutos[nI][5] .And. aProdutos[nI][4] > 0
            aAdd(aFiltrados, aClone(aProdutos[nI]))
        EndIf
    Next nI
    
    cMsg += "=== PRODUTOS FILTRADOS ===" + CRLF
    cMsg += "Ativos com estoque: " + cValToChar(Len(aFiltrados)) + CRLF + CRLF
    
    For nI := 1 To Len(aFiltrados)
        cMsg += aFiltrados[nI][1] + " - " + aFiltrados[nI][2] + CRLF
        cMsg += "Estoque: " + cValToChar(aFiltrados[nI][4]) + " un" + CRLF
        cMsg += "Preço: R$ " + Transform(aFiltrados[nI][3], "@E 999,999.99") + CRLF + CRLF
    Next nI
    
    cMsg += "?? Filter = selecionar registros"
    
    MsgInfo(cMsg, "Filtrar")
Return

/*
EXEMPLO 2: Transformar Preços (Real ? Dólar)
*/
Static Function fEx02()
    Local aProdutos := {}
    Local aProdUSD := {}
    Local nCotacao := 5.25
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? TRANSFORMAR MOEDA" + CRLF + CRLF
    cMsg += "Cotação: R$ " + Transform(nCotacao, "@E 9.99") + CRLF + CRLF
    
    // Produtos em Real
    aAdd(aProdutos, {"NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"MOUSE", 35.00})
    aAdd(aProdutos, {"MONITOR", 850.00})
    
    cMsg += "=== REAIS ===" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += aProdutos[nI][1] + " - R$ "
        cMsg += Transform(aProdutos[nI][2], "@E 999,999.99") + CRLF
    Next nI
    
    // Transforma para dólar
    For nI := 1 To Len(aProdutos)
        aAdd(aProdUSD, {aProdutos[nI][1], aProdutos[nI][2] / nCotacao})
    Next nI
    
    cMsg += CRLF + "=== DÓLARES ===" + CRLF
    For nI := 1 To Len(aProdUSD)
        cMsg += aProdUSD[nI][1] + " - $ "
        cMsg += Transform(aProdUSD[nI][2], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "?? Map = transformar valores"
    
    MsgInfo(cMsg, "Transformar")
Return

/*
EXEMPLO 3: Calcular Comissões por Vendedor
*/
Static Function fEx03()
    Local aVendas := {}
    Local aComissoes := {}
    Local aTmp := {}
    Local nPos := 0
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? CALCULAR COMISSÕES" + CRLF + CRLF
    
    // Vendas realizadas
    aAdd(aVendas, {"V001", "JOSE", 5000.00})
    aAdd(aVendas, {"V002", "MARIA", 7500.00})
    aAdd(aVendas, {"V001", "JOSE", 3000.00})
    aAdd(aVendas, {"V003", "PEDRO", 4500.00})
    aAdd(aVendas, {"V002", "MARIA", 2500.00})
    
    cMsg += "Total vendas: " + cValToChar(Len(aVendas)) + CRLF + CRLF
    
    // Agrupa e calcula comissão (5%)
    For nI := 1 To Len(aVendas)
        nPos := aScan(aComissoes, {|x| x[1] == aVendas[nI][1]})
        
        If nPos > 0
            // Já existe - soma
            aComissoes[nPos][3] += aVendas[nI][3]
        Else
            // Novo vendedor
            aAdd(aComissoes, {aVendas[nI][1], aVendas[nI][2], aVendas[nI][3]})
        EndIf
    Next nI
    
    // Ordena por valor
    aSort(aComissoes,,, {|x,y| x[3] > y[3]})
    
    cMsg += "=== COMISSÕES (5%) ===" + CRLF
    For nI := 1 To Len(aComissoes)
        cMsg += aComissoes[nI][1] + " - " + aComissoes[nI][2] + CRLF
        cMsg += "Vendas: R$ " + Transform(aComissoes[nI][3], "@E 999,999.99") + CRLF
        cMsg += "Comissão: R$ " + Transform(aComissoes[nI][3] * 0.05, "@E 999,999.99") + CRLF + CRLF
    Next nI
    
    cMsg += "?? Group by + reduce"
    
    MsgInfo(cMsg, "Comissões")
Return

/*
EXEMPLO 4: Consolidar Vendas por Região
*/
Static Function fEx04()
    Local aVendas := {}
    Local aRegional := {}
    Local nPos := 0
    Local cMsg := ""
    Local nI := 0
    Local nTotal := 0
    
    cMsg := "??? CONSOLIDAR POR REGIÃO" + CRLF + CRLF
    
    // Vendas por filial
    aAdd(aVendas, {"FIL01", "SP", 15000.00})
    aAdd(aVendas, {"FIL02", "RJ", 12000.00})
    aAdd(aVendas, {"FIL03", "SP", 18000.00})
    aAdd(aVendas, {"FIL04", "MG", 9000.00})
    aAdd(aVendas, {"FIL05", "RJ", 11000.00})
    
    // Consolida por estado
    For nI := 1 To Len(aVendas)
        nPos := aScan(aRegional, {|x| x[1] == aVendas[nI][2]})
        
        If nPos > 0
            aRegional[nPos][2] += aVendas[nI][3]
            aRegional[nPos][3]++
        Else
            aAdd(aRegional, {aVendas[nI][2], aVendas[nI][3], 1})
        EndIf
    Next nI
    
    // Ordena por valor
    aSort(aRegional,,, {|x,y| x[2] > y[2]})
    
    cMsg += "=== POR REGIÃO ===" + CRLF
    For nI := 1 To Len(aRegional)
        cMsg += aRegional[nI][1] + CRLF
        cMsg += "Filiais: " + cValToChar(aRegional[nI][3]) + CRLF
        cMsg += "Total: R$ " + Transform(aRegional[nI][2], "@E 999,999.99") + CRLF + CRLF
        nTotal += aRegional[nI][2]
    Next nI
    
    cMsg += "=== TOTAL GERAL ===" + CRLF
    cMsg += "R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Consolidar = agrupar + somar"
    
    MsgInfo(cMsg, "Consolidar")
Return

/*
EXEMPLO 5: Dashboard Gerencial Completo
*/
Static Function fEx05()
    Local aVendas := {}
    Local aProdutos := {}
    Local nTotalVlr := 0
    Local nTotalQtd := 0
    Local nMaiorVenda := 0
    Local cTopProduto := ""
    Local nTopQtd := 0
    Local cMsg := ""
    Local nI := 0
    Local nPos := 0
    
    cMsg := "?? DASHBOARD GERENCIAL" + CRLF + CRLF
    
    // Vendas do mês
    aAdd(aVendas, {"NOTEBOOK", 10, 3500.00})
    aAdd(aVendas, {"MOUSE", 150, 35.00})
    aAdd(aVendas, {"TECLADO", 80, 125.00})
    aAdd(aVendas, {"MONITOR", 25, 850.00})
    aAdd(aVendas, {"WEBCAM", 45, 180.00})
    
    // Processa dados
    For nI := 1 To Len(aVendas)
        nTotalQtd += aVendas[nI][2]
        nTotalVlr += aVendas[nI][2] * aVendas[nI][3]
        
        // Maior venda
        If (aVendas[nI][2] * aVendas[nI][3]) > nMaiorVenda
            nMaiorVenda := aVendas[nI][2] * aVendas[nI][3]
        EndIf
        
        // Top produto (quantidade)
        If aVendas[nI][2] > nTopQtd
            nTopQtd := aVendas[nI][2]
            cTopProduto := aVendas[nI][1]
        EndIf
    Next nI
    
    cMsg += "=== RESUMO DO MÊS ===" + CRLF + CRLF
    
    cMsg += "?? ITENS VENDIDOS" + CRLF
    cMsg += cValToChar(nTotalQtd) + " unidades" + CRLF + CRLF
    
    cMsg += "?? FATURAMENTO" + CRLF
    cMsg += "R$ " + Transform(nTotalVlr, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? TICKET MÉDIO" + CRLF
    cMsg += "R$ " + Transform(nTotalVlr / Len(aVendas), "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? TOP PRODUTO" + CRLF
    cMsg += cTopProduto + " - " + cValToChar(nTopQtd) + " un" + CRLF + CRLF
    
    cMsg += "?? MAIOR VENDA" + CRLF
    cMsg += "R$ " + Transform(nMaiorVenda, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "=== TOP 3 PRODUTOS ===" + CRLF
    
    // Ordena por faturamento
    aSort(aVendas,,, {|x,y| (x[2]*x[3]) > (y[2]*y[3])})
    
    For nI := 1 To Min(3, Len(aVendas))
        cMsg += cValToChar(nI) + "º " + aVendas[nI][1] + " - R$ "
        cMsg += Transform(aVendas[nI][2] * aVendas[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "?? Arrays = Business Intelligence"
    
    MsgInfo(cMsg, "Dashboard")
Return
