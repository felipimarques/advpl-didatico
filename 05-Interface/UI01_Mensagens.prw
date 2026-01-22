// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI01
Exemplos práticos de mensagens básicas

Funções abordadas:
- MsgInfo() - informação
- MsgAlert() - alerta/atenção
- MsgStop() - erro/parar
- Aviso() - com opções
- Alert() - alerta simples

@type User Function
@author Felipi Marques
@since 09/01/2026

@example
U_UI01()
/*/

User Function UI01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Mensagens Básicas", ;
                     "1-MsgInfo" + CRLF + ;
                     "2-MsgAlert" + CRLF + ;
                     "3-MsgStop" + CRLF + ;
                     "4-Aviso (opções)" + CRLF + ;
                     "5-Validações práticas" + CRLF + ;
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
EXEMPLO 1: MsgInfo - Informação
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "? OPERAÇÃO CONCLUÍDA!" + CRLF + CRLF
    cMsg += "Cliente cadastrado com sucesso" + CRLF + CRLF
    cMsg += "Código: 000123" + CRLF
    cMsg += "Nome: JOSE SILVA" + CRLF + CRLF
    cMsg += "O cliente já pode realizar pedidos"
    
    MsgInfo(cMsg, "Sucesso")
    
    // Exemplo 2
    MsgInfo("Pedido incluído com sucesso!" + CRLF + ;
            "Número: 000456", "Pedido de Venda")
    
    // Exemplo 3
    MsgInfo("3 produtos importados", "Importação")
Return

/*
EXEMPLO 2: MsgAlert - Alerta/Atenção
*/
Static Function fEx02()
    Local cMsg := ""
    
    cMsg := "?? ATENÇÃO" + CRLF + CRLF
    cMsg += "O cliente possui pendências:" + CRLF + CRLF
    cMsg += "• 2 títulos em atraso" + CRLF
    cMsg += "• Valor: R$ 5.450,00" + CRLF + CRLF
    cMsg += "Verifique antes de liberar novo pedido"
    
    MsgAlert(cMsg, "Pendências")
    
    // Exemplo 2
    MsgAlert("Produto com estoque baixo!" + CRLF + ;
             "Saldo: 5 unidades", "Estoque")
    
    // Exemplo 3
    MsgAlert("Preço alterado difere da tabela", "Atenção")
Return

/*
EXEMPLO 3: MsgStop - Erro/Parar
*/
Static Function fEx03()
    Local cMsg := ""
    
    cMsg := "? ERRO AO INCLUIR PEDIDO" + CRLF + CRLF
    cMsg += "Motivo:" + CRLF
    cMsg += "Cliente não possui limite de crédito" + CRLF + CRLF
    cMsg += "Ações necessárias:" + CRLF
    cMsg += "1. Contate o financeiro" + CRLF
    cMsg += "2. Solicite aprovação de crédito" + CRLF
    cMsg += "3. Tente novamente após liberação"
    
    MsgStop(cMsg, "Erro")
    
    // Exemplo 2
    MsgStop("CNPJ inválido!" + CRLF + ;
            "Digite apenas números", "Validação")
    
    // Exemplo 3
    MsgStop("Produto não encontrado", "Erro")
Return

/*
EXEMPLO 4: Aviso com Opções
*/
Static Function fEx04()
    Local nOpc := 0
    Local cMsg := ""
    
    cMsg := "Cliente possui pedidos em aberto" + CRLF + CRLF
    cMsg += "O que deseja fazer?"
    
    nOpc := Aviso("Pedidos em Aberto", ;
                  cMsg, ;
                  {"Ver Pedidos", "Ignorar", "Cancelar"}, 3)
    
    Do Case
        Case nOpc == 1
            MsgInfo("Abrindo lista de pedidos...", "Pedidos")
        Case nOpc == 2
            MsgInfo("Continuando operação", "OK")
        Case nOpc == 3
            MsgInfo("Operação cancelada", "Cancelado")
    EndCase
    
    // Exemplo 2: Confirmação de exclusão
    nOpc := Aviso("Confirma Exclusão?", ;
                  "Deseja realmente excluir o produto?" + CRLF + ;
                  "Código: PA001 - NOTEBOOK", ;
                  {"Sim", "Não"}, 2)
    
    If nOpc == 1
        MsgInfo("Produto excluído", "Exclusão")
    Else
        MsgInfo("Exclusão cancelada", "Cancelado")
    EndIf
Return

/*
EXEMPLO 5: Validações Práticas
*/
Static Function fEx05()
    Local cCnpj := "12345678000199"
    Local nQtd := 5
    Local nEstoque := 3
    Local nValor := 150.00
    Local nMinimo := 100.00
    Local lOk := .T.
    
    // Validação 1: CNPJ
    If Len(AllTrim(cCnpj)) != 14
        MsgStop("CNPJ deve ter 14 dígitos!" + CRLF + ;
                "Digite apenas números", "CNPJ Inválido")
        lOk := .F.
    EndIf
    
    If lOk
        MsgInfo("CNPJ validado com sucesso", "OK")
    EndIf
    
    // Validação 2: Estoque
    If nQtd > nEstoque
        MsgAlert("Quantidade solicitada: " + cValToChar(nQtd) + CRLF + ;
                 "Estoque disponível: " + cValToChar(nEstoque) + CRLF + CRLF + ;
                 "Estoque insuficiente!", "Atenção")
    Else
        MsgInfo("Estoque OK", "Validação")
    EndIf
    
    // Validação 3: Valor mínimo
    If nValor < nMinimo
        MsgStop("Valor R$ " + Transform(nValor, "@E 999,999.99") + CRLF + ;
                "está abaixo do mínimo permitido" + CRLF + ;
                "Mínimo: R$ " + Transform(nMinimo, "@E 999,999.99"), ;
                "Valor Inválido")
    Else
        MsgInfo("Valor aprovado", "OK")
    EndIf
    
    // Validação 4: Múltiplas condições
    If Empty(cCnpj)
        MsgStop("CNPJ não informado!", "Campo Obrigatório")
    ElseIf nQtd <= 0
        MsgStop("Quantidade deve ser maior que zero!", "Quantidade Inválida")
    ElseIf nEstoque <= 0
        MsgAlert("Produto sem estoque!" + CRLF + ;
                 "Verifique disponibilidade", "Atenção")
    Else
        MsgInfo("Todas validações OK!" + CRLF + ;
                "Pode prosseguir com a operação", "Validação")
    EndIf
Return
