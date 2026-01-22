// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} VAR05
Exemplos práticos de conversão entre tipos em ADVPL

Funções de conversão:
- cValToChar() = qualquer tipo ? string
- Val() = string ? número
- CToD() / DtoC() = conversões de data
- Str() = número ? string formatado
- Transform() = formatação avançada

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_VAR05()
/*/

User Function VAR05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Conversões de Tipos", ;
                     "1-Número ? String" + CRLF + ;
                     "2-String ? Número" + CRLF + ;
                     "3-Data (CToD/DtoC)" + CRLF + ;
                     "4-Transform (Picture)" + CRLF + ;
                     "5-Validar tipo (ValType)" + CRLF + ;
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
EXEMPLO 1: Número ? String
*/
Static Function fEx01()
    Local nPedido := 123456
    Local nPreco := 1250.50
    Local lAtivo := .T.
    Local cMsg := ""
    
    cMsg := "?? ? ?? NÚMERO ? STRING" + CRLF + CRLF
    
    // cValToChar (recomendado)
    cMsg += "=== cValToChar() ===" + CRLF
    cMsg += "Pedido: " + cValToChar(nPedido) + CRLF
    cMsg += "Preço: " + cValToChar(nPreco) + CRLF
    cMsg += "Ativo: " + cValToChar(lAtivo) + CRLF + CRLF
    
    // Str (mais controle)
    cMsg += "=== Str() ===" + CRLF
    cMsg += "Str(123, 6): [" + Str(123, 6) + "]" + CRLF
    cMsg += "Str(12.5, 8, 2): [" + Str(12.5, 8, 2) + "]" + CRLF + CRLF
    
    // StrZero (com zeros)
    cMsg += "=== StrZero() ===" + CRLF
    cMsg += "StrZero(123, 6): " + StrZero(123, 6) + CRLF + CRLF
    
    cMsg += "?? Use cValToChar para debug"
    
    MsgInfo(cMsg, "Número ? String")
Return

/*
EXEMPLO 2: String ? Número
*/
Static Function fEx02()
    Local cValor1 := "1250.50"
    Local cValor2 := "100"
    Local cValor3 := "ABC123"
    Local nNum1 := 0
    Local nNum2 := 0
    Local nNum3 := 0
    Local cMsg := ""
    
    // Converte
    nNum1 := Val(cValor1)
    nNum2 := Val(cValor2)
    nNum3 := Val(cValor3)  // Retorna 0
    
    cMsg := "?? ? ?? STRING ? NÚMERO" + CRLF + CRLF
    
    cMsg += "Val('1250.50') = " + cValToChar(nNum1) + CRLF
    cMsg += "Val('100') = " + cValToChar(nNum2) + CRLF
    cMsg += "Val('ABC123') = " + cValToChar(nNum3) + " ?" + CRLF + CRLF
    
    cMsg += "?? ATENÇÃO:" + CRLF
    cMsg += "• Val() retorna 0 se inválido" + CRLF
    cMsg += "• Ponto = decimal (não vírgula)" + CRLF
    cMsg += "• Para vírgula, use StrTran antes" + CRLF + CRLF
    
    // Exemplo vírgula
    Local cBrasil := "1.250,50"
    Local cUS := StrTran(StrTran(cBrasil, ".", ""), ",", ".")
    Local nValor := Val(cUS)
    
    cMsg += "Valor BR: " + cBrasil + CRLF
    cMsg += "Convertido: " + Transform(nValor, "@E 999,999.99")
    
    MsgInfo(cMsg, "String ? Número")
Return

/*
EXEMPLO 3: Conversões de Data
*/
Static Function fEx03()
    Local dHoje := Date()
    Local cData := "15/01/2026"
    Local dConv := CToD(cData)
    Local cMsg := ""
    
    cMsg := "?? CONVERSÕES DE DATA" + CRLF + CRLF
    
    // Date() ? String
    cMsg += "=== DtoC (Date to Char) ===" + CRLF
    cMsg += "Date(): " + DtoC(dHoje) + CRLF
    cMsg += "DtoS(): " + DtoS(dHoje) + " (AAAAMMDD)" + CRLF + CRLF
    
    // String ? Date
    cMsg += "=== CToD (Char to Date) ===" + CRLF
    cMsg += "String: " + cData + CRLF
    cMsg += "CToD: " + DtoC(dConv) + CRLF
    cMsg += "Tipo: " + ValType(dConv) + CRLF + CRLF
    
    // Data vazia
    cMsg += "=== Data Vazia ===" + CRLF
    cMsg += "CToD(''): " + DtoC(CToD("")) + CRLF
    cMsg += "Empty: " + cValToChar(Empty(CToD(""))) + CRLF + CRLF
    
    cMsg += "?? DtoS() útil para SQL ORDER BY"
    
    MsgInfo(cMsg, "Data")
Return

/*
EXEMPLO 4: Transform (Formatação)
*/
Static Function fEx04()
    Local nValor := 1250.50
    Local cCNPJ := "12345678000195"
    Local cCPF := "12345678900"
    Local cTel := "11987654321"
    Local cMsg := ""
    
    cMsg := "?? TRANSFORM (PICTURE)" + CRLF + CRLF
    
    // Valores monetários
    cMsg += "=== VALORES ===" + CRLF
    cMsg += "@E 999,999.99: " + Transform(nValor, "@E 999,999.99") + CRLF
    cMsg += "@E 999,999.999: " + Transform(125.5, "@E 999,999.999") + CRLF + CRLF
    
    // Documentos
    cMsg += "=== DOCUMENTOS ===" + CRLF
    cMsg += "CNPJ: " + Transform(cCNPJ, "@R 99.999.999/9999-99") + CRLF
    cMsg += "CPF: " + Transform(cCPF, "@R 999.999.999-99") + CRLF
    cMsg += "Tel: " + Transform(cTel, "@R (99) 99999-9999") + CRLF + CRLF
    
    // Outros
    cMsg += "=== OUTROS ===" + CRLF
    cMsg += "@!: " + Transform("teste", "@!") + " (maiúscula)" + CRLF
    cMsg += "@R: Máscara fixa" + CRLF
    cMsg += "@E: Valor numérico" + CRLF + CRLF
    
    cMsg += "?? Transform resolve formatação"
    
    MsgInfo(cMsg, "Transform")
Return

/*
EXEMPLO 5: Validar Tipo (ValType)
*/
Static Function fEx05()
    Local xVar1 := "Texto"
    Local xVar2 := 123
    Local xVar3 := .T.
    Local xVar4 := Date()
    Local xVar5 := {}
    Local cMsg := ""
    
    cMsg := "?? VALIDAR TIPO (ValType)" + CRLF + CRLF
    
    cMsg += "Variável 1: '" + cValToChar(xVar1) + "'" + CRLF
    cMsg += "ValType: " + ValType(xVar1) + " (Character)" + CRLF + CRLF
    
    cMsg += "Variável 2: " + cValToChar(xVar2) + CRLF
    cMsg += "ValType: " + ValType(xVar2) + " (Numeric)" + CRLF + CRLF
    
    cMsg += "Variável 3: " + cValToChar(xVar3) + CRLF
    cMsg += "ValType: " + ValType(xVar3) + " (Logical)" + CRLF + CRLF
    
    cMsg += "Variável 4: " + DtoC(xVar4) + CRLF
    cMsg += "ValType: " + ValType(xVar4) + " (Date)" + CRLF + CRLF
    
    cMsg += "Variável 5: {}" + CRLF
    cMsg += "ValType: " + ValType(xVar5) + " (Array)" + CRLF + CRLF
    
    cMsg += "TIPOS:" + CRLF
    cMsg += "C=Character, N=Numeric, L=Logical" + CRLF
    cMsg += "D=Date, A=Array, O=Object, B=Block" + CRLF
    cMsg += "U=Undefined (não existe)" + CRLF + CRLF
    
    cMsg += "?? Use Type() para variáveis inexistentes"
    
    MsgInfo(cMsg, "ValType")
Return
