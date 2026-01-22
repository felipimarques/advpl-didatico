// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD05
Exemplos práticos de filtros em tabelas

Funções abordadas:
- DbSetFilter() - criar filtro
- DbClearFilter() - limpar filtro
- Filtrar com expressão
- Filtrar com bloco de código
- Contadores com filtro

@type User Function
@author Felipi Marques
@since 05/12/2025

@example
U_BD05()
/*/

User Function BD05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Filtros", ;
                     "1-Conceito de filtro" + CRLF + ;
                     "2-Filtro simples" + CRLF + ;
                     "3-Filtro com bloco" + CRLF + ;
                     "4-Filtrar clientes ativos" + CRLF + ;
                     "5-Produtos por tipo" + CRLF + ;
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
EXEMPLO 1: Conceito de Filtro
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? DbSetFilter()" + CRLF + CRLF
    
    cMsg += "Filtra registros da tabela" + CRLF
    cMsg += "Apenas registros que atendem condição aparecem" + CRLF + CRLF
    
    cMsg += "SINTAXE:" + CRLF
    cMsg += "DbSetFilter(bFiltro, cFiltro)" + CRLF + CRLF
    
    cMsg += "=== EXEMPLO 1: Expressão ===" + CRLF
    cMsg += "DbSelectArea('SA1')" + CRLF
    cMsg += "DbSetFilter({|| A1_EST == 'SP'}, 'A1_EST == SP')" + CRLF + CRLF
    
    cMsg += "=== EXEMPLO 2: Bloco ===" + CRLF
    cMsg += "DbSetFilter({|| A1_MSBLQL != '1'}, 'Ativos')" + CRLF + CRLF
    
    cMsg += "LIMPAR FILTRO:" + CRLF
    cMsg += "DbClearFilter()" + CRLF + CRLF
    
    cMsg += "?? Filtro afeta navegação!" + CRLF
    cMsg += "DbSkip, DbGoTop, etc só veem filtrados"
    
    MsgInfo(cMsg, "Conceito Filtro")
Return

/*
EXEMPLO 2: Filtro Simples
*/
Static Function fEx02()
    Local cMsg := ""
    Local nSemFiltro := 0
    Local nComFiltro := 0
    
    cMsg := "?? FILTRO SIMPLES" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Sem filtro
    DbClearFilter()
    DbGoTop()
    
    While !Eof()
        nSemFiltro++
        DbSkip()
    EndDo
    
    cMsg += "SEM FILTRO:" + CRLF
    cMsg += "Total clientes: " + cValToChar(nSemFiltro) + CRLF + CRLF
    
    // Com filtro (estado SP)
    DbSetFilter({|| A1_EST == "SP"}, "A1_EST == 'SP'")
    DbGoTop()
    
    While !Eof()
        nComFiltro++
        DbSkip()
    EndDo
    
    cMsg += "COM FILTRO (SP):" + CRLF
    cMsg += "Total clientes: " + cValToChar(nComFiltro) + CRLF + CRLF
    
    // Limpa filtro
    DbClearFilter()
    
    cMsg += "? Filtro aplicado e removido!" + CRLF + CRLF
    cMsg += "?? DbClearFilter() volta ao normal"
    
    MsgInfo(cMsg, "Filtro Simples")
Return

/*
EXEMPLO 3: Filtro com Bloco Complexo
*/
Static Function fEx03()
    Local cMsg := ""
    Local nTotal := 0
    Local cEstado := "SP"
    Local cTipo := "R"
    
    cMsg := "?? FILTRO COMPLEXO" + CRLF + CRLF
    cMsg += "Condições:" + CRLF
    cMsg += "• Estado = SP" + CRLF
    cMsg += "• Tipo = R (Revendedor)" + CRLF
    cMsg += "• Não bloqueado" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Filtro composto
    DbSetFilter({|| A1_EST == cEstado .And. ;
                    A1_TIPO == cTipo .And. ;
                    A1_MSBLQL != "1"}, "Filtro Complexo")
    
    DbGoTop()
    
    If !Eof()
        cMsg += "=== CLIENTES FILTRADOS ===" + CRLF
        
        While !Eof() .And. nTotal < 5
            nTotal++
            cMsg += cValToChar(nTotal) + ". " + AllTrim(SA1->A1_COD) + " - "
            cMsg += AllTrim(SA1->A1_NOME) + CRLF
            DbSkip()
        EndDo
        
        If !Eof()
            While !Eof()
                nTotal++
                DbSkip()
            EndDo
            cMsg += "... mais " + cValToChar(nTotal - 5) + " registros" + CRLF
        EndIf
        
        cMsg += CRLF + "Total: " + cValToChar(nTotal) + " clientes"
    Else
        cMsg += "? Nenhum cliente atende filtro"
    EndIf
    
    DbClearFilter()
    
    cMsg += CRLF + CRLF + "?? Combine múltiplas condições"
    
    MsgInfo(cMsg, "Filtro Complexo")
Return

/*
EXEMPLO 4: Filtrar Clientes Ativos
*/
Static Function fEx04()
    Local cMsg := ""
    Local nAtivos := 0
    Local nBloqueados := 0
    
    cMsg := "?? CLIENTES ATIVOS x BLOQUEADOS" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Conta ativos
    DbSetFilter({|| Empty(A1_MSBLQL) .Or. A1_MSBLQL == "2"}, "Ativos")
    DbGoTop()
    
    While !Eof()
        nAtivos++
        DbSkip()
    EndDo
    
    cMsg += "? ATIVOS: " + cValToChar(nAtivos) + CRLF
    
    // Conta bloqueados
    DbClearFilter()
    DbSetFilter({|| A1_MSBLQL == "1"}, "Bloqueados")
    DbGoTop()
    
    While !Eof()
        nBloqueados++
        If nBloqueados <= 5
            cMsg += "   • " + AllTrim(SA1->A1_COD) + " - " + AllTrim(SA1->A1_NOME) + CRLF
        EndIf
        DbSkip()
    EndDo
    
    If nBloqueados > 0
        cMsg += CRLF
    EndIf
    
    cMsg += "? BLOQUEADOS: " + cValToChar(nBloqueados) + CRLF + CRLF
    
    DbClearFilter()
    
    cMsg += "=== TOTAIS ===" + CRLF
    cMsg += "Ativos: " + cValToChar(nAtivos) + CRLF
    cMsg += "Bloqueados: " + cValToChar(nBloqueados) + CRLF
    cMsg += "Geral: " + cValToChar(nAtivos + nBloqueados) + CRLF + CRLF
    
    cMsg += "?? Filtro para status"
    
    MsgInfo(cMsg, "Clientes Ativos")
Return

/*
EXEMPLO 5: Produtos por Tipo
*/
Static Function fEx05()
    Local aTipos := {"PA", "MP", "ME", "PI", "AI"}
    Local aDescTipo := {"Produto Acabado", "Matéria Prima", "Mercadoria", ;
                        "Produto Intermediário", "Ativo Imobilizado"}
    Local cMsg := ""
    Local nI := 0
    Local nQtd := 0
    
    cMsg := "?? PRODUTOS POR TIPO" + CRLF + CRLF
    
    DbSelectArea("SB1")
    DbSetOrder(1)
    
    For nI := 1 To Len(aTipos)
        
        // Aplica filtro por tipo
        DbSetFilter({|| B1_TIPO == aTipos[nI]}, "Tipo: " + aTipos[nI])
        DbGoTop()
        
        nQtd := 0
        While !Eof()
            nQtd++
            DbSkip()
        EndDo
        
        cMsg += aTipos[nI] + " - " + aDescTipo[nI] + CRLF
        cMsg += "Quantidade: " + cValToChar(nQtd) + CRLF + CRLF
        
    Next nI
    
    DbClearFilter()
    
    cMsg += "?? Filtrar por categoria/tipo" + CRLF
    cMsg += "?? Útil para relatórios"
    
    MsgInfo(cMsg, "Produtos por Tipo")
Return
