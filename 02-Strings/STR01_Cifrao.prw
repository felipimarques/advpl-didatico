// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR01
Exemplos práticos do operador $ em situações reais do dia a dia no Protheus

Você vai aprender a usar o operador $ (cifrão) através de situações que 
todo desenvolvedor ADVPL enfrenta: validar produtos, filtrar clientes, 
verificar tipos de pedidos, e muito mais!

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs O operador $ verifica se um texto está contido dentro de outro
@obs Muito útil para: validações, filtros, buscas e classificações

@example
U_STR01()

@see
https://tdn.totvs.com/display/tec/Operadores+Comuns
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR01()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Validação de código de produto
            Case nOpcao == 2
                fEx02()  // Filtro de clientes VIP
            Case nOpcao == 3
                fEx03()  // Verificação de tipo de pedido
            Case nOpcao == 4
                fEx04()  // Validação de conta contábil
            Case nOpcao == 5
                fEx05()  // Classificação de fornecedor
        EndCase
    EndDo
    
    RestArea(aArea)
Return

// ==========================================================================
// Menu de Seleção
// ==========================================================================
Static Function fMenuEx()
    Local nOpcao := 0
    Local aOpcoes := {}
    
    aAdd(aOpcoes, "1 - Validar código de produto")
    aAdd(aOpcoes, "2 - Filtrar clientes VIP")
    aAdd(aOpcoes, "3 - Verificar tipo de pedido")
    aAdd(aOpcoes, "4 - Validar conta contábil")
    aAdd(aOpcoes, "5 - Classificar fornecedor")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("Operador $ - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Validação de Código de Produto (Cadastro SB1)
// ==========================================================================
/*
SITUAÇÃO REAL:
No Protheus, produtos podem ter códigos estruturados. Por exemplo:
- PA = Produto Acabado
- MP = Matéria Prima
- ME = Mercadoria

Você precisa validar se o produto digitado pelo usuário é do tipo correto.
*/
Static Function fEx01()
    Local cProduto := Space(15)
    Local lValid   := .F.
    Local cMsg     := ""
    
    // Simula entrada do usuário (no Protheus seria um MsGet)
    cProduto := "PA0001234567890"  // Produto Acabado
    
    // Verifica se o código começa com PA (Produto Acabado)
    lValid := "PA" $ cProduto
    
    If lValid
        cMsg := "? PRODUTO VÁLIDO!" + CRLF + CRLF
        cMsg += "Código: " + cProduto + CRLF
        cMsg += "Tipo: PRODUTO ACABADO" + CRLF + CRLF
        cMsg += "Este produto pode ser faturado!"
        MsgInfo(cMsg, "Validação de Produto")
    Else
        cMsg := "?? ATENÇÃO!" + CRLF + CRLF
        cMsg += "Código: " + cProduto + CRLF + CRLF
        cMsg += "Este NÃO é um produto acabado." + CRLF
        cMsg += "Produtos acabados devem começar com 'PA'"
        MsgAlert(cMsg, "Validação de Produto")
    EndIf
    
    // Demonstra outros tipos
    fMosTip()
Return

Static Function fMosTip()
    Local cInfo := ""
    
    cInfo := "?? TIPOS DE PRODUTO NO PROTHEUS:" + CRLF + CRLF
    cInfo += "PA = Produto Acabado (pode vender)" + CRLF
    cInfo += "MP = Matéria Prima (usa produção)" + CRLF
    cInfo += "ME = Mercadoria (revenda)" + CRLF
    cInfo += "PI = Produto Intermediário" + CRLF + CRLF
    cInfo += "O operador $ ajuda a identificar o tipo!"
    
    MsgInfo(cInfo, "Dica: Tabela SB1")
Return

// ==========================================================================
// Exemplo 2: Filtro de Clientes VIP (Cadastro SA1)
// ==========================================================================
/*
SITUAÇÃO REAL:
Você precisa criar um relatório só com clientes VIP.
No Protheus, você pode marcar clientes especiais no campo A1_TIPO.
Vamos filtrar clientes que têm "VIP" no tipo.
*/
Static Function fEx02()
    Local aClient := {}
    Local cMsg    := ""
    Local nI      := 0
    Local nVIPs   := 0
    
    // Simula dados da tabela SA1 (Clientes)
    aAdd(aClient, {"000001", "EMPRESA ABC LTDA",       "NORMAL"})
    aAdd(aClient, {"000002", "INDUSTRIA XYZ SA",      "VIP"})
    aAdd(aClient, {"000003", "COMERCIO 123",          "NORMAL"})
    aAdd(aClient, {"000004", "CORPORACAO VIP TECH",   "VIP"})
    aAdd(aClient, {"000005", "LOJA DO ZE",            "NORMAL"})
    
    cMsg := "?? FILTRO DE CLIENTES VIP" + CRLF
    cMsg += Replicate("=", 50) + CRLF + CRLF
    
    // Percorre array procurando "VIP" no tipo
    For nI := 1 To Len(aClient)
        // Aqui está a mágica do operador $
        If "VIP" $ aClient[nI][3]
            nVIPs++
            cMsg += "? " + aClient[nI][1] + " - " + aClient[nI][2] + CRLF
        EndIf
    Next nI
    
    cMsg += CRLF + Replicate("=", 50) + CRLF
    cMsg += "Total de clientes VIP: " + cValToChar(nVIPs) + CRLF + CRLF
    cMsg += "?? No Protheus real, você usaria:" + CRLF
    cMsg += "   DbSelectArea('SA1')" + CRLF
    cMsg += "   While !SA1->(Eof())" + CRLF
    cMsg += "      If 'VIP' $ SA1->A1_TIPO ..."
    
    MsgInfo(cMsg, "Tabela SA1 - Clientes")
Return

// ==========================================================================
// Exemplo 3: Verificação de Tipo de Pedido (Tabela SC5)
// ==========================================================================
/*
SITUAÇÃO REAL:
No módulo Faturamento, pedidos podem ser:
- N = Normal
- B = Bonificação
- D = Devolução
- I = Importação

Você precisa validar se pode faturar o pedido.
Apenas pedidos NORMAIS e IMPORTAÇÃO podem ser faturados.
*/
Static Function fEx03()
    Local cPedido := "123456"
    Local cTipo   := "N"  // Pode ser N, B, D ou I
    Local lPodFat := .F.
    Local cMsg    := ""
    
    // Verifica se o tipo permite faturamento
    // Tipos permitidos: N (Normal) ou I (Importação)
    lPodFat := ("N" $ cTipo) .Or. ("I" $ cTipo)
    
    cMsg := "?? VALIDAÇÃO DE FATURAMENTO" + CRLF + CRLF
    cMsg += "Pedido: " + cPedido + CRLF
    cMsg += "Tipo: " + cTipo + " - " + fDesTipo(cTipo) + CRLF + CRLF
    
    If lPodFat
        cMsg += "? PEDIDO LIBERADO PARA FATURAMENTO!" + CRLF + CRLF
        cMsg += "Este pedido pode gerar nota fiscal."
        MsgInfo(cMsg, "Tabela SC5 - Pedidos")
    Else
        cMsg += "?? PEDIDO BLOQUEADO!" + CRLF + CRLF
        cMsg += "Este tipo de pedido NÃO pode ser faturado." + CRLF
        cMsg += "Somente pedidos NORMAIS ou IMPORTAÇÃO."
        MsgStop(cMsg, "Tabela SC5 - Pedidos")
    EndIf
Return

Static Function fDesTipo(cTipo)
    Local cDesc := ""
    
    Do Case
        Case "N" $ cTipo
            cDesc := "NORMAL"
        Case "B" $ cTipo
            cDesc := "BONIFICAÇÃO"
        Case "D" $ cTipo
            cDesc := "DEVOLUÇÃO"
        Case "I" $ cTipo
            cDesc := "IMPORTAÇÃO"
        Otherwise
            cDesc := "DESCONHECIDO"
    EndCase
Return cDesc

// ==========================================================================
// Exemplo 4: Validação de Conta Contábil (Tabela CT1)
// ==========================================================================
/*
SITUAÇÃO REAL:
Contas contábeis seguem estrutura:
- 1.01.001 = Ativo Circulante
- 2.01.001 = Passivo Circulante
- 3.01.001 = Patrimônio Líquido
- 4.01.001 = Receita
- 5.01.001 = Despesa

Você precisa validar se a conta digitada é de RECEITA ou DESPESA.
*/
Static Function fEx04()
    Local cConta := "4.01.001.0001"
    Local cMsg   := ""
    
    cMsg := "?? VALIDAÇÃO CONTÁBIL" + CRLF + CRLF
    cMsg += "Conta: " + cConta + CRLF + CRLF
    
    // Verifica o primeiro dígito da conta
    If "4." $ cConta
        cMsg += "? CONTA DE RECEITA" + CRLF + CRLF
        cMsg += "Esta conta aceita lançamentos de:" + CRLF
        cMsg += "• Vendas" + CRLF
        cMsg += "• Serviços prestados" + CRLF
        cMsg += "• Receitas financeiras"
        MsgInfo(cMsg, "Tabela CT1 - Plano de Contas")
        
    ElseIf "5." $ cConta
        cMsg += "?? CONTA DE DESPESA" + CRLF + CRLF
        cMsg += "Esta conta aceita lançamentos de:" + CRLF
        cMsg += "• Custos operacionais" + CRLF
        cMsg += "• Despesas administrativas" + CRLF
        cMsg += "• Despesas financeiras"
        MsgInfo(cMsg, "Tabela CT1 - Plano de Contas")
        
    Else
        cMsg += "?? CONTA PATRIMONIAL" + CRLF + CRLF
        cMsg += "Esta é uma conta de:" + CRLF
        cMsg += "• Ativo (1.x)" + CRLF
        cMsg += "• Passivo (2.x)" + CRLF
        cMsg += "• Patrimônio Líquido (3.x)"
        MsgInfo(cMsg, "Tabela CT1 - Plano de Contas")
    EndIf
Return

// ==========================================================================
// Exemplo 5: Classificação de Fornecedor (Tabela SA2)
// ==========================================================================
/*
SITUAÇÃO REAL:
Você precisa classificar fornecedores por região para relatórios gerenciais.
Fornecedores de SP têm tratamento diferente (ICMS, prazo, etc).
*/
Static Function fEx05()
    Local aForce := {}
    Local cMsg   := ""
    Local nI     := 0
    Local nSP    := 0
    Local nOutro := 0
    
    // Simula dados da tabela SA2 (Fornecedores)
    aAdd(aForce, {"000001", "FORNECEDOR ABC",  "SP", "São Paulo"})
    aAdd(aForce, {"000002", "INDUSTRIA XYZ",   "RJ", "Rio de Janeiro"})
    aAdd(aForce, {"000003", "COMERCIO 123",    "SP", "Campinas"})
    aAdd(aForce, {"000004", "EMPRESA TECH",    "SP", "Santos"})
    aAdd(aForce, {"000005", "DISTRIBUIDOR MG", "MG", "Belo Horizonte"})
    
    cMsg := "?? CLASSIFICAÇÃO POR REGIÃO" + CRLF
    cMsg += Replicate("=", 50) + CRLF + CRLF
    cMsg += "?? FORNECEDORES DE SÃO PAULO:" + CRLF + CRLF
    
    // Filtra fornecedores de SP
    For nI := 1 To Len(aForce)
        If "SP" $ aForce[nI][3]
            nSP++
            cMsg += "  " + aForce[nI][1] + " - " + aForce[nI][2] + CRLF
            cMsg += "  ?? " + aForce[nI][4] + CRLF + CRLF
        Else
            nOutro++
        EndIf
    Next nI
    
    cMsg += Replicate("=", 50) + CRLF
    cMsg += "Total SP: " + cValToChar(nSP) + " | "
    cMsg += "Outros: " + cValToChar(nOutro) + CRLF + CRLF
    cMsg += "?? Fornecedores SP tem:" + CRLF
    cMsg += "• ICMS diferenciado" + CRLF
    cMsg += "• Prazo de entrega menor" + CRLF
    cMsg += "• Custo de frete reduzido"
    
    MsgInfo(cMsg, "Tabela SA2 - Fornecedores")
Return


