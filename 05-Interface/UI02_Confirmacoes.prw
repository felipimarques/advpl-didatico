// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI02
Exemplos práticos de confirmações

Funções abordadas:
- MsgYesNo() - sim/não
- MsgNoYes() - não/sim (padrão não)
- Confirmações de operações
- Validação de ações críticas

@type User Function
@author Felipi Marques
@since 14/01/2026

@example
U_UI02()
/*/

User Function UI02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Confirmações", ;
                     "1-MsgYesNo básico" + CRLF + ;
                     "2-MsgNoYes (padrão não)" + CRLF + ;
                     "3-Confirmar exclusão" + CRLF + ;
                     "4-Confirmar processamento" + CRLF + ;
                     "5-Fluxo com validação" + CRLF + ;
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
EXEMPLO 1: MsgYesNo Básico
*/
Static Function fEx01()
    Local lResposta := .F.
    
    // Exemplo 1: Simples
    lResposta := MsgYesNo("Confirma a operação?", "Confirmação")
    
    If lResposta
        MsgInfo("Usuário clicou em SIM", "Resposta")
    Else
        MsgInfo("Usuário clicou em NÃO", "Resposta")
    EndIf
    
    // Exemplo 2: Com detalhes
    lResposta := MsgYesNo("Deseja continuar com o cadastro?" + CRLF + CRLF + ;
                          "Cliente: JOSE SILVA" + CRLF + ;
                          "CNPJ: 12.345.678/0001-99", ;
                          "Confirmar Cadastro")
    
    If lResposta
        MsgInfo("Cliente será cadastrado", "Prosseguir")
    Else
        MsgAlert("Cadastro cancelado pelo usuário", "Cancelado")
    EndIf
Return

/*
EXEMPLO 2: MsgNoYes (Padrão NÃO)
*/
Static Function fEx02()
    Local lResposta := .F.
    
    // MsgNoYes = foco no NÃO (mais seguro)
    lResposta := MsgNoYes("?? ATENÇÃO!" + CRLF + CRLF + ;
                          "Esta operação NÃO pode ser desfeita!" + CRLF + CRLF + ;
                          "Confirma exclusão de TODOS os registros?", ;
                          "Exclusão em Massa")
    
    If lResposta
        MsgStop("Operação confirmada" + CRLF + ;
                "Todos registros seriam excluídos", "Confirmado")
    Else
        MsgInfo("Operação cancelada" + CRLF + ;
                "Nenhum registro foi excluído", "Seguro")
    EndIf
    
    // Exemplo 2: Sair sem salvar
    lResposta := MsgNoYes("Existem alterações não salvas!" + CRLF + CRLF + ;
                          "Deseja sair mesmo assim?", ;
                          "Alterações Pendentes")
    
    If lResposta
        MsgAlert("Saindo sem salvar", "Atenção")
    Else
        MsgInfo("Continuando edição", "OK")
    EndIf
Return

/*
EXEMPLO 3: Confirmar Exclusão
*/
Static Function fEx03()
    Local cCodigo := "000123"
    Local cNome := "JOSE SILVA"
    Local lConfirma := .F.
    Local lTemPedido := .T.  // Simula
    
    // Verifica se pode excluir
    If lTemPedido
        MsgStop("Cliente não pode ser excluído!" + CRLF + CRLF + ;
                "Motivo: Possui pedidos cadastrados" + CRLF + CRLF + ;
                "Exclua os pedidos primeiro", ;
                "Exclusão Bloqueada")
        Return
    EndIf
    
    // Pede confirmação
    lConfirma := MsgNoYes("?? CONFIRMA EXCLUSÃO?" + CRLF + CRLF + ;
                          "Código: " + cCodigo + CRLF + ;
                          "Nome: " + cNome + CRLF + CRLF + ;
                          "Esta ação não pode ser desfeita!", ;
                          "Excluir Cliente")
    
    If lConfirma
        // Simula exclusão
        MsgInfo("Cliente excluído com sucesso!" + CRLF + CRLF + ;
                "Código: " + cCodigo, ;
                "Exclusão")
    Else
        MsgInfo("Exclusão cancelada" + CRLF + ;
                "Cliente mantido no sistema", ;
                "Cancelado")
    EndIf
Return

/*
EXEMPLO 4: Confirmar Processamento
*/
Static Function fEx04()
    Local nQtdProd := 150
    Local lProcessar := .F.
    
    // Aviso sobre processamento
    lProcessar := MsgYesNo("?? REAJUSTE DE PREÇOS" + CRLF + CRLF + ;
                           "Serão processados: " + cValToChar(nQtdProd) + " produtos" + CRLF + ;
                           "Percentual: 10%" + CRLF + ;
                           "Tempo estimado: 2 minutos" + CRLF + CRLF + ;
                           "Deseja iniciar o processamento?", ;
                           "Reajuste em Lote")
    
    If lProcessar
        MsgInfo("Iniciando processamento..." + CRLF + CRLF + ;
                "Produtos: " + cValToChar(nQtdProd) + CRLF + ;
                "Aguarde o término", ;
                "Processando")
        
        // Simula processamento
        MsgInfo("? PROCESSAMENTO CONCLUÍDO!" + CRLF + CRLF + ;
                "Produtos atualizados: " + cValToChar(nQtdProd) + CRLF + ;
                "Novos preços já estão em vigor", ;
                "Sucesso")
    Else
        MsgAlert("Processamento cancelado" + CRLF + ;
                 "Nenhum preço foi alterado", ;
                 "Cancelado")
    EndIf
Return

/*
EXEMPLO 5: Fluxo Completo com Validações
*/
Static Function fEx05()
    Local cCliente := "CLI001"
    Local nValor := 5000.00
    Local nLimite := 10000.00
    Local nSaldo := 3000.00
    Local lLiberar := .F.
    Local lContinuar := .T.
    
    // Validação 1: Verifica saldo disponível
    If (nSaldo + nValor) > nLimite
        MsgAlert("?? LIMITE DE CRÉDITO" + CRLF + CRLF + ;
                 "Valor pedido: R$ " + Transform(nValor, "@E 999,999.99") + CRLF + ;
                 "Saldo usado: R$ " + Transform(nSaldo, "@E 999,999.99") + CRLF + ;
                 "Limite total: R$ " + Transform(nLimite, "@E 999,999.99") + CRLF + CRLF + ;
                 "Pedido excede o limite!", ;
                 "Crédito Insuficiente")
        
        // Pergunta se quer solicitar aprovação
        lLiberar := MsgYesNo("Deseja solicitar aprovação de crédito?", ;
                             "Aprovação Especial")
        
        If lLiberar
            MsgInfo("Solicitação enviada ao financeiro" + CRLF + ;
                    "Aguarde aprovação", ;
                    "Solicitado")
            lContinuar := .F.
        Else
            lContinuar := .F.
        EndIf
    EndIf
    
    // Se passou validação, confirma pedido
    If lContinuar
        lContinuar := MsgYesNo("? CRÉDITO APROVADO" + CRLF + CRLF + ;
                               "Cliente: " + cCliente + CRLF + ;
                               "Valor: R$ " + Transform(nValor, "@E 999,999.99") + CRLF + ;
                               "Saldo após: R$ " + Transform((nLimite-nSaldo-nValor), "@E 999,999.99") + CRLF + CRLF + ;
                               "Confirma o pedido?", ;
                               "Confirmar Pedido")
        
        If lContinuar
            MsgInfo("?? PEDIDO INCLUÍDO!" + CRLF + CRLF + ;
                    "Número: 000789" + CRLF + ;
                    "Valor: R$ " + Transform(nValor, "@E 999,999.99"), ;
                    "Sucesso")
        Else
            MsgInfo("Pedido cancelado pelo usuário", "Cancelado")
        EndIf
    EndIf
    
    // Pergunta se quer fazer outro pedido
    If MsgYesNo("Deseja incluir outro pedido?", "Novo Pedido")
        MsgInfo("Retornando ao menu de pedidos...", "OK")
    Else
        MsgInfo("Finalizando...", "Sair")
    EndIf
Return
