// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR06
Exemplos práticos de arrays multidimensionais

Tópicos abordados:
- Arrays aninhados (arrays dentro de arrays)
- Estruturas complexas (pedidos com itens)
- Grid de dados (tabelas)
- Acesso a múltiplas dimensões
- Percorrer estruturas complexas

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR06()
/*/

User Function ARR06()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Arrays Multidimensionais", ;
                     "1-Array 2D (tabela)" + CRLF + ;
                     "2-Pedido com itens" + CRLF + ;
                     "3-Grid de produtos" + CRLF + ;
                     "4-Cliente com endereços" + CRLF + ;
                     "5-Relatório hierárquico" + CRLF + ;
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
EXEMPLO 1: Array 2D (Tabela)
*/
Static Function fEx01()
    Local aTabela := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? ARRAY 2D (TABELA)" + CRLF + CRLF
    
    // Monta tabela (linhas e colunas)
    aAdd(aTabela, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aTabela, {"PA002", "MOUSE", 35.00})
    aAdd(aTabela, {"PA003", "TECLADO", 125.00})
    
    cMsg += "Código | Produto | Preço" + CRLF
    cMsg += "-------|---------|-------" + CRLF
    
    For nI := 1 To Len(aTabela)
        cMsg += aTabela[nI][1] + " | "  // Coluna 1
        cMsg += aTabela[nI][2] + " | "  // Coluna 2
        cMsg += Transform(aTabela[nI][3], "@E 999,999.99") + CRLF  // Coluna 3
    Next nI
    
    cMsg += CRLF + "Estrutura:" + CRLF
    cMsg += "aTabela[linha][coluna]" + CRLF + CRLF
    
    cMsg += "Exemplo:" + CRLF
    cMsg += "aTabela[2][2] = " + aTabela[2][2] + CRLF + CRLF
    
    cMsg += "?? Array 2D = linhas e colunas"
    
    MsgInfo(cMsg, "Array 2D")
Return

/*
EXEMPLO 2: Pedido com Itens
*/
Static Function fEx02()
    Local aPedido := {}
    Local aItens := {}
    Local cMsg := ""
    Local nI := 0
    Local nTotal := 0
    
    cMsg := "?? PEDIDO COM ITENS" + CRLF + CRLF
    
    // Cabeçalho do pedido
    aPedido := {"PED001", "CLI001", "JOSE SILVA", Date(), {}}
    
    // Adiciona itens (último elemento é array!)
    aAdd(aPedido[5], {"PA001", "NOTEBOOK", 2, 3500.00})
    aAdd(aPedido[5], {"PA002", "MOUSE", 5, 35.00})
    aAdd(aPedido[5], {"PA003", "TECLADO", 2, 125.00})
    
    cMsg += "=== CABEÇALHO ===" + CRLF
    cMsg += "Pedido: " + aPedido[1] + CRLF
    cMsg += "Cliente: " + aPedido[2] + " - " + aPedido[3] + CRLF
    cMsg += "Data: " + DToC(aPedido[4]) + CRLF + CRLF
    
    cMsg += "=== ITENS ===" + CRLF
    For nI := 1 To Len(aPedido[5])
        aItens := aPedido[5][nI]
        cMsg += cValToChar(nI) + ". " + aItens[2] + CRLF
        cMsg += "   Qtd: " + cValToChar(aItens[3]) + " x R$ "
        cMsg += Transform(aItens[4], "@E 999,999.99") + " = R$ "
        cMsg += Transform(aItens[3] * aItens[4], "@E 999,999.99") + CRLF
        nTotal += aItens[3] * aItens[4]
    Next nI
    
    cMsg += CRLF + "TOTAL: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Array dentro de array"
    
    MsgInfo(cMsg, "Pedido Itens")
Return

/*
EXEMPLO 3: Grid de Produtos (Matriz)
*/
Static Function fEx03()
    Local aGrid := {}
    Local cMsg := ""
    Local nLin := 0
    Local nCol := 0
    Local nQtd := 0
    
    cMsg := "??? GRID DE ESTOQUE" + CRLF + CRLF
    
    // Monta grid 3x4 (3 produtos x 4 filiais)
    // Produto 1
    aAdd(aGrid, {"NOTEBOOK", {100, 50, 75, 25}})
    // Produto 2
    aAdd(aGrid, {"MOUSE", {250, 300, 150, 100}})
    // Produto 3
    aAdd(aGrid, {"TECLADO", {80, 120, 90, 60}})
    
    cMsg += "         | FIL1 | FIL2 | FIL3 | FIL4" + CRLF
    cMsg += "---------|------|------|------|------" + CRLF
    
    For nLin := 1 To Len(aGrid)
        cMsg += PadR(aGrid[nLin][1], 9) + "|"
        For nCol := 1 To Len(aGrid[nLin][2])
            cMsg += PadL(cValToChar(aGrid[nLin][2][nCol]), 5) + " |"
            nQtd += aGrid[nLin][2][nCol]
        Next nCol
        cMsg += CRLF
    Next nLin
    
    cMsg += CRLF + "Total geral: " + cValToChar(nQtd) + " unidades" + CRLF + CRLF
    
    cMsg += "Acesso:" + CRLF
    cMsg += "aGrid[produto][2][filial]" + CRLF + CRLF
    
    cMsg += "?? Matriz para relatórios"
    
    MsgInfo(cMsg, "Grid")
Return

/*
EXEMPLO 4: Cliente com Múltiplos Endereços
*/
Static Function fEx04()
    Local aCliente := {}
    Local aEnderecos := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? CLIENTE COM ENDEREÇOS" + CRLF + CRLF
    
    // Dados do cliente
    aCliente := {"CLI001", "JOSE SILVA", "12345678000199", {}}
    
    // Adiciona endereços
    aAdd(aCliente[4], {"C", "RUA A, 100", "SP", "01234-000"})  // Cobrança
    aAdd(aCliente[4], {"E", "RUA B, 200", "SP", "05678-000"})  // Entrega
    aAdd(aCliente[4], {"E", "RUA C, 300", "RJ", "20000-000"})  // Entrega 2
    
    cMsg += "=== CLIENTE ===" + CRLF
    cMsg += "Código: " + aCliente[1] + CRLF
    cMsg += "Nome: " + aCliente[2] + CRLF
    cMsg += "CNPJ: " + aCliente[3] + CRLF + CRLF
    
    cMsg += "=== ENDEREÇOS ===" + CRLF
    For nI := 1 To Len(aCliente[4])
        aEnderecos := aCliente[4][nI]
        cMsg += cValToChar(nI) + ". "
        cMsg += If(aEnderecos[1] == "C", "Cobrança", "Entrega") + CRLF
        cMsg += "   " + aEnderecos[2] + CRLF
        cMsg += "   " + aEnderecos[3] + " - " + aEnderecos[4] + CRLF
    Next nI
    
    cMsg += CRLF + "Total endereços: " + cValToChar(Len(aCliente[4])) + CRLF + CRLF
    
    cMsg += "?? 1:N em arrays aninhados"
    
    MsgInfo(cMsg, "Cliente Endereços")
Return

/*
EXEMPLO 5: Relatório Hierárquico (Vendedor > Pedidos)
*/
Static Function fEx05()
    Local aVendedores := {}
    Local aVendedor := {}
    Local aPedidos := {}
    Local cMsg := ""
    Local nV := 0
    Local nP := 0
    Local nTotalVend := 0
    Local nTotalGeral := 0
    
    cMsg := "?? RELATÓRIO HIERÁRQUICO" + CRLF + CRLF
    
    // Vendedor 1 com seus pedidos
    aAdd(aVendedores, {"V001", "MARIA", {}})
    aAdd(aVendedores[1][3], {"PED001", 5000.00})
    aAdd(aVendedores[1][3], {"PED002", 3500.00})
    
    // Vendedor 2 com seus pedidos
    aAdd(aVendedores, {"V002", "JOAO", {}})
    aAdd(aVendedores[2][3], {"PED003", 7500.00})
    aAdd(aVendedores[2][3], {"PED004", 2000.00})
    aAdd(aVendedores[2][3], {"PED005", 4500.00})
    
    cMsg += "=== VENDAS POR VENDEDOR ===" + CRLF + CRLF
    
    For nV := 1 To Len(aVendedores)
        aVendedor := aVendedores[nV]
        nTotalVend := 0
        
        cMsg += "?? " + aVendedor[1] + " - " + aVendedor[2] + CRLF
        
        For nP := 1 To Len(aVendedor[3])
            aPedidos := aVendedor[3][nP]
            cMsg += "   • " + aPedidos[1] + " - R$ "
            cMsg += Transform(aPedidos[2], "@E 999,999.99") + CRLF
            nTotalVend += aPedidos[2]
        Next nP
        
        cMsg += "   Subtotal: R$ " + Transform(nTotalVend, "@E 999,999.99") + CRLF + CRLF
        nTotalGeral += nTotalVend
    Next nV
    
    cMsg += "=== TOTAL GERAL ===" + CRLF
    cMsg += "R$ " + Transform(nTotalGeral, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Arrays aninhados para hierarquia"
    
    MsgInfo(cMsg, "Hierárquico")
Return
