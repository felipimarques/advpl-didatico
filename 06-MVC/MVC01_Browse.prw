// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC01
Browse Básico - Lista de registros

Exemplos práticos de FWMBrowse:
- Browse de clientes
- Browse com filtro
- Browse com legenda
- Browse com seek
- Browse completo

@type User Function
@author Felipi Marques
@since 23/11/2025

@example
U_MVC01()
/*/

User Function MVC01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Browse Básico", ;
                     "1-Browse Simples" + CRLF + ;
                     "2-Browse com Filtro" + CRLF + ;
                     "3-Browse com Legenda" + CRLF + ;
                     "4-Browse com Seek" + CRLF + ;
                     "5-Browse Completo" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                fEx01Simples()
            Case nOpc == 2
                fEx02Filtro()
            Case nOpc == 3
                fEx03Legenda()
            Case nOpc == 4
                fEx04Seek()
            Case nOpc == 5
                fEx05Completo()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Browse Simples de Clientes
Cria um browse básico da SA1
*/
Static Function fEx01Simples()
    Local oBrowse
    
    // Cria objeto browse
    oBrowse := FWMBrowse():New()
    
    // Define a tabela
    oBrowse:SetAlias("SA1")
    
    // Define o título
    oBrowse:SetDescription("Cadastro de Clientes")
    
    // Ativa o browse
    oBrowse:Activate()
Return

/*
EXEMPLO 2: Browse com Filtro
Mostra apenas clientes de SP
*/
Static Function fEx02Filtro()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes de São Paulo")
    
    // Aplica filtro padrão
    oBrowse:SetFilterDefault("A1_EST == 'SP'")
    
    oBrowse:Activate()
Return

/*
EXEMPLO 3: Browse com Legenda
Cores para identificar status do cliente
*/
Static Function fEx03Legenda()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes com Status")
    
    // Adiciona legendas (condição, cor, descrição)
    oBrowse:AddLegend("A1_MSBLQL == '1'", "RED", "Bloqueado")
    oBrowse:AddLegend("A1_MSBLQL != '1' .And. A1_LC > 0", "GREEN", "Ativo com Limite")
    oBrowse:AddLegend("A1_MSBLQL != '1' .And. A1_LC == 0", "YELLOW", "Ativo sem Limite")
    
    oBrowse:Activate()
Return

/*
EXEMPLO 4: Browse com Pesquisa (Seek)
Permite pesquisar por código ou nome
*/
Static Function fEx04Seek()
    Local oBrowse
    Local aSeek := {}
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes - Com Pesquisa")
    
    // Define pesquisa por código
    aSeek := {{"Código", {{"", "C", 6, 0, "A1_COD", "@!"}}}}
    oBrowse:SetSeek(.T., aSeek)
    
    oBrowse:Activate()
Return

/*
EXEMPLO 5: Browse Completo
Todas as configurações juntas
*/
Static Function fEx05Completo()
    Local oBrowse
    Local aSeek := {}
    
    oBrowse := FWMBrowse():New()
    
    // Configurações básicas
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cadastro Completo - Clientes")
    
    // Define campos a exibir
    oBrowse:SetOnlyFields({"A1_COD", "A1_LOJA", "A1_NOME", "A1_EST", "A1_MUN", "A1_LC"})
    
    // Filtro: apenas clientes ativos
    oBrowse:SetFilterDefault("A1_MSBLQL != '1'")
    
    // Legendas
    oBrowse:AddLegend("A1_LC == 0", "YELLOW", "Sem Limite Crédito")
    oBrowse:AddLegend("A1_LC > 0 .And. A1_LC <= 10000", "GREEN", "Limite até 10mil")
    oBrowse:AddLegend("A1_LC > 10000", "BLUE", "Limite acima de 10mil")
    
    // Pesquisa
    aSeek := {{"Código", {{"", "C", 6, 0, "A1_COD", "@!"}}}, ;
              {"Nome", {{"", "C", 40, 0, "A1_NOME", "@!"}}}}
    oBrowse:SetSeek(.T., aSeek)
    
    // Desabilita detalhes
    oBrowse:DisableDetails()
    
    // Ativa
    oBrowse:Activate()
Return
