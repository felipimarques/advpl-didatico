// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR01
Exemplos práticos de manipulação básica de arrays

Funções abordadas:
- aAdd() - adicionar elemento
- aIns() - inserir em posição específica
- aDel() - marcar para deletar
- aSize() - redimensionar array

@type User Function
@author Felipi Marques
@since 07/01/2026

@example
U_ARR01()
/*/

User Function ARR01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Manipulação de Arrays", ;
                     "1-aAdd (adicionar)" + CRLF + ;
                     "2-aIns (inserir posição)" + CRLF + ;
                     "3-aDel + aSize (remover)" + CRLF + ;
                     "4-Lista de produtos" + CRLF + ;
                     "5-Carrinho de compras" + CRLF + ;
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
EXEMPLO 1: aAdd - Adicionar Elementos
*/
Static Function fEx01()
    Local aClientes := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "? aAdd() - ADICIONAR" + CRLF + CRLF
    cMsg += "Array inicial vazio: {}" + CRLF + CRLF
    
    // Adiciona clientes
    aAdd(aClientes, "CLI001")
    aAdd(aClientes, "CLI002")
    aAdd(aClientes, "CLI003")
    
    cMsg += "Após adicionar 3 clientes:" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(aClientes)) + CRLF + CRLF
    
    For nI := 1 To Len(aClientes)
        cMsg += "[" + cValToChar(nI) + "] " + aClientes[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? aAdd sempre adiciona no final"
    
    MsgInfo(cMsg, "aAdd()")
Return

/*
EXEMPLO 2: aIns - Inserir em Posição Específica
*/
Static Function fEx02()
    Local aItens := {"Item 1", "Item 2", "Item 4"}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? aIns() - INSERIR POSIÇÃO" + CRLF + CRLF
    cMsg += "Array original:" + CRLF
    For nI := 1 To Len(aItens)
        cMsg += "[" + cValToChar(nI) + "] " + aItens[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "Inserindo 'Item 3' na posição 3:" + CRLF
    cMsg += "aIns(aItens, 3)" + CRLF
    cMsg += "aItens[3] := 'Item 3'" + CRLF + CRLF
    
    // Insere espaço na posição 3
    aIns(aItens, 3)
    // Define o valor
    aItens[3] := "Item 3"
    
    cMsg += "Array após inserção:" + CRLF
    For nI := 1 To Len(aItens)
        cMsg += "[" + cValToChar(nI) + "] " + aItens[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? aIns cria espaço vazio" + CRLF
    cMsg += "Você precisa atribuir o valor!"
    
    MsgInfo(cMsg, "aIns()")
Return

/*
EXEMPLO 3: aDel + aSize - Remover Elementos
*/
Static Function fEx03()
    Local aProdutos := {"PA001", "PA002", "PA003", "PA004", "PA005"}
    Local cMsg := ""
    Local nI := 0
    Local nPos := 3
    
    cMsg := "? aDel() + aSize() - REMOVER" + CRLF + CRLF
    cMsg += "Array original (5 itens):" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += "[" + cValToChar(nI) + "] " + aProdutos[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "Removendo posição 3:" + CRLF
    cMsg += "aDel(aProdutos, 3)" + CRLF
    cMsg += "aSize(aProdutos, Len(aProdutos)-1)" + CRLF + CRLF
    
    // Remove
    aDel(aProdutos, nPos)
    aSize(aProdutos, Len(aProdutos)-1)
    
    cMsg += "Array após remoção (4 itens):" + CRLF
    For nI := 1 To Len(aProdutos)
        cMsg += "[" + cValToChar(nI) + "] " + aProdutos[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? IMPORTANTE:" + CRLF
    cMsg += "aDel() só marca" + CRLF
    cMsg += "aSize() redimensiona" + CRLF
    cMsg += "Use os dois juntos!"
    
    MsgInfo(cMsg, "aDel() + aSize()")
Return

/*
EXEMPLO 4: Lista de Produtos Cadastrados
*/
Static Function fEx04()
    Local aProdutos := {}
    Local cMsg := ""
    Local nI := 0
    
    // Adiciona produtos
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00})
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00})
    aAdd(aProdutos, {"PA004", "MONITOR", 850.00})
    
    cMsg := "?? CADASTRO DE PRODUTOS" + CRLF + CRLF
    cMsg += "Total cadastrado: " + cValToChar(Len(aProdutos)) + CRLF + CRLF
    
    For nI := 1 To Len(aProdutos)
        cMsg += "Código: " + aProdutos[nI][1] + CRLF
        cMsg += "Produto: " + aProdutos[nI][2] + CRLF
        cMsg += "Preço: R$ " + Transform(aProdutos[nI][3], "@E 999,999.99") + CRLF
        If nI < Len(aProdutos)
            cMsg += Replicate("-", 30) + CRLF
        EndIf
    Next nI
    
    MsgInfo(cMsg, "Lista Produtos")
Return

/*
EXEMPLO 5: Carrinho de Compras (Completo)
*/
Static Function fEx05()
    Local aCarrinho := {}
    Local cMsg := ""
    Local nI := 0
    Local nTotal := 0
    
    // Cliente adiciona produtos
    aAdd(aCarrinho, {"NOTEBOOK", 1, 3500.00})
    aAdd(aCarrinho, {"MOUSE", 2, 35.00})
    aAdd(aCarrinho, {"TECLADO", 1, 125.00})
    
    cMsg := "?? CARRINHO DE COMPRAS" + CRLF + CRLF
    cMsg += "Itens no carrinho: " + cValToChar(Len(aCarrinho)) + CRLF + CRLF
    
    // Lista itens
    For nI := 1 To Len(aCarrinho)
        cMsg += cValToChar(nI) + ". " + aCarrinho[nI][1] + CRLF
        cMsg += "   Qtde: " + cValToChar(aCarrinho[nI][2]) + CRLF
        cMsg += "   Unit: R$ " + Transform(aCarrinho[nI][3], "@E 999,999.99") + CRLF
        cMsg += "   Subtotal: R$ " + Transform(aCarrinho[nI][2] * aCarrinho[nI][3], "@E 999,999.99") + CRLF + CRLF
        nTotal += aCarrinho[nI][2] * aCarrinho[nI][3]
    Next nI
    
    cMsg += Replicate("=", 35) + CRLF
    cMsg += "TOTAL: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    // Cliente remove mouse
    cMsg += "? Removendo MOUSE..." + CRLF
    aDel(aCarrinho, 2)
    aSize(aCarrinho, Len(aCarrinho)-1)
    
    nTotal := 0
    cMsg += CRLF + "Itens atualizados: " + cValToChar(Len(aCarrinho)) + CRLF
    For nI := 1 To Len(aCarrinho)
        nTotal += aCarrinho[nI][2] * aCarrinho[nI][3]
    Next nI
    cMsg += "Novo total: R$ " + Transform(nTotal, "@E 999,999.99")
    
    MsgInfo(cMsg, "Carrinho")
Return
