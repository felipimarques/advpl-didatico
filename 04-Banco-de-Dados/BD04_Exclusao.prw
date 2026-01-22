// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD04
Exemplos práticos de exclusão de registros

Funções abordadas:
- RecLock() + Delete - excluir registro
- DbDelete() - marcar como deletado
- Deleted() - verificar se está deletado
- SET DELETED ON/OFF
- Exclusão em cascata

@type User Function
@author Felipi Marques
@since 28/11/2025

@example
U_BD04()
/*/

User Function BD04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Exclusão", ;
                     "1-Conceito exclusão" + CRLF + ;
                     "2-Excluir registro" + CRLF + ;
                     "3-Deleted() e SET DELETED" + CRLF + ;
                     "4-Excluir cliente" + CRLF + ;
                     "5-Exclusão em cascata" + CRLF + ;
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
EXEMPLO 1: Conceito de Exclusão
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "??? EXCLUSÃO NO PROTHEUS" + CRLF + CRLF
    
    cMsg += "Registro NÃO é removido fisicamente!" + CRLF
    cMsg += "É apenas MARCADO como deletado" + CRLF + CRLF
    
    cMsg += "=== FORMA 1: RecLock + Delete ===" + CRLF
    cMsg += "RecLock('SA1', .F.)" + CRLF
    cMsg += "DbDelete()" + CRLF
    cMsg += "MsUnlock()" + CRLF + CRLF
    
    cMsg += "=== FORMA 2: Direto ===" + CRLF
    cMsg += "DbSelectArea('SA1')" + CRLF
    cMsg += "RecLock('SA1', .F.)" + CRLF
    cMsg += "SA1->(DbDelete())" + CRLF
    cMsg += "MsUnlock()" + CRLF + CRLF
    
    cMsg += "?? IMPORTANTE:" + CRLF
    cMsg += "• SET DELETED ON = ignora deletados" + CRLF
    cMsg += "• SET DELETED OFF = mostra deletados" + CRLF + CRLF
    
    cMsg += "?? Protheus mantém histórico!"
    
    MsgInfo(cMsg, "Conceito Exclusão")
Return

/*
EXEMPLO 2: Excluir Registro
*/
Static Function fEx02()
    Local cMsg := ""
    Local cCodigo := ""
    
    cMsg := "? EXCLUIR REGISTRO" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cCodigo := SA1->A1_COD
        
        cMsg += "ANTES:" + CRLF
        cMsg += "Código: " + AllTrim(SA1->A1_COD) + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF
        cMsg += "Deleted: " + If(Deleted(), "Sim", "Não") + CRLF + CRLF
        
        // Exclui
        RecLock("SA1", .F.)
        DbDelete()
        MsUnlock()
        
        cMsg += "DEPOIS:" + CRLF
        cMsg += "Código: " + AllTrim(SA1->A1_COD) + CRLF
        cMsg += "Deleted: " + If(Deleted(), "Sim ?", "Não") + CRLF + CRLF
        
        cMsg += "? Registro marcado como deletado!" + CRLF + CRLF
        
        cMsg += "?? DbDelete() marca para exclusão" + CRLF
        cMsg += "?? Deleted() verifica status"
    Else
        cMsg += "? Nenhum registro para excluir"
    EndIf
    
    MsgInfo(cMsg, "Excluir")
Return

/*
EXEMPLO 3: Deleted() e SET DELETED
*/
Static Function fEx03()
    Local cMsg := ""
    Local nTotal := 0
    Local nDeletados := 0
    
    cMsg := "?? DELETED() e SET DELETED" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Conta com SET DELETED OFF (mostra deletados)
    SET DELETED OFF
    DbGoTop()
    
    While !Eof()
        nTotal++
        If Deleted()
            nDeletados++
        EndIf
        DbSkip()
    EndDo
    
    cMsg += "SET DELETED OFF:" + CRLF
    cMsg += "Total registros: " + cValToChar(nTotal) + CRLF
    cMsg += "Deletados: " + cValToChar(nDeletados) + CRLF
    cMsg += "Ativos: " + cValToChar(nTotal - nDeletados) + CRLF + CRLF
    
    // Conta com SET DELETED ON (ignora deletados)
    SET DELETED ON
    nTotal := 0
    DbGoTop()
    
    While !Eof()
        nTotal++
        DbSkip()
    EndDo
    
    cMsg += "SET DELETED ON:" + CRLF
    cMsg += "Total registros: " + cValToChar(nTotal) + CRLF
    cMsg += "(Deletados não aparecem)" + CRLF + CRLF
    
    cMsg += "?? SET DELETED ON é o padrão" + CRLF
    cMsg += "?? Usuários não veem deletados"
    
    MsgInfo(cMsg, "SET DELETED")
Return

/*
EXEMPLO 4: Excluir Cliente com Validação
*/
Static Function fEx04()
    Local cCodigo := ""
    Local cLoja := ""
    Local cMsg := ""
    Local lTemPedido := .F.
    
    cMsg := "??? EXCLUIR CLIENTE" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cCodigo := SA1->A1_COD
        cLoja := SA1->A1_LOJA
        
        cMsg += "Cliente: " + AllTrim(SA1->A1_COD) + "/" + SA1->A1_LOJA + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        // Verifica se tem pedidos
        DbSelectArea("SC5")
        DbSetOrder(1)  // Filial + Num
        DbGoTop()
        
        While !Eof()
            If SC5->C5_CLIENTE == cCodigo .And. SC5->C5_LOJACLI == cLoja
                lTemPedido := .T.
                Exit
            EndIf
            DbSkip()
        EndDo
        
        If lTemPedido
            cMsg += "? NÃO PODE EXCLUIR!" + CRLF + CRLF
            cMsg += "Cliente possui pedidos cadastrados" + CRLF + CRLF
            cMsg += "?? Validar antes de excluir"
        Else
            // Pode excluir
            DbSelectArea("SA1")
            DbSetOrder(1)
            If DbSeek(xFilial("SA1") + cCodigo + cLoja)
                RecLock("SA1", .F.)
                DbDelete()
                MsUnlock()
                
                cMsg += "? CLIENTE EXCLUÍDO!" + CRLF + CRLF
                cMsg += "?? Sempre valide relacionamentos"
            EndIf
        EndIf
    Else
        cMsg += "? Nenhum cliente para excluir"
    EndIf
    
    MsgInfo(cMsg, "Excluir Cliente")
Return

/*
EXEMPLO 5: Exclusão em Cascata (Pedido + Itens)
*/
Static Function fEx05()
    Local cNumPed := ""
    Local cMsg := ""
    Local nItens := 0
    
    cMsg := "??? EXCLUSÃO EM CASCATA" + CRLF + CRLF
    
    DbSelectArea("SC5")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cNumPed := SC5->C5_NUM
        
        cMsg += "Pedido: " + cNumPed + CRLF
        cMsg += "Cliente: " + AllTrim(SC5->C5_CLIENTE) + CRLF + CRLF
        
        // Conta itens
        DbSelectArea("SC6")
        DbSetOrder(1)  // Filial + Num + Item
        If DbSeek(xFilial("SC6") + cNumPed)
            While !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") ;
                           .And. SC6->C6_NUM == cNumPed
                nItens++
                DbSkip()
            EndDo
        EndIf
        
        cMsg += "Itens: " + cValToChar(nItens) + CRLF + CRLF
        
        // Exclui itens
        DbSelectArea("SC6")
        DbSetOrder(1)
        DbSeek(xFilial("SC6") + cNumPed)
        
        While !Eof() .And. SC6->C6_FILIAL == xFilial("SC6") ;
                       .And. SC6->C6_NUM == cNumPed
            
            RecLock("SC6", .F.)
            DbDelete()
            MsUnlock()
            
            DbSkip()
        EndDo
        
        // Exclui cabeçalho
        DbSelectArea("SC5")
        DbSetOrder(1)
        If DbSeek(xFilial("SC5") + cNumPed)
            RecLock("SC5", .F.)
            DbDelete()
            MsUnlock()
        EndIf
        
        cMsg += "? EXCLUÍDO EM CASCATA!" + CRLF + CRLF
        cMsg += "Cabeçalho: 1 registro" + CRLF
        cMsg += "Itens: " + cValToChar(nItens) + " registros" + CRLF + CRLF
        
        cMsg += "?? Sempre exclua relacionamentos!" + CRLF
        cMsg += "?? Ordem: filhos ? pai"
    Else
        cMsg += "? Nenhum pedido para excluir"
    EndIf
    
    MsgInfo(cMsg, "Exclusão Cascata")
Return
