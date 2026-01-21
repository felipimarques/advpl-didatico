// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR06
Exemplos práticos da função Len() em situações reais do Protheus

A função Len() retorna o tamanho (comprimento) de strings e é fundamental para:
- Validar tamanho mínimo/máximo de campos
- Verificar se senha atende requisitos
- Validar CPF, CNPJ, telefone (quantidade de dígitos)
- Limitar entrada de texto em campos
- Processar dados de tamanho fixo

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs Len(c) = Retorna quantidade de caracteres
@obs Len(a) = Retorna quantidade de elementos de array
@obs Conta espaços em branco também!

@example
U_STR06()

@see
https://tdn.totvs.com/display/tec/Len
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR06()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Validar CPF/CNPJ
            Case nOpcao == 2
                fEx02()  // Validar senha forte
            Case nOpcao == 3
                fEx03()  // Limitar entrada de texto
            Case nOpcao == 4
                fEx04()  // Validar telefone
            Case nOpcao == 5
                fEx05()  // Processar arquivo layout fixo
        EndCase
    EndDo
    
    RestArea(aArea)
Return

// ==========================================================================
// Menu de Seleção
// ==========================================================================
Static Function fMenuEx()
    Local nOpcao := 0
    Local aOpcoes := {}
    
    aAdd(aOpcoes, "1 - Validar CPF/CNPJ")
    aAdd(aOpcoes, "2 - Validar senha forte")
    aAdd(aOpcoes, "3 - Limitar entrada de texto")
    aAdd(aOpcoes, "4 - Validar telefone")
    aAdd(aOpcoes, "5 - Processar layout fixo")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("Len() - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Validar CPF/CNPJ (Cadastros SA1/SA2)
// ==========================================================================
/*
SITUAÇÃO REAL:
CPF deve ter 11 dígitos, CNPJ deve ter 14 dígitos.
Use Len() para identificar qual é e validar tamanho.
*/
Static Function fEx01()
    Local aDocs  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cDoc   := ""
    Local nLen   := 0
    
    // Simula documentos digitados (sem formatação)
    aAdd(aDocs, "12345678900")       // CPF correto
    aAdd(aDocs, "1234567890")        // CPF incompleto
    aAdd(aDocs, "12345678000195")    // CNPJ correto
    aAdd(aDocs, "123456780001")      // CNPJ incompleto
    aAdd(aDocs, "123")               // Inválido
    
    cMsg := "?? VALIDAÇÃO DE CPF/CNPJ POR TAMANHO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aDocs)
        cDoc := AllTrim(aDocs[nI])
        nLen := Len(cDoc)
        
        cMsg += cValToChar(nI) + ". Documento: " + cDoc + CRLF
        cMsg += "   Tamanho: " + cValToChar(nLen) + " dígitos" + CRLF
        cMsg += "   " + fVldDoc(cDoc) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   cCGC := AllTrim(M->A1_CGC)" + CRLF + CRLF
    cMsg += "   Do Case" + CRLF
    cMsg += "      Case Len(cCGC) == 11" + CRLF
    cMsg += "         // É CPF - validar dígitos" + CRLF
    cMsg += "         lValido := fValidaCPF(cCGC)" + CRLF + CRLF
    cMsg += "      Case Len(cCGC) == 14" + CRLF
    cMsg += "         // É CNPJ - validar dígitos" + CRLF
    cMsg += "         lValido := fValidaCNPJ(cCGC)" + CRLF + CRLF
    cMsg += "      Otherwise" + CRLF
    cMsg += "         MsgStop('Documento inválido!')" + CRLF
    cMsg += "         lValido := .F." + CRLF
    cMsg += "   EndCase"
    
    MsgInfo(cMsg, "Len() - CPF/CNPJ")
Return

Static Function fVldDoc(cDoc)
    Local nLen := Len(cDoc)
    Local cResult := ""
    
    Do Case
        Case nLen == 11
            cResult := "? CPF - Tamanho correto"
        Case nLen == 14
            cResult := "? CNPJ - Tamanho correto"
        Case nLen < 11
            cResult := "? INVÁLIDO - Muito curto"
        Case nLen == 12 .Or. nLen == 13
            cResult := "? INVÁLIDO - CPF ou CNPJ incompleto"
        Otherwise
            cResult := "? INVÁLIDO - Tamanho incorreto"
    EndCase
Return cResult

// ==========================================================================
// Exemplo 2: Validar Senha Forte (Login/Segurança)
// ==========================================================================
/*
SITUAÇÃO REAL:
Senhas devem ter requisitos mínimos:
- Mínimo 8 caracteres
- Máximo 20 caracteres
- Recomendado: 12+ caracteres

Use Len() para validar antes de gravar.
*/
Static Function fEx02()
    Local aSenhas := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cSenha  := ""
    Local nLen    := 0
    
    // Simula senhas digitadas
    aAdd(aSenhas, "123")              // Muito curta
    aAdd(aSenhas, "Senha123")         // Mínima (8 chars)
    aAdd(aSenhas, "Senh@Fort3!")      // Boa (12 chars)
    aAdd(aSenhas, "MinhaS3nh@Supe rForte2026")  // Muito longa
    aAdd(aSenhas, "A1b2C3d4")         // Mínima
    
    cMsg := "?? VALIDAÇÃO DE SENHA FORTE" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aSenhas)
        cSenha := aSenhas[nI]
        nLen   := Len(cSenha)
        
        cMsg += cValToChar(nI) + ". Senha: " + cSenha + CRLF
        cMsg += "   Tamanho: " + cValToChar(nLen) + " caracteres" + CRLF
        cMsg += "   " + fVldSenha(cSenha) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO CADASTRO:" + CRLF
    cMsg += "   Static Function fVldSenha()" + CRLF
    cMsg += "      Local cSenha := M->SENHA" + CRLF
    cMsg += "      Local nLen   := Len(AllTrim(cSenha))" + CRLF + CRLF
    cMsg += "      If nLen < 8" + CRLF
    cMsg += "         Help(,,'SENHA',,'Mín 8 caracteres!',1)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "      If nLen > 20" + CRLF
    cMsg += "         Help(,,'SENHA',,'Máx 20 caracteres!',1)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "   Return .T."
    
    MsgInfo(cMsg, "Len() - Senha")
Return

Static Function fVldSenha(cSenha)
    Local nLen := Len(cSenha)
    Local cResult := ""
    
    Do Case
        Case nLen < 8
            cResult := "? FRACA - Mínimo 8 caracteres"
        Case nLen >= 8 .And. nLen < 12
            cResult := "?? REGULAR - Recomendado 12+"
        Case nLen >= 12 .And. nLen <= 20
            cResult := "? FORTE - Tamanho ideal!"
        Otherwise
            cResult := "? MUITO LONGA - Máximo 20 caracteres"
    EndCase
Return cResult

// ==========================================================================
// Exemplo 3: Limitar Entrada de Texto (Valid de Campos)
// ==========================================================================
/*
SITUAÇÃO REAL:
Campos têm tamanhos máximos definidos no dicionário.
Use Len() para validar ANTES do usuário sair do campo.
Evita erro "String size overflow".
*/
Static Function fEx03()
    Local aCampos := {}
    Local cMsg    := ""
    Local nI      := 0
    
    // Simula campos com limites (Nome do campo, Valor, Tamanho máximo)
    aAdd(aCampos, {"A1_NOME",  "EMPRESA ABC LTDA",                40})
    aAdd(aCampos, {"A1_NREDUZ", "EMPRESA ABC",                     20})
    aAdd(aCampos, {"A1_END",   "RUA DAS FLORES NUMERO 1234 APT 501 BLOCO B CENTRO", 60})
    aAdd(aCampos, {"A1_BAIRRO", "CENTRO",                          30})
    aAdd(aCampos, {"A1_MUN",   "SAO PAULO",                        30})
    
    cMsg := "?? LIMITAÇÃO DE ENTRADA DE TEXTO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aCampos)
        cMsg += "Campo: " + aCampos[nI][1] + CRLF
        cMsg += "Valor: " + aCampos[nI][2] + CRLF
        cMsg += "Digitado: " + cValToChar(Len(aCampos[nI][2])) + " chars" + CRLF
        cMsg += "Limite: " + cValToChar(aCampos[nI][3]) + " chars" + CRLF
        cMsg += "Status: " + fVldTam(aCampos[nI][2], aCampos[nI][3]) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO EM TELA:" + CRLF
    cMsg += "   // Valid do campo A1_NOME" + CRLF
    cMsg += "   Static Function fVldNome()" + CRLF
    cMsg += "      Local cNome := M->A1_NOME" + CRLF
    cMsg += "      Local nTam  := TamSX3('A1_NOME')[1]" + CRLF + CRLF
    cMsg += "      If Len(AllTrim(cNome)) > nTam" + CRLF
    cMsg += "         cMsg := 'Nome muito longo! '" + CRLF
    cMsg += "         cMsg += 'Máximo: ' + cValToChar(nTam)" + CRLF
    cMsg += "         MsgStop(cMsg)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "   Return .T."
    
    MsgInfo(cMsg, "Len() - Limites")
Return

Static Function fVldTam(cTexto, nMax)
    Local nLen := Len(cTexto)
    
    If nLen <= nMax
        Return "? OK - Dentro do limite"
    Else
        Return "? EXCEDEU - " + cValToChar(nLen - nMax) + " chars a mais"
    EndIf
Return

// ==========================================================================
// Exemplo 4: Validar Telefone (Formatação)
// ==========================================================================
/*
SITUAÇÃO REAL:
Telefones têm tamanhos específicos:
- Fixo: (11) 1234-5678 = 10 dígitos
- Celular: (11) 91234-5678 = 11 dígitos (9º dígito)

Use Len() para identificar tipo e validar.
*/
Static Function fEx04()
    Local aTels  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cTel   := ""
    Local nLen   := 0
    
    // Simula telefones (só números)
    aAdd(aTels, "1112345678")      // Fixo SP (10 dígitos)
    aAdd(aTels, "11912345678")     // Celular SP (11 dígitos)
    aAdd(aTels, "119123456")       // Incompleto
    aAdd(aTels, "21987654321")     // Celular RJ
    aAdd(aTels, "4733221100")      // Fixo SC
    
    cMsg := "?? VALIDAÇÃO DE TELEFONE" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aTels)
        cTel := aTels[nI]
        nLen := Len(cTel)
        
        cMsg += cValToChar(nI) + ". " + fFormatTel(cTel) + CRLF
        cMsg += "   Dígitos: " + cValToChar(nLen) + CRLF
        cMsg += "   " + fVldTel(cTel) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   cTel := StrTran(M->A1_TEL,'-','')" + CRLF
    cMsg += "   cTel := StrTran(cTel,'(','')" + CRLF
    cMsg += "   cTel := StrTran(cTel,')' ,'')" + CRLF
    cMsg += "   cTel := StrTran(cTel,' ','')" + CRLF + CRLF
    cMsg += "   nLen := Len(cTel)" + CRLF + CRLF
    cMsg += "   If nLen < 10 .Or. nLen > 11" + CRLF
    cMsg += "      MsgStop('Telefone inválido!')" + CRLF
    cMsg += "      Return .F." + CRLF
    cMsg += "   EndIf"
    
    MsgInfo(cMsg, "Len() - Telefone")
Return

Static Function fVldTel(cTel)
    Local nLen := Len(cTel)
    Local cResult := ""
    
    Do Case
        Case nLen == 10
            cResult := "? FIXO - 10 dígitos"
        Case nLen == 11
            cResult := "? CELULAR - 11 dígitos (9º dígito)"
        Case nLen < 10
            cResult := "? INCOMPLETO - Faltam dígitos"
        Otherwise
            cResult := "? INVÁLIDO - Muitos dígitos"
    EndCase
Return cResult

Static Function fFormatTel(cTel)
    Local nLen := Len(cTel)
    Local cFormat := ""
    
    If nLen == 10
        // (11) 1234-5678
        cFormat := "(" + SubStr(cTel,1,2) + ") "
        cFormat += SubStr(cTel,3,4) + "-"
        cFormat += SubStr(cTel,7,4)
    ElseIf nLen == 11
        // (11) 91234-5678
        cFormat := "(" + SubStr(cTel,1,2) + ") "
        cFormat += SubStr(cTel,3,5) + "-"
        cFormat += SubStr(cTel,8,4)
    Else
        cFormat := cTel + " (formato inválido)"
    EndIf
Return cFormat

// ==========================================================================
// Exemplo 5: Processar Arquivo Layout Fixo (Integração)
// ==========================================================================
/*
SITUAÇÃO REAL:
Arquivos de layout fixo têm tamanhos exatos por campo:
- Código: posições 1-15 (15 chars)
- Descrição: posições 16-55 (40 chars)
- Preço: posições 56-70 (15 chars)

Use Len() para validar antes de processar.
*/
Static Function fEx05()
    Local aLinhas := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cLinha  := ""
    Local nLen    := 0
    Local nErros  := 0
    
    // Simula linhas de arquivo (tamanho correto = 70 chars)
    aAdd(aLinhas, "PA0001         NOTEBOOK DELL INSPIRON 15              0000000005500.00")
    aAdd(aLinhas, "PA0002         MOUSE LOGITECH MX MASTER 3             0000000000450.00")
    aAdd(aLinhas, "PA0003         TECLADO MECANICO")  // Incompleta!
    aAdd(aLinhas, "PA0004         MONITOR LG 27 ULTRAWIDE                0000000002100.00")
    
    cMsg := "?? VALIDAÇÃO DE LAYOUT FIXO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Layout esperado: 70 caracteres" + CRLF
    cMsg += "  Código: 1-15 (15 chars)" + CRLF
    cMsg += "  Descrição: 16-55 (40 chars)" + CRLF
    cMsg += "  Preço: 56-70 (15 chars)" + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aLinhas)
        cLinha := aLinhas[nI]
        nLen   := Len(cLinha)
        
        cMsg += "Linha " + cValToChar(nI) + ": "
        
        If nLen == 70
            cMsg += "? OK (" + cValToChar(nLen) + " chars)" + CRLF
        Else
            cMsg += "? ERRO (" + cValToChar(nLen) + " chars)" + CRLF
            nErros++
        EndIf
    Next nI
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "Total de linhas: " + cValToChar(Len(aLinhas)) + CRLF
    cMsg += "Linhas com erro: " + cValToChar(nErros) + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? PROCESSAMENTO NO PROTHEUS:" + CRLF
    cMsg += "   FT_FUse(cArquivo)" + CRLF
    cMsg += "   FT_FGoTop()" + CRLF + CRLF
    cMsg += "   While !FT_FEof()" + CRLF
    cMsg += "      cLinha := FT_FReadLn()" + CRLF + CRLF
    cMsg += "      // Valida tamanho" + CRLF
    cMsg += "      If Len(cLinha) <> 70" + CRLF
    cMsg += "         cLog += 'Linha '+ cValToChar(nLin)" + CRLF
    cMsg += "         cLog += ' tamanho incorreto!'" + CRLF
    cMsg += "         FT_FSkip()" + CRLF
    cMsg += "         Loop" + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "      // Processa linha..." + CRLF
    cMsg += "      cCodigo := SubStr(cLinha, 1, 15)" + CRLF
    cMsg += "      cDesc   := SubStr(cLinha, 16, 40)" + CRLF
    cMsg += "      cPreco  := SubStr(cLinha, 56, 15)" + CRLF + CRLF
    cMsg += "      FT_FSkip()" + CRLF
    cMsg += "   EndDo" + CRLF
    cMsg += "   FT_FUse()"
    
    MsgInfo(cMsg, "Len() - Layout Fixo")
Return
