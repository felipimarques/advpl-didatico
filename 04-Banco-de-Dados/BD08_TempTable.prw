// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD08
Exemplos práticos de tabelas temporárias

Funções abordadas:
- FWTemporaryTable():New() - criar tabela temp
- :SetFields() - definir campos
- :AddIndex() - adicionar índice
- :Create() - criar fisicamente
- :Delete() - excluir tabela

@type User Function
@author Felipi Marques
@since 02/01/2026

@example
U_BD08()
/*/

User Function BD08()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Tabelas Temporárias", ;
                     "1-Conceito temp table" + CRLF + ;
                     "2-Criar e usar" + CRLF + ;
                     "3-Com índice" + CRLF + ;
                     "4-Processar vendas" + CRLF + ;
                     "5-Dashboard temp" + CRLF + ;
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
EXEMPLO 1: Conceito de Tabela Temporária
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? TABELA TEMPORÁRIA" + CRLF + CRLF
    
    cMsg += "Cria tabela para processamento" + CRLF
    cMsg += "Automaticamente excluída ao final" + CRLF + CRLF
    
    cMsg += "ESTRUTURA:" + CRLF
    cMsg += "oTempTable := FWTemporaryTable():New('TRB')" + CRLF + CRLF
    
    cMsg += "// Define campos" + CRLF
    cMsg += "aFields := {}" + CRLF
    cMsg += "aAdd(aFields, {'CODIGO', 'C', 6, 0})" + CRLF
    cMsg += "aAdd(aFields, {'NOME', 'C', 40, 0})" + CRLF
    cMsg += "aAdd(aFields, {'VALOR', 'N', 12, 2})" + CRLF
    cMsg += "oTempTable:SetFields(aFields)" + CRLF + CRLF
    
    cMsg += "// Cria índice" + CRLF
    cMsg += "oTempTable:AddIndex('1', {'CODIGO'})" + CRLF
    cMsg += "oTempTable:Create()" + CRLF + CRLF
    
    cMsg += "// Usar como tabela normal" + CRLF
    cMsg += "RecLock('TRB', .T.)" + CRLF
    cMsg += "TRB->CODIGO := '000001'" + CRLF
    cMsg += "MsUnlock()" + CRLF + CRLF
    
    cMsg += "// Excluir" + CRLF
    cMsg += "oTempTable:Delete()" + CRLF + CRLF
    
    cMsg += "QUANDO USAR:" + CRLF
    cMsg += "• Processar grandes volumes" + CRLF
    cMsg += "• Consolidar dados" + CRLF
    cMsg += "• Relatórios complexos" + CRLF
    cMsg += "• Cálculos intermediários"
    
    MsgInfo(cMsg, "Conceito Temp Table")
Return

/*
EXEMPLO 2: Criar e Usar Tabela Temporária
*/
Static Function fEx02()
    Local oTempTable := Nil
    Local aFields := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? CRIAR E USAR" + CRLF + CRLF
    
    // Cria estrutura
    aAdd(aFields, {"CODIGO", "C", 6, 0})
    aAdd(aFields, {"NOME", "C", 30, 0})
    aAdd(aFields, {"PRECO", "N", 10, 2})
    
    // Cria tabela temp
    oTempTable := FWTemporaryTable():New("TRB")
    oTempTable:SetFields(aFields)
    oTempTable:Create()
    
    cMsg += "? Tabela criada!" + CRLF + CRLF
    
    // Adiciona registros
    RecLock("TRB", .T.)
    TRB->CODIGO := "PA001"
    TRB->NOME := "NOTEBOOK"
    TRB->PRECO := 3500.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->CODIGO := "PA002"
    TRB->NOME := "MOUSE"
    TRB->PRECO := 35.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->CODIGO := "PA003"
    TRB->NOME := "TECLADO"
    TRB->PRECO := 125.00
    MsUnlock()
    
    cMsg += "Registros incluídos: 3" + CRLF + CRLF
    
    // Lista
    DbSelectArea("TRB")
    DbGoTop()
    
    cMsg += "=== CONTEÚDO ===" + CRLF
    While !Eof()
        nI++
        cMsg += cValToChar(nI) + ". " + AllTrim(TRB->CODIGO) + " - "
        cMsg += AllTrim(TRB->NOME) + " - R$ "
        cMsg += Transform(TRB->PRECO, "@E 999,999.99") + CRLF
        DbSkip()
    EndDo
    
    // Exclui tabela
    oTempTable:Delete()
    
    cMsg += CRLF + "? Tabela excluída!" + CRLF + CRLF
    cMsg += "?? Usa como tabela normal"
    
    MsgInfo(cMsg, "Criar e Usar")
Return

/*
EXEMPLO 3: Tabela Temporária com Índice
*/
Static Function fEx03()
    Local oTempTable := Nil
    Local aFields := {}
    Local cMsg := ""
    
    cMsg := "?? TEMP TABLE COM ÍNDICE" + CRLF + CRLF
    
    // Estrutura
    aAdd(aFields, {"CLIENTE", "C", 6, 0})
    aAdd(aFields, {"NOME", "C", 40, 0})
    aAdd(aFields, {"TOTAL", "N", 12, 2})
    
    // Cria com índices
    oTempTable := FWTemporaryTable():New("TRB")
    oTempTable:SetFields(aFields)
    oTempTable:AddIndex("1", {"CLIENTE"})
    oTempTable:AddIndex("2", {"NOME"})
    oTempTable:AddIndex("3", {"TOTAL"})
    oTempTable:Create()
    
    cMsg += "Índices criados:" + CRLF
    cMsg += "1 - CLIENTE" + CRLF
    cMsg += "2 - NOME" + CRLF
    cMsg += "3 - TOTAL" + CRLF + CRLF
    
    // Adiciona dados
    RecLock("TRB", .T.)
    TRB->CLIENTE := "CLI003"
    TRB->NOME := "PEDRO"
    TRB->TOTAL := 5000.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->CLIENTE := "CLI001"
    TRB->NOME := "JOSE"
    TRB->TOTAL := 8500.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->CLIENTE := "CLI002"
    TRB->NOME := "MARIA"
    TRB->TOTAL := 12000.00
    MsUnlock()
    
    // Busca por código
    DbSelectArea("TRB")
    DbSetOrder(1)
    If DbSeek("CLI002")
        cMsg += "Busca por código:" + CRLF
        cMsg += "? Encontrado: " + AllTrim(TRB->NOME) + CRLF + CRLF
    EndIf
    
    // Ordena por valor
    DbSetOrder(3)
    DbGoTop()
    
    cMsg += "Ordenado por TOTAL:" + CRLF
    While !Eof()
        cMsg += AllTrim(TRB->NOME) + " - R$ "
        cMsg += Transform(TRB->TOTAL, "@E 999,999.99") + CRLF
        DbSkip()
    EndDo
    
    oTempTable:Delete()
    
    cMsg += CRLF + "?? Índices aceleram buscas"
    
    MsgInfo(cMsg, "Com Índice")
Return

/*
EXEMPLO 4: Processar Vendas em Temp Table
*/
Static Function fEx04()
    Local oTempTable := Nil
    Local aFields := {}
    Local cMsg := ""
    Local nTotal := 0
    
    cMsg := "?? PROCESSAR VENDAS" + CRLF + CRLF
    
    // Estrutura
    aAdd(aFields, {"VENDEDOR", "C", 6, 0})
    aAdd(aFields, {"NOME", "C", 30, 0})
    aAdd(aFields, {"QTDPED", "N", 6, 0})
    aAdd(aFields, {"TOTAL", "N", 14, 2})
    
    oTempTable := FWTemporaryTable():New("TRB")
    oTempTable:SetFields(aFields)
    oTempTable:AddIndex("1", {"TOTAL"})
    oTempTable:Create()
    
    // Simula processamento (normalmente viria de query)
    RecLock("TRB", .T.)
    TRB->VENDEDOR := "V001"
    TRB->NOME := "JOSE SILVA"
    TRB->QTDPED := 25
    TRB->TOTAL := 125000.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->VENDEDOR := "V002"
    TRB->NOME := "MARIA SANTOS"
    TRB->QTDPED := 35
    TRB->TOTAL := 185000.00
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->VENDEDOR := "V003"
    TRB->NOME := "PEDRO COSTA"
    TRB->QTDPED := 18
    TRB->TOTAL := 98000.00
    MsUnlock()
    
    // Ordena por total (decrescente precisa ir do fim)
    DbSelectArea("TRB")
    DbSetOrder(1)
    DbGoBottom()
    
    cMsg += "=== RANKING DE VENDAS ===" + CRLF
    
    While !Bof()
        cMsg += AllTrim(TRB->NOME) + CRLF
        cMsg += "Pedidos: " + cValToChar(TRB->QTDPED) + CRLF
        cMsg += "Total: R$ " + Transform(TRB->TOTAL, "@E 999,999.99") + CRLF + CRLF
        nTotal += TRB->TOTAL
        DbSkip(-1)
    EndDo
    
    cMsg += "TOTAL GERAL: R$ " + Transform(nTotal, "@E 999,999.99") + CRLF + CRLF
    
    oTempTable:Delete()
    
    cMsg += "?? Temp table para consolidação"
    
    MsgInfo(cMsg, "Processar Vendas")
Return

/*
EXEMPLO 5: Dashboard com Temp Table
*/
Static Function fEx05()
    Local oTempTable := Nil
    Local aFields := {}
    Local cMsg := ""
    Local nMaior := 0
    Local cTop := ""
    
    cMsg := "?? DASHBOARD" + CRLF + CRLF
    
    // Estrutura para indicadores
    aAdd(aFields, {"INDICADOR", "C", 30, 0})
    aAdd(aFields, {"VALOR", "N", 14, 2})
    aAdd(aFields, {"PERCEN", "N", 6, 2})
    
    oTempTable := FWTemporaryTable():New("TRB")
    oTempTable:SetFields(aFields)
    oTempTable:Create()
    
    // Simula cálculos
    RecLock("TRB", .T.)
    TRB->INDICADOR := "FATURAMENTO MES"
    TRB->VALOR := 450000.00
    TRB->PERCEN := 15.5
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->INDICADOR := "CUSTO"
    TRB->VALOR := 280000.00
    TRB->PERCEN := -5.2
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->INDICADOR := "MARGEM"
    TRB->VALOR := 170000.00
    TRB->PERCEN := 45.8
    MsUnlock()
    
    RecLock("TRB", .T.)
    TRB->INDICADOR := "PEDIDOS"
    TRB->VALOR := 125
    TRB->PERCEN := 8.7
    MsUnlock()
    
    // Mostra dashboard
    DbSelectArea("TRB")
    DbGoTop()
    
    cMsg += "=== INDICADORES ===" + CRLF + CRLF
    
    While !Eof()
        cMsg += AllTrim(TRB->INDICADOR) + CRLF
        
        If TRB->INDICADOR != "PEDIDOS"
            cMsg += "R$ " + Transform(TRB->VALOR, "@E 999,999.99")
        Else
            cMsg += cValToChar(TRB->VALOR) + " pedidos"
        EndIf
        
        cMsg += " ("
        If TRB->PERCEN > 0
            cMsg += "+"
        EndIf
        cMsg += Transform(TRB->PERCEN, "@E 999.99") + "%)" + CRLF + CRLF
        
        If TRB->VALOR > nMaior
            nMaior := TRB->VALOR
            cTop := AllTrim(TRB->INDICADOR)
        EndIf
        
        DbSkip()
    EndDo
    
    cMsg += "?? DESTAQUE: " + cTop + CRLF + CRLF
    
    oTempTable:Delete()
    
    cMsg += "?? Temp table para dashboards"
    
    MsgInfo(cMsg, "Dashboard")
Return
