// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR13
Exemplos práticos das funções PadL, PadR e PadC

Funções de alinhamento:
- PadL() = preenche à esquerda (alinha à direita)
- PadR() = preenche à direita (alinha à esquerda)
- PadC() = centraliza
Muito usado em relatórios e layouts fixos!

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs PadL(cTexto, nTamanho, cCaractere)
@obs PadR(cTexto, nTamanho, cCaractere)
@obs PadC(cTexto, nTamanho, cCaractere)

@example
U_STR13()

@see
https://tdn.totvs.com/display/tec/PadL
https://tdn.totvs.com/display/tec/PadR
https://tdn.totvs.com/display/tec/PadC
/*/

User Function STR13()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Pad (L/R/C) - Exemplos", ;
                     "1-Relatório alinhado" + CRLF + ;
                     "2-Chaves compostas (banco)" + CRLF + ;
                     "3-Layout arquivo fixo" + CRLF + ;
                     "4-Centralizar títulos" + CRLF + ;
                     "5-Preencher zeros à esquerda" + CRLF + ;
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
EXEMPLO 1: Relatório com Alinhamento
*/
Static Function fEx01()
    Local cRel := ""
    Local cProd1 := "PA001"
    Local cDesc1 := "PRODUTO A"
    Local nVlr1 := 1250.00
    Local cProd2 := "PA002"
    Local cDesc2 := "PRODUTO B"
    Local nVlr2 := 750.50
    
    cRel := PadC("RELATÓRIO DE VENDAS", 60, " ") + CRLF
    cRel += Replicate("=", 60) + CRLF + CRLF
    
    // Cabeçalho
    cRel += PadR("Código", 10)
    cRel += PadR("Descrição", 30)
    cRel += PadL("Valor", 20) + CRLF
    cRel += Replicate("-", 60) + CRLF
    
    // Dados - valores alinhados à direita
    cRel += PadR(cProd1, 10)
    cRel += PadR(cDesc1, 30)
    cRel += PadL(Transform(nVlr1, "@E 999,999.99"), 20) + CRLF
    
    cRel += PadR(cProd2, 10)
    cRel += PadR(cDesc2, 30)
    cRel += PadL(Transform(nVlr2, "@E 999,999.99"), 20) + CRLF
    
    cRel += Replicate("=", 60)
    
    MsgInfo(cRel, "PadL/PadR/PadC")
Return

/*
EXEMPLO 2: Chaves Compostas para Busca
CRÍTICO: Campos CHAR do Protheus têm espaços à direita!
*/
Static Function fEx02()
    Local cFilMsg := "01"
    Local cCodigo := "PA001"
    Local cChave := ""
    Local cMsg := ""
    
    // Monta chave respeitando tamanho dos campos
    cChave := PadR(cFilMsg, 2) + PadR(cCodigo, 15)
    
    cMsg := "?? CHAVES COMPOSTAS" + CRLF + CRLF
    cMsg += "Filial: [" + cFilMsg + "]" + CRLF
    cMsg += "Código: [" + cCodigo + "]" + CRLF + CRLF
    cMsg += "Chave montada:" + CRLF
    cMsg += "[" + cChave + "]" + CRLF + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cChave)) + " chars" + CRLF + CRLF
    cMsg += "?? Uso:" + CRLF
    cMsg += "DbSeek(xFilial('SB1') + PadR(cCod, 15))"
    
    MsgInfo(cMsg, "PadR()")
Return

/*
EXEMPLO 3: Layout Arquivo Posicional (EDI/SPED)
*/
Static Function fEx03()
    Local cTipo := "10"
    Local cCNPJ := "12345678000195"
    Local cNome := "EMPRESA TESTE LTDA"
    Local nValor := 12500.50
    Local cLinha := ""
    Local cMsg := ""
    
    // Monta linha com tamanho fixo
    cLinha := PadR(cTipo, 2)                           // Pos 1-2
    cLinha += PadR(cCNPJ, 14)                          // Pos 3-16
    cLinha += PadR(cNome, 40)                          // Pos 17-56
    cLinha += PadL(StrZero(nValor*100, 12), 12, "0")   // Pos 57-68
    
    cMsg := "?? LAYOUT POSICIONAL" + CRLF + CRLF
    cMsg += "Tipo (2): " + cTipo + CRLF
    cMsg += "CNPJ (14): " + cCNPJ + CRLF
    cMsg += "Nome (40): " + cNome + CRLF
    cMsg += "Valor (12): " + cValToChar(nValor) + CRLF + CRLF
    cMsg += "Linha gerada (68 chars):" + CRLF
    cMsg += "[" + cLinha + "]" + CRLF + CRLF
    cMsg += "Total: " + cValToChar(Len(cLinha)) + " caracteres"
    
    MsgInfo(cMsg, "PadL/PadR")
Return

/*
EXEMPLO 4: Centralizar Títulos
*/
Static Function fEx04()
    Local cTit1 := "RELATÓRIO GERENCIAL"
    Local cTit2 := "Período: 01/01/2026 a 31/01/2026"
    Local cTit3 := "VENDAS POR REGIÃO"
    Local nLarg := 70
    Local cRel := ""
    
    cRel := Replicate("=", nLarg) + CRLF
    cRel += PadC(cTit1, nLarg) + CRLF
    cRel += PadC(cTit2, nLarg) + CRLF
    cRel += PadC(cTit3, nLarg) + CRLF
    cRel += Replicate("=", nLarg) + CRLF + CRLF
    
    cRel += PadR("Região", 20) + PadL("Total", 20) + CRLF
    cRel += Replicate("-", nLarg) + CRLF
    cRel += PadR("Sul", 20) + PadL("125.000,00", 20) + CRLF
    cRel += PadR("Sudeste", 20) + PadL("850.000,00", 20) + CRLF
    cRel += PadR("Norte", 20) + PadL("75.000,00", 20) + CRLF
    
    MsgInfo(cRel, "PadC()")
Return

/*
EXEMPLO 5: Preencher Zeros à Esquerda (PadL)
*/
Static Function fEx05()
    Local cPedido := "123"
    Local cNF := "456"
    Local cParcela := "1"
    Local cMsg := ""
    
    // Completa com zeros à esquerda
    cPedido := PadL(cPedido, 6, "0")
    cNF := PadL(cNF, 9, "0")
    cParcela := PadL(cParcela, 3, "0")
    
    cMsg := "0?? PREENCHER ZEROS" + CRLF + CRLF
    cMsg += "Pedido: " + cPedido + CRLF
    cMsg += "Nota Fiscal: " + cNF + CRLF
    cMsg += "Parcela: " + cParcela + CRLF + CRLF
    cMsg += "?? Ou use StrZero():" + CRLF
    cMsg += "StrZero(123, 6) = " + StrZero(123, 6)
    
    MsgInfo(cMsg, "PadL()")
Return
