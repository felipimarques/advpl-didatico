// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR07
Exemplos práticos das funções Left() e Right() em situações reais do Protheus

Left() e Right() extraem caracteres das extremidades de strings:
- Left() pega os primeiros caracteres (da esquerda)
- Right() pega os últimos caracteres (da direita)

Uso comum:
- Extrair código de filial de produtos
- Pegar extensão de arquivos
- Validar prefixos e sufixos
- Extrair dígito verificador
- Processar códigos estruturados

@type User Function
@author Felipi Marques
@since 27/11/2025

@obs Left(c, n) = Pega N caracteres da ESQUERDA
@obs Right(c, n) = Pega N caracteres da DIREITA
@obs Equivalente a SubStr mas mais legível!

@example
U_STR07()

@see
https://tdn.totvs.com/display/tec/Left
https://tdn.totvs.com/display/tec/Right
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR07()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Extrair filial de código
            Case nOpcao == 2
                fEx02()  // Validar extensão de arquivo
            Case nOpcao == 3
                fEx03()  // Extrair dígito verificador
            Case nOpcao == 4
                fEx04()  // Validar prefixo de código
            Case nOpcao == 5
                fEx05()  // Processar ano de competência
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
    
    aAdd(aOpcoes, "1 - Extrair filial de código")
    aAdd(aOpcoes, "2 - Validar extensão arquivo")
    aAdd(aOpcoes, "3 - Extrair dígito verificador")
    aAdd(aOpcoes, "4 - Validar prefixo de código")
    aAdd(aOpcoes, "5 - Processar ano competência")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("Left/Right - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Extrair Filial de Código Estruturado
// ==========================================================================
/*
SITUAÇÃO REAL:
Códigos estruturados: 01PA0001 (Filial + Tipo + Código)
Use Left() para extrair a filial (primeiros 2 dígitos).
*/
Static Function fEx01()
    Local aProd  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cProd  := ""
    Local cFil   := ""
    Local cTipo  := ""
    
    // Simula produtos com código estruturado
    aAdd(aProd, {"01PA0001234", "NOTEBOOK DELL"})
    aAdd(aProd, {"02MP0005678", "MATERIA PRIMA ABC"})
    aAdd(aProd, {"01ME0009999", "MERCADORIA XYZ"})
    aAdd(aProd, {"03PA0001111", "PRODUTO ACABADO 123"})
    
    cMsg := "?? EXTRAÇÃO DE FILIAL COM LEFT()" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aProd)
        cProd := aProd[nI][1]
        
        // Left() pega os primeiros caracteres
        cFil  := Left(cProd, 2)         // 2 primeiros = Filial
        cTipo := SubStr(cProd, 3, 2)    // Posição 3-4 = Tipo
        
        cMsg += "Código: " + cProd + CRLF
        cMsg += "  ?? Filial: " + cFil + " - " + fDesFilial(cFil) + CRLF
        cMsg += "  ?? Tipo: " + cTipo + " - " + fDesTipo(cTipo) + CRLF
        cMsg += "  ?? Produto: " + aProd[nI][2] + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? FILTRO POR FILIAL:" + CRLF
    cMsg += "   cFilFiltro := '01'  // Matriz" + CRLF + CRLF
    cMsg += "   DbSelectArea('SB1')" + CRLF
    cMsg += "   DbGoTop()" + CRLF + CRLF
    cMsg += "   While !SB1->(Eof())" + CRLF
    cMsg += "      // Extrai filial com Left()" + CRLF
    cMsg += "      cFilProd := Left(SB1->B1_COD, 2)" + CRLF + CRLF
    cMsg += "      If cFilProd == cFilFiltro" + CRLF
    cMsg += "         // Adiciona no relatório..." + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "      SB1->(DbSkip())" + CRLF
    cMsg += "   EndDo" + CRLF + CRLF
    cMsg += "   ?? Left() é mais claro que SubStr(x,1,2)!"
    
    MsgInfo(cMsg, "Left() - Filial")
Return

Static Function fDesFilial(cFil)
    Do Case
        Case cFil == "01"
            Return "MATRIZ SP"
        Case cFil == "02"
            Return "FILIAL RJ"
        Case cFil == "03"
            Return "FILIAL MG"
        Otherwise
            Return "FILIAL " + cFil
    EndCase
Return

Static Function fDesTipo(cTipo)
    Do Case
        Case cTipo == "PA"
            Return "PRODUTO ACABADO"
        Case cTipo == "MP"
            Return "MATÉRIA PRIMA"
        Case cTipo == "ME"
            Return "MERCADORIA"
        Otherwise
            Return "TIPO " + cTipo
    EndCase
Return

// ==========================================================================
// Exemplo 2: Validar Extensão de Arquivo (Upload/Importação)
// ==========================================================================
/*
SITUAÇÃO REAL:
Ao fazer upload/importação, validar se arquivo é permitido.
Use Right() para pegar extensão (.pdf, .xml, .csv).
*/
Static Function fEx02()
    Local aArqs  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cArq   := ""
    Local cExt   := ""
    
    // Simula arquivos para upload
    aAdd(aArqs, "NOTA_FISCAL_123.xml")
    aAdd(aArqs, "PRODUTOS.csv")
    aAdd(aArqs, "CONTRATO.pdf")
    aAdd(aArqs, "VIRUS.exe")
    aAdd(aArqs, "CLIENTES.txt")
    aAdd(aArqs, "FOTO_PRODUTO.jpg")
    
    cMsg := "?? VALIDAÇÃO DE EXTENSÃO COM RIGHT()" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Extensões permitidas: .xml, .csv, .pdf, .txt" + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aArqs)
        cArq := aArqs[nI]
        
        // Right() pega os últimos caracteres (extensão)
        cExt := Right(cArq, 4)  // .xxx = 4 caracteres
        
        cMsg += cValToChar(nI) + ". " + cArq + CRLF
        cMsg += "   Extensão: " + cExt + CRLF
        cMsg += "   " + fVldArq(cExt) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO EM UPLOAD:" + CRLF
    cMsg += "   // Botão de upload" + CRLF
    cMsg += "   cArquivo := cGetFile('*.*', 'Selecione')" + CRLF + CRLF
    cMsg += "   If !Empty(cArquivo)" + CRLF
    cMsg += "      // Pega extensão com Right()" + CRLF
    cMsg += "      cExt := Lower(Right(cArquivo, 4))" + CRLF + CRLF
    cMsg += "      If !(cExt $ '.xml/.csv/.pdf/.txt')" + CRLF
    cMsg += "         cMsg := 'Arquivo não permitido!'" + CRLF
    cMsg += "         cMsg += Chr(13) + 'Use: XML, CSV, PDF ou TXT'" + CRLF
    cMsg += "         MsgStop(cMsg)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "   EndIf"
    
    MsgInfo(cMsg, "Right() - Extensão")
Return

Static Function fVldArq(cExt)
    Local cExtL := Lower(cExt)
    
    If cExtL $ ".xml/.csv/.pdf/.txt"
        Return "? PERMITIDO"
    Else
        Return "? BLOQUEADO - Extensão não permitida"
    EndIf
Return

// ==========================================================================
// Exemplo 3: Extrair Dígito Verificador (CPF/CNPJ/Códigos)
// ==========================================================================
/*
SITUAÇÃO REAL:
CPF: 123456789-09 (últimos 2 dígitos = verificadores)
Código de barras: 123456789012-3 (último dígito = verificador)
Use Right() para extrair facilmente.
*/
Static Function fEx03()
    Local aDados := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cDoc   := ""
    Local cBase  := ""
    Local cDig   := ""
    
    // Simula documentos
    aAdd(aDados, {"CPF",        "12345678909",     2})   // 2 dígitos
    aAdd(aDados, {"CNPJ",       "12345678000195",  2})   // 2 dígitos
    aAdd(aDados, {"COD BARRAS", "12345678901234",  1})   // 1 dígito
    aAdd(aDados, {"CONTA",      "00123456-7",      1})   // 1 dígito
    
    cMsg := "?? EXTRAÇÃO DE DÍGITO VERIFICADOR" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aDados)
        cDoc  := StrTran(aDados[nI][2], "-", "")  // Remove hífen
        
        // Right() pega últimos caracteres (dígitos verificadores)
        cDig  := Right(cDoc, aDados[nI][3])
        
        // Left() pega o resto (base do documento)
        cBase := Left(cDoc, Len(cDoc) - aDados[nI][3])
        
        cMsg += aDados[nI][1] + ": " + aDados[nI][2] + CRLF
        cMsg += "  ?? Base: " + cBase + CRLF
        cMsg += "  ? Dígitos: " + cDig + " (" + cValToChar(aDados[nI][3])
        cMsg += " dígitos)" + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO DE DÍGITO:" + CRLF
    cMsg += "   Static Function fValidaCPF(cCPF)" + CRLF
    cMsg += "      Local cBase := Left(cCPF, 9)" + CRLF
    cMsg += "      Local cDig  := Right(cCPF, 2)" + CRLF
    cMsg += "      Local cCalc := ''" + CRLF + CRLF
    cMsg += "      // Calcula dígito com base" + CRLF
    cMsg += "      cCalc := fCalcDigCPF(cBase)" + CRLF + CRLF
    cMsg += "      // Compara calculado com informado" + CRLF
    cMsg += "      If cCalc <> cDig" + CRLF
    cMsg += "         Return .F.  // Inválido" + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "   Return .T." + CRLF + CRLF
    cMsg += "   ?? Left() pega base, Right() pega dígito!"
    
    MsgInfo(cMsg, "Right() - Dígito Verificador")
Return

// ==========================================================================
// Exemplo 4: Validar Prefixo de Código (Regras de Negócio)
// ==========================================================================
/*
SITUAÇÃO REAL:
Códigos de produto devem começar com prefixo específico:
- PA = Produto Acabado (pode vender)
- MP = Matéria Prima (só produção)
- SE = Serviço (não tem estoque)

Use Left() para validar prefixo.
*/
Static Function fEx04()
    Local aProd  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cCod   := ""
    Local cPref  := ""
    
    // Simula códigos digitados
    aAdd(aProd, "PA001234")
    aAdd(aProd, "MP005678")
    aAdd(aProd, "SE000999")
    aAdd(aProd, "XX123456")  // Prefixo inválido
    aAdd(aProd, "PA999888")
    
    cMsg := "? VALIDAÇÃO DE PREFIXO DE CÓDIGO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Prefixos válidos: PA, MP, SE" + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aProd)
        cCod  := aProd[nI]
        
        // Left() pega prefixo (2 primeiros caracteres)
        cPref := Left(cCod, 2)
        
        cMsg += cValToChar(nI) + ". Código: " + cCod + CRLF
        cMsg += "   Prefixo: " + cPref + CRLF
        cMsg += "   " + fVldPref(cPref) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO EM CADASTRO:" + CRLF
    cMsg += "   // Valid do campo B1_COD" + CRLF
    cMsg += "   Static Function fVldCodProd()" + CRLF
    cMsg += "      Local cCodigo := M->B1_COD" + CRLF
    cMsg += "      Local cPrefixo := Left(cCodigo, 2)" + CRLF + CRLF
    cMsg += "      If !(cPrefixo $ 'PA/MP/SE')" + CRLF
    cMsg += "         cMsg := 'Prefixo inválido!'" + CRLF
    cMsg += "         cMsg += Chr(13) + 'Use: PA, MP ou SE'" + CRLF
    cMsg += "         MsgStop(cMsg)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "   Return .T."
    
    MsgInfo(cMsg, "Left() - Prefixo")
Return

Static Function fVldPref(cPref)
    Local cResult := ""
    
    Do Case
        Case cPref == "PA"
            cResult := "? PRODUTO ACABADO - Pode vender"
        Case cPref == "MP"
            cResult := "? MATÉRIA PRIMA - Só produção"
        Case cPref == "SE"
            cResult := "? SERVIÇO - Não tem estoque"
        Otherwise
            cResult := "? PREFIXO INVÁLIDO"
    EndCase
Return cResult

// ==========================================================================
// Exemplo 5: Processar Ano de Competência (Relatórios)
// ==========================================================================
/*
SITUAÇÃO REAL:
Competência: 202601 (AAAAMM)
Para agrupar por ano em relatórios, use Left() para pegar ano.
Para agrupar por mês, use Right() para pegar mês.
*/
Static Function fEx05()
    Local aComp  := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cComp  := ""
    Local cAno   := ""
    Local cMes   := ""
    Local nTotal := 0
    Local nAno26 := 0
    Local nAno25 := 0
    
    // Simula competências de faturamento
    aAdd(aComp, {"202501", 150000.00})
    aAdd(aComp, {"202502", 180000.00})
    aAdd(aComp, {"202512", 250000.00})
    aAdd(aComp, {"202601", 200000.00})
    aAdd(aComp, {"202602", 220000.00})
    
    cMsg := "?? AGRUPAMENTO POR ANO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aComp)
        cComp := aComp[nI][1]
        
        // Left() pega ano (4 primeiros)
        cAno := Left(cComp, 4)
        
        // Right() pega mês (2 últimos)
        cMes := Right(cComp, 2)
        
        nTotal += aComp[nI][2]
        
        If cAno == "2026"
            nAno26 += aComp[nI][2]
        Else
            nAno25 += aComp[nI][2]
        EndIf
        
        cMsg += fMesExtenso(cMes) + "/" + cAno + ": R$ "
        cMsg += Transform(aComp[nI][2], "@E 999,999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "TOTALIZAÇÕES:" + CRLF + CRLF
    cMsg += "?? Ano 2025: R$ " + Transform(nAno25, "@E 999,999,999.99") + CRLF
    cMsg += "?? Ano 2026: R$ " + Transform(nAno26, "@E 999,999,999.99") + CRLF
    cMsg += "?? TOTAL: R$ " + Transform(nTotal, "@E 999,999,999.99") + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? AGRUPAMENTO EM QUERY:" + CRLF
    cMsg += "   BeginSql Alias 'TMP'" + CRLF
    cMsg += "      SELECT" + CRLF
    cMsg += "         LEFT(COMPET, 4) AS ANO," + CRLF
    cMsg += "         RIGHT(COMPET, 2) AS MES," + CRLF
    cMsg += "         SUM(VALOR) AS TOTAL" + CRLF
    cMsg += "      FROM FATURAMENTO" + CRLF
    cMsg += "      GROUP BY LEFT(COMPET, 4)," + CRLF
    cMsg += "               RIGHT(COMPET, 2)" + CRLF
    cMsg += "   EndSql" + CRLF + CRLF
    cMsg += "   ?? Left() agrupa por ano!" + CRLF
    cMsg += "   ?? Right() agrupa por mês!"
    
    MsgInfo(cMsg, "Left/Right - Competência")
Return

Static Function fMesExtenso(cMes)
    Local aMeses := {"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", ;
                     "Jul", "Ago", "Set", "Out", "Nov", "Dez"}
    Local nMes   := Val(cMes)
    
    If nMes >= 1 .And. nMes <= 12
        Return aMeses[nMes]
    EndIf
Return "Mês?"
