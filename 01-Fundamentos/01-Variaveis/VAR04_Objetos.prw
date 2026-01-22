// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} VAR04
Exemplos práticos de Objetos em ADVPL

Objetos permitem agrupar dados e métodos:
- JsonObject (mais comum)
- Classes personalizadas
- Propriedades e métodos
- Útil para retornos de funções
- Estruturas complexas

@type User Function
@author Felipi Marques
@since 25/11/2025

@example
U_VAR04()
/*/

User Function VAR04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Objetos - Fundamentos", ;
                     "1-JsonObject simples" + CRLF + ;
                     "2-Objeto de cliente" + CRLF + ;
                     "3-Objeto de pedido" + CRLF + ;
                     "4-Array de objetos" + CRLF + ;
                     "5-ToJson/FromJson" + CRLF + ;
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
EXEMPLO 1: JsonObject Simples
*/
Static Function fEx01()
    Local oProduto := JsonObject():New()
    Local cMsg := ""
    
    // Define propriedades
    oProduto["codigo"] := "PA001"
    oProduto["descricao"] := "PRODUTO A"
    oProduto["preco"] := 125.50
    oProduto["ativo"] := .T.
    
    cMsg := "?? OBJETO SIMPLES" + CRLF + CRLF
    cMsg += "JsonObject():New()" + CRLF + CRLF
    
    cMsg += "Código: " + oProduto["codigo"] + CRLF
    cMsg += "Descrição: " + oProduto["descricao"] + CRLF
    cMsg += "Preço: R$ " + Transform(oProduto["preco"], "@E 999,999.99") + CRLF
    cMsg += "Ativo: " + If(oProduto["ativo"], "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "?? Acesso: objeto['propriedade']"
    
    MsgInfo(cMsg, "JsonObject")
Return

/*
EXEMPLO 2: Objeto de Cliente
*/
Static Function fEx02()
    Local oCliente := fCriaCliente()
    Local cMsg := ""
    
    cMsg := "?? OBJETO CLIENTE" + CRLF + CRLF
    cMsg += "Código: " + oCliente["codigo"] + CRLF
    cMsg += "Loja: " + oCliente["loja"] + CRLF
    cMsg += "Nome: " + oCliente["nome"] + CRLF
    cMsg += "CNPJ: " + oCliente["cnpj"] + CRLF
    cMsg += "Tipo: " + oCliente["tipo"] + CRLF
    cMsg += "Bloqueado: " + If(oCliente["bloqueado"], "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Endereço:" + CRLF
    cMsg += oCliente["endereco"]["rua"] + ", " + oCliente["endereco"]["numero"] + CRLF
    cMsg += oCliente["endereco"]["cidade"] + "/" + oCliente["endereco"]["uf"] + CRLF
    cMsg += "CEP: " + oCliente["endereco"]["cep"] + CRLF + CRLF
    
    cMsg += "?? Objetos podem ter objetos dentro"
    
    MsgInfo(cMsg, "Cliente")
Return

Static Function fCriaCliente()
    Local oCliente := JsonObject():New()
    Local oEnder := JsonObject():New()
    
    oCliente["codigo"] := "000001"
    oCliente["loja"] := "01"
    oCliente["nome"] := "CLIENTE TESTE LTDA"
    oCliente["cnpj"] := "12.345.678/0001-95"
    oCliente["tipo"] := "F"  // F=Fornecedor
    oCliente["bloqueado"] := .F.
    
    oEnder["rua"] := "Av. Paulista"
    oEnder["numero"] := "1000"
    oEnder["cidade"] := "São Paulo"
    oEnder["uf"] := "SP"
    oEnder["cep"] := "01310-100"
    
    oCliente["endereco"] := oEnder
    
Return oCliente

/*
EXEMPLO 3: Objeto de Pedido com Itens
*/
Static Function fEx03()
    Local oPedido := fCriaPedido()
    Local cMsg := ""
    Local nI := 0
    Local nTotal := 0
    
    cMsg := "?? OBJETO PEDIDO" + CRLF + CRLF
    cMsg += "Número: " + oPedido["numero"] + CRLF
    cMsg += "Cliente: " + oPedido["cliente"] + CRLF
    cMsg += "Emissão: " + DtoC(oPedido["emissao"]) + CRLF
    cMsg += "Condição: " + oPedido["condpgto"] + CRLF + CRLF
    
    cMsg += "ITENS:" + CRLF
    For nI := 1 To Len(oPedido["itens"])
        cMsg += "[" + cValToChar(nI) + "] "
        cMsg += oPedido["itens"][nI]["produto"] + " - "
        cMsg += "Qtd: " + cValToChar(oPedido["itens"][nI]["qtde"]) + " - "
        cMsg += "R$ " + Transform(oPedido["itens"][nI]["vlrunit"], "@E 999.99") + CRLF
        nTotal += oPedido["itens"][nI]["qtde"] * oPedido["itens"][nI]["vlrunit"]
    Next nI
    
    cMsg += CRLF + "Total: R$ " + Transform(nTotal, "@E 999,999.99")
    
    MsgInfo(cMsg, "Pedido")
Return

Static Function fCriaPedido()
    Local oPedido := JsonObject():New()
    Local aItens := {}
    Local oItem := Nil
    
    oPedido["numero"] := "000123"
    oPedido["cliente"] := "000001"
    oPedido["emissao"] := Date()
    oPedido["condpgto"] := "001"
    
    // Item 1
    oItem := JsonObject():New()
    oItem["produto"] := "PA001"
    oItem["qtde"] := 10
    oItem["vlrunit"] := 125.50
    aAdd(aItens, oItem)
    
    // Item 2
    oItem := JsonObject():New()
    oItem["produto"] := "PA002"
    oItem["qtde"] := 5
    oItem["vlrunit"] := 75.00
    aAdd(aItens, oItem)
    
    oPedido["itens"] := aItens
    
Return oPedido

/*
EXEMPLO 4: Array de Objetos
*/
Static Function fEx04()
    Local aClientes := {}
    Local oCliente := Nil
    Local cMsg := ""
    Local nI := 0
    
    // Cliente 1
    oCliente := JsonObject():New()
    oCliente["codigo"] := "000001"
    oCliente["nome"] := "CLIENTE A"
    oCliente["ativo"] := .T.
    aAdd(aClientes, oCliente)
    
    // Cliente 2
    oCliente := JsonObject():New()
    oCliente["codigo"] := "000002"
    oCliente["nome"] := "CLIENTE B"
    oCliente["ativo"] := .F.
    aAdd(aClientes, oCliente)
    
    // Cliente 3
    oCliente := JsonObject():New()
    oCliente["codigo"] := "000003"
    oCliente["nome"] := "CLIENTE C"
    oCliente["ativo"] := .T.
    aAdd(aClientes, oCliente)
    
    cMsg := "?? ARRAY DE OBJETOS" + CRLF + CRLF
    cMsg += "Total: " + cValToChar(Len(aClientes)) + " clientes" + CRLF + CRLF
    
    For nI := 1 To Len(aClientes)
        cMsg += "[" + cValToChar(nI) + "] "
        cMsg += aClientes[nI]["codigo"] + " - "
        cMsg += aClientes[nI]["nome"] + " - "
        cMsg += If(aClientes[nI]["ativo"], "?", "?") + CRLF
    Next nI
    
    cMsg += CRLF + "?? Muito usado em APIs REST"
    
    MsgInfo(cMsg, "Array de Objetos")
Return

/*
EXEMPLO 5: Conversão JSON
*/
Static Function fEx05()
    Local oProduto := JsonObject():New()
    Local cJson := ""
    Local oNovo := Nil
    Local cMsg := ""
    
    // Cria objeto
    oProduto["codigo"] := "PA001"
    oProduto["descricao"] := "PRODUTO A"
    oProduto["preco"] := 125.50
    oProduto["ativo"] := .T.
    
    // Converte para JSON
    cJson := oProduto:ToJson()
    
    // Converte de volta para objeto
    oNovo := JsonObject():New()
    oNovo:FromJson(cJson)
    
    cMsg := "?? CONVERSÃO JSON" + CRLF + CRLF
    cMsg += "=== OBJETO ORIGINAL ===" + CRLF
    cMsg += "Código: " + oProduto["codigo"] + CRLF
    cMsg += "Preço: " + cValToChar(oProduto["preco"]) + CRLF + CRLF
    
    cMsg += "=== JSON ===" + CRLF
    cMsg += cJson + CRLF + CRLF
    
    cMsg += "=== OBJETO NOVO ===" + CRLF
    cMsg += "Código: " + oNovo["codigo"] + CRLF
    cMsg += "Preço: " + cValToChar(oNovo["preco"]) + CRLF + CRLF
    
    cMsg += "?? Útil para APIs e integrações"
    
    MsgInfo(cMsg, "JSON")
Return
