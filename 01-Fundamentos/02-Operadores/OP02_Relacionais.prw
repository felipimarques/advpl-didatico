// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} OP02
Exemplos práticos de operadores relacionais em ADVPL

Operadores de comparação:
- == (igual)
- != ou <> ou # (diferente)
- > (maior)
- < (menor)
- >= (maior ou igual)
- <= (menor ou igual)
- $ (contém)

Retornam .T. (verdadeiro) ou .F. (falso)

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_OP02()
/*/

User Function OP02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Operadores Relacionais", ;
                     "1-Igualdade (==)" + CRLF + ;
                     "2-Diferente (!=, <>, #)" + CRLF + ;
                     "3-Maior/Menor (>, <)" + CRLF + ;
                     "4-Maior/Menor igual (>=, <=)" + CRLF + ;
                     "5-Contém ($)" + CRLF + ;
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
EXEMPLO 1: Igualdade ==
*/
Static Function fEx01()
    Local cStatus := "A"
    Local nSaldo := 100
    Local dVenc := Date()
    Local cMsg := ""
    
    cMsg := "? IGUALDADE (==)" + CRLF + CRLF
    
    cMsg += "Status = 'A'" + CRLF
    cMsg += "Status == 'A' ? " + If(cStatus == "A", "SIM", "NÃO") + CRLF
    cMsg += "Status == 'B' ? " + If(cStatus == "B", "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Saldo = 100" + CRLF
    cMsg += "Saldo == 100 ? " + If(nSaldo == 100, "SIM", "NÃO") + CRLF
    cMsg += "Saldo == 0 ? " + If(nSaldo == 0, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Vencimento = " + DtoC(dVenc) + CRLF
    cMsg += "Vence hoje? " + If(dVenc == Date(), "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "?? String: case-sensitive!" + CRLF
    cMsg += "'A' == 'a' ? " + If("A" == "a", "SIM", "NÃO")
    
    MsgInfo(cMsg, "==")
Return

/*
EXEMPLO 2: Diferente (!=, <>, #)
*/
Static Function fEx02()
    Local cTipo := "PA"
    Local lBloq := .F.
    Local cMsg := ""
    
    cMsg := "? DIFERENTE (!=, <>, #)" + CRLF + CRLF
    
    cMsg += "Tipo = 'PA'" + CRLF
    cMsg += "Tipo != 'ME' ? " + If(cTipo != "ME", "SIM", "NÃO") + CRLF
    cMsg += "Tipo <> 'MP' ? " + If(cTipo <> "MP", "SIM", "NÃO") + CRLF
    cMsg += "Tipo # 'PA' ? " + If(cTipo # "PA", "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Bloqueado = .F." + CRLF
    cMsg += "!lBloq ? " + If(!lBloq, "SIM (não bloq)", "NÃO") + CRLF + CRLF
    
    cMsg += "?? TRÊS FORMAS:" + CRLF
    cMsg += "!= (recomendado)" + CRLF
    cMsg += "<> (legado)" + CRLF
    cMsg += "# (legado)" + CRLF + CRLF
    
    cMsg += "Validação típica:" + CRLF
    If !lBloq .And. cTipo == "PA"
        cMsg += "? Cliente pode comprar"
    Else
        cMsg += "? Cliente bloqueado"
    EndIf
    
    MsgInfo(cMsg, "!=")
Return

/*
EXEMPLO 3: Maior e Menor
*/
Static Function fEx03()
    Local nEstoque := 15
    Local nMinimo := 10
    Local nMaximo := 100
    Local dEmiss := Date() - 30
    Local cMsg := ""
    
    cMsg := "???? MAIOR/MENOR (>, <)" + CRLF + CRLF
    
    cMsg += "Estoque: " + cValToChar(nEstoque) + CRLF
    cMsg += "Mínimo: " + cValToChar(nMinimo) + CRLF
    cMsg += "Máximo: " + cValToChar(nMaximo) + CRLF + CRLF
    
    cMsg += "Estoque > Mínimo ? " + If(nEstoque > nMinimo, "SIM", "NÃO") + CRLF
    cMsg += "Estoque < Máximo ? " + If(nEstoque < nMaximo, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Emissão: " + DtoC(dEmiss) + CRLF
    cMsg += "Hoje: " + DtoC(Date()) + CRLF
    cMsg += "Emissão < Hoje ? " + If(dEmiss < Date(), "SIM", "NÃO") + CRLF + CRLF
    
    // Validação
    If nEstoque < nMinimo
        cMsg += "?? ALERTA: Estoque abaixo do mínimo!"
    ElseIf nEstoque > nMaximo
        cMsg += "?? ALERTA: Estoque acima do máximo!"
    Else
        cMsg += "? Estoque OK"
    EndIf
    
    MsgInfo(cMsg, "> <")
Return

/*
EXEMPLO 4: Maior/Menor ou Igual
*/
Static Function fEx04()
    Local nIdade := 18
    Local nSalario := 3000
    Local dVenc := Date()
    Local cMsg := ""
    
    cMsg := "?????? MAIOR/MENOR OU IGUAL (>=, <=)" + CRLF + CRLF
    
    cMsg += "=== VALIDAÇÕES ===" + CRLF + CRLF
    
    // Idade
    cMsg += "Idade: " + cValToChar(nIdade) + CRLF
    If nIdade >= 18
        cMsg += "? Maior de idade" + CRLF
    Else
        cMsg += "? Menor de idade" + CRLF
    EndIf
    cMsg += CRLF
    
    // Salário
    cMsg += "Salário: R$ " + Transform(nSalario, "@E 999,999.99") + CRLF
    If nSalario <= 2000
        cMsg += "?? Faixa: Baixa" + CRLF
    ElseIf nSalario <= 5000
        cMsg += "?? Faixa: Média" + CRLF
    Else
        cMsg += "?? Faixa: Alta" + CRLF
    EndIf
    cMsg += CRLF
    
    // Vencimento
    cMsg += "Vencimento: " + DtoC(dVenc) + CRLF
    If dVenc <= Date()
        cMsg += "? Vencido ou vence hoje!"
    Else
        cMsg += "? Ainda não venceu"
    EndIf
    
    MsgInfo(cMsg, ">= <=")
Return

/*
EXEMPLO 5: Contém ($)
*/
Static Function fEx05()
    Local cProduto := "PA001"
    Local cEmail := "vendas@empresa.com"
    Local cObs := "CLIENTE VIP - PRIORIDADE ENTREGA"
    Local cMsg := ""
    
    cMsg := "?? CONTÉM ($)" + CRLF + CRLF
    
    // Tipo produto
    cMsg += "Código: " + cProduto + CRLF
    If "PA" $ cProduto
        cMsg += "? Produto Acabado" + CRLF
    ElseIf "MP" $ cProduto
        cMsg += "? Matéria Prima" + CRLF
    Else
        cMsg += "? Outro tipo" + CRLF
    EndIf
    cMsg += CRLF
    
    // E-mail
    cMsg += "E-mail: " + cEmail + CRLF
    If "@" $ cEmail .And. "." $ cEmail
        cMsg += "? Formato válido" + CRLF
    Else
        cMsg += "? Formato inválido" + CRLF
    EndIf
    cMsg += CRLF
    
    // Observações
    cMsg += "Obs: " + cObs + CRLF
    If "VIP" $ Upper(cObs)
        cMsg += "? Cliente VIP detectado!" + CRLF
    EndIf
    If "PRIORIDADE" $ Upper(cObs)
        cMsg += "?? Entrega prioritária!" + CRLF
    EndIf
    cMsg += CRLF
    
    cMsg += "?? $ verifica se texto contém"
    
    MsgInfo(cMsg, "$")
Return
