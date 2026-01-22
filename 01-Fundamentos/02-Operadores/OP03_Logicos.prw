// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} OP03
Exemplos práticos de operadores lógicos em ADVPL

Operadores lógicos:
- .And. (E) - todas condições verdadeiras
- .Or. (OU) - pelo menos uma verdadeira
- ! ou .Not. (NÃO) - inverte o valor

Usados para combinar múltiplas condições

@type User Function
@author Felipi Marques
@since 19/11/2025

@example
U_OP03()
/*/

User Function OP03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Operadores Lógicos", ;
                     "1-.And. (E)" + CRLF + ;
                     "2-.Or. (OU)" + CRLF + ;
                     "3-! ou .Not. (NÃO)" + CRLF + ;
                     "4-Combinações" + CRLF + ;
                     "5-Validações ERP" + CRLF + ;
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
EXEMPLO 1: .And. (E) - Todas verdadeiras
*/
Static Function fEx01()
    Local lAtivo := .T.
    Local lBloq := .F.
    Local nSaldo := 100
    Local cMsg := ""
    
    cMsg := "? .AND. (E)" + CRLF + CRLF
    cMsg += "Todas as condições devem ser verdadeiras" + CRLF + CRLF
    
    cMsg += "Cliente ativo: " + If(lAtivo, "SIM", "NÃO") + CRLF
    cMsg += "Bloqueado: " + If(lBloq, "SIM", "NÃO") + CRLF
    cMsg += "Saldo positivo: " + If(nSaldo > 0, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "=== VALIDAÇÃO ===" + CRLF
    If lAtivo .And. !lBloq .And. nSaldo > 0
        cMsg += "? Cliente PODE faturar" + CRLF
        cMsg += "Todas condições OK!"
    Else
        cMsg += "? Cliente NÃO pode faturar" + CRLF
        If !lAtivo
            cMsg += "• Inativo" + CRLF
        EndIf
        If lBloq
            cMsg += "• Bloqueado" + CRLF
        EndIf
        If nSaldo <= 0
            cMsg += "• Sem saldo" + CRLF
        EndIf
    EndIf
    
    cMsg += CRLF + "?? .And. = precisa ser tudo verdade"
    
    MsgInfo(cMsg, ".And.")
Return

/*
EXEMPLO 2: .Or. (OU) - Pelo menos uma verdadeira
*/
Static Function fEx02()
    Local cTipo := "PA"
    Local cGrupo := "0001"
    Local lPromocao := .F.
    Local cMsg := ""
    
    cMsg := "?? .OR. (OU)" + CRLF + CRLF
    cMsg += "Pelo menos uma condição verdadeira" + CRLF + CRLF
    
    cMsg += "Tipo: " + cTipo + CRLF
    cMsg += "Grupo: " + cGrupo + CRLF
    cMsg += "Promoção: " + If(lPromocao, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "=== FILTRO DE PRODUTOS ===" + CRLF
    If cTipo == "PA" .Or. cGrupo == "0001" .Or. lPromocao
        cMsg += "? Produto incluído no filtro!" + CRLF + CRLF
        cMsg += "Motivos:" + CRLF
        If cTipo == "PA"
            cMsg += "• É Produto Acabado" + CRLF
        EndIf
        If cGrupo == "0001"
            cMsg += "• Grupo especial" + CRLF
        EndIf
        If lPromocao
            cMsg += "• Em promoção" + CRLF
        EndIf
    Else
        cMsg += "? Produto NÃO incluído"
    EndIf
    
    cMsg += CRLF + "?? .Or. = basta uma ser verdade"
    
    MsgInfo(cMsg, ".Or.")
Return

/*
EXEMPLO 3: ! ou .Not. (NÃO) - Inverte
*/
Static Function fEx03()
    Local lBloqueado := .F.
    Local lVencido := .F.
    Local lProcessado := .T.
    Local cMsg := ""
    
    cMsg := "?? ! ou .NOT. (NÃO)" + CRLF + CRLF
    cMsg += "Inverte o valor lógico" + CRLF + CRLF
    
    cMsg += "Bloqueado: " + If(lBloqueado, "SIM", "NÃO") + CRLF
    cMsg += "!Bloqueado: " + If(!lBloqueado, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "Vencido: " + If(lVencido, "SIM", "NÃO") + CRLF
    cMsg += ".Not. Vencido: " + If(.Not. lVencido, "SIM", "NÃO") + CRLF + CRLF
    
    cMsg += "=== VALIDAÇÕES ===" + CRLF
    
    // Não bloqueado
    If !lBloqueado
        cMsg += "? Cliente liberado" + CRLF
    EndIf
    
    // Não vencido
    If !lVencido
        cMsg += "? Título em dia" + CRLF
    EndIf
    
    // Não processado
    If !lProcessado
        cMsg += "?? Aguardando processo" + CRLF
    Else
        cMsg += "? Já processado" + CRLF
    EndIf
    
    cMsg += CRLF + "?? ! é mais usado que .Not."
    
    MsgInfo(cMsg, "! .Not.")
Return

/*
EXEMPLO 4: Combinações Complexas
*/
Static Function fEx04()
    Local lVIP := .T.
    Local nPedidos := 15
    Local nValor := 5000
    Local cRegiao := "SUL"
    Local cMsg := ""
    Local lDesconto := .F.
    
    // Regra complexa de desconto
    lDesconto := (lVIP .And. nPedidos >= 10) .Or. (nValor > 10000) .Or. (cRegiao == "SUL" .And. nValor > 3000)
    
    cMsg := "?? COMBINAÇÕES COMPLEXAS" + CRLF + CRLF
    
    cMsg += "Cliente VIP: " + If(lVIP, "SIM", "NÃO") + CRLF
    cMsg += "Pedidos: " + cValToChar(nPedidos) + CRLF
    cMsg += "Valor: R$ " + Transform(nValor, "@E 999,999.99") + CRLF
    cMsg += "Região: " + cRegiao + CRLF + CRLF
    
    cMsg += "=== REGRA DE DESCONTO ===" + CRLF
    cMsg += "(VIP E Pedidos>=10) OU" + CRLF
    cMsg += "(Valor>10000) OU" + CRLF
    cMsg += "(Sul E Valor>3000)" + CRLF + CRLF
    
    If lDesconto
        cMsg += "? TEM DIREITO A DESCONTO!" + CRLF + CRLF
        cMsg += "Motivos:" + CRLF
        If lVIP .And. nPedidos >= 10
            cMsg += "• VIP com muitos pedidos" + CRLF
        EndIf
        If nValor > 10000
            cMsg += "• Valor alto" + CRLF
        EndIf
        If cRegiao == "SUL" .And. nValor > 3000
            cMsg += "• Sul com valor bom" + CRLF
        EndIf
    Else
        cMsg += "? Sem desconto"
    EndIf
    
    cMsg += CRLF + "?? Use parênteses para clareza"
    
    MsgInfo(cMsg, "Combinações")
Return

/*
EXEMPLO 5: Validações ERP Reais
*/
Static Function fEx05()
    Local cTpPed := "N"  // N=Normal, B=Bonificação
    Local lAtivo := .T.
    Local lBloq := .F.
    Local nLimCred := 10000
    Local nSaldo := 8500
    Local dVenc := Date() + 5
    Local nValorPed := 2000
    Local cMsg := ""
    Local lLibera := .F.
    
    // Validação completa de liberação
    lLibera := lAtivo .And. !lBloq .And. ;
               (cTpPed == "B" .Or. (nSaldo + nValorPed <= nLimCred)) .And. ;
               dVenc > Date()
    
    cMsg := "?? VALIDAÇÃO ERP COMPLETA" + CRLF + CRLF
    
    cMsg += "=== DADOS ===" + CRLF
    cMsg += "Tipo pedido: " + If(cTpPed=="N", "Normal", "Bonif") + CRLF
    cMsg += "Cliente ativo: " + If(lAtivo, "SIM", "NÃO") + CRLF
    cMsg += "Bloqueado: " + If(lBloq, "SIM", "NÃO") + CRLF
    cMsg += "Limite: R$ " + Transform(nLimCred, "@E 999,999.99") + CRLF
    cMsg += "Saldo atual: R$ " + Transform(nSaldo, "@E 999,999.99") + CRLF
    cMsg += "Valor pedido: R$ " + Transform(nValorPed, "@E 999,999.99") + CRLF
    cMsg += "Novo saldo: R$ " + Transform(nSaldo+nValorPed, "@E 999,999.99") + CRLF
    cMsg += "Vencimento: " + DtoC(dVenc) + CRLF + CRLF
    
    cMsg += "=== VALIDAÇÃO ===" + CRLF
    If lLibera
        cMsg += "? PEDIDO LIBERADO!" + CRLF + CRLF
        cMsg += "Todas validações OK:" + CRLF
        cMsg += "? Cliente ativo" + CRLF
        cMsg += "? Não bloqueado" + CRLF
        If cTpPed == "B"
            cMsg += "? Bonificação (sem limite)" + CRLF
        Else
            cMsg += "? Dentro do limite" + CRLF
        EndIf
        cMsg += "? Não vencido" + CRLF
    Else
        cMsg += "? PEDIDO BLOQUEADO!" + CRLF + CRLF
        cMsg += "Problemas:" + CRLF
        If !lAtivo
            cMsg += "? Cliente inativo" + CRLF
        EndIf
        If lBloq
            cMsg += "? Cliente bloqueado" + CRLF
        EndIf
        If cTpPed != "B" .And. nSaldo + nValorPed > nLimCred
            cMsg += "? Estoura limite crédito" + CRLF
        EndIf
        If dVenc <= Date()
            cMsg += "? Título vencido" + CRLF
        EndIf
    EndIf
    
    MsgInfo(cMsg, "Validação ERP")
Return
