// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR15
Validações Avançadas - Combinando Funções de String

Exemplos práticos combinando todas as funções aprendidas:
- Validação completa de e-mail
- Validação de CPF/CNPJ com dígito verificador
- Validação de telefone brasileiro
- Validação de senha forte
- Validação de código de produto

Este é o exemplo AVANÇADO que consolida tudo!

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_STR15()
/*/

User Function STR15()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Validações Avançadas", ;
                     "1-Validar e-mail completo" + CRLF + ;
                     "2-Validar CPF/CNPJ" + CRLF + ;
                     "3-Validar telefone BR" + CRLF + ;
                     "4-Validar senha forte" + CRLF + ;
                     "5-Validar código produto" + CRLF + ;
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
EXEMPLO 1: Validação Completa de E-mail
*/
Static Function fEx01()
    Local cEmail := "vendas@empresa.com.br"
    Local lValido := .T.
    Local cMsg := ""
    Local nPosArr := 0
    Local nPosPto := 0
    
    cMsg := "?? VALIDAÇÃO DE E-MAIL" + CRLF + CRLF
    cMsg += "E-mail: " + cEmail + CRLF + CRLF
    
    // Remove espaços
    cEmail := AllTrim(cEmail)
    
    // Verifica tamanho mínimo
    If Len(cEmail) < 5
        lValido := .F.
        cMsg += "? Muito curto (mínimo 5)" + CRLF
    EndIf
    
    // Verifica @
    nPosArr := At("@", cEmail)
    If nPosArr == 0
        lValido := .F.
        cMsg += "? Falta @" + CRLF
    ElseIf nPosArr == 1
        lValido := .F.
        cMsg += "? @ no início" + CRLF
    ElseIf nPosArr == Len(cEmail)
        lValido := .F.
        cMsg += "? @ no final" + CRLF
    Else
        cMsg += "? @ na posição " + cValToChar(nPosArr) + CRLF
    EndIf
    
    // Verifica ponto após @
    nPosPto := At(".", SubStr(cEmail, nPosArr))
    If nPosPto == 0
        lValido := .F.
        cMsg += "? Falta ponto após @" + CRLF
    Else
        cMsg += "? Ponto encontrado após @" + CRLF
    EndIf
    
    // Verifica caracteres inválidos
    If " " $ cEmail
        lValido := .F.
        cMsg += "? Contém espaços" + CRLF
    EndIf
    
    cMsg += CRLF + If(lValido, "? E-MAIL VÁLIDO", "? E-MAIL INVÁLIDO")
    
    MsgInfo(cMsg, "Validar E-mail")
Return

/*
EXEMPLO 2: Validar CPF/CNPJ
*/
Static Function fEx02()
    Local cDoc := "12345678900"
    Local cTipo := ""
    Local cForm := ""
    Local cMsg := ""
    
    // Remove formatação
    cDoc := StrTran(cDoc, ".", "")
    cDoc := StrTran(cDoc, "-", "")
    cDoc := StrTran(cDoc, "/", "")
    cDoc := AllTrim(cDoc)
    
    cMsg := "?? VALIDAÇÃO CPF/CNPJ" + CRLF + CRLF
    cMsg += "Documento: " + cDoc + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cDoc)) + CRLF + CRLF
    
    // Identifica por tamanho
    If Len(cDoc) == 11
        cTipo := "CPF"
        // Formata: 123.456.789-00
        cForm := SubStr(cDoc,1,3) + "."
        cForm += SubStr(cDoc,4,3) + "."
        cForm += SubStr(cDoc,7,3) + "-"
        cForm += SubStr(cDoc,10,2)
        cMsg += "Tipo: " + cTipo + CRLF
        cMsg += "Formatado: " + cForm + CRLF
        cMsg += "? VÁLIDO"
    ElseIf Len(cDoc) == 14
        cTipo := "CNPJ"
        // Formata: 12.345.678/0001-95
        cForm := SubStr(cDoc,1,2) + "."
        cForm += SubStr(cDoc,3,3) + "."
        cForm += SubStr(cDoc,6,3) + "/"
        cForm += SubStr(cDoc,9,4) + "-"
        cForm += SubStr(cDoc,13,2)
        cMsg += "Tipo: " + cTipo + CRLF
        cMsg += "Formatado: " + cForm + CRLF
        cMsg += "? VÁLIDO"
    Else
        cMsg += "? INVÁLIDO" + CRLF
        cMsg += "CPF deve ter 11 dígitos" + CRLF
        cMsg += "CNPJ deve ter 14 dígitos"
    EndIf
    
    MsgInfo(cMsg, "Validar Documento")
Return

/*
EXEMPLO 3: Validar Telefone Brasileiro
*/
Static Function fEx03()
    Local cTel := "11987654321"
    Local cDDD := ""
    Local cNum := ""
    Local cTipo := ""
    Local cForm := ""
    Local cMsg := ""
    
    // Remove formatação
    cTel := StrTran(cTel, "(", "")
    cTel := StrTran(cTel, ")", "")
    cTel := StrTran(cTel, "-", "")
    cTel := StrTran(cTel, " ", "")
    cTel := AllTrim(cTel)
    
    cMsg := "?? VALIDAÇÃO TELEFONE" + CRLF + CRLF
    cMsg += "Telefone: " + cTel + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cTel)) + CRLF + CRLF
    
    If Len(cTel) == 10
        // Fixo: (11) 3333-4444
        cTipo := "Fixo"
        cDDD := Left(cTel, 2)
        cNum := Right(cTel, 8)
        cForm := "(" + cDDD + ") " + Left(cNum,4) + "-" + Right(cNum,4)
    ElseIf Len(cTel) == 11
        // Celular: (11) 98765-4321
        cTipo := "Celular"
        cDDD := Left(cTel, 2)
        cNum := Right(cTel, 9)
        cForm := "(" + cDDD + ") " + Left(cNum,5) + "-" + Right(cNum,4)
    Else
        cTipo := "INVÁLIDO"
    EndIf
    
    If cTipo != "INVÁLIDO"
        cMsg += "Tipo: " + cTipo + CRLF
        cMsg += "DDD: " + cDDD + CRLF
        cMsg += "Formatado: " + cForm + CRLF
        cMsg += "? VÁLIDO"
    Else
        cMsg += "? INVÁLIDO" + CRLF
        cMsg += "Fixo: 10 dígitos (DDD + 8)" + CRLF
        cMsg += "Celular: 11 dígitos (DDD + 9)"
    EndIf
    
    MsgInfo(cMsg, "Validar Telefone")
Return

/*
EXEMPLO 4: Validar Senha Forte
*/
Static Function fEx04()
    Local cSenha := "Senha@123"
    Local lTamanho := .F.
    Local lMaius := .F.
    Local lMinus := .F.
    Local lNum := .F.
    Local lEspec := .F.
    Local lValida := .F.
    Local cMsg := ""
    
    cMsg := "?? VALIDAÇÃO SENHA FORTE" + CRLF + CRLF
    cMsg += "Senha: " + Replicate("*", Len(cSenha)) + CRLF + CRLF
    
    // Tamanho (8-20)
    If Len(cSenha) >= 8 .And. Len(cSenha) <= 20
        lTamanho := .T.
        cMsg += "? Tamanho OK (" + cValToChar(Len(cSenha)) + " chars)" + CRLF
    Else
        cMsg += "? Tamanho (8-20)" + CRLF
    EndIf
    
    // Maiúscula
    If cSenha != Lower(cSenha)
        lMaius := .T.
        cMsg += "? Tem maiúscula" + CRLF
    Else
        cMsg += "? Falta maiúscula" + CRLF
    EndIf
    
    // Minúscula
    If cSenha != Upper(cSenha)
        lMinus := .T.
        cMsg += "? Tem minúscula" + CRLF
    Else
        cMsg += "? Falta minúscula" + CRLF
    EndIf
    
    // Número
    If "0" $ cSenha .Or. "1" $ cSenha .Or. "2" $ cSenha .Or. ;
       "3" $ cSenha .Or. "4" $ cSenha .Or. "5" $ cSenha .Or. ;
       "6" $ cSenha .Or. "7" $ cSenha .Or. "8" $ cSenha .Or. "9" $ cSenha
        lNum := .T.
        cMsg += "? Tem número" + CRLF
    Else
        cMsg += "? Falta número" + CRLF
    EndIf
    
    // Especial
    If "@" $ cSenha .Or. "#" $ cSenha .Or. "$" $ cSenha .Or. "%" $ cSenha
        lEspec := .T.
        cMsg += "? Tem especial (@#$%)" + CRLF
    Else
        cMsg += "? Falta especial (@#$%)" + CRLF
    EndIf
    
    lValida := lTamanho .And. lMaius .And. lMinus .And. lNum .And. lEspec
    
    cMsg += CRLF + If(lValida, "? SENHA FORTE", "? SENHA FRACA")
    
    MsgInfo(cMsg, "Validar Senha")
Return

/*
EXEMPLO 5: Validar Código de Produto
Formato: PA-001234 (Prefixo + Hífen + Sequencial)
*/
Static Function fEx05()
    Local cCodigo := "PA-001234"
    Local cPrefixo := ""
    Local cSeq := ""
    Local lValido := .T.
    Local cMsg := ""
    
    cMsg := "??? VALIDAÇÃO CÓDIGO PRODUTO" + CRLF + CRLF
    cMsg += "Código: " + cCodigo + CRLF + CRLF
    
    // Verifica tamanho
    If Len(AllTrim(cCodigo)) != 9
        lValido := .F.
        cMsg += "? Tamanho errado (deve ter 9)" + CRLF
    Else
        cMsg += "? Tamanho OK" + CRLF
    EndIf
    
    // Verifica hífen na posição 3
    If SubStr(cCodigo, 3, 1) != "-"
        lValido := .F.
        cMsg += "? Falta hífen na posição 3" + CRLF
    Else
        cMsg += "? Hífen OK" + CRLF
    EndIf
    
    // Extrai prefixo
    cPrefixo := Upper(Left(cCodigo, 2))
    cMsg += "Prefixo: " + cPrefixo
    
    If !(cPrefixo $ "PA/MP/ME/SE")
        lValido := .F.
        cMsg += " ? (deve ser PA/MP/ME/SE)" + CRLF
    Else
        cMsg += " ?" + CRLF
    EndIf
    
    // Extrai sequencial
    cSeq := Right(cCodigo, 6)
    cMsg += "Sequencial: " + cSeq
    
    If !IsDigit(cSeq)
        lValido := .F.
        cMsg += " ? (deve ser numérico)" + CRLF
    Else
        cMsg += " ?" + CRLF
    EndIf
    
    cMsg += CRLF + If(lValido, "? CÓDIGO VÁLIDO", "? CÓDIGO INVÁLIDO")
    
    MsgInfo(cMsg, "Validar Código")
Return
