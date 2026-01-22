// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI04
Exemplos práticos de Parambox

Funções abordadas:
- ParamBox() - tela de parâmetros
- Tipos de campos
- Validações
- Consultas F3
- Relatórios com parâmetros

@type User Function
@author Felipi Marques
@since 20/01/2026

@example
U_UI04()
/*/

User Function UI04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Parambox", ;
                     "1-Parambox simples" + CRLF + ;
                     "2-Vários tipos" + CRLF + ;
                     "3-Com F3 (consulta)" + CRLF + ;
                     "4-Relatório clientes" + CRLF + ;
                     "5-Filtro pedidos" + CRLF + ;
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
EXEMPLO 1: Parambox Simples
*/
Static Function fEx01()
    Local aParam := {}
    Local aRet := {}
    Local cMsg := ""
    
    // Define parâmetros
    aAdd(aParam, {1, "Cliente De", Space(6), "", "", "SA1", "", 50, .F.})
    aAdd(aParam, {1, "Cliente Até", Replicate("Z",6), "", "", "SA1", "", 50, .T.})
    
    // Exibe tela
    If ParamBox(aParam, "Parâmetros", @aRet)
        cMsg := "? PARÂMETROS CONFIRMADOS" + CRLF + CRLF
        cMsg += "Cliente De: " + aRet[1] + CRLF
        cMsg += "Cliente Até: " + aRet[2] + CRLF + CRLF
        cMsg += "Processamento seria executado aqui"
        MsgInfo(cMsg, "Confirmado")
    Else
        MsgInfo("Usuário cancelou", "Cancelado")
    EndIf
Return

/*
EXEMPLO 2: Vários Tipos de Campos
*/
Static Function fEx02()
    Local aParam := {}
    Local aRet := {}
    Local aCombo := {"Opção 1", "Opção 2", "Opção 3"}
    Local cMsg := ""
    
    // Tipo 1: Get (texto/número)
    aAdd(aParam, {1, "Nome Cliente", Space(40), "", "", "", "", 60, .F.})
    
    // Tipo 2: Combo
    aAdd(aParam, {2, "Tipo", 1, aCombo, 50, "", .T.})
    
    // Tipo 3: Radio (1=Sim, 2=Não)
    aAdd(aParam, {3, "Ativo", 1, {"Sim", "Não"}, 50, "", .T.})
    
    // Tipo 4: Check
    aAdd(aParam, {4, "Bloqueado", 2, "", 50, "", .T.})
    
    // Tipo 5: Get com validação de número
    aAdd(aParam, {1, "Valor Mínimo", 0, "@E 999,999.99", "", "", "", 50, .F.})
    
    // Tipo 6: Data
    aAdd(aParam, {1, "Data De", Date(), "", "", "", "", 50, .F.})
    aAdd(aParam, {1, "Data Até", Date(), "", "", "", "", 50, .T.})
    
    If ParamBox(aParam, "Tipos de Parâmetros", @aRet)
        cMsg := "PARÂMETROS INFORMADOS:" + CRLF + CRLF
        cMsg += "Nome: " + aRet[1] + CRLF
        cMsg += "Tipo: " + aCombo[aRet[2]] + CRLF
        cMsg += "Ativo: " + If(aRet[3]==1, "Sim", "Não") + CRLF
        cMsg += "Bloqueado: " + If(aRet[4]==1, "Sim", "Não") + CRLF
        cMsg += "Valor Mín: R$ " + Transform(aRet[5], "@E 999,999.99") + CRLF
        cMsg += "Data De: " + DToC(aRet[6]) + CRLF
        cMsg += "Data Até: " + DToC(aRet[7])
        MsgInfo(cMsg, "Parâmetros")
    EndIf
Return

/*
EXEMPLO 3: Com F3 (Consulta Padrão)
*/
Static Function fEx03()
    Local aParam := {}
    Local aRet := {}
    Local cMsg := ""
    
    // Cliente com F3
    aAdd(aParam, {1, "Cliente", Space(6), "", "", "SA1", "", 50, .F.})
    aAdd(aParam, {1, "Loja", Space(2), "", "", "", "", 20, .F.})
    
    // Produto com F3
    aAdd(aParam, {1, "Produto", Space(15), "", "", "SB1", "", 70, .F.})
    
    // Vendedor com F3
    aAdd(aParam, {1, "Vendedor", Space(6), "", "", "SA3", "", 50, .T.})
    
    If ParamBox(aParam, "Consultas com F3", @aRet)
        cMsg := "SELECIONADOS:" + CRLF + CRLF
        cMsg += "Cliente: " + aRet[1] + "/" + aRet[2] + CRLF
        cMsg += "Produto: " + aRet[3] + CRLF
        cMsg += "Vendedor: " + aRet[4] + CRLF + CRLF
        cMsg += "Use F3 para buscar valores"
        MsgInfo(cMsg, "Seleção")
    EndIf
Return

/*
EXEMPLO 4: Relatório de Clientes
*/
Static Function fEx04()
    Local aParam := {}
    Local aRet := {}
    Local aOrdem := {"Código", "Nome", "Cidade", "Estado"}
    Local cMsg := ""
    Local cQuery := ""
    Local nCont := 0
    
    // Parâmetros do relatório
    aAdd(aParam, {1, "Cliente De", Space(6), "", "", "SA1", "", 50, .F.})
    aAdd(aParam, {1, "Cliente Até", Replicate("Z",6), "", "", "SA1", "", 50, .T.})
    aAdd(aParam, {2, "Estado", 1, {"Todos", "SP", "RJ", "MG"}, 50, "", .T.})
    aAdd(aParam, {3, "Situação", 1, {"Ativo", "Bloqueado", "Todos"}, 80, "", .T.})
    aAdd(aParam, {2, "Ordenar Por", 1, aOrdem, 70, "", .T.})
    
    If ParamBox(aParam, "Relatório de Clientes", @aRet)
        
        cMsg := "?? RELATÓRIO DE CLIENTES" + CRLF + CRLF
        cMsg += "Filtros aplicados:" + CRLF
        cMsg += "Cliente: " + AllTrim(aRet[1]) + " até " + AllTrim(aRet[2]) + CRLF
        
        If aRet[3] > 1
            cMsg += "Estado: " + {"","SP","RJ","MG"}[aRet[3]] + CRLF
        EndIf
        
        cMsg += "Situação: " + {"Ativo","Bloqueado","Todos"}[aRet[4]] + CRLF
        cMsg += "Ordem: " + aOrdem[aRet[5]] + CRLF + CRLF
        
        // Simulação de processamento
        cMsg += "=== RESULTADO ===" + CRLF
        cMsg += "15 clientes encontrados" + CRLF + CRLF
        cMsg += "Relatório seria gerado aqui"
        
        MsgInfo(cMsg, "Relatório")
    EndIf
Return

/*
EXEMPLO 5: Filtro de Pedidos Avançado
*/
Static Function fEx05()
    Local aParam := {}
    Local aRet := {}
    Local aTipo := {"Normal", "Devolução", "Todos"}
    Local aStatus := {"Aberto", "Faturado", "Cancelado", "Todos"}
    Local cMsg := ""
    
    // Período
    aAdd(aParam, {1, "Data De", FirstDay(Date()), "", "", "", "", 50, .F.})
    aAdd(aParam, {1, "Data Até", Date(), "", "", "", "", 50, .T.})
    
    // Cliente
    aAdd(aParam, {1, "Cliente De", Space(6), "", "", "SA1", "", 50, .F.})
    aAdd(aParam, {1, "Cliente Até", Replicate("Z",6), "", "", "SA1", "", 50, .T.})
    
    // Vendedor
    aAdd(aParam, {1, "Vendedor", Space(6), "", "", "SA3", "", 50, .T.})
    
    // Valor
    aAdd(aParam, {1, "Valor Mínimo", 0, "@E 999,999.99", "", "", "", 50, .F.})
    aAdd(aParam, {1, "Valor Máximo", 999999.99, "@E 999,999.99", "", "", "", 50, .T.})
    
    // Tipo e Status
    aAdd(aParam, {2, "Tipo Pedido", 1, aTipo, 70, "", .T.})
    aAdd(aParam, {2, "Status", 1, aStatus, 70, "", .T.})
    
    // Opções
    aAdd(aParam, {4, "Apenas Com Saldo", 2, "", 70, "", .T.})
    aAdd(aParam, {4, "Incluir Bloqueados", 2, "", 70, "", .T.})
    
    If ParamBox(aParam, "Filtro de Pedidos", @aRet,,,,,,,, .T., .T.)
        
        cMsg := "?? FILTROS APLICADOS" + CRLF + CRLF
        
        cMsg += "=== PERÍODO ===" + CRLF
        cMsg += "De: " + DToC(aRet[1]) + CRLF
        cMsg += "Até: " + DToC(aRet[2]) + CRLF + CRLF
        
        cMsg += "=== CLIENTE ===" + CRLF
        cMsg += "De: " + aRet[3] + CRLF
        cMsg += "Até: " + aRet[4] + CRLF + CRLF
        
        If !Empty(aRet[5])
            cMsg += "Vendedor: " + aRet[5] + CRLF + CRLF
        EndIf
        
        cMsg += "=== VALOR ===" + CRLF
        cMsg += "De: R$ " + Transform(aRet[6], "@E 999,999.99") + CRLF
        cMsg += "Até: R$ " + Transform(aRet[7], "@E 999,999.99") + CRLF + CRLF
        
        cMsg += "=== OPÇÕES ===" + CRLF
        cMsg += "Tipo: " + aTipo[aRet[8]] + CRLF
        cMsg += "Status: " + aStatus[aRet[9]] + CRLF
        cMsg += "Com Saldo: " + If(aRet[10]==1, "Sim", "Não") + CRLF
        cMsg += "Bloqueados: " + If(aRet[11]==1, "Sim", "Não") + CRLF + CRLF
        
        cMsg += "Consulta seria executada aqui"
        
        MsgInfo(cMsg, "Filtros")
    EndIf
Return
