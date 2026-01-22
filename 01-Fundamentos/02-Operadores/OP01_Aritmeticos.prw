// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} OP01
Exemplos práticos de operadores aritméticos em ADVPL

Operadores disponíveis:
- + (adição)
- - (subtração)
- * (multiplicação)
- / (divisão)
- % (módulo/resto)
- ** ou ^ (potência)
- ++ (incremento)
- -- (decremento)

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_OP01()
/*/

User Function OP01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Operadores Aritméticos", ;
                     "1-Básicos (+, -, *, /)" + CRLF + ;
                     "2-Módulo (resto)" + CRLF + ;
                     "3-Potência (** ou ^)" + CRLF + ;
                     "4-Incremento/Decremento" + CRLF + ;
                     "5-Cálculos ERP" + CRLF + ;
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
EXEMPLO 1: Operadores Básicos
*/
Static Function fEx01()
    Local nA := 100
    Local nB := 30
    Local cMsg := ""
    
    cMsg := "?? OPERADORES BÁSICOS" + CRLF + CRLF
    cMsg += "A = " + cValToChar(nA) + CRLF
    cMsg += "B = " + cValToChar(nB) + CRLF + CRLF
    
    cMsg += "A + B = " + cValToChar(nA + nB) + CRLF
    cMsg += "A - B = " + cValToChar(nA - nB) + CRLF
    cMsg += "A * B = " + cValToChar(nA * nB) + CRLF
    cMsg += "A / B = " + cValToChar(nA / nB) + CRLF + CRLF
    
    cMsg += "?? Divisão por zero = erro fatal!"
    
    MsgInfo(cMsg, "+ - * /")
Return

/*
EXEMPLO 2: Módulo (Resto da Divisão)
*/
Static Function fEx02()
    Local nTotal := 127
    Local nParcelas := 10
    Local nValorParc := 0
    Local nResto := 0
    Local cMsg := ""
    
    nValorParc := Int(nTotal / nParcelas)
    nResto := nTotal % nParcelas
    
    cMsg := "? MÓDULO (RESTO)" + CRLF + CRLF
    cMsg += "Total: R$ " + Transform(nTotal, "@E 999.99") + CRLF
    cMsg += "Parcelas: " + cValToChar(nParcelas) + CRLF + CRLF
    
    cMsg += "Valor por parcela: R$ " + Transform(nValorParc, "@E 999.99") + CRLF
    cMsg += "Resto (centavos): R$ " + Transform(nResto, "@E 999.99") + CRLF + CRLF
    
    cMsg += "?? APLICAÇÃO:" + CRLF
    cMsg += "• 9 parcelas de R$ " + Transform(nValorParc, "@E 999.99") + CRLF
    cMsg += "• 1 parcela de R$ " + Transform(nValorParc + nResto, "@E 999.99") + CRLF + CRLF
    
    cMsg += "?? Módulo resolve arredondamento"
    
    MsgInfo(cMsg, "Módulo %")
Return

/*
EXEMPLO 3: Potência
*/
Static Function fEx03()
    Local nBase := 2
    Local nExp := 10
    Local nResult := 0
    Local cMsg := ""
    
    nResult := nBase ** nExp  // ou nBase ^ nExp
    
    cMsg := "?? POTÊNCIA" + CRLF + CRLF
    cMsg += "2 ** 10 = " + cValToChar(nResult) + CRLF
    cMsg += "2 ^ 10 = " + cValToChar(nBase ^ nExp) + CRLF + CRLF
    
    cMsg += "EXEMPLOS:" + CRLF
    cMsg += "2 ** 8 = " + cValToChar(2**8) + " (256 bytes)" + CRLF
    cMsg += "10 ** 2 = " + cValToChar(10**2) + " (área 10x10)" + CRLF
    cMsg += "10 ** 3 = " + cValToChar(10**3) + " (litros?m³)" + CRLF + CRLF
    
    cMsg += "?? Use ** ou ^"
    
    MsgInfo(cMsg, "Potência")
Return

/*
EXEMPLO 4: Incremento e Decremento
*/
Static Function fEx04()
    Local nCont := 0
    Local nEstoque := 100
    Local cMsg := ""
    
    cMsg := "?? INCREMENTO/DECREMENTO" + CRLF + CRLF
    
    // Incremento
    cMsg += "=== INCREMENTO (++) ===" + CRLF
    cMsg += "Contador inicial: " + cValToChar(nCont) + CRLF
    nCont++
    cMsg += "Após nCont++: " + cValToChar(nCont) + CRLF
    nCont++
    cMsg += "Após nCont++: " + cValToChar(nCont) + CRLF + CRLF
    
    // Decremento
    cMsg += "=== DECREMENTO (--) ===" + CRLF
    cMsg += "Estoque inicial: " + cValToChar(nEstoque) + CRLF
    nEstoque--
    cMsg += "Após venda (--): " + cValToChar(nEstoque) + CRLF
    nEstoque -= 10  // Equivalente
    cMsg += "Após venda (-=10): " + cValToChar(nEstoque) + CRLF + CRLF
    
    cMsg += "?? nCont++ = nCont := nCont + 1"
    
    MsgInfo(cMsg, "++ --")
Return

/*
EXEMPLO 5: Cálculos Reais de ERP
*/
Static Function fEx05()
    Local nQtde    := 10
    Local nPreco   := 125.50
    Local nDescPer := 10  // 10%
    Local nIPI     := 5       // 5%
    Local nBruto   := 0
    Local nDesc    := 0
    Local nLiquido := 0
    Local nImposto := 0
    Local nTotal   := 0
    Local cMsg     := ""
    
    // Cálculo passo a passo
    nBruto   := nQtde * nPreco
    nDesc    := nBruto * (nDescPer / 100)
    nLiquido := nBruto - nDesc
    nImposto := nLiquido * (nIPI / 100)
    nTotal   := nLiquido + nImposto
    
    cMsg := "?? CÁLCULO DE PEDIDO" + CRLF + CRLF
    
    cMsg += "Quantidade: " + cValToChar(nQtde) + CRLF
    cMsg += "Preço unit: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF
    cMsg += "Desconto: " + cValToChar(nDescPer) + "%" + CRLF
    cMsg += "IPI: " + cValToChar(nIPI) + "%" + CRLF + CRLF
    
    cMsg += "=== CÁLCULO ===" + CRLF
    cMsg += "Valor bruto: R$ " + Transform(nBruto, "@E 999,999.99") + CRLF
    cMsg += "(-) Desconto: R$ " + Transform(nDesc, "@E 999,999.99") + CRLF
    cMsg += "(=) Líquido: R$ " + Transform(nLiquido, "@E 999,999.99") + CRLF
    cMsg += "(+) IPI: R$ " + Transform(nImposto, "@E 999,999.99") + CRLF
    cMsg += "(=) TOTAL: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Ordem: * e / antes de + e -"
    
    MsgInfo(cMsg, "Cálculo ERP")
Return
