// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} OP05
Exemplos práticos do operador ternário (If inline) em ADVPL

Operador ternário = If inline:
If(condição, seVerdadeiro, seFalso)

Substitui estruturas If/Else simples de forma concisa

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_OP05()
/*/

User Function OP05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Operador Ternário (If)", ;
                     "1-Sintaxe básica" + CRLF + ;
                     "2-Status e classificações" + CRLF + ;
                     "3-Validações inline" + CRLF + ;
                     "4-If aninhado" + CRLF + ;
                     "5-Casos práticos ERP" + CRLF + ;
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
EXEMPLO 1: Sintaxe Básica
*/
Static Function fEx01()
    Local nIdade := 25
    Local cStatus := ""
    Local lAtivo := .T.
    Local cSituacao := ""
    Local cMsg := ""
    
    // Forma tradicional
    If nIdade >= 18
        cStatus := "Maior de idade"
    Else
        cStatus := "Menor de idade"
    EndIf
    
    // Forma inline (ternário)
    cSituacao := If(lAtivo, "ATIVO", "INATIVO")
    
    cMsg := "? OPERADOR TERNÁRIO" + CRLF + CRLF
    
    cMsg += "=== FORMA TRADICIONAL ===" + CRLF
    cMsg += "If nIdade >= 18" + CRLF
    cMsg += "    cStatus := 'Maior de idade'" + CRLF
    cMsg += "Else" + CRLF
    cMsg += "    cStatus := 'Menor de idade'" + CRLF
    cMsg += "EndIf" + CRLF + CRLF
    
    cMsg += "Resultado: " + cStatus + CRLF + CRLF
    
    cMsg += "=== FORMA INLINE ===" + CRLF
    cMsg += "cSituacao := If(lAtivo, 'ATIVO', 'INATIVO')" + CRLF + CRLF
    cMsg += "Resultado: " + cSituacao + CRLF + CRLF
    
    cMsg += "?? If() deixa código mais limpo"
    
    MsgInfo(cMsg, "If()")
Return

/*
EXEMPLO 2: Status e Classificações
*/
Static Function fEx02()
    Local cTipo := "PA"
    Local nSaldo := 150
    Local lBloqueado := .F.
    Local cMsg := ""
    
    cMsg := "??? STATUS E CLASSIFICAÇÕES" + CRLF + CRLF
    
    // Tipo de produto
    cMsg += "Tipo: " + cTipo + CRLF
    cMsg += "Descrição: " + If(cTipo == "PA", "Produto Acabado", ;
                               If(cTipo == "MP", "Matéria Prima", ;
                               If(cTipo == "ME", "Mercadoria", "Outro"))) + CRLF + CRLF
    
    // Nível de estoque
    cMsg += "Saldo: " + cValToChar(nSaldo) + CRLF
    cMsg += "Status: " + If(nSaldo >= 100, "? NORMAL", ;
                           If(nSaldo >= 50, "?? BAIXO", "? CRÍTICO")) + CRLF + CRLF
    
    // Status cliente
    cMsg += "Bloqueado: " + If(lBloqueado, "SIM", "NÃO") + CRLF
    cMsg += "Situação: " + If(!lBloqueado, "? Liberado para venda", "? Venda bloqueada") + CRLF + CRLF
    
    cMsg += "?? Use para textos dinâmicos"
    
    MsgInfo(cMsg, "If()")
Return

/*
EXEMPLO 3: Validações Inline
*/
Static Function fEx03()
    Local cEmail := "vendas@empresa.com"
    Local cCNPJ := "12345678000195"
    Local nPreco := 125.50
    Local cMsg := ""
    
    cMsg := "? VALIDAÇÕES INLINE" + CRLF + CRLF
    
    // Validar e-mail
    cMsg += "E-mail: " + cEmail + CRLF
    cMsg += "Status: " + If("@" $ cEmail .And. "." $ cEmail, ;
                           "? Válido", "? Inválido") + CRLF + CRLF
    
    // Validar CNPJ
    cMsg += "CNPJ: " + cCNPJ + CRLF
    cMsg += "Tamanho: " + If(Len(cCNPJ) == 14, "? OK", "? Incorreto") + CRLF + CRLF
    
    // Validar preço
    cMsg += "Preço: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF
    cMsg += "Faixa: " + If(nPreco < 100, "Econômico", ;
                          If(nPreco < 500, "Médio", "Premium")) + CRLF + CRLF
    
    cMsg += "?? Validações rápidas em uma linha"
    
    MsgInfo(cMsg, "If()")
Return

/*
EXEMPLO 4: If Aninhado (cuidado!)
*/
Static Function fEx04()
    Local nNota := 85
    Local cConceito := ""
    Local nSalario := 3500
    Local cFaixa := ""
    Local cMsg := ""
    
    // If aninhado - conceito
    cConceito := If(nNota >= 90, "A - Excelente", ;
                    If(nNota >= 80, "B - Ótimo", ;
                       If(nNota >= 70, "C - Bom", ;
                          If(nNota >= 60, "D - Regular", "F - Reprovado"))))
    
    // If aninhado - salário
    cFaixa := If(nSalario <= 2000, "Baixa", ;
                 If(nSalario <= 5000, "Média", ;
                    If(nSalario <= 10000, "Alta", "Muito Alta")))
    
    cMsg := "?? IF ANINHADO" + CRLF + CRLF
    
    cMsg += "=== CONCEITO POR NOTA ===" + CRLF
    cMsg += "Nota: " + cValToChar(nNota) + CRLF
    cMsg += "Conceito: " + cConceito + CRLF + CRLF
    
    cMsg += "=== FAIXA SALARIAL ===" + CRLF
    cMsg += "Salário: R$ " + Transform(nSalario, "@E 999,999.99") + CRLF
    cMsg += "Faixa: " + cFaixa + CRLF + CRLF
    
    cMsg += "?? ATENÇÃO:" + CRLF
    cMsg += "If aninhado funciona mas:" + CRLF
    cMsg += "• Dificulta leitura" + CRLF
    cMsg += "• Use Do Case quando muitas opções" + CRLF + CRLF
    
    cMsg += "?? Máximo 2-3 níveis de aninhamento"
    
    MsgInfo(cMsg, "If() Aninhado")
Return

/*
EXEMPLO 5: Casos Práticos ERP
*/
Static Function fEx05()
    Local dVenc := Date() - 5
    Local nDias := Date() - dVenc
    Local cTpPed := "N"
    Local nVlrPed := 5000
    Local lVIP := .T.
    Local nDesconto := 0
    Local cMsg := ""
    
    cMsg := "?? CASOS PRÁTICOS ERP" + CRLF + CRLF
    
    // Título vencido
    cMsg += "=== TÍTULO ===" + CRLF
    cMsg += "Vencimento: " + DtoC(dVenc) + CRLF
    cMsg += "Status: " + If(dVenc < Date(), ;
                           "?? VENCIDO há " + cValToChar(nDias) + " dias", ;
                           "? Em dia") + CRLF + CRLF
    
    // Tipo de pedido
    cMsg += "=== PEDIDO ===" + CRLF
    cMsg += "Tipo: " + cTpPed + CRLF
    cMsg += "Descrição: " + If(cTpPed == "N", "Normal", ;
                              If(cTpPed == "B", "Bonificação", ;
                                 If(cTpPed == "D", "Devolução", "Outros"))) + CRLF + CRLF
    
    // Desconto VIP
    nDesconto := If(lVIP, ;
                    If(nVlrPed >= 10000, 15, ;
                       If(nVlrPed >= 5000, 10, 5)), ;
                    If(nVlrPed >= 10000, 5, 0))
    
    cMsg += "=== DESCONTO ===" + CRLF
    cMsg += "Cliente VIP: " + If(lVIP, "SIM", "NÃO") + CRLF
    cMsg += "Valor pedido: R$ " + Transform(nVlrPed, "@E 999,999.99") + CRLF
    cMsg += "Desconto: " + cValToChar(nDesconto) + "%" + CRLF + CRLF
    
    // Indicador visual
    cMsg += "=== INDICADORES ===" + CRLF
    cMsg += "Semáforo estoque:" + CRLF
    cMsg += "100+ = " + If(150 >= 100, "?? Verde", "?? Vermelho") + CRLF
    cMsg += "50+ = " + If(30 >= 50, "?? Verde", "?? Vermelho") + CRLF
    cMsg += "10+ = " + If(5 >= 10, "?? Verde", "?? Vermelho") + CRLF + CRLF
    
    cMsg += "?? If() é muito usado no dia a dia"
    
    MsgInfo(cMsg, "ERP")
Return
