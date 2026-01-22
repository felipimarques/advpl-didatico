// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} VAR01
Exemplos práticos de tipos de dados em ADVPL

Tipos disponíveis:
- Caractere (String)
- Numérico (Integer e Decimal)
- Lógico (Boolean)
- Data
- Array
- Objeto
- Bloco de código

@type User Function
@author Felipi Marques
@since 06/11/2025

@example
U_VAR01()
/*/

User Function VAR01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Tipos de Dados", ;
                     "1-Caractere (String)" + CRLF + ;
                     "2-Numérico" + CRLF + ;
                     "3-Lógico (Boolean)" + CRLF + ;
                     "4-Data" + CRLF + ;
                     "5-Array e Objeto" + CRLF + ;
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
EXEMPLO 1: Tipo Caractere (String)
Usado para textos: códigos, nomes, descrições
*/
Static Function fEx01()
    Local cCodProd := "PA001"
    Local cDescr := "PRODUTO A"
    Local cCNPJ := "12.345.678/0001-95"
    Local cObs := ""
    Local cMsg := ""
    
    cObs := "Produto cadastrado em " + DtoC(Date())
    
    cMsg := "?? TIPO CARACTERE" + CRLF + CRLF
    cMsg += "Código: " + cCodProd + CRLF
    cMsg += "Tipo: " + ValType(cCodProd) + " (Character)" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cCodProd)) + " chars" + CRLF + CRLF
    cMsg += "Descrição: " + cDescr + CRLF
    cMsg += "CNPJ: " + cCNPJ + CRLF
    cMsg += "Observação: " + cObs + CRLF + CRLF
    cMsg += "?? Dica: Use aspas duplas ou simples"
    
    MsgInfo(cMsg, "Caractere")
Return

/*
EXEMPLO 2: Tipo Numérico
Inteiros e decimais no mesmo tipo
*/
Static Function fEx02()
    Local nQtde := 10
    Local nPreco := 125.50
    Local nTotal := 0
    Local nDesc := 0.15  // 15%
    Local nFinal := 0
    Local cMsg := ""
    
    nTotal := nQtde * nPreco
    nFinal := nTotal * (1 - nDesc)
    
    cMsg := "?? TIPO NUMÉRICO" + CRLF + CRLF
    
    cMsg += "Quantidade: " + cValToChar(nQtde) + CRLF
    cMsg += "Tipo: " + ValType(nQtde) + " (Numeric)" + CRLF + CRLF
    
    cMsg += "Preço: R$ " + Transform(nPreco, "@E 999,999.99") + CRLF
    cMsg += "Desconto: " + Transform(nDesc*100, "@E 999.99") + "%" + CRLF
    cMsg += "Total: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF
    cMsg += "Final: R$ " + Transform(nFinal, "@E 999,999.99") + CRLF + CRLF
    
    cMsg += "?? Dica: Não tem separação int/float"
    
    MsgInfo(cMsg, "Numérico")
Return

/*
EXEMPLO 3: Tipo Lógico (Boolean)
Usado para flags, status, validações
*/
Static Function fEx03()
    Local lAtivo := .T.
    Local lBloq := .F.
    Local lVIP := .T.
    Local lTemPed := .T.
    Local cMsg := ""
    
    cMsg := "? TIPO LÓGICO" + CRLF + CRLF
    
    cMsg += "Cliente ativo? " + If(lAtivo, "SIM", "NÃO") + CRLF
    cMsg += "Tipo: " + ValType(lAtivo) + " (Logical)" + CRLF
    cMsg += "Valor: " + cValToChar(lAtivo) + CRLF + CRLF
    
    cMsg += "Bloqueado? " + If(lBloq, "SIM", "NÃO") + CRLF
    cMsg += "É VIP? " + If(lVIP, "SIM", "NÃO") + CRLF
    cMsg += "Tem pedidos? " + If(lTemPed, "SIM", "NÃO") + CRLF + CRLF
    
    // Validação
    If lAtivo .And. !lBloq .And. lVIP
        cMsg += "? Cliente apto para faturamento"
    Else
        cMsg += "? Cliente não pode faturar"
    EndIf
    
    cMsg += CRLF + CRLF + "?? Dica: .T. = True / .F. = False"
    
    MsgInfo(cMsg, "Lógico")
Return

/*
EXEMPLO 4: Tipo Data
Formato interno AAAAMMDD
*/
Static Function fEx04()
    Local dHoje := Date()
    Local dEmiss := CToD("15/01/2026")
    Local dVenc := dEmiss + 30
    Local nDias := 0
    Local cMsg := ""
    
    nDias := dVenc - dHoje
    
    cMsg := "?? TIPO DATA" + CRLF + CRLF
    
    cMsg += "Data de hoje: " + DtoC(dHoje) + CRLF
    cMsg += "Tipo: " + ValType(dHoje) + " (Date)" + CRLF
    cMsg += "Formato interno: " + DtoS(dHoje) + CRLF + CRLF
    
    cMsg += "Data emissão: " + DtoC(dEmiss) + CRLF
    cMsg += "Data vencimento: " + DtoC(dVenc) + CRLF
    cMsg += "Prazo: " + cValToChar(dVenc - dEmiss) + " dias" + CRLF + CRLF
    
    If nDias >= 0
        cMsg += "? Faltam " + cValToChar(nDias) + " dias"
    Else
        cMsg += "?? Vencido há " + cValToChar(Abs(nDias)) + " dias"
    EndIf
    
    cMsg += CRLF + CRLF + "?? Dica: Date(), CToD(), DtoC()"
    
    MsgInfo(cMsg, "Data")
Return

/*
EXEMPLO 5: Array e Objeto
Estruturas complexas
*/
Static Function fEx05()
    Local aProd := {}
    Local oCliente := Nil
    Local cMsg := ""
    
    // Array simples
    aAdd(aProd, "PA001")
    aAdd(aProd, "PRODUTO A")
    aAdd(aProd, 125.50)
    
    // Objeto simples
    oCliente := JsonObject():New()
    oCliente["codigo"] := "000001"
    oCliente["nome"] := "CLIENTE TESTE"
    oCliente["ativo"] := .T.
    
    cMsg := "?? ARRAY E OBJETO" + CRLF + CRLF
    
    cMsg += "=== ARRAY ===" + CRLF
    cMsg += "Tipo: " + ValType(aProd) + " (Array)" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(aProd)) + CRLF
    cMsg += "[1] " + aProd[1] + CRLF
    cMsg += "[2] " + aProd[2] + CRLF
    cMsg += "[3] " + cValToChar(aProd[3]) + CRLF + CRLF
    
    cMsg += "=== OBJETO ===" + CRLF
    cMsg += "Tipo: " + ValType(oCliente) + " (Object)" + CRLF
    cMsg += "Código: " + oCliente["codigo"] + CRLF
    cMsg += "Nome: " + oCliente["nome"] + CRLF
    cMsg += "Ativo: " + If(oCliente["ativo"], "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "?? Veremos mais detalhes depois"
    
    MsgInfo(cMsg, "Array/Objeto")
Return
