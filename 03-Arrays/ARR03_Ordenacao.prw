// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR03
Exemplos práticos de ordenação de arrays

Função abordada:
- aSort() - ordenar array
- Ordem crescente/decrescente
- Ordenar por coluna específica
- Múltiplos níveis de ordenação

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR03()
/*/

User Function ARR03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Ordenação de Arrays", ;
                     "1-aSort simples" + CRLF + ;
                     "2-Crescente/Decrescente" + CRLF + ;
                     "3-Ordenar por coluna" + CRLF + ;
                     "4-Ordenação múltipla" + CRLF + ;
                     "5-Top 5 vendedores" + CRLF + ;
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
EXEMPLO 1: aSort Simples
*/
Static Function fEx01()
    Local aNomes := {"Pedro", "Ana", "Carlos", "Beatriz", "João"}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? aSort() SIMPLES" + CRLF + CRLF
    
    cMsg += "ANTES da ordenação:" + CRLF
    For nI := 1 To Len(aNomes)
        cMsg += cValToChar(nI) + ". " + aNomes[nI] + CRLF
    Next nI
    
    // Ordena
    aSort(aNomes)
    
    cMsg += CRLF + "DEPOIS da ordenação:" + CRLF
    For nI := 1 To Len(aNomes)
        cMsg += cValToChar(nI) + ". " + aNomes[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? aSort() modifica o array original"
    
    MsgInfo(cMsg, "aSort()")
Return

/*
EXEMPLO 2: Crescente e Decrescente
*/
Static Function fEx02()
    Local aSaldos := {150, 25, 300, 10, 200}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? CRESCENTE/DECRESCENTE" + CRLF + CRLF
    
    cMsg += "Original: "
    For nI := 1 To Len(aSaldos)
        cMsg += cValToChar(aSaldos[nI]) + If(nI < Len(aSaldos), ", ", "")
    Next nI
    cMsg += CRLF + CRLF
    
    // Crescente (padrão)
    aSort(aSaldos,,, {|x,y| x < y})
    cMsg += "CRESCENTE (menor?maior):" + CRLF
    For nI := 1 To Len(aSaldos)
        cMsg += cValToChar(nI) + ". " + cValToChar(aSaldos[nI]) + CRLF
    Next nI
    
    cMsg += CRLF
    
    // Decrescente
    aSort(aSaldos,,, {|x,y| x > y})
    cMsg += "DECRESCENTE (maior?menor):" + CRLF
    For nI := 1 To Len(aSaldos)
        cMsg += cValToChar(nI) + ". " + cValToChar(aSaldos[nI]) + CRLF
    Next nI
    
    cMsg += CRLF + "?? Use bloco {|x,y| x > y} para decrescente"
    
    MsgInfo(cMsg, "Crescente/Decrescente")
Return

/*
EXEMPLO 3: Ordenar por Coluna Específica
*/
Static Function fEx03()
    Local aProdutos := {}
    Local cMsg := ""
    Local nI := 0
    
    // Monta produtos
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00})
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00})
    
    cMsg := "?? ORDENAR POR COLUNA" + CRLF + CRLF
    
    // Ordena por código (coluna 1)
    aSort(aProdutos,,, {|x,y| x[1] < y[1]})
    
    cMsg += "Ordenado por CÓDIGO:" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += aProdutos[nI][1] + " - " + aProdutos[nI][2] + CRLF
    Next nI
    
    cMsg += CRLF
    
    // Ordena por preço (coluna 3)
    aSort(aProdutos,,, {|x,y| x[3] < y[3]})
    
    cMsg += "Ordenado por PREÇO:" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += aProdutos[nI][2] + " - R$ " + Transform(aProdutos[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "?? Use x[coluna] para ordenar"
    
    MsgInfo(cMsg, "Por Coluna")
Return

/*
EXEMPLO 4: Ordenação Múltipla (Região + Nome)
*/
Static Function fEx04()
    Local aClientes := {}
    Local cMsg := ""
    Local nI := 0
    
    // Monta clientes
    aAdd(aClientes, {"SUL", "Carlos"})
    aAdd(aClientes, {"NORTE", "Ana"})
    aAdd(aClientes, {"SUL", "Beatriz"})
    aAdd(aClientes, {"NORTE", "Daniel"})
    aAdd(aClientes, {"SUL", "Amanda"})
    
    cMsg := "??? ORDENAÇÃO MÚLTIPLA" + CRLF + CRLF
    cMsg += "1º por REGIÃO" + CRLF
    cMsg += "2º por NOME" + CRLF + CRLF
    
    // Ordena por região, depois por nome
    aSort(aClientes,,, {|x,y| x[1]+x[2] < y[1]+y[2]})
    
    For nI := 1 To Len(aClientes)
        cMsg += aClientes[nI][1] + " - " + aClientes[nI][2] + CRLF
    Next nI
    
    cMsg += CRLF + "?? Concatene campos para ordenar"
    
    MsgInfo(cMsg, "Múltipla")
Return

/*
EXEMPLO 5: Top 5 Vendedores
*/
Static Function fEx05()
    Local aVendas := {}
    Local cMsg := ""
    Local nI := 0
    
    // Monta vendas
    aAdd(aVendas, {"João", 125000.00})
    aAdd(aVendas, {"Maria", 98000.00})
    aAdd(aVendas, {"Pedro", 156000.00})
    aAdd(aVendas, {"Ana", 187000.00})
    aAdd(aVendas, {"Carlos", 142000.00})
    aAdd(aVendas, {"Beatriz", 95000.00})
    aAdd(aVendas, {"Lucas", 178000.00})
    
    cMsg := "?? TOP 5 VENDEDORES" + CRLF + CRLF
    
    // Ordena decrescente por valor
    aSort(aVendas,,, {|x,y| x[2] > y[2]})
    
    For nI := 1 To Min(5, Len(aVendas))
        cMsg += cValToChar(nI) + "º - " + aVendas[nI][1] + CRLF
        cMsg += "R$ " + Transform(aVendas[nI][2], "@E 999,999,999.99") + CRLF
        
        // Indicador visual
        If nI == 1
            cMsg += "?? 1º LUGAR!" + CRLF
        ElseIf nI == 2
            cMsg += "?? 2º LUGAR" + CRLF
        ElseIf nI == 3
            cMsg += "?? 3º LUGAR" + CRLF
        EndIf
        
        If nI < Min(5, Len(aVendas))
            cMsg += Replicate("-", 30) + CRLF
        EndIf
    Next nI
    
    cMsg += CRLF + "?? Use Min() para limitar top N"
    
    MsgInfo(cMsg, "Top 5")
Return
