// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR08
Exemplos práticos da função StrTran() em situações reais do Protheus

A função StrTran() substitui texto dentro de strings:
- Trocar palavras específicas
- Remover caracteres indesejados
- Padronizar dados (vírgula por ponto, etc)
- Limpar formatação (tirar pontos, hífens)
- Corrigir dados em massa

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs StrTran(cTexto, cBusca, cSubstitui)
@obs Troca TODAS as ocorrências de cBusca por cSubstitui
@obs Case-sensitive (diferencia maiúsculas/minúsculas)

@example
U_STR08()

@see
https://tdn.totvs.com/display/tec/StrTran
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR08()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Limpar formatação CPF/CNPJ
            Case nOpcao == 2
                fEx02()  // Padronizar decimal (vírgula/ponto)
            Case nOpcao == 3
                fEx03()  // Remover acentos
            Case nOpcao == 4
                fEx04()  // Substituir quebra de linha
            Case nOpcao == 5
                fEx05()  // Corrigir dados em massa
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
    
    aAdd(aOpcoes, "1 - Limpar formatação CPF/CNPJ")
    aAdd(aOpcoes, "2 - Padronizar decimal")
    aAdd(aOpcoes, "3 - Remover acentos")
    aAdd(aOpcoes, "4 - Substituir quebra de linha")
    aAdd(aOpcoes, "5 - Corrigir dados em massa")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("StrTran() - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Limpar Formatação de CPF/CNPJ/Telefone
// ==========================================================================
/*
SITUAÇÃO REAL:
Usuário digita: 123.456.789-00
Banco precisa: 12345678900 (só números)

Use StrTran() para remover pontos, hífens, parênteses, espaços.
*/
Static Function fEx01()
    Local aDados := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cOrig  := ""
    Local cLimpo := ""
    
    // Simula dados formatados
    aAdd(aDados, {"CPF",      "123.456.789-00"})
    aAdd(aDados, {"CNPJ",     "12.345.678/0001-95"})
    aAdd(aDados, {"Telefone", "(11) 91234-5678"})
    aAdd(aDados, {"Celular",  "(21) 9 8765-4321"})
    aAdd(aDados, {"CEP",      "01310-100"})
    
    cMsg := "?? LIMPEZA DE FORMATAÇÃO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aDados)
        cOrig  := aDados[nI][2]
        cLimpo := fLimpaFmt(cOrig)
        
        cMsg += aDados[nI][1] + ":" + CRLF
        cMsg += "  Original: " + cOrig + CRLF
        cMsg += "  Limpo: " + cLimpo + CRLF
        cMsg += "  Tamanho: " + cValToChar(Len(cLimpo)) + " dígitos" + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? LIMPEZA NO PROTHEUS:" + CRLF
    cMsg += "   Static Function fLimpaDoc(cDocumento)" + CRLF
    cMsg += "      Local cLimpo := cDocumento" + CRLF + CRLF
    cMsg += "      // Remove formatação" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, '.', '')" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, '-', '')" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, '/', '')" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, '(', '')" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, ')', '')" + CRLF
    cMsg += "      cLimpo := StrTran(cLimpo, ' ', '')" + CRLF + CRLF
    cMsg += "   Return cLimpo" + CRLF + CRLF
    cMsg += "   // Na gravação:" + CRLF
    cMsg += "   SA1->A1_CGC := fLimpaDoc(M->A1_CGC)"
    
    MsgInfo(cMsg, "StrTran() - Limpar")
Return

Static Function fLimpaFmt(cTexto)
    Local cLimpo := cTexto
    
    // Remove todos os caracteres de formatação
    cLimpo := StrTran(cLimpo, ".", "")
    cLimpo := StrTran(cLimpo, "-", "")
    cLimpo := StrTran(cLimpo, "/", "")
    cLimpo := StrTran(cLimpo, "(", "")
    cLimpo := StrTran(cLimpo, ")", "")
    cLimpo := StrTran(cLimpo, " ", "")
Return cLimpo

// ==========================================================================
// Exemplo 2: Padronizar Decimal - Vírgula para Ponto
// ==========================================================================
/*
SITUAÇÃO REAL:
Importação de Excel/CSV: valores vêm com vírgula (1.500,50)
Protheus precisa de ponto (1500.50) para Val()

Use StrTran() para trocar vírgula por ponto.
*/
Static Function fEx02()
    Local aValor := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cOrig  := ""
    Local cConv  := ""
    Local nNum   := 0
    
    // Simula valores importados (formato brasileiro)
    aAdd(aValor, "1.500,50")
    aAdd(aValor, "2.890,00")
    aAdd(aValor, "150,75")
    aAdd(aValor, "10.000,99")
    
    cMsg := "?? CONVERSÃO VÍRGULA ? PONTO" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Formato Excel/CSV ? Formato Protheus" + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aValor)
        cOrig := aValor[nI]
        
        // Converte formato brasileiro para americano
        cConv := StrTran(cOrig, ".", "")     // Remove ponto (milhar)
        cConv := StrTran(cConv, ",", ".")    // Troca vírgula por ponto (decimal)
        
        nNum := Val(cConv)
        
        cMsg += "Linha " + cValToChar(nI) + ":" + CRLF
        cMsg += "  Excel: " + cOrig + CRLF
        cMsg += "  Convertido: " + cConv + CRLF
        cMsg += "  Numérico: " + Transform(nNum, "@E 999,999.99") + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? IMPORTAÇÃO CSV:" + CRLF
    cMsg += "   FT_FUse(cArquivo)" + CRLF
    cMsg += "   FT_FGoTop()" + CRLF + CRLF
    cMsg += "   While !FT_FEof()" + CRLF
    cMsg += "      cLinha := FT_FReadLn()" + CRLF
    cMsg += "      aItens := StrTokArr(cLinha, ';')" + CRLF + CRLF
    cMsg += "      // Pega valor (coluna 3)" + CRLF
    cMsg += "      cValor := aItens[3]  // '1.500,50'" + CRLF + CRLF
    cMsg += "      // Converte para numérico" + CRLF
    cMsg += "      cValor := StrTran(cValor, '.', '')" + CRLF
    cMsg += "      cValor := StrTran(cValor, ',', '.')" + CRLF
    cMsg += "      nValor := Val(cValor)  // 1500.50" + CRLF + CRLF
    cMsg += "      // Grava no banco..." + CRLF
    cMsg += "      SB1->B1_PRV1 := nValor" + CRLF + CRLF
    cMsg += "      FT_FSkip()" + CRLF
    cMsg += "   EndDo"
    
    MsgInfo(cMsg, "StrTran() - Decimal")
Return

// ==========================================================================
// Exemplo 3: Remover Acentos (URLs e Arquivos)
// ==========================================================================
/*
SITUAÇÃO REAL:
Nome de arquivo: "Relatório de Comissão.pdf"
Sistema precisa: "Relatorio de Comissao.pdf" (sem acentos)

Use StrTran() para trocar caracteres acentuados.
*/
Static Function fEx03()
    Local aNomes := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cOrig  := ""
    Local cSem   := ""
    
    // Simula nomes de arquivos
    aAdd(aNomes, "Relatório de Comissão.pdf")
    aAdd(aNomes, "Orçamento São Paulo.xlsx")
    aAdd(aNomes, "Análise Técnica.docx")
    aAdd(aNomes, "José da Silva.jpg")
    
    cMsg := "?? REMOÇÃO DE ACENTOS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aNomes)
        cOrig := aNomes[nI]
        cSem  := fRemAcento(cOrig)
        
        cMsg += "Arquivo " + cValToChar(nI) + ":" + CRLF
        cMsg += "  Com acentos: " + cOrig + CRLF
        cMsg += "  Sem acentos: " + cSem + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? GERAÇÃO DE ARQUIVO:" + CRLF
    cMsg += "   cNomeArq := 'Relatório ' + dToc(Date())" + CRLF
    cMsg += "   cNomeArq := fRemoveAcentos(cNomeArq)" + CRLF
    cMsg += "   cNomeArq += '.pdf'" + CRLF + CRLF
    cMsg += "   cPath := '\\system\\relatorios\\'" + CRLF
    cMsg += "   nHandle := FCreate(cPath + cNomeArq)" + CRLF + CRLF
    cMsg += "   ?? IMPORTANTE:" + CRLF
    cMsg += "   • URLs não aceitam acentos" + CRLF
    cMsg += "   • Nomes de arquivo em rede" + CRLF
    cMsg += "   • Integração com APIs externas"
    
    MsgInfo(cMsg, "StrTran() - Acentos")
Return

Static Function fRemAcento(cTexto)
    Local cSem := cTexto
    
    // Troca acentuadas por normais
    cSem := StrTran(cSem, "á", "a")
    cSem := StrTran(cSem, "à", "a")
    cSem := StrTran(cSem, "ã", "a")
    cSem := StrTran(cSem, "â", "a")
    cSem := StrTran(cSem, "Á", "A")
    cSem := StrTran(cSem, "À", "A")
    cSem := StrTran(cSem, "Ã", "A")
    cSem := StrTran(cSem, "Â", "A")
    
    cSem := StrTran(cSem, "é", "e")
    cSem := StrTran(cSem, "ê", "e")
    cSem := StrTran(cSem, "É", "E")
    cSem := StrTran(cSem, "Ê", "E")
    
    cSem := StrTran(cSem, "í", "i")
    cSem := StrTran(cSem, "Í", "I")
    
    cSem := StrTran(cSem, "ó", "o")
    cSem := StrTran(cSem, "ô", "o")
    cSem := StrTran(cSem, "õ", "o")
    cSem := StrTran(cSem, "Ó", "O")
    cSem := StrTran(cSem, "Ô", "O")
    cSem := StrTran(cSem, "Õ", "O")
    
    cSem := StrTran(cSem, "ú", "u")
    cSem := StrTran(cSem, "Ú", "U")
    
    cSem := StrTran(cSem, "ç", "c")
    cSem := StrTran(cSem, "Ç", "C")
Return cSem

// ==========================================================================
// Exemplo 4: Substituir Quebra de Linha (Observações/Memos)
// ==========================================================================
/*
SITUAÇÃO REAL:
Campo memo tem quebras de linha (Chr(13)+Chr(10))
Para exibir em uma linha ou exportar, precisa trocar por espaço.
*/
Static Function fEx04()
    Local cObs    := ""
    Local cMsg    := ""
    Local cLinha  := ""
    Local cHTML   := ""
    
    // Simula observação de pedido (com quebras)
    cObs := "Cliente solicitou entrega expressa." + CRLF
    cObs += "Prazo máximo: 3 dias úteis." + CRLF
    cObs += "Entregar diretamente ao Sr. João."
    
    cMsg := "?? TRATAMENTO DE QUEBRAS DE LINHA" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "ORIGINAL (com quebras):" + CRLF + CRLF
    cMsg += cObs + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Substitui quebra por espaço (uma linha só)
    cLinha := StrTran(cObs, CRLF, " ")
    cMsg += "LINHA ÚNICA (para CSV):" + CRLF + CRLF
    cMsg += cLinha + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Substitui quebra por <br> (HTML)
    cHTML := StrTran(cObs, CRLF, "<br>")
    cMsg += "HTML (para email):" + CRLF + CRLF
    cMsg += cHTML + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? EXPORTAÇÃO CSV:" + CRLF
    cMsg += "   cObs := SC5->C5_OBS  // Campo memo" + CRLF + CRLF
    cMsg += "   // Remove quebras (CSV não aceita)" + CRLF
    cMsg += "   cObs := StrTran(cObs, Chr(13), '')" + CRLF
    cMsg += "   cObs := StrTran(cObs, Chr(10), '')" + CRLF
    cMsg += "   // OU substitui por espaço:" + CRLF
    cMsg += "   cObs := StrTran(cObs, CRLF, ' ')" + CRLF + CRLF
    cMsg += "   cLinha := cCod + ';' + cObs + ';' + cValor" + CRLF
    cMsg += "   FWrite(nHandle, cLinha + CRLF)"
    
    MsgInfo(cMsg, "StrTran() - Quebra Linha")
Return

// ==========================================================================
// Exemplo 5: Corrigir Dados em Massa (Update)
// ==========================================================================
/*
SITUAÇÃO REAL:
Erro na importação: todos emails vieram com erro
"contato@@empresa.com" (dois @)
Precisa corrigir no banco: @@ ? @

Use StrTran() em UPDATE para corrigir em massa.
*/
Static Function fEx05()
    Local aEmails := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cEmail  := ""
    Local cCorrig := ""
    Local nCorr   := 0
    
    // Simula emails com erro (importação errada)
    aAdd(aEmails, {"000001", "contato@@empresa.com"})
    aAdd(aEmails, {"000002", "vendas@@totvs.com.br"})
    aAdd(aEmails, {"000003", "suporte@protheus.com"})  // Correto
    aAdd(aEmails, {"000004", "admin@@sistema.com"})
    aAdd(aEmails, {"000005", "fiscal@@empresa.com"})
    
    cMsg := "?? CORREÇÃO EM MASSA" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Problema: Importação criou emails com @@" + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aEmails)
        cEmail  := aEmails[nI][2]
        cCorrig := StrTran(cEmail, "@@", "@")
        
        cMsg += "Cliente: " + aEmails[nI][1] + CRLF
        
        If cEmail <> cCorrig
            cMsg += "  ? Errado: " + cEmail + CRLF
            cMsg += "  ? Corrigido: " + cCorrig + CRLF
            nCorr++
        Else
            cMsg += "  ? OK: " + cEmail + CRLF
        EndIf
        
        cMsg += CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Total de emails: " + cValToChar(Len(aEmails)) + CRLF
    cMsg += "Corrigidos: " + cValToChar(nCorr) + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? CORREÇÃO NO BANCO:" + CRLF
    cMsg += "   // Opção 1: Loop com RecLock" + CRLF
    cMsg += "   DbSelectArea('SA1')" + CRLF
    cMsg += "   DbGoTop()" + CRLF + CRLF
    cMsg += "   While !SA1->(Eof())" + CRLF
    cMsg += "      If '@@' $ SA1->A1_EMAIL" + CRLF
    cMsg += "         RecLock('SA1', .F.)" + CRLF
    cMsg += "            cEmail := SA1->A1_EMAIL" + CRLF
    cMsg += "            SA1->A1_EMAIL := StrTran(cEmail,'@@','@')" + CRLF
    cMsg += "         SA1->(MsUnlock())" + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "      SA1->(DbSkip())" + CRLF
    cMsg += "   EndDo" + CRLF + CRLF
    cMsg += "   // Opção 2: SQL Update (mais rápido)" + CRLF
    cMsg += "   BeginSql Alias 'TMP'" + CRLF
    cMsg += "      UPDATE SA010 SET" + CRLF
    cMsg += "         A1_EMAIL = REPLACE(A1_EMAIL,'@@','@')" + CRLF
    cMsg += "      WHERE A1_EMAIL LIKE '%@@%'" + CRLF
    cMsg += "   EndSql"
    
    MsgInfo(cMsg, "StrTran() - Correção")
Return
