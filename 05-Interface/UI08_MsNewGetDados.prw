// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI08
Exemplos práticos de grid editável

Funções abordadas:
- MsNewGetDados - grid editável
- Linha de cabeçalho
- Validações de linha
- Adição/exclusão de linhas
- Totalizadores
- Pedido completo com itens

@type User Function
@author Felipi Marques
@since 17/01/2026

@example
U_UI08()
/*/

User Function UI08()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Grid Editável", ;
                     "1-Conceito GetDados" + CRLF + ;
                     "2-Grid simples" + CRLF + ;
                     "3-Grid com validação" + CRLF + ;
                     "4-Pedido completo" + CRLF + ;
                     "5-Cálculo automático" + CRLF + ;
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
EXEMPLO 1: Conceito de GetDados
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? GETDADOS (Grid Editável)" + CRLF + CRLF
    
    cMsg += "Permite edição de múltiplas linhas" + CRLF
    cMsg += "como itens de pedido, nota fiscal, etc" + CRLF + CRLF
    
    cMsg += "ESTRUTURA BÁSICA:" + CRLF + CRLF
    
    cMsg += "// Array com dados" + CRLF
    cMsg += "aItens := {}" + CRLF
    cMsg += "aAdd(aItens, {'001', 'MOUSE', 1, 35.00, 35.00})" + CRLF + CRLF
    
    cMsg += "// Cabeçalho" + CRLF
    cMsg += "aHeader := {}" + CRLF
    cMsg += "aAdd(aHeader, {'Produto', 'C6_PRODUTO', '@!', ...})" + CRLF
    cMsg += "aAdd(aHeader, {'Qtde', 'C6_QTDVEN', '@E 9999', ...})" + CRLF + CRLF
    
    cMsg += "// Cria GetDados" + CRLF
    cMsg += "oGetDados := MsNewGetDados():New(" + CRLF
    cMsg += "  nTop, nLeft, nBottom, nRight," + CRLF
    cMsg += "  GD_INSERT+GD_DELETE+GD_UPDATE," + CRLF
    cMsg += "  'AllwaysTrue', 'AllwaysTrue'," + CRLF
    cMsg += "  '', {campos editáveis}," + CRLF
    cMsg += "  0, 999, cFieldOk, '', cDelOk," + CRLF
    cMsg += "  oDlg, aHeader, aItens)" + CRLF + CRLF
    
    cMsg += "// Acessar dados" + CRLF
    cMsg += "aCols := oGetDados:aCols" + CRLF + CRLF
    
    cMsg += "FUNCIONALIDADES:" + CRLF
    cMsg += "• Incluir linhas (Ctrl+N)" + CRLF
    cMsg += "• Excluir linhas (Ctrl+D)" + CRLF
    cMsg += "• Validações de campo" + CRLF
    cMsg += "• Validações de linha" + CRLF
    cMsg += "• Cálculos automáticos" + CRLF + CRLF
    
    cMsg += "USO:" + CRLF
    cMsg += "• Itens de pedido" + CRLF
    cMsg += "• Itens de nota fiscal" + CRLF
    cMsg += "• Lançamentos contábeis" + CRLF
    cMsg += "• Lista de produtos" + CRLF
    cMsg += "• Planilhas diversas"
    
    MsgInfo(cMsg, "Conceito")
Return

/*
EXEMPLO 2: Grid Simples
*/
Static Function fEx02()
    Local cMsg := ""
    
    cMsg := "?? GRID SIMPLES" + CRLF + CRLF
    
    cMsg += "Exemplo de grid básico com produtos:" + CRLF + CRLF
    
    cMsg += "??????????????????????????????????????????????????" + CRLF
    cMsg += "? Produto? Descrição    ?Qtde? Preço   ? Total   ?" + CRLF
    cMsg += "??????????????????????????????????????????????????" + CRLF
    cMsg += "? PA001  ? NOTEBOOK     ?  1 ? 3.500,00? 3.500,00?" + CRLF
    cMsg += "? PA002  ? MOUSE        ?  2 ?    35,00?    70,00?" + CRLF
    cMsg += "? PA003  ? TECLADO      ?  1 ?   125,00?   125,00?" + CRLF
    cMsg += "??????????????????????????????????????????????????" + CRLF + CRLF
    
    cMsg += "Usuário pode:" + CRLF
    cMsg += "• Clicar nas células para editar" + CRLF
    cMsg += "• F3 no campo produto" + CRLF
    cMsg += "• Ctrl+N para nova linha" + CRLF
    cMsg += "• Ctrl+D para excluir linha" + CRLF + CRLF
    
    cMsg += "Total calculado automaticamente"
    
    MsgInfo(cMsg, "Grid Simples")
Return

/*
EXEMPLO 3: Grid com Validação
*/
Static Function fEx03()
    Local aItens := {}
    Local nI := 0
    Local cMsg := ""
    Local lOk := .T.
    
    // Simula dados do grid
    aAdd(aItens, {"PA001", "NOTEBOOK", 1, 3500.00, 3500.00, .F.})
    aAdd(aItens, {"PA002", "MOUSE", 0, 35.00, 0.00, .F.})  // Qtde zero - erro
    aAdd(aItens, {"", "", 1, 0.00, 0.00, .F.})  // Produto vazio - erro
    
    cMsg := "? VALIDAÇÃO DE GRID" + CRLF + CRLF
    cMsg += "Validando itens do grid..." + CRLF + CRLF
    
    For nI := 1 To Len(aItens)
        
        cMsg += "Linha " + cValToChar(nI) + ": "
        
        // Valida produto
        If Empty(aItens[nI][1])
            cMsg += "? Produto não informado" + CRLF
            lOk := .F.
            Loop
        EndIf
        
        // Valida quantidade
        If aItens[nI][3] <= 0
            cMsg += "? Quantidade inválida" + CRLF
            lOk := .F.
            Loop
        EndIf
        
        // Valida preço
        If aItens[nI][4] <= 0
            cMsg += "? Preço inválido" + CRLF
            lOk := .F.
            Loop
        EndIf
        
        cMsg += "? OK" + CRLF
        
    Next nI
    
    cMsg += CRLF
    
    If lOk
        cMsg += "? Todos os itens validados!"
    Else
        cMsg += "? Corrija os erros antes de continuar"
    EndIf
    
    MsgInfo(cMsg, "Validação")
Return

/*
EXEMPLO 4: Pedido Completo
*/
Static Function fEx04()
    Local aItens := {}
    Local nI := 0
    Local cMsg := ""
    Local nTotal := 0
    
    // Cabeçalho
    Local cPedido := "000001"
    Local cCliente := "CLI001"
    Local cNome := "JOSE SILVA"
    Local dEmissao := Date()
    
    // Simula itens do pedido
    aAdd(aItens, {"PA001", "NOTEBOOK DELL", 2, 3500.00, 7000.00, .F.})
    aAdd(aItens, {"PA002", "MOUSE LOGITECH", 2, 35.00, 70.00, .F.})
    aAdd(aItens, {"PA003", "TECLADO MICROSOFT", 2, 125.00, 250.00, .F.})
    aAdd(aItens, {"PA004", "MONITOR LG 24", 2, 850.00, 1700.00, .F.})
    
    cMsg := "?? PEDIDO DE VENDAS" + CRLF + CRLF
    
    cMsg += "=== CABEÇALHO ===" + CRLF
    cMsg += "Pedido: " + cPedido + CRLF
    cMsg += "Cliente: " + cCliente + " - " + cNome + CRLF
    cMsg += "Emissão: " + DtoC(dEmissao) + CRLF + CRLF
    
    cMsg += "=== ITENS ===" + CRLF + CRLF
    
    For nI := 1 To Len(aItens)
        cMsg += cValToChar(nI) + ". " + AllTrim(aItens[nI][1]) + " - " + AllTrim(aItens[nI][2]) + CRLF
        cMsg += "   Qtde: " + cValToChar(aItens[nI][3])
        cMsg += " x R$ " + Transform(aItens[nI][4], "@E 999,999.99")
        cMsg += " = R$ " + Transform(aItens[nI][5], "@E 999,999.99") + CRLF + CRLF
        
        nTotal += aItens[nI][5]
    Next nI
    
    cMsg += "=== TOTAIS ===" + CRLF
    cMsg += "Itens: " + cValToChar(Len(aItens)) + CRLF
    cMsg += "Total: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "? Pedido pronto para gravar"
    
    MsgInfo(cMsg, "Pedido")
    
    If MsgYesNo("Confirma gravação do pedido?", "Confirmar")
        MsgInfo("?? Pedido gravado com sucesso!" + CRLF + CRLF + ;
                "Número: " + cPedido, "Sucesso")
    EndIf
Return

/*
EXEMPLO 5: Cálculo Automático
*/
Static Function fEx05()
    Local aItens := {}
    Local nI := 0
    Local cMsg := ""
    Local nSubTotal := 0
    Local nDesconto := 10  // 10%
    Local nValDesc := 0
    Local nTotal := 0
    
    // Itens
    aAdd(aItens, {"PA001", "NOTEBOOK", 1, 3500.00})
    aAdd(aItens, {"PA002", "MOUSE", 2, 35.00})
    aAdd(aItens, {"PA003", "TECLADO", 1, 125.00})
    
    cMsg := "?? CÁLCULO AUTOMÁTICO" + CRLF + CRLF
    
    cMsg += "ITENS:" + CRLF
    
    For nI := 1 To Len(aItens)
        nTotalItem := aItens[nI][3] * aItens[nI][4]
        
        cMsg += aItens[nI][2] + CRLF
        cMsg += cValToChar(aItens[nI][3]) + " x R$ " + Transform(aItens[nI][4], "@E 999,999.99")
        cMsg += " = R$ " + Transform(nTotalItem, "@E 999,999.99") + CRLF + CRLF
        
        nSubTotal += nTotalItem
    Next nI
    
    // Calcula desconto
    nValDesc := nSubTotal * (nDesconto / 100)
    nTotal := nSubTotal - nValDesc
    
    cMsg += "???????????????????????????" + CRLF
    cMsg += "Subtotal: R$ " + Transform(nSubTotal, "@E 999,999.99") + CRLF
    cMsg += "Desconto " + cValToChar(nDesconto) + "%: R$ " + Transform(nValDesc, "@E 999,999.99") + CRLF
    cMsg += "???????????????????????????" + CRLF
    cMsg += "TOTAL: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Valores calculados automaticamente!" + CRLF + CRLF
    
    cMsg += "RECURSOS:" + CRLF
    cMsg += "• Subtotal calculado ao somar itens" + CRLF
    cMsg += "• Desconto aplicado sobre subtotal" + CRLF
    cMsg += "• Total atualizado em tempo real" + CRLF
    cMsg += "• Mudança em qtde/preço recalcula tudo"
    
    MsgInfo(cMsg, "Cálculo")
Return
