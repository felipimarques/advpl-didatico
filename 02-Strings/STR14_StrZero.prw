// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR14
Exemplos práticos da função StrZero()

StrZero() converte número em string preenchida com zeros:
- Formatar códigos sequenciais
- Gerar números de documentos
- Criar identificadores com zeros à esquerda
- Completar campos numéricos
- Padronizar numeração

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs StrZero(nNumero, nTamanho, nDecimais)

@example
U_STR14()

@see
https://tdn.totvs.com/display/tec/StrZero
/*/

User Function STR14()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("StrZero() - Exemplos", ;
                     "1-Gerar código produto" + CRLF + ;
                     "2-Número pedido/NF" + CRLF + ;
                     "3-Código barras" + CRLF + ;
                     "4-Sequencial parcelas" + CRLF + ;
                     "5-Layout arquivo remessa" + CRLF + ;
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
EXEMPLO 1: Gerar Código de Produto Sequencial
*/
Static Function fEx01()
    Local nSeq := 1
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "??? GERAÇÃO DE CÓDIGOS" + CRLF + CRLF
    cMsg += "Produtos criados hoje:" + CRLF + CRLF
    
    For nI := 1 To 5
        cMsg += "PA" + StrZero(nSeq, 6) + " - PRODUTO " + cValToChar(nSeq) + CRLF
        nSeq++
    Next nI
    
    cMsg += CRLF + "?? Próximo código: PA" + StrZero(nSeq, 6)
    
    MsgInfo(cMsg, "StrZero()")
Return

/*
EXEMPLO 2: Número de Pedido e Nota Fiscal
*/
Static Function fEx02()
    Local nPedido := 1234
    Local nNF := 567
    Local cSerie := "1"
    Local cMsg := ""
    
    cMsg := "?? NUMERAÇÃO DE DOCUMENTOS" + CRLF + CRLF
    
    // Pedido com 6 dígitos
    cMsg += "Pedido de Venda:" + CRLF
    cMsg += "Número: " + StrZero(nPedido, 6) + CRLF + CRLF
    
    // Nota fiscal com 9 dígitos + série
    cMsg += "Nota Fiscal:" + CRLF
    cMsg += "Série: " + cSerie + CRLF
    cMsg += "Número: " + StrZero(nNF, 9) + CRLF + CRLF
    
    cMsg += "?? Chave:" + CRLF
    cMsg += cSerie + StrZero(nNF, 9)
    
    MsgInfo(cMsg, "StrZero()")
Return

/*
EXEMPLO 3: Código de Barras EAN-13
*/
Static Function fEx03()
    Local cPais := "789"        // Brasil
    Local cEmpresa := "1234"
    Local cProduto := "56789"
    Local cDV := "5"
    Local cEAN := ""
    Local cMsg := ""
    
    // Monta código EAN-13
    cEAN := cPais + cEmpresa + cProduto + cDV
    
    cMsg := "?? CÓDIGO DE BARRAS EAN-13" + CRLF + CRLF
    cMsg += "País: " + cPais + " (Brasil)" + CRLF
    cMsg += "Empresa: " + cEmpresa + CRLF
    cMsg += "Produto: " + cProduto + CRLF
    cMsg += "Dígito Verificador: " + cDV + CRLF + CRLF
    cMsg += "Código completo:" + CRLF
    cMsg += cEAN + CRLF + CRLF
    cMsg += "Total: " + cValToChar(Len(cEAN)) + " dígitos"
    
    MsgInfo(cMsg, "StrZero()")
Return

/*
EXEMPLO 4: Sequencial de Parcelas
*/
Static Function fEx04()
    Local cPrefixo := "FAT"
    Local cNumero := "000123"
    Local nParcelas := 3
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? GERAÇÃO DE PARCELAS" + CRLF + CRLF
    cMsg += "Título: " + cPrefixo + " " + cNumero + CRLF
    cMsg += "Parcelas: " + cValToChar(nParcelas) + CRLF + CRLF
    
    For nI := 1 To nParcelas
        cMsg += StrZero(nI, 3) + "/" + StrZero(nParcelas, 3)
        cMsg += " - R$ 1.000,00" + CRLF
    Next nI
    
    MsgInfo(cMsg, "StrZero()")
Return

/*
EXEMPLO 5: Layout Arquivo Remessa Bancária
Valor 1250.50 ? 000000000125050 (15 posições, centavos)
*/
Static Function fEx05()
    Local nValor := 1250.50
    Local nValCent := nValor * 100  // Converte para centavos
    Local cValorFmt := ""
    Local cLinha := ""
    Local cMsg := ""
    
    // Formato: 15 posições, sem vírgula
    cValorFmt := StrZero(nValCent, 15)
    
    // Monta linha remessa
    cLinha := "3"                          // Tipo registro
    cLinha += StrZero(1, 5)                // Sequencial
    cLinha += "FAT"                        // Prefixo
    cLinha += StrZero(123, 10)             // Número título
    cLinha += cValorFmt                    // Valor
    
    cMsg := "?? ARQUIVO REMESSA" + CRLF + CRLF
    cMsg += "Valor original: R$ " + Transform(nValor, "@E 999,999.99") + CRLF
    cMsg += "Em centavos: " + cValToChar(nValCent) + CRLF
    cMsg += "Formatado: " + cValorFmt + CRLF + CRLF
    cMsg += "Linha remessa (parcial):" + CRLF
    cMsg += cLinha + CRLF + CRLF
    cMsg += "? Pronto para envio ao banco"
    
    MsgInfo(cMsg, "StrZero()")
Return
