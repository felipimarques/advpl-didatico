// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD06
Exemplos práticos de transações

Funções abordadas:
- Begin Transaction - iniciar transação
- End Transaction - confirmar transação
- RollBack - desfazer transação
- Controle de integridade
- Múltiplas tabelas

@type User Function
@author Felipi Marques
@since 12/12/2025

@example
U_BD06()
/*/

User Function BD06()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Transações", ;
                     "1-Conceito transação" + CRLF + ;
                     "2-Begin/End Transaction" + CRLF + ;
                     "3-RollBack erro" + CRLF + ;
                     "4-Incluir pedido" + CRLF + ;
                     "5-Transferência entre contas" + CRLF + ;
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
EXEMPLO 1: Conceito de Transação
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? TRANSAÇÃO" + CRLF + CRLF
    
    cMsg += "Agrupa operações em uma unidade" + CRLF
    cMsg += "TUDO ou NADA é gravado!" + CRLF + CRLF
    
    cMsg += "SINTAXE:" + CRLF
    cMsg += "Begin Transaction" + CRLF
    cMsg += "   // Operações no banco" + CRLF
    cMsg += "   RecLock(...)" + CRLF
    cMsg += "   If lErro" + CRLF
    cMsg += "      RollBack  // Desfaz tudo" + CRLF
    cMsg += "   EndIf" + CRLF
    cMsg += "End Transaction  // Confirma tudo" + CRLF + CRLF
    
    cMsg += "QUANDO USAR:" + CRLF
    cMsg += "• Incluir pedido + itens" + CRLF
    cMsg += "• Transferência entre contas" + CRLF
    cMsg += "• Baixa de título + movimento" + CRLF
    cMsg += "• Qualquer operação em lote" + CRLF + CRLF
    
    cMsg += "BENEFÍCIOS:" + CRLF
    cMsg += "? Garante integridade" + CRLF
    cMsg += "? Desfaz se der erro" + CRLF
    cMsg += "? Atomicidade (tudo ou nada)" + CRLF + CRLF
    
    cMsg += "?? Sempre use em operações críticas!"
    
    MsgInfo(cMsg, "Conceito Transação")
Return

/*
EXEMPLO 2: Begin/End Transaction
*/
Static Function fEx02()
    Local cCodigo := ""
    Local cMsg := ""
    Local lOk := .T.
    
    cMsg := "? BEGIN/END TRANSACTION" + CRLF + CRLF
    
    cCodigo := GetSx8Num("SA1", "A1_COD")
    
    cMsg += "Incluindo cliente..." + CRLF + CRLF
    
    Begin Transaction
        
        RecLock("SA1", .T.)
        SA1->A1_FILIAL := xFilial("SA1")
        SA1->A1_COD := cCodigo
        SA1->A1_LOJA := "01"
        SA1->A1_NOME := "CLIENTE TRANSACAO"
        SA1->A1_NREDUZ := "CLI TRANS"
        SA1->A1_TIPO := "R"
        SA1->A1_EST := "SP"
        SA1->A1_MUN := "SAO PAULO"
        MsUnlock()
        
        lOk := .T.
        
    End Transaction
    
    If lOk
        ConfirmSx8()
        cMsg += "? GRAVADO COM SUCESSO!" + CRLF + CRLF
        cMsg += "Código: " + cCodigo + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        cMsg += "?? End Transaction confirmou"
    Else
        RollbackSx8()
        cMsg += "? Erro ao gravar"
    EndIf
    
    MsgInfo(cMsg, "Begin/End")
Return

/*
EXEMPLO 3: RollBack em Caso de Erro
*/
Static Function fEx03()
    Local cCodigo := ""
    Local cMsg := ""
    Local lErro := .F.
    
    cMsg := "? ROLLBACK POR ERRO" + CRLF + CRLF
    
    cCodigo := GetSx8Num("SA1", "A1_COD")
    
    Begin Transaction
        
        // Primeira inclusão
        RecLock("SA1", .T.)
        SA1->A1_FILIAL := xFilial("SA1")
        SA1->A1_COD := cCodigo
        SA1->A1_LOJA := "01"
        SA1->A1_NOME := "CLIENTE 1"
        SA1->A1_NREDUZ := "CLI 1"
        SA1->A1_TIPO := "R"
        MsUnlock()
        
        cMsg += "1º inclusão: OK" + CRLF
        
        // Simula erro na segunda
        lErro := .T.
        
        If lErro
            cMsg += "2º inclusão: ERRO!" + CRLF + CRLF
            DisarmTransaction()
            RollBack
        EndIf
        
    End Transaction
    
    If lErro
        RollbackSx8()
        
        cMsg += "?? ROLLBACK EXECUTADO" + CRLF + CRLF
        
        // Verifica se foi gravado
        DbSelectArea("SA1")
        DbSetOrder(1)
        If !DbSeek(xFilial("SA1") + cCodigo)
            cMsg += "? 1º registro NÃO foi gravado" + CRLF
            cMsg += "Transação desfeita!" + CRLF + CRLF
        EndIf
        
        cMsg += "?? RollBack desfaz TUDO" + CRLF
        cMsg += "?? Garante integridade"
    EndIf
    
    MsgInfo(cMsg, "RollBack")
Return

/*
EXEMPLO 4: Incluir Pedido com Transação
*/
Static Function fEx04()
    Local cNumPed := ""
    Local cCliente := ""
    Local cMsg := ""
    Local lOk := .T.
    
    cMsg := "?? INCLUIR PEDIDO" + CRLF + CRLF
    
    // Busca um cliente
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If Eof()
        MsgAlert("Nenhum cliente cadastrado!", "Atenção")
        Return
    EndIf
    
    cCliente := SA1->A1_COD
    cNumPed := GetSx8Num("SC5", "C5_NUM")
    
    Begin Transaction
        
        // Cabeçalho
        RecLock("SC5", .T.)
        SC5->C5_FILIAL := xFilial("SC5")
        SC5->C5_NUM := cNumPed
        SC5->C5_TIPO := "N"
        SC5->C5_CLIENTE := cCliente
        SC5->C5_LOJACLI := SA1->A1_LOJA
        SC5->C5_EMISSAO := Date()
        MsUnlock()
        
        cMsg += "Cabeçalho: OK" + CRLF
        
        // Item 1
        RecLock("SC6", .T.)
        SC6->C6_FILIAL := xFilial("SC6")
        SC6->C6_NUM := cNumPed
        SC6->C6_ITEM := "01"
        SC6->C6_PRODUTO := "PA001"
        SC6->C6_QTDVEN := 1
        SC6->C6_PRCVEN := 100.00
        SC6->C6_VALOR := 100.00
        MsUnlock()
        
        cMsg += "Item 01: OK" + CRLF
        
        // Item 2
        RecLock("SC6", .T.)
        SC6->C6_FILIAL := xFilial("SC6")
        SC6->C6_NUM := cNumPed
        SC6->C6_ITEM := "02"
        SC6->C6_PRODUTO := "PA002"
        SC6->C6_QTDVEN := 2
        SC6->C6_PRCVEN := 50.00
        SC6->C6_VALOR := 100.00
        MsUnlock()
        
        cMsg += "Item 02: OK" + CRLF + CRLF
        
        If !lOk
            DisarmTransaction()
        EndIf
        
    End Transaction
    
    If lOk
        ConfirmSx8()
        cMsg += "? PEDIDO GRAVADO!" + CRLF + CRLF
        cMsg += "Número: " + cNumPed + CRLF
        cMsg += "Itens: 2" + CRLF
        cMsg += "Valor: R$ 200,00" + CRLF + CRLF
        cMsg += "?? Cabeçalho + itens em 1 transação"
    Else
        RollbackSx8()
        cMsg += "? Erro - Nada foi gravado"
    EndIf
    
    MsgInfo(cMsg, "Incluir Pedido")
Return

/*
EXEMPLO 5: Transferência Entre Contas (Simulado)
*/
Static Function fEx05()
    Local cContaOrigem := "001"
    Local cContaDestino := "002"
    Local nValor := 1000.00
    Local cMsg := ""
    Local lOk := .T.
    
    cMsg := "?? TRANSFERÊNCIA ENTRE CONTAS" + CRLF + CRLF
    
    cMsg += "Origem: " + cContaOrigem + CRLF
    cMsg += "Destino: " + cContaDestino + CRLF
    cMsg += "Valor: R$ " + Transform(nValor, "@E 999,999.99") + CRLF + CRLF
    
    Begin Transaction
        
        // Débita conta origem
        RecLock("SE1", .T.)  // Simulação
        SE1->E1_FILIAL := xFilial("SE1")
        SE1->E1_PREFIXO := "TRF"
        SE1->E1_NUM := "000001"
        SE1->E1_TIPO := "NF"
        SE1->E1_VALOR := nValor * -1  // Débito
        MsUnlock()
        
        cMsg += "? Débito conta origem" + CRLF
        
        // Credita conta destino
        RecLock("SE1", .T.)  // Simulação
        SE1->E1_FILIAL := xFilial("SE1")
        SE1->E1_PREFIXO := "TRF"
        SE1->E1_NUM := "000002"
        SE1->E1_TIPO := "NF"
        SE1->E1_VALOR := nValor  // Crédito
        MsUnlock()
        
        cMsg += "? Crédito conta destino" + CRLF + CRLF
        
        // Simula validação
        If nValor <= 0
            lOk := .F.
            DisarmTransaction()
        EndIf
        
    End Transaction
    
    If lOk
        cMsg += "? TRANSFERÊNCIA CONCLUÍDA!" + CRLF + CRLF
        cMsg += "?? Ambas operações gravadas" + CRLF
        cMsg += "?? Integridade garantida"
    Else
        cMsg += "? TRANSFERÊNCIA CANCELADA!" + CRLF + CRLF
        cMsg += "Nenhuma operação foi gravada"
    EndIf
    
    MsgInfo(cMsg, "Transferência")
Return
