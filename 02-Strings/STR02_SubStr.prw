// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR02
Exemplos práticos da função SubStr() em situações reais do Protheus

A função SubStr() extrai pedaços de uma string. É fundamental para:
- Separar código de filial de produtos
- Extrair dígitos verificadores
- Pegar prefixo/número de documentos
- Manipular datas e códigos estruturados

@type User Function
@author Felipi Marques
@since 09/11/2025

@obs SubStr(cTexto, nInicio, nTamanho)
@obs nInicio = posição inicial (começa em 1)
@obs nTamanho = quantos caracteres pegar (opcional)

@example
U_STR02()

@see
https://tdn.totvs.com/display/tec/SubStr
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR02()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Extrair filial de produto
            Case nOpcao == 2
                fEx02()  // Dígito verificador CPF/CNPJ
            Case nOpcao == 3
                fEx03()  // Separar prefixo e número de título
            Case nOpcao == 4
                fEx04()  // Extrair ano/mês de competência
            Case nOpcao == 5
                fEx05()  // Classificar conta contábil por nível
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
    
    aAdd(aOpcoes, "1 - Extrair filial de produto")
    aAdd(aOpcoes, "2 - Validar dígito CPF/CNPJ")
    aAdd(aOpcoes, "3 - Separar prefixo de título")
    aAdd(aOpcoes, "4 - Extrair ano/mês de competência")
    aAdd(aOpcoes, "5 - Classificar conta por nível")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("SubStr() - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Extrair Filial de Produto (Cadastro SB1/SB2)
// ==========================================================================
/*
SITUAÇÃO REAL:
Em empresas multi-filial, produtos podem ter código estruturado:
  01PA0001234567890
  ?????? Código do produto (13 caracteres)
  ?????? Tipo (PA = Produto Acabado)
  ?????? Filial (01 = Matriz, 02 = Filial 1, etc)

Você precisa extrair a filial para filtrar estoque por localização.
*/
Static Function fEx01()
    Local cProduto := "01PA0001234567890"  // 01 = Filial, PA = Tipo, resto = código
    Local cFilMsg  := ""
    Local cTipo    := ""
    Local cCodigo  := ""
    Local cMsg     := ""
    
    // Extrai as partes do código estruturado
    cFilMsg  := SubStr(cProduto, 1, 2)   // Pega 2 caracteres do início
    cTipo    := SubStr(cProduto, 3, 2)   // Pega 2 caracteres da posição 3
    cCodigo  := SubStr(cProduto, 5)      // Pega tudo a partir da posição 5
    
    cMsg := "?? ANÁLISE DE CÓDIGO ESTRUTURADO" + CRLF + CRLF
    cMsg += "Código completo: " + cProduto + CRLF
    cMsg += Replicate("=", 50) + CRLF + CRLF
    
    cMsg += "?? Filial: " + cFilMsg + " - " + fDesFilial(cFilMsg) + CRLF
    cMsg += "?? Tipo: " + cTipo + " - " + fDesTipoProd(cTipo) + CRLF
    cMsg += "?? Código: " + cCodigo + CRLF + CRLF
    
    cMsg += Replicate("=", 50) + CRLF + CRLF
    
    cMsg += "?? USO NO PROTHEUS:" + CRLF
    cMsg += "   cFilProd := SubStr(SB2->B2_COD, 1, 2)" + CRLF
    cMsg += "   If cFilProd == cFilAnt" + CRLF
    cMsg += "      // Produto da mesma filial"
    
    MsgInfo(cMsg, "SubStr() - Estrutura de Código")
Return

Static Function fDesFilial(cFil)
    Local cDesc := ""
    
    Do Case
        Case cFil == "01"
            cDesc := "MATRIZ - SÃO PAULO"
        Case cFil == "02"
            cDesc := "FILIAL 1 - RIO DE JANEIRO"
        Case cFil == "03"
            cDesc := "FILIAL 2 - CAMPINAS"
        Otherwise
            cDesc := "FILIAL DESCONHECIDA"
    EndCase
Return cDesc

Static Function fDesTipoProd(cTipo)
    Local cDesc := ""
    
    Do Case
        Case cTipo == "PA"
            cDesc := "PRODUTO ACABADO"
        Case cTipo == "MP"
            cDesc := "MATÉRIA PRIMA"
        Case cTipo == "ME"
            cDesc := "MERCADORIA"
        Otherwise
            cDesc := "TIPO DESCONHECIDO"
    EndCase
Return cDesc

// ==========================================================================
// Exemplo 2: Dígito Verificador de CPF/CNPJ (Cadastro SA1/SA2)
// ==========================================================================
/*
SITUAÇÃO REAL:
CPF/CNPJ tem dígitos verificadores no final:
  CPF:  123.456.789-09  (09 = dígitos verificadores)
  CNPJ: 12.345.678/0001-95  (95 = dígitos verificadores)

Você precisa extrair os dígitos para validação ou exibição separada.
*/
Static Function fEx02()
    Local cCPF     := "12345678909"        // 11 dígitos
    Local cCNPJ    := "12345678000195"     // 14 dígitos
    Local cDigCPF  := ""
    Local cDigCNPJ := ""
    Local cMsg     := ""
    
    // Extrai os 2 últimos dígitos (verificadores)
    cDigCPF  := SubStr(cCPF, 10, 2)    // Posição 10, pega 2 caracteres
    cDigCNPJ := SubStr(cCNPJ, 13, 2)   // Posição 13, pega 2 caracteres
    
    // OU: pegar do final usando tamanho negativo
    // cDigCPF := SubStr(cCPF, -2)     // Pega 2 últimos caracteres
    
    cMsg := "?? EXTRAÇÃO DE DÍGITOS VERIFICADORES" + CRLF + CRLF
    
    // Formata CPF
    cMsg += "?? CPF: " + fFormatCPF(cCPF) + CRLF
    cMsg += "   Base: " + SubStr(cCPF, 1, 9) + CRLF
    cMsg += "   Dígitos: " + cDigCPF + CRLF + CRLF
    
    // Formata CNPJ
    cMsg += "?? CNPJ: " + fFormatCNPJ(cCNPJ) + CRLF
    cMsg += "   Base: " + SubStr(cCNPJ, 1, 12) + CRLF
    cMsg += "   Dígitos: " + cDigCNPJ + CRLF + CRLF
    
    cMsg += Replicate("=", 50) + CRLF + CRLF
    
    cMsg += "?? VALIDAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   cCGC := SA1->A1_CGC" + CRLF
    cMsg += "   If Len(cCGC) == 11  // CPF" + CRLF
    cMsg += "      cDig := SubStr(cCGC, 10, 2)" + CRLF
    cMsg += "   Else  // CNPJ" + CRLF
    cMsg += "      cDig := SubStr(cCGC, 13, 2)"
    
    MsgInfo(cMsg, "SubStr() - Dígitos Verificadores")
Return

Static Function fFormatCPF(cCPF)
    Local cFormat := ""
    
    cFormat := SubStr(cCPF, 1, 3) + "."
    cFormat += SubStr(cCPF, 4, 3) + "."
    cFormat += SubStr(cCPF, 7, 3) + "-"
    cFormat += SubStr(cCPF, 10, 2)
Return cFormat

Static Function fFormatCNPJ(cCNPJ)
    Local cFormat := ""
    
    cFormat := SubStr(cCNPJ, 1, 2) + "."
    cFormat += SubStr(cCNPJ, 3, 3) + "."
    cFormat += SubStr(cCNPJ, 6, 3) + "/"
    cFormat += SubStr(cCNPJ, 9, 4) + "-"
    cFormat += SubStr(cCNPJ, 13, 2)
Return cFormat

// ==========================================================================
// Exemplo 3: Separar Prefixo e Número de Título (Tabela SE1/SE2)
// ==========================================================================
/*
SITUAÇÃO REAL:
Títulos a receber/pagar têm estrutura:
  Prefixo: FAT (3 caracteres)
  Número: 000123 (6 caracteres)
  Código completo: FAT000123

Você precisa separar para relatórios, filtros e validações.
*/
Static Function fEx03()
    Local aTitulos := {}
    Local cMsg     := ""
    Local nI       := 0
    Local cPrefixo := ""
    Local cNumero  := ""
    
    // Simula títulos da tabela SE1 (Contas a Receber)
    aAdd(aTitulos, {"FAT000123", "VENDA PRODUTO A",  1500.00, "CLIENTE ABC"})
    aAdd(aTitulos, {"FAT000124", "VENDA PRODUTO B",  2300.00, "CLIENTE XYZ"})
    aAdd(aTitulos, {"DEV000045", "DEVOLUÇÃO ITEM X",  -500.00, "CLIENTE ABC"})
    aAdd(aTitulos, {"SRV000012", "SERVIÇO TÉCNICO",   800.00, "CLIENTE 123"})
    
    cMsg := "?? ANÁLISE DE TÍTULOS - CONTAS A RECEBER" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aTitulos)
        // Extrai prefixo (3 primeiros caracteres)
        cPrefixo := SubStr(aTitulos[nI][1], 1, 3)
        
        // Extrai número (do 4º caractere em diante)
        cNumero := SubStr(aTitulos[nI][1], 4)
        
        cMsg += "?? Título " + cValToChar(nI) + ":" + CRLF
        cMsg += "   Prefixo: " + cPrefixo + " - " + fDesPrefixo(cPrefixo) + CRLF
        cMsg += "   Número: " + cNumero + CRLF
        cMsg += "   Histórico: " + aTitulos[nI][2] + CRLF
        cMsg += "   Valor: R$ " + Transform(aTitulos[nI][3], "@E 999,999.99") + CRLF
        cMsg += "   Cliente: " + aTitulos[nI][4] + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? FILTRO NO PROTHEUS:" + CRLF
    cMsg += "   cPref := SubStr(SE1->E1_NUM, 1, 3)" + CRLF
    cMsg += "   If cPref == 'FAT'" + CRLF
    cMsg += "      // Processar apenas faturas"
    
    MsgInfo(cMsg, "SubStr() - Prefixo de Títulos")
Return

Static Function fDesPrefixo(cPrefixo)
    Local cDesc := ""
    
    Do Case
        Case cPrefixo == "FAT"
            cDesc := "FATURA DE VENDA"
        Case cPrefixo == "DEV"
            cDesc := "DEVOLUÇÃO"
        Case cPrefixo == "SRV"
            cDesc := "SERVIÇO"
        Case cPrefixo == "ADT"
            cDesc := "ADIANTAMENTO"
        Otherwise
            cDesc := "OUTRO TIPO"
    EndCase
Return cDesc

// ==========================================================================
// Exemplo 4: Extrair Ano/Mês de Competência (Diversos módulos)
// ==========================================================================
/*
SITUAÇÃO REAL:
Campos de competência são gravados como AAAAMM (6 dígitos):
  202601 = Janeiro de 2026
  202512 = Dezembro de 2025

Você precisa separar ano e mês para filtros, relatórios e validações.
*/
Static Function fEx04()
    Local aCompet := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cAno    := ""
    Local cMes    := ""
    
    // Simula competências de fechamento
    aAdd(aCompet, {"202601", "Abertura do exercício",     .T.})
    aAdd(aCompet, {"202602", "Faturamento recorde",       .T.})
    aAdd(aCompet, {"202603", "Competência em aberto",     .F.})
    aAdd(aCompet, {"202512", "Fechamento ano anterior",   .T.})
    
    cMsg := "?? ANÁLISE DE COMPETÊNCIAS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aCompet)
        // Extrai ano (4 primeiros dígitos)
        cAno := SubStr(aCompet[nI][1], 1, 4)
        
        // Extrai mês (2 últimos dígitos)
        cMes := SubStr(aCompet[nI][1], 5, 2)
        
        cMsg += fMesExtenso(cMes) + "/" + cAno
        
        If aCompet[nI][3]
            cMsg += " ? FECHADO" + CRLF
        Else
            cMsg += " ?? ABERTO" + CRLF
        EndIf
        
        cMsg += "   Observação: " + aCompet[nI][2] + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO DE PERÍODO:" + CRLF
    cMsg += "   cComp := '202601'" + CRLF
    cMsg += "   cAno := SubStr(cComp, 1, 4)  // '2026'" + CRLF
    cMsg += "   cMes := SubStr(cComp, 5, 2)  // '01'" + CRLF + CRLF
    cMsg += "   If cAno >= '2026' .And. cMes >= '01'" + CRLF
    cMsg += "      // Período válido para lançamento"
    
    MsgInfo(cMsg, "SubStr() - Competência")
Return

Static Function fMesExtenso(cMes)
    Local aMeses := {"Janeiro", "Fevereiro", "Março", "Abril", ;
                     "Maio", "Junho", "Julho", "Agosto", ;
                     "Setembro", "Outubro", "Novembro", "Dezembro"}
    Local nMes   := Val(cMes)
    
    If nMes >= 1 .And. nMes <= 12
        Return aMeses[nMes]
    EndIf
Return "Mês Inválido"

// ==========================================================================
// Exemplo 5: Classificar Conta Contábil por Nível (Tabela CT1)
// ==========================================================================
/*
SITUAÇÃO REAL:
Plano de contas tem estrutura hierárquica:
  1              = Nível 1 (Ativo)
  1.01           = Nível 2 (Ativo Circulante)
  1.01.001       = Nível 3 (Caixa)
  1.01.001.0001  = Nível 4 (Caixa Matriz)

Você precisa identificar o nível para totalização e relatórios gerenciais.
*/
Static Function fEx05()
    Local aContas := {}
    Local cMsg    := ""
    Local nI      := 0
    Local nNivel  := 0
    
    // Simula plano de contas (CT1)
    aAdd(aContas, {"1",             "ATIVO"})
    aAdd(aContas, {"1.01",          "ATIVO CIRCULANTE"})
    aAdd(aContas, {"1.01.001",      "DISPONIBILIDADES"})
    aAdd(aContas, {"1.01.001.0001", "CAIXA MATRIZ"})
    aAdd(aContas, {"1.01.001.0002", "CAIXA FILIAL 1"})
    aAdd(aContas, {"1.01.002",      "BANCOS"})
    aAdd(aContas, {"1.01.002.0001", "BANCO DO BRASIL"})
    
    cMsg := "?? HIERARQUIA DO PLANO DE CONTAS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aContas)
        // Conta os pontos para determinar o nível
        nNivel := fContaNivel(aContas[nI][1])
        
        // Formata com indentação visual
        cMsg += Space(nNivel * 2)  // Indenta por nível
        cMsg += fIconeNivel(nNivel) + " "
        cMsg += aContas[nI][1] + " - " + aContas[nI][2]
        cMsg += " (Nível " + cValToChar(nNivel) + ")" + CRLF
    Next nI
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? IDENTIFICAÇÃO DE NÍVEL:" + CRLF
    cMsg += "   Conta '1' = 1 ponto = Nível 1" + CRLF
    cMsg += "   Conta '1.01' = 2 pontos = Nível 2" + CRLF
    cMsg += "   Conta '1.01.001' = 3 pontos = Nível 3" + CRLF + CRLF
    cMsg += "   Nível 1 e 2 = Totalizadoras" + CRLF
    cMsg += "   Nível 3+ = Analíticas (aceitam lançamento)"
    
    MsgInfo(cMsg, "SubStr() - Hierarquia Contábil")
Return

Static Function fContaNivel(cConta)
    Local nNivel := 1
    Local nI     := 0
    Local cChar  := ""
    
    // Conta quantos pontos tem na string
    For nI := 1 To Len(cConta)
        cChar := SubStr(cConta, nI, 1)  // Pega 1 caractere por vez
        If cChar == "."
            nNivel++
        EndIf
    Next nI
Return nNivel

Static Function fIconeNivel(nNivel)
    Local cIcone := ""
    
    Do Case
        Case nNivel == 1
            cIcone := "??"
        Case nNivel == 2
            cIcone := "??"
        Case nNivel == 3
            cIcone := "??"
        Otherwise
            cIcone := "??"
    EndCase
Return cIcone
