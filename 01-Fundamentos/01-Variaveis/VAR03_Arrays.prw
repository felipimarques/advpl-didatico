// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} VAR03
Exemplos práticos de Arrays em ADVPL

Arrays são listas que podem conter qualquer tipo:
- Arrays simples (unidimensionais)
- Arrays multidimensionais
- Arrays dinâmicos
- Funções úteis: aAdd, aDel, aSize, aScan

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_VAR03()
/*/

User Function VAR03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Arrays - Fundamentos", ;
                     "1-Array simples" + CRLF + ;
                     "2-Array multidimensional" + CRLF + ;
                     "3-Adicionar/Remover" + CRLF + ;
                     "4-Percorrer (For/ForEach)" + CRLF + ;
                     "5-Buscar (aScan)" + CRLF + ;
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
EXEMPLO 1: Array Simples
*/
Static Function fEx01()
    Local aProdutos := {}
    Local cMsg := ""
    
    // Adiciona elementos
    aAdd(aProdutos, "PA001")
    aAdd(aProdutos, "PA002")
    aAdd(aProdutos, "PA003")
    
    cMsg := "?? ARRAY SIMPLES" + CRLF + CRLF
    cMsg += "Declaração:" + CRLF
    cMsg += "Local aProdutos := {}" + CRLF + CRLF
    
    cMsg += "Adicionando:" + CRLF
    cMsg += "aAdd(aProdutos, 'PA001')" + CRLF
    cMsg += "aAdd(aProdutos, 'PA002')" + CRLF
    cMsg += "aAdd(aProdutos, 'PA003')" + CRLF + CRLF
    
    cMsg += "Resultado:" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(aProdutos)) + CRLF
    cMsg += "[1] = " + aProdutos[1] + CRLF
    cMsg += "[2] = " + aProdutos[2] + CRLF
    cMsg += "[3] = " + aProdutos[3] + CRLF + CRLF
    
    cMsg += "?? Arrays começam em 1 (não 0)"
    
    MsgInfo(cMsg, "Array Simples")
Return

/*
EXEMPLO 2: Array Multidimensional
Estrutura de tabela (linhas e colunas)
*/
Static Function fEx02()
    Local aItens := {}
    Local cMsg := ""
    
    // Cada linha é um array
    aAdd(aItens, {"PA001", "PRODUTO A", 10, 125.50})
    aAdd(aItens, {"PA002", "PRODUTO B", 25, 75.00})
    aAdd(aItens, {"PA003", "PRODUTO C", 5, 200.00})
    
    cMsg := "?? ARRAY MULTIDIMENSIONAL" + CRLF + CRLF
    cMsg += "Estrutura de tabela:" + CRLF
    cMsg += "[Linha][Coluna]" + CRLF + CRLF
    
    cMsg += "Item 1:" + CRLF
    cMsg += "Código: " + aItens[1][1] + CRLF
    cMsg += "Descr: " + aItens[1][2] + CRLF
    cMsg += "Qtde: " + cValToChar(aItens[1][3]) + CRLF
    cMsg += "Preço: " + Transform(aItens[1][4], "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "Item 2:" + CRLF
    cMsg += "Código: " + aItens[2][1] + CRLF
    cMsg += "Descr: " + aItens[2][2] + CRLF
    cMsg += "Qtde: " + cValToChar(aItens[2][3]) + CRLF
    cMsg += "Preço: " + Transform(aItens[2][4], "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Muito usado em grids/MsNewGetDados"
    
    MsgInfo(cMsg, "Array Multidimensional")
Return

/*
EXEMPLO 3: Adicionar e Remover
*/
Static Function fEx03()
    Local aLista := {}
    Local cMsg := ""
    
    // Adiciona
    aAdd(aLista, "Item 1")
    aAdd(aLista, "Item 2")
    aAdd(aLista, "Item 3")
    aAdd(aLista, "Item 4")
    
    cMsg := "? ADICIONAR/REMOVER" + CRLF + CRLF
    cMsg += "Após adicionar 4 itens:" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(aLista)) + CRLF + CRLF
    
    // Remove posição 2
    aDel(aLista, 2)
    aSize(aLista, Len(aLista)-1)
    
    cMsg += "Após remover posição 2:" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(aLista)) + CRLF
    cMsg += "[1] = " + aLista[1] + CRLF
    cMsg += "[2] = " + aLista[2] + CRLF
    cMsg += "[3] = " + aLista[3] + CRLF + CRLF
    
    cMsg += "?? IMPORTANTE:" + CRLF
    cMsg += "aDel() marca para deletar" + CRLF
    cMsg += "aSize() redimensiona" + CRLF
    cMsg += "Use os dois juntos!"
    
    MsgInfo(cMsg, "Adicionar/Remover")
Return

/*
EXEMPLO 4: Percorrer Array
*/
Static Function fEx04()
    Local aClientes := {"CLI001", "CLI002", "CLI003", "CLI004", "CLI005"}
    Local cMsg := ""
    Local nI := 0
    Local cItem := ""
    
    cMsg := "?? PERCORRER ARRAY" + CRLF + CRLF
    
    // Forma 1: For tradicional
    cMsg += "=== FOR TRADICIONAL ===" + CRLF
    For nI := 1 To Len(aClientes)
        cMsg += "[" + cValToChar(nI) + "] " + aClientes[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "=== FOR EACH ===" + CRLF
    For Each cItem In aClientes
        cMsg += "• " + cItem + CRLF
    Next cItem
    
    cMsg += CRLF + "?? For Each é mais simples" + CRLF
    cMsg += "mas For tradicional dá mais controle"
    
    MsgInfo(cMsg, "Percorrer")
Return

/*
EXEMPLO 5: Buscar com aScan
*/
Static Function fEx05()
    Local aEstoque := {}
    Local nPos := 0
    Local cMsg := ""
    
    // Monta array
    aAdd(aEstoque, {"PA001", 100})
    aAdd(aEstoque, {"PA002", 250})
    aAdd(aEstoque, {"PA003", 50})
    aAdd(aEstoque, {"PA004", 0})
    
    cMsg := "?? BUSCAR COM ASCAN" + CRLF + CRLF
    
    // Busca produto PA002
    nPos := aScan(aEstoque, {|x| x[1] == "PA002"})
    
    If nPos > 0
        cMsg += "? Produto PA002 encontrado!" + CRLF
        cMsg += "Posição: " + cValToChar(nPos) + CRLF
        cMsg += "Código: " + aEstoque[nPos][1] + CRLF
        cMsg += "Saldo: " + cValToChar(aEstoque[nPos][2]) + CRLF + CRLF
    Else
        cMsg += "? Produto não encontrado" + CRLF + CRLF
    EndIf
    
    // Busca produto zerado
    nPos := aScan(aEstoque, {|x| x[2] == 0})
    
    If nPos > 0
        cMsg += "?? Produto zerado encontrado!" + CRLF
        cMsg += "Código: " + aEstoque[nPos][1] + CRLF + CRLF
    EndIf
    
    cMsg += "?? aScan retorna posição ou 0"
    
    MsgInfo(cMsg, "aScan")
Return
