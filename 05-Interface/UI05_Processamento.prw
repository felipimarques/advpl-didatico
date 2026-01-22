// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI05
Exemplos práticos de processamento com feedback

Funções abordadas:
- FWMsgRun() - processa com mensagem
- Processa() - barra de progresso
- ProcRegua() - define régua
- IncProc() - incrementa régua
- Processamento em lote

@type User Function
@author Felipi Marques
@since 10/01/2026

@example
U_UI05()
/*/

User Function UI05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Processamento", ;
                     "1-FWMsgRun simples" + CRLF + ;
                     "2-Processa com régua" + CRLF + ;
                     "3-Importar dados" + CRLF + ;
                     "4-Reajustar preços" + CRLF + ;
                     "5-Gerar relatório" + CRLF + ;
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
EXEMPLO 1: FWMsgRun Simples
*/
Static Function fEx01()
    Local nTotal := 0
    
    // Processa com mensagem
    FWMsgRun(, {|oSay| nTotal := fProcessa1(oSay)}, "Aguarde", "Processando dados...")
    
    MsgInfo("Processamento concluído!" + CRLF + CRLF + ;
            "Registros: " + cValToChar(nTotal), "Sucesso")
Return

Static Function fProcessa1(oSay)
    Local nI := 0
    Local nTotal := 100
    
    For nI := 1 To nTotal
        // Atualiza mensagem
        oSay:SetText("Processando " + cValToChar(nI) + " de " + cValToChar(nTotal))
        
        // Simula processamento
        Sleep(50)
    Next nI
    
Return nTotal

/*
EXEMPLO 2: Processa com Régua
*/
Static Function fEx02()
    
    Processa({|| fProcessa2()}, "Processando", "Aguarde...")
    
    MsgInfo("Processamento finalizado!", "Sucesso")
Return

Static Function fProcessa2()
    Local nI := 0
    Local nTotal := 50
    
    // Define régua
    ProcRegua(nTotal)
    
    For nI := 1 To nTotal
        // Incrementa régua
        IncProc("Processando registro " + cValToChar(nI) + "...")
        
        // Simula processamento
        Sleep(100)
    Next nI
    
Return

/*
EXEMPLO 3: Importar Dados
*/
Static Function fEx03()
    Local nImportados := 0
    Local nErros := 0
    Local cMsg := ""
    
    FWMsgRun(, {|oSay| fImportar(oSay, @nImportados, @nErros)}, ;
             "Importação", "Importando clientes...")
    
    cMsg := "?? IMPORTAÇÃO CONCLUÍDA" + CRLF + CRLF
    cMsg += "? Importados: " + cValToChar(nImportados) + CRLF
    
    If nErros > 0
        cMsg += "? Erros: " + cValToChar(nErros) + CRLF
    EndIf
    
    cMsg += CRLF + "Verifique o log para detalhes"
    
    MsgInfo(cMsg, "Importação")
Return

Static Function fImportar(oSay, nImportados, nErros)
    Local nI := 0
    Local nTotal := 25
    Local aClientes := {}
    Local cCodigo := ""
    
    // Simula leitura de arquivo
    oSay:SetText("Lendo arquivo...")
    Sleep(500)
    
    // Simula importação
    For nI := 1 To nTotal
        cCodigo := StrZero(nI, 6)
        
        oSay:SetText("Importando cliente " + cCodigo + " (" + ;
                     cValToChar(nI) + "/" + cValToChar(nTotal) + ")")
        
        // Simula validação
        If nI % 10 == 0  // Simula erro a cada 10
            nErros++
        Else
            // Incluir cliente aqui
            nImportados++
        EndIf
        
        Sleep(100)
    Next nI
    
    oSay:SetText("Finalizando...")
    Sleep(300)
    
Return

/*
EXEMPLO 4: Reajustar Preços em Lote
*/
Static Function fEx04()
    Local nPerc := 10
    Local nTotal := 0
    
    If !MsgYesNo("Confirma reajuste de 10% nos preços?", "Reajuste")
        Return
    EndIf
    
    Processa({|| nTotal := fReajustar(nPerc)}, "Reajuste", "Atualizando preços...")
    
    MsgInfo("? REAJUSTE CONCLUÍDO" + CRLF + CRLF + ;
            "Produtos atualizados: " + cValToChar(nTotal) + CRLF + ;
            "Percentual: " + cValToChar(nPerc) + "%" + CRLF + CRLF + ;
            "Novos preços em vigor!", "Sucesso")
Return

Static Function fReajustar(nPerc)
    Local nCont := 0
    
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbGoTop()
    
    // Conta registros
    Count To nCont
    
    // Define régua
    ProcRegua(nCont)
    
    DbGoTop()
    
    Begin Transaction
        
        While !Eof()
            
            IncProc("Produto: " + AllTrim(SB1->B1_COD) + " - " + AllTrim(SB1->B1_DESC))
            
            If SB1->B1_PRV1 > 0
                RecLock("SB1", .F.)
                SB1->B1_PRV1 := SB1->B1_PRV1 * (1 + (nPerc/100))
                MsUnlock()
            EndIf
            
            DbSkip()
        EndDo
        
    End Transaction
    
Return nCont

/*
EXEMPLO 5: Gerar Relatório Completo
*/
Static Function fEx05()
    Local nClientes := 0
    Local nPedidos := 0
    Local nTotal := 0
    
    Processa({|| fGerarRelatorio(@nClientes, @nPedidos, @nTotal)}, ;
             "Relatório", "Gerando relatório...")
    
    MsgInfo("?? RELATÓRIO GERADO" + CRLF + CRLF + ;
            "Clientes processados: " + cValToChar(nClientes) + CRLF + ;
            "Pedidos analisados: " + cValToChar(nPedidos) + CRLF + ;
            "Valor total: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF + ;
            "Relatório salvo com sucesso!", "Sucesso")
Return

Static Function fGerarRelatorio(nClientes, nPedidos, nTotal)
    Local nCont := 0
    
    // Fase 1: Processar clientes
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    Count To nCont
    ProcRegua(nCont * 2)  // Clientes + Pedidos
    
    DbGoTop()
    While !Eof()
        IncProc("Processando cliente: " + AllTrim(SA1->A1_NOME))
        nClientes++
        DbSkip()
    EndDo
    
    // Fase 2: Processar pedidos
    DbSelectArea("SC5")
    DbSetOrder(1)
    DbGoTop()
    
    While !Eof()
        IncProc("Processando pedido: " + SC5->C5_NUM)
        
        nPedidos++
        
        // Simula cálculo de valor
        DbSelectArea("SC6")
        DbSetOrder(1)
        If DbSeek(xFilial("SC6") + SC5->C5_NUM)
            While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM
                nTotal += SC6->C6_VALOR
                DbSkip()
            EndDo
        EndIf
        
        DbSelectArea("SC5")
        DbSkip()
    EndDo
    
Return
