// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR02
Exemplos práticos de busca em arrays

Funções abordadas:
- aScan() - busca simples
- aScanX() - busca com múltiplas condições
- Busca em arrays multidimensionais
- Validar existência

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR02()
/*/

User Function ARR02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Busca em Arrays", ;
                     "1-aScan simples" + CRLF + ;
                     "2-aScan com bloco" + CRLF + ;
                     "3-Busca multidimensional" + CRLF + ;
                     "4-Validar duplicidade" + CRLF + ;
                     "5-Buscar cliente pedido" + CRLF + ;
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
EXEMPLO 1: aScan Simples
*/
Static Function fEx01()
    Local aStatus := {"A", "B", "C", "D", "E"}
    Local cBusca := "C"
    Local nPos := 0
    Local cMsg := ""
    
    cMsg := "?? aScan() SIMPLES" + CRLF + CRLF
    cMsg += "Array: {'A', 'B', 'C', 'D', 'E'}" + CRLF + CRLF
    
    // Busca
    nPos := aScan(aStatus, cBusca)
    
    cMsg += "Buscando: '" + cBusca + "'" + CRLF
    cMsg += "nPos := aScan(aStatus, 'C')" + CRLF + CRLF
    
    If nPos > 0
        cMsg += "? ENCONTRADO!" + CRLF
        cMsg += "Posição: " + cValToChar(nPos) + CRLF
        cMsg += "Valor: " + aStatus[nPos]
    Else
        cMsg += "? NÃO ENCONTRADO" + CRLF
        cMsg += "nPos = 0"
    EndIf
    
    cMsg += CRLF + CRLF + "?? aScan retorna posição ou 0"
    
    MsgInfo(cMsg, "aScan()")
Return

/*
EXEMPLO 2: aScan com Bloco de Código
*/
Static Function fEx02()
    Local aSaldos := {50, 100, 25, 150, 10}
    Local nPos := 0
    Local cMsg := ""
    
    cMsg := "?? aScan() COM BLOCO" + CRLF + CRLF
    cMsg += "Saldos: {50, 100, 25, 150, 10}" + CRLF + CRLF
    
    // Busca saldo zerado
    nPos := aScan(aSaldos, {|x| x == 0})
    cMsg += "Saldo zerado? " + If(nPos > 0, "SIM [" + cValToChar(nPos) + "]", "NÃO") + CRLF
    
    // Busca saldo abaixo de 30
    nPos := aScan(aSaldos, {|x| x < 30})
    If nPos > 0
        cMsg += "Saldo < 30? SIM [" + cValToChar(nPos) + "] = " + cValToChar(aSaldos[nPos]) + CRLF
    Else
        cMsg += "Saldo < 30? NÃO" + CRLF
    EndIf
    
    // Busca saldo acima de 100
    nPos := aScan(aSaldos, {|x| x > 100})
    If nPos > 0
        cMsg += "Saldo > 100? SIM [" + cValToChar(nPos) + "] = " + cValToChar(aSaldos[nPos]) + CRLF
    Else
        cMsg += "Saldo > 100? NÃO" + CRLF
    EndIf
    
    cMsg += CRLF + "?? Use blocos para condições complexas"
    
    MsgInfo(cMsg, "aScan() Bloco")
Return

/*
EXEMPLO 3: Busca em Array Multidimensional
*/
Static Function fEx03()
    Local aProdutos := {}
    Local cBusca := "PA002"
    Local nPos := 0
    Local cMsg := ""
    
    // Monta array
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00})
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00})
    
    cMsg := "?? BUSCA MULTIDIMENSIONAL" + CRLF + CRLF
    cMsg += "Buscando código: " + cBusca + CRLF + CRLF
    
    // Busca pelo código (coluna 1)
    nPos := aScan(aProdutos, {|x| x[1] == cBusca})
    
    If nPos > 0
        cMsg += "? PRODUTO ENCONTRADO!" + CRLF + CRLF
        cMsg += "Posição: " + cValToChar(nPos) + CRLF
        cMsg += "Código: " + aProdutos[nPos][1] + CRLF
        cMsg += "Descrição: " + aProdutos[nPos][2] + CRLF
        cMsg += "Preço: R$ " + Transform(aProdutos[nPos][3], "@E 999,999.99")
    Else
        cMsg += "? PRODUTO NÃO ENCONTRADO"
    EndIf
    
    cMsg += CRLF + CRLF + "?? Use x[coluna] para acessar"
    
    MsgInfo(cMsg, "Multidimensional")
Return

/*
EXEMPLO 4: Validar Duplicidade ao Cadastrar
*/
Static Function fEx04()
    Local aEmails := {"joao@empresa.com", "maria@empresa.com", "pedro@empresa.com"}
    Local cNovoEmail := "maria@empresa.com"
    Local nPos := 0
    Local cMsg := ""
    
    cMsg := "? VALIDAR DUPLICIDADE" + CRLF + CRLF
    cMsg += "E-mails cadastrados:" + CRLF
    cMsg += "• joao@empresa.com" + CRLF
    cMsg += "• maria@empresa.com" + CRLF
    cMsg += "• pedro@empresa.com" + CRLF + CRLF
    
    cMsg += "Tentando cadastrar: " + cNovoEmail + CRLF + CRLF
    
    // Valida duplicidade
    nPos := aScan(aEmails, {|x| Upper(AllTrim(x)) == Upper(AllTrim(cNovoEmail))})
    
    If nPos > 0
        cMsg += "? E-MAIL JÁ CADASTRADO!" + CRLF
        cMsg += "Posição: " + cValToChar(nPos) + CRLF
        cMsg += "Valor: " + aEmails[nPos] + CRLF + CRLF
        cMsg += "Cadastro bloqueado!"
    Else
        cMsg += "? E-MAIL DISPONÍVEL!" + CRLF + CRLF
        aAdd(aEmails, cNovoEmail)
        cMsg += "Cadastro realizado com sucesso!" + CRLF
        cMsg += "Total: " + cValToChar(Len(aEmails)) + " e-mails"
    EndIf
    
    cMsg += CRLF + CRLF + "?? Sempre valide antes de adicionar"
    
    MsgInfo(cMsg, "Duplicidade")
Return

/*
EXEMPLO 5: Buscar Cliente em Pedido
*/
Static Function fEx05()
    Local aPedidos := {}
    Local cCliente := "CLI002"
    Local aPedCli := {}
    Local nI := 0
    Local cMsg := ""
    
    // Monta pedidos
    aAdd(aPedidos, {"000001", "CLI001", Date()-10, 1500.00})
    aAdd(aPedidos, {"000002", "CLI002", Date()-8, 2500.00})
    aAdd(aPedidos, {"000003", "CLI001", Date()-5, 800.00})
    aAdd(aPedidos, {"000004", "CLI002", Date()-2, 3200.00})
    aAdd(aPedidos, {"000005", "CLI003", Date(), 1200.00})
    
    cMsg := "?? BUSCAR PEDIDOS DO CLIENTE" + CRLF + CRLF
    cMsg += "Cliente: " + cCliente + CRLF + CRLF
    
    // Busca todos pedidos do cliente
    For nI := 1 To Len(aPedidos)
        If aPedidos[nI][2] == cCliente
            aAdd(aPedCli, aPedidos[nI])
        EndIf
    Next nI
    
    If Len(aPedCli) > 0
        cMsg += "? PEDIDOS ENCONTRADOS: " + cValToChar(Len(aPedCli)) + CRLF + CRLF
        
        For nI := 1 To Len(aPedCli)
            cMsg += "Pedido: " + aPedCli[nI][1] + CRLF
            cMsg += "Data: " + DtoC(aPedCli[nI][3]) + CRLF
            cMsg += "Valor: R$ " + Transform(aPedCli[nI][4], "@E 999,999.99") + CRLF
            If nI < Len(aPedCli)
                cMsg += Replicate("-", 30) + CRLF
            EndIf
        Next nI
    Else
        cMsg += "? Nenhum pedido encontrado"
    EndIf
    
    cMsg += CRLF + CRLF + "?? For + If para buscar múltiplos"
    
    MsgInfo(cMsg, "Pedidos Cliente")
Return
