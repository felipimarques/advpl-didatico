// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR05
Exemplos práticos de processamento de arrays

Funções abordadas:
- aEval() - executar função para cada elemento
- aFill() - preencher array com valor
- Processar todos elementos
- Transformações em massa

@type User Function
@author Felipi Marques
@since 13/01/2026

@example
U_ARR05()
/*/

User Function ARR05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Processamento de Arrays", ;
                     "1-aEval básico" + CRLF + ;
                     "2-aEval com transformação" + CRLF + ;
                     "3-aFill (preencher)" + CRLF + ;
                     "4-Reajuste em lote" + CRLF + ;
                     "5-Calcular totalizadores" + CRLF + ;
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
EXEMPLO 1: aEval Básico (Percorrer)
*/
Static Function fEx01()
    Local aProdutos := {"NOTEBOOK", "MOUSE", "TECLADO", "MONITOR"}
    Local cMsg := ""
    Local cLista := ""
    
    cMsg := "?? aEval() BÁSICO" + CRLF + CRLF
    cMsg += "Array: {'NOTEBOOK', 'MOUSE', 'TECLADO', 'MONITOR'}" + CRLF + CRLF
    
    // Percorre e monta lista
    aEval(aProdutos, {|x| cLista += "• " + x + CRLF})
    
    cMsg += "Usando aEval:" + CRLF
    cMsg += cLista + CRLF
    
    cMsg += "Código:" + CRLF
    cMsg += "aEval(aProdutos, {|x| cLista += x})" + CRLF + CRLF
    
    cMsg += "?? aEval executa bloco para cada item"
    
    MsgInfo(cMsg, "aEval()")
Return

/*
EXEMPLO 2: aEval com Transformação
*/
Static Function fEx02()
    Local aPrecos := {100, 250, 50, 175}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? aEval() COM TRANSFORMAÇÃO" + CRLF + CRLF
    
    cMsg += "Preços originais:" + CRLF
    For nI := 1 To Len(aPrecos)
        cMsg += "R$ " + Transform(aPrecos[nI], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "Aplicando reajuste de 10%..." + CRLF + CRLF
    
    // Reajusta todos preços
    aEval(aPrecos, {|x,i| aPrecos[i] := x * 1.10}, 1)
    
    cMsg += "Preços reajustados:" + CRLF
    For nI := 1 To Len(aPrecos)
        cMsg += "R$ " + Transform(aPrecos[nI], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "Código:" + CRLF
    cMsg += "aEval(aPrecos, {|x,i| aPrecos[i] := x * 1.10})" + CRLF + CRLF
    
    cMsg += "?? Use índice (i) para modificar"
    
    MsgInfo(cMsg, "Transformação")
Return

/*
EXEMPLO 3: aFill (Preencher Array)
*/
Static Function fEx03()
    Local aStatus := Array(5)
    Local aSaldos := Array(10)
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? aFill() - PREENCHER" + CRLF + CRLF
    
    // Preenche com valor padrão
    aFill(aStatus, "A")
    aFill(aSaldos, 0)
    
    cMsg += "Array status (5 posições):" + CRLF
    For nI := 1 To Len(aStatus)
        cMsg += "[" + cValToChar(nI) + "] = " + aStatus[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "Array saldos (10 posições):" + CRLF
    For nI := 1 To Len(aSaldos)
        cMsg += "[" + cValToChar(nI) + "] = " + cValToChar(aSaldos[nI]) + CRLF
    Next nI
    
    cMsg += CRLF + "Código:" + CRLF
    cMsg += "aStatus := Array(5)" + CRLF
    cMsg += "aFill(aStatus, 'A')" + CRLF + CRLF
    
    cMsg += "?? aFill para inicializar arrays"
    
    MsgInfo(cMsg, "aFill()")
Return

/*
EXEMPLO 4: Reajuste de Preços em Lote
*/
Static Function fEx04()
    Local aProdutos := {}
    Local nReaj := 1.15  // 15%
    Local cMsg := ""
    Local nI := 0
    
    // Monta produtos
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3000.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 30.00})
    aAdd(aProdutos, {"PA003", "TECLADO", 100.00})
    aAdd(aProdutos, {"PA004", "MONITOR", 800.00})
    
    cMsg := "?? REAJUSTE EM LOTE" + CRLF + CRLF
    cMsg += "Reajuste: 15%" + CRLF + CRLF
    
    cMsg += "ANTES:" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += aProdutos[nI][1] + " - R$ " + Transform(aProdutos[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    // Aplica reajuste
    aEval(aProdutos, {|x,i| aProdutos[i][3] := x[3] * nReaj})
    
    cMsg += CRLF + "DEPOIS:" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += aProdutos[nI][1] + " - R$ " + Transform(aProdutos[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "?? aEval processa todos de uma vez"
    
    MsgInfo(cMsg, "Reajuste Lote")
Return

/*
EXEMPLO 5: Calcular Totalizadores
*/
Static Function fEx05()
    Local aVendas := {}
    Local nTotalVlr := 0
    Local nTotalQtd := 0
    Local nMaior := 0
    Local cMaiorProd := ""
    Local cMsg := ""
    Local nI := 0
    
    // Monta vendas
    aAdd(aVendas, {"NOTEBOOK", 5, 3500.00})
    aAdd(aVendas, {"MOUSE", 25, 35.00})
    aAdd(aVendas, {"TECLADO", 15, 125.00})
    aAdd(aVendas, {"MONITOR", 10, 850.00})
    
    cMsg := "?? TOTALIZADORES" + CRLF + CRLF
    
    // Calcula totais
    aEval(aVendas, {|x| nTotalQtd += x[2], ;
                        nTotalVlr += (x[2] * x[3])})
    
    // Busca maior venda
    aEval(aVendas, {|x| If((x[2]*x[3]) > nMaior, ;
                        (nMaior := x[2]*x[3], cMaiorProd := x[1]), Nil)})
    
    cMsg += "PRODUTOS:" + CRLF
    For nI := 1 To Len(aVendas)
        cMsg += aVendas[nI][1] + " - "
        cMsg += "Qtd: " + cValToChar(aVendas[nI][2]) + " - "
        cMsg += "R$ " + Transform(aVendas[nI][2] * aVendas[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "=== TOTAIS ===" + CRLF
    cMsg += "Quantidade: " + cValToChar(nTotalQtd) + " itens" + CRLF
    cMsg += "Valor: R$ " + Transform(nTotalVlr, "@E 999,999,999.99") + CRLF + CRLF
    
    cMsg += "?? MAIOR VENDA:" + CRLF
    cMsg += cMaiorProd + " - R$ " + Transform(nMaior, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? aEval para cálculos em massa"
    
    MsgInfo(cMsg, "Totalizadores")
Return
