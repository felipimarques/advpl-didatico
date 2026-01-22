// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} OP04
Exemplos práticos de operadores de atribuição em ADVPL

Operadores de atribuição:
- := (atribuição simples)
- += (soma e atribui)
- -= (subtrai e atribui)
- *= (multiplica e atribui)
- /= (divide e atribui)
- ++ (incremento)
- -- (decremento)

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_OP04()
/*/

User Function OP04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Operadores de Atribuição", ;
                     "1-:= (atribuição)" + CRLF + ;
                     "2-+= (soma e atribui)" + CRLF + ;
                     "3--= (subtrai e atribui)" + CRLF + ;
                     "4-*= /= (mult/div e atribui)" + CRLF + ;
                     "5-++ -- (incr/decr)" + CRLF + ;
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
EXEMPLO 1: := (Atribuição Simples)
*/
Static Function fEx01()
    Local cProduto := ""
    Local nPreco := 0
    Local lAtivo := .F.
    Local dCadastro := CToD("")
    Local cMsg := ""
    
    cMsg := "?? ATRIBUIÇÃO SIMPLES (:=)" + CRLF + CRLF
    
    cMsg += "=== INICIALIZAÇÃO ===" + CRLF
    cMsg += "Local cProduto := ''" + CRLF
    cMsg += "Local nPreco := 0" + CRLF
    cMsg += "Local lAtivo := .F." + CRLF
    cMsg += "Local dCadastro := CToD('')" + CRLF + CRLF
    
    // Atribui valores
    cProduto := "PA001"
    nPreco := 125.50
    lAtivo := .T.
    dCadastro := Date()
    
    cMsg += "=== APÓS ATRIBUIÇÃO ===" + CRLF
    cMsg += "cProduto := 'PA001'" + CRLF
    cMsg += "Resultado: " + cProduto + CRLF + CRLF
    
    cMsg += "nPreco := 125.50" + CRLF
    cMsg += "Resultado: " + cValToChar(nPreco) + CRLF + CRLF
    
    cMsg += "lAtivo := .T." + CRLF
    cMsg += "Resultado: " + If(lAtivo, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "dCadastro := Date()" + CRLF
    cMsg += "Resultado: " + DtoC(dCadastro) + CRLF + CRLF
    
    cMsg += "?? := é o operador básico"
    
    MsgInfo(cMsg, ":=")
Return

/*
EXEMPLO 2: += (Soma e Atribui)
*/
Static Function fEx02()
    Local nTotal := 0
    Local cNome := ""
    Local cMsg := ""
    
    cMsg := "? += (SOMA E ATRIBUI)" + CRLF + CRLF
    
    // Acumular valores
    cMsg += "=== ACUMULAR VENDAS ===" + CRLF
    cMsg += "Total inicial: " + cValToChar(nTotal) + CRLF + CRLF
    
    nTotal += 100
    cMsg += "nTotal += 100" + CRLF
    cMsg += "Total: " + cValToChar(nTotal) + CRLF + CRLF
    
    nTotal += 250.50
    cMsg += "nTotal += 250.50" + CRLF
    cMsg += "Total: " + cValToChar(nTotal) + CRLF + CRLF
    
    nTotal += 75.25
    cMsg += "nTotal += 75.25" + CRLF
    cMsg += "Total: " + cValToChar(nTotal) + CRLF + CRLF
    
    // Concatenar strings
    cMsg += "=== CONCATENAR STRINGS ===" + CRLF
    cNome := "PRODUTO"
    cMsg += "Inicial: " + cNome + CRLF + CRLF
    
    cNome += " "
    cNome += "ACABADO"
    cMsg += "cNome += ' ACABADO'" + CRLF
    cMsg += "Resultado: " + cNome + CRLF + CRLF
    
    cMsg += "?? += evita repetir variável"
    
    MsgInfo(cMsg, "+=")
Return

/*
EXEMPLO 3: -= (Subtrai e Atribui)
*/
Static Function fEx03()
    Local nEstoque := 100
    Local nSaldo := 5000
    Local cMsg := ""
    
    cMsg := "? -= (SUBTRAI E ATRIBUI)" + CRLF + CRLF
    
    cMsg += "=== MOVIMENTAÇÃO ESTOQUE ===" + CRLF
    cMsg += "Estoque inicial: " + cValToChar(nEstoque) + CRLF + CRLF
    
    // Venda 1
    nEstoque -= 10
    cMsg += "Venda 10 un (nEstoque -= 10)" + CRLF
    cMsg += "Estoque: " + cValToChar(nEstoque) + CRLF + CRLF
    
    // Venda 2
    nEstoque -= 25
    cMsg += "Venda 25 un (nEstoque -= 25)" + CRLF
    cMsg += "Estoque: " + cValToChar(nEstoque) + CRLF + CRLF
    
    // Venda 3
    nEstoque -= 5
    cMsg += "Venda 5 un (nEstoque -= 5)" + CRLF
    cMsg += "Estoque: " + cValToChar(nEstoque) + CRLF + CRLF
    
    cMsg += "=== PAGAMENTO ===" + CRLF
    cMsg += "Saldo inicial: R$ " + Transform(nSaldo, "@E 999,999.99") + CRLF
    nSaldo -= 1250.50
    cMsg += "Pagamento (nSaldo -= 1250.50)" + CRLF
    cMsg += "Novo saldo: R$ " + Transform(nSaldo, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? -= para baixas e saídas"
    
    MsgInfo(cMsg, "-=")
Return

/*
EXEMPLO 4: *= e /= (Multiplica/Divide e Atribui)
*/
Static Function fEx04()
    Local nPreco := 100
    Local nQuantidade := 8
    Local cMsg := ""
    
    cMsg := "??? *= e /= (MULT/DIV E ATRIBUI)" + CRLF + CRLF
    
    // Multiplicação
    cMsg += "=== REAJUSTE DE PREÇO ===" + CRLF
    cMsg += "Preço atual: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF + CRLF
    
    nPreco *= 1.10  // Aumenta 10%
    cMsg += "Reajuste 10% (nPreco *= 1.10)" + CRLF
    cMsg += "Novo preço: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF + CRLF
    
    nPreco *= 1.05  // Aumenta 5%
    cMsg += "Reajuste 5% (nPreco *= 1.05)" + CRLF
    cMsg += "Novo preço: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF + CRLF
    
    // Divisão
    cMsg += "=== RATEIO ===" + CRLF
    cMsg += "Total: " + cValToChar(nQuantidade) + " itens" + CRLF + CRLF
    
    nQuantidade /= 2  // Divide por 2
    cMsg += "Divide por 2 (nQuantidade /= 2)" + CRLF
    cMsg += "Resultado: " + cValToChar(nQuantidade) + CRLF + CRLF
    
    cMsg += "?? *= para reajustes" + CRLF
    cMsg += "?? /= para rateios"
    
    MsgInfo(cMsg, "*= /=")
Return

/*
EXEMPLO 5: ++ e -- (Incremento/Decremento)
*/
Static Function fEx05()
    Local nContador := 0
    Local nLinha := 10
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? ++ e -- (INCREMENTO/DECREMENTO)" + CRLF + CRLF
    
    // Incremento
    cMsg += "=== CONTADOR ===" + CRLF
    cMsg += "Inicial: " + cValToChar(nContador) + CRLF + CRLF
    
    For nI := 1 To 5
        nContador++
        cMsg += "nContador++ = " + cValToChar(nContador) + CRLF
    Next nI
    
    cMsg += CRLF + "=== DECREMENTO ===" + CRLF
    cMsg += "Linha inicial: " + cValToChar(nLinha) + CRLF + CRLF
    
    nLinha--
    cMsg += "nLinha-- = " + cValToChar(nLinha) + CRLF
    nLinha--
    cMsg += "nLinha-- = " + cValToChar(nLinha) + CRLF
    nLinha--
    cMsg += "nLinha-- = " + cValToChar(nLinha) + CRLF + CRLF
    
    cMsg += "=== EQUIVALÊNCIAS ===" + CRLF
    cMsg += "nCont++ é igual a nCont += 1" + CRLF
    cMsg += "nCont-- é igual a nCont -= 1" + CRLF + CRLF
    
    cMsg += "?? Use em loops e contadores"
    
    MsgInfo(cMsg, "++ --")
Return
