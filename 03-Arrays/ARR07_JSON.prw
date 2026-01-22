// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR07
Exemplos práticos de conversão JSON

Funções abordadas:
- FwJsonSerialize() - array para JSON
- FwJsonDeserialize() - JSON para array
- ToJson() - objeto para JSON
- FromJson() - JSON para objeto
- Integração com APIs

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR07()
/*/

User Function ARR07()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Conversão JSON", ;
                     "1-Array para JSON" + CRLF + ;
                     "2-JSON para Array" + CRLF + ;
                     "3-Objeto para JSON" + CRLF + ;
                     "4-Exportar pedido" + CRLF + ;
                     "5-Importar clientes" + CRLF + ;
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
EXEMPLO 1: Array para JSON
*/
Static Function fEx01()
    Local aProdutos := {}
    Local cJson := ""
    Local cMsg := ""
    
    cMsg := "?? ARRAY PARA JSON" + CRLF + CRLF
    
    // Monta array
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00})
    aAdd(aProdutos, {"PA003", "TECLADO", 125.00})
    
    cMsg += "Array original:" + CRLF
    cMsg += "3 produtos cadastrados" + CRLF + CRLF
    
    // Converte para JSON
    cJson := FwJsonSerialize(aProdutos, .F., .T.)
    
    cMsg += "JSON gerado:" + CRLF
    cMsg += cJson + CRLF + CRLF
    
    cMsg += "Código:" + CRLF
    cMsg += "FwJsonSerialize(aProdutos, .F., .T.)" + CRLF + CRLF
    
    cMsg += "Parâmetros:" + CRLF
    cMsg += ".F. = Não usar UTF8" + CRLF
    cMsg += ".T. = Identar (pretty)" + CRLF + CRLF
    
    cMsg += "?? Usar para APIs/integração"
    
    MsgInfo(cMsg, "Array ? JSON")
Return

/*
EXEMPLO 2: JSON para Array
*/
Static Function fEx02()
    Local cJson := ""
    Local aItens := {}
    Local cErro := ""
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? JSON PARA ARRAY" + CRLF + CRLF
    
    // JSON de exemplo
    cJson := '[{"codigo":"CLI001","nome":"JOSE"},{"codigo":"CLI002","nome":"MARIA"}]'
    
    cMsg += "JSON recebido:" + CRLF
    cMsg += cJson + CRLF + CRLF
    
    // Converte para array
    FwJsonDeserialize(cJson, @aItens)
    
    If Len(aItens) > 0
        cMsg += "Array convertido:" + CRLF
        For nI := 1 To Len(aItens)
            cMsg += cValToChar(nI) + ". " + aItens[nI]["codigo"] + " - " + aItens[nI]["nome"] + CRLF
        Next nI
        
        cMsg += CRLF + "Acesso:" + CRLF
        cMsg += "aItens[1]['codigo']" + CRLF
        cMsg += "aItens[1]:codigo" + CRLF + CRLF
        
        cMsg += "?? JSON vira dicionário"
    Else
        cMsg += "? Erro ao converter JSON"
    EndIf
    
    MsgInfo(cMsg, "JSON ? Array")
Return

/*
EXEMPLO 3: Objeto para JSON
*/
Static Function fEx03()
    Local oCliente := Nil
    Local cJson := ""
    Local cMsg := ""
    
    cMsg := "?? OBJETO PARA JSON" + CRLF + CRLF
    
    // Cria objeto
    oCliente := JsonObject():New()
    oCliente["codigo"] := "CLI001"
    oCliente["nome"] := "JOSE SILVA"
    oCliente["ativo"] := .T.
    oCliente["credito"] := 5000.00
    
    cMsg += "Objeto criado:" + CRLF
    cMsg += "Código: " + oCliente["codigo"] + CRLF
    cMsg += "Nome: " + oCliente["nome"] + CRLF
    cMsg += "Ativo: " + If(oCliente["ativo"], "Sim", "Não") + CRLF
    cMsg += "Crédito: R$ " + Transform(oCliente["credito"], "@E 999,999.99") + CRLF + CRLF
    
    // Converte para JSON
    cJson := oCliente:ToJson()
    
    cMsg += "JSON gerado:" + CRLF
    cMsg += cJson + CRLF + CRLF
    
    cMsg += "Código:" + CRLF
    cMsg += "oCliente:ToJson()" + CRLF + CRLF
    
    cMsg += "?? JsonObject facilita conversão"
    
    MsgInfo(cMsg, "Objeto ? JSON")
Return

/*
EXEMPLO 4: Exportar Pedido Completo
*/
Static Function fEx04()
    Local oPedido := JsonObject():New()
    Local aItens := {}
    Local oItem := Nil
    Local cJson := ""
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? EXPORTAR PEDIDO" + CRLF + CRLF
    
    // Cabeçalho
    oPedido["numero"] := "PED001"
    oPedido["cliente"] := "CLI001"
    oPedido["data"] := DToS(Date())
    
    // Itens
    oItem := JsonObject():New()
    oItem["produto"] := "PA001"
    oItem["descricao"] := "NOTEBOOK"
    oItem["qtd"] := 2
    oItem["preco"] := 3500.00
    aAdd(aItens, oItem)
    
    oItem := JsonObject():New()
    oItem["produto"] := "PA002"
    oItem["descricao"] := "MOUSE"
    oItem["qtd"] := 5
    oItem["preco"] := 35.00
    aAdd(aItens, oItem)
    
    oPedido["itens"] := aItens
    
    // Gera JSON
    cJson := oPedido:ToJson()
    
    cMsg += "JSON do pedido:" + CRLF
    cMsg += SubStr(cJson, 1, 200) + "..." + CRLF + CRLF
    
    cMsg += "Estrutura:" + CRLF
    cMsg += "• Cabeçalho" + CRLF
    cMsg += "• Array de itens" + CRLF + CRLF
    
    cMsg += "?? Enviar para API externa"
    
    MsgInfo(cMsg, "Exportar Pedido")
Return

/*
EXEMPLO 5: Importar Clientes da API
*/
Static Function fEx05()
    Local cJson := ""
    Local oRetorno := JsonObject():New()
    Local aClientes := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? IMPORTAR CLIENTES" + CRLF + CRLF
    
    // Simula JSON da API
    cJson := '{"sucesso":true,"total":3,"clientes":['
    cJson += '{"codigo":"CLI001","nome":"JOSE SILVA","cnpj":"12345678000199"},'
    cJson += '{"codigo":"CLI002","nome":"MARIA SANTOS","cnpj":"98765432000188"},'
    cJson += '{"codigo":"CLI003","nome":"PEDRO COSTA","cnpj":"11122233000177"}'
    cJson += ']}'
    
    // Processa JSON
    oRetorno:FromJson(cJson)
    
    If oRetorno["sucesso"]
        aClientes := oRetorno["clientes"]
        
        cMsg += "? Importação OK" + CRLF
        cMsg += "Total: " + cValToChar(oRetorno["total"]) + " clientes" + CRLF + CRLF
        
        cMsg += "=== CLIENTES ===" + CRLF
        For nI := 1 To Len(aClientes)
            cMsg += cValToChar(nI) + ". " + aClientes[nI]["codigo"] + CRLF
            cMsg += "   Nome: " + aClientes[nI]["nome"] + CRLF
            cMsg += "   CNPJ: " + aClientes[nI]["cnpj"] + CRLF
        Next nI
        
        cMsg += CRLF + "?? Pronto para gravar no banco"
    Else
        cMsg += "? Erro na importação"
    EndIf
    
    MsgInfo(cMsg, "Importar Clientes")
Return
