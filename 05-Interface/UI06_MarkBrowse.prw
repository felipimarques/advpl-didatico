// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} UI06
Exemplos práticos de seleção múltipla

Funções abordadas:
- MarkBrowse básico
- Seleção de registros
- Processamento de marcados
- Ações em lote
- Relatórios com seleção

@type User Function
@author Felipi Marques
@since 16/01/2026

@example
U_UI06()
/*/

User Function UI06()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Seleção Múltipla", ;
                     "1-Conceito MarkBrowse" + CRLF + ;
                     "2-Selecionar clientes" + CRLF + ;
                     "3-Selecionar produtos" + CRLF + ;
                     "4-Reajuste seletivo" + CRLF + ;
                     "5-Relatório selecionado" + CRLF + ;
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
EXEMPLO 1: Conceito de MarkBrowse
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? MARKBROWSE" + CRLF + CRLF
    
    cMsg += "Permite selecionar múltiplos registros" + CRLF
    cMsg += "para processamento em lote" + CRLF + CRLF
    
    cMsg += "ESTRUTURA BÁSICA:" + CRLF + CRLF
    
    cMsg += "// Marca temporária" + CRLF
    cMsg += "cMarca := GetMark()" + CRLF + CRLF
    
    cMsg += "// Define campos do browse" + CRLF
    cMsg += "aCampos := {" + CRLF
    cMsg += "  {'OK', 'C', 2, 0}," + CRLF
    cMsg += "  {'CODIGO', 'C', 6, 0}," + CRLF
    cMsg += "  {'NOME', 'C', 40, 0}" + CRLF
    cMsg += "}" + CRLF + CRLF
    
    cMsg += "// Cria MarkBrowse" + CRLF
    cMsg += "oBrowse := FWMarkBrowse():New()" + CRLF
    cMsg += "oBrowse:SetAlias('SA1')" + CRLF
    cMsg += "oBrowse:SetMark(cMarca, 'SA1', 'OK')" + CRLF
    cMsg += "oBrowse:Activate()" + CRLF + CRLF
    
    cMsg += "// Processar marcados" + CRLF
    cMsg += "DbSelectArea('SA1')" + CRLF
    cMsg += "DbGoTop()" + CRLF
    cMsg += "While !Eof()" + CRLF
    cMsg += "  If SA1->OK == cMarca" + CRLF
    cMsg += "    // Processar" + CRLF
    cMsg += "  EndIf" + CRLF
    cMsg += "  DbSkip()" + CRLF
    cMsg += "EndDo" + CRLF + CRLF
    
    cMsg += "USO:" + CRLF
    cMsg += "• Reajuste seletivo" + CRLF
    cMsg += "• Exclusão em lote" + CRLF
    cMsg += "• Relatórios personalizados" + CRLF
    cMsg += "• Importação/exportação"
    
    MsgInfo(cMsg, "Conceito")
Return

/*
EXEMPLO 2: Selecionar Clientes
*/
Static Function fEx02()
    MsgInfo("Seleção de Clientes" + CRLF + CRLF + ;
            "Abriria tela de seleção múltipla" + CRLF + ;
            "com lista de clientes para marcar" + CRLF + CRLF + ;
            "Após seleção, poderia:" + CRLF + ;
            "• Enviar email em lote" + CRLF + ;
            "• Alterar condição de pagamento" + CRLF + ;
            "• Gerar etiquetas" + CRLF + ;
            "• Exportar para Excel", "Seleção Clientes")
Return

/*
EXEMPLO 3: Selecionar Produtos
*/
Static Function fEx03()
    MsgInfo("Seleção de Produtos" + CRLF + CRLF + ;
            "Abriria browse com:" + CRLF + CRLF + ;
            "? PA001 - NOTEBOOK - R$ 3.500,00" + CRLF + ;
            "? PA002 - MOUSE - R$ 35,00" + CRLF + ;
            "? PA003 - TECLADO - R$ 125,00" + CRLF + ;
            "? PA004 - MONITOR - R$ 850,00" + CRLF + CRLF + ;
            "Usuário marca os desejados" + CRLF + ;
            "Pressiona OK para confirmar", "Seleção Produtos")
Return

/*
EXEMPLO 4: Reajuste Seletivo
*/
Static Function fEx04()
    Local aProdutos := {}
    Local aSelecionados := {}
    Local nI := 0
    Local nPerc := 15
    Local cMsg := ""
    
    // Simula lista de produtos
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00, .F.})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00, .F.})
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00, .F.})
    aAdd(aProdutos, {"PA004", "MONITOR", 850.00, .F.})
    
    cMsg := "?? SIMULAÇÃO DE SELEÇÃO" + CRLF + CRLF
    cMsg += "Produtos disponíveis:" + CRLF + CRLF
    
    For nI := 1 To Len(aProdutos)
        cMsg += "? " + aProdutos[nI][1] + " - " + aProdutos[nI][2]
        cMsg += " - R$ " + Transform(aProdutos[nI][3], "@E 999,999.99") + CRLF
    Next nI
    
    cMsg += CRLF + "Usuário marcaria os produtos desejados"
    
    MsgInfo(cMsg, "Seleção")
    
    // Simula seleção (marca os dois primeiros)
    aProdutos[1][4] := .T.
    aProdutos[2][4] := .T.
    
    // Monta lista de selecionados
    For nI := 1 To Len(aProdutos)
        If aProdutos[nI][4]
            aAdd(aSelecionados, aProdutos[nI])
        EndIf
    Next nI
    
    If Len(aSelecionados) > 0
        
        cMsg := "? PRODUTOS SELECIONADOS" + CRLF + CRLF
        
        For nI := 1 To Len(aSelecionados)
            cMsg += "? " + aSelecionados[nI][1] + " - " + aSelecionados[nI][2] + CRLF
        Next nI
        
        cMsg += CRLF + "Reajuste: " + cValToChar(nPerc) + "%"
        
        MsgInfo(cMsg, "Selecionados")
        
        If MsgYesNo("Confirma reajuste de " + cValToChar(nPerc) + "% nos produtos selecionados?", "Confirmar")
            
            cMsg := "?? REAJUSTE APLICADO" + CRLF + CRLF
            
            For nI := 1 To Len(aSelecionados)
                aSelecionados[nI][3] := aSelecionados[nI][3] * (1 + (nPerc/100))
                
                cMsg += aSelecionados[nI][1] + " - "
                cMsg += "R$ " + Transform(aSelecionados[nI][3], "@E 999,999.99") + CRLF
            Next nI
            
            cMsg += CRLF + "Produtos atualizados: " + cValToChar(Len(aSelecionados))
            
            MsgInfo(cMsg, "Sucesso")
        EndIf
    Else
        MsgAlert("Nenhum produto selecionado", "Atenção")
    EndIf
Return

/*
EXEMPLO 5: Relatório com Seleção
*/
Static Function fEx05()
    Local aClientes := {}
    Local aSelecionados := {}
    Local nI := 0
    Local cMsg := ""
    Local nTotal := 0
    
    // Simula lista de clientes
    aAdd(aClientes, {"CLI001", "JOSE SILVA", "SP", 15000.00, .F.})
    aAdd(aClientes, {"CLI002", "MARIA SANTOS", "RJ", 25000.00, .F.})
    aAdd(aClientes, {"CLI003", "PEDRO COSTA", "MG", 8000.00, .F.})
    aAdd(aClientes, {"CLI004", "ANA SOUZA", "SP", 32000.00, .F.})
    
    cMsg := "?? RELATÓRIO PERSONALIZADO" + CRLF + CRLF
    cMsg += "Selecione os clientes para o relatório:" + CRLF + CRLF
    
    For nI := 1 To Len(aClientes)
        cMsg += "? " + aClientes[nI][2] + " (" + aClientes[nI][3] + ")" + CRLF
    Next nI
    
    MsgInfo(cMsg, "Seleção Relatório")
    
    // Simula seleção
    aClientes[1][5] := .T.
    aClientes[3][5] := .T.
    aClientes[4][5] := .T.
    
    // Processa selecionados
    For nI := 1 To Len(aClientes)
        If aClientes[nI][5]
            aAdd(aSelecionados, aClientes[nI])
            nTotal += aClientes[nI][4]
        EndIf
    Next nI
    
    If Len(aSelecionados) > 0
        
        cMsg := "?? RELATÓRIO GERADO" + CRLF + CRLF
        cMsg += "=== CLIENTES SELECIONADOS ===" + CRLF + CRLF
        
        For nI := 1 To Len(aSelecionados)
            cMsg += cValToChar(nI) + ". " + aSelecionados[nI][2] + CRLF
            cMsg += "   Estado: " + aSelecionados[nI][3] + CRLF
            cMsg += "   Faturamento: R$ " + Transform(aSelecionados[nI][4], "@E 999,999.99") + CRLF + CRLF
        Next nI
        
        cMsg += "=== TOTAIS ===" + CRLF
        cMsg += "Clientes: " + cValToChar(Len(aSelecionados)) + CRLF
        cMsg += "Faturamento: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
        
        cMsg += "Relatório seria impresso/exportado"
        
        MsgInfo(cMsg, "Relatório")
    EndIf
Return
