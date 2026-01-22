// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC03
View com Folders - Telas com abas

Exemplos de telas com múltiplas abas:
- Cadastro com 2 folders
- Cadastro com 3 folders
- Folders com boxes
- Layout horizontal/vertical
- Layout completo

@type User Function
@author Felipi Marques
@since 01/12/2025

@example
U_MVC03()
/*/

User Function MVC03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - View com Folders", ;
                     "1-Cliente (2 folders)" + CRLF + ;
                     "2-Produto (3 folders)" + CRLF + ;
                     "3-Layout Horizontal" + CRLF + ;
                     "4-Layout Vertical" + CRLF + ;
                     "5-Layout Completo" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX06()
            Case nOpc == 2
                U_MVCEX07()
            Case nOpc == 3
                U_MVCEX08()
            Case nOpc == 4
                U_MVCEX09()
            Case nOpc == 5
                U_MVCEX10()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Cliente com 2 Folders
Aba Cadastrais e Aba Comercial
*/

User Function MVCEX06()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes - 2 Folders")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX06" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX06" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX06" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX06M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SA1")
    Local oStru2 := FWFormStruct(2, "SA1")
    
    // Estrutura 1: Campos cadastrais
    oStru1:SetProperty("*", MVC_VIEW_CANCHANGE, .F.)  // Desabilita todos
    oStru1:SetProperty("A1_COD", MVC_VIEW_CANCHANGE, .T.)
    oStru1:SetProperty("A1_LOJA", MVC_VIEW_CANCHANGE, .T.)
    oStru1:SetProperty("A1_NOME", MVC_VIEW_CANCHANGE, .T.)
    oStru1:SetProperty("A1_NREDUZ", MVC_VIEW_CANCHANGE, .T.)
    oStru1:SetProperty("A1_CGC", MVC_VIEW_CANCHANGE, .T.)
    
    // Estrutura 2: Campos comerciais
    oStru2:SetProperty("*", MVC_VIEW_CANCHANGE, .F.)  // Desabilita todos
    oStru2:SetProperty("A1_VEND", MVC_VIEW_CANCHANGE, .T.)
    oStru2:SetProperty("A1_LC", MVC_VIEW_CANCHANGE, .T.)
    oStru2:SetProperty("A1_NATUREZ", MVC_VIEW_CANCHANGE, .T.)
    oStru2:SetProperty("A1_COND", MVC_VIEW_CANCHANGE, .T.)
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    // Adiciona os campos em IDs diferentes
    oView:AddField("VIEW_CAD", oStru1, "SA1MASTER")
    oView:AddField("VIEW_COM", oStru2, "SA1MASTER")
    
    // Cria folder
    oView:CreateFolder("PASTAS", "TELA")
    oView:AddSheet("PASTAS", "ABA1", "Cadastrais")
    oView:AddSheet("PASTAS", "ABA2", "Comercial")
    
    // Cria boxes dentro das abas
    oView:CreateHorizontalBox("BOX1", 100, , , "PASTAS", "ABA1")
    oView:CreateHorizontalBox("BOX2", 100, , , "PASTAS", "ABA2")
    
    // Posiciona os campos nos boxes
    oView:SetOwnerView("VIEW_CAD", "BOX1")
    oView:SetOwnerView("VIEW_COM", "BOX2")
    
    // Títulos
    oView:EnableTitleView("VIEW_CAD", "Dados Cadastrais")
    oView:EnableTitleView("VIEW_COM", "Dados Comerciais")
Return oView

/*
EXEMPLO 2: Produto com 3 Folders
Cadastrais, Estoque e Fiscal
*/

User Function MVCEX07()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SB1")
    oBrowse:SetDescription("Produtos - 3 Folders")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX07" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX07" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX07" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSB1 := FWFormStruct(1, "SB1")
    
    oModel := MPFormModel():New("MVCEX07M")
    oModel:AddFields("SB1MASTER", , oStruSB1)
    oModel:SetPrimaryKey({"B1_FILIAL", "B1_COD"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SB1", {|cCampo| AllTrim(cCampo) $ "B1_COD|B1_DESC|B1_TIPO|B1_UM|B1_GRUPO"})
    Local oStru2 := FWFormStruct(2, "SB1", {|cCampo| AllTrim(cCampo) $ "B1_LOCPAD|B1_ESTSEG|B1_EMIN|B1_LE|B1_QE"})
    Local oStru3 := FWFormStruct(2, "SB1", {|cCampo| AllTrim(cCampo) $ "B1_ORIGEM|B1_POSIPI|B1_PICM|B1_IPI|B1_PICMRET"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_CAD", oStru1, "SB1MASTER")
    oView:AddField("VIEW_EST", oStru2, "SB1MASTER")
    oView:AddField("VIEW_FIS", oStru3, "SB1MASTER")
    
    // Cria folder com 3 abas
    oView:CreateFolder("PASTAS", "TELA")
    oView:AddSheet("PASTAS", "ABA1", "Cadastrais")
    oView:AddSheet("PASTAS", "ABA2", "Estoque")
    oView:AddSheet("PASTAS", "ABA3", "Fiscal")
    
    oView:CreateHorizontalBox("BOX1", 100, , , "PASTAS", "ABA1")
    oView:CreateHorizontalBox("BOX2", 100, , , "PASTAS", "ABA2")
    oView:CreateHorizontalBox("BOX3", 100, , , "PASTAS", "ABA3")
    
    oView:SetOwnerView("VIEW_CAD", "BOX1")
    oView:SetOwnerView("VIEW_EST", "BOX2")
    oView:SetOwnerView("VIEW_FIS", "BOX3")
Return oView

/*
EXEMPLO 3: Layout Horizontal
Divide tela em cima e embaixo
*/

User Function MVCEX08()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Layout Horizontal")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX08" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX08" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX08M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_COD|A1_LOJA|A1_NOME|A1_NREDUZ|A1_CGC"})
    Local oStru2 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_END|A1_EST|A1_COD_MUN|A1_MUN|A1_CEP|A1_BAIRRO"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_SUP", oStru1, "SA1MASTER")
    oView:AddField("VIEW_INF", oStru2, "SA1MASTER")
    
    // Divide tela: 40% em cima, 60% embaixo
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    
    oView:SetOwnerView("VIEW_SUP", "SUPERIOR")
    oView:SetOwnerView("VIEW_INF", "INFERIOR")
    
    oView:EnableTitleView("VIEW_SUP", "Dados Principais")
    oView:EnableTitleView("VIEW_INF", "Endereço")
Return oView

/*
EXEMPLO 4: Layout Vertical
Divide tela lado a lado
*/

User Function MVCEX09()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Layout Vertical")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX09" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX09" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX09M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_COD|A1_LOJA|A1_NOME|A1_CGC|A1_END|A1_EST|A1_MUN"})
    Local oStru2 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_VEND|A1_LC|A1_NATUREZ|A1_COND|A1_TABELA"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_ESQ", oStru1, "SA1MASTER")
    oView:AddField("VIEW_DIR", oStru2, "SA1MASTER")
    
    // Divide tela: 50% esquerda, 50% direita
    oView:CreateVerticalBox("ESQUERDA", 50)
    oView:CreateVerticalBox("DIREITA", 50)
    
    oView:SetOwnerView("VIEW_ESQ", "ESQUERDA")
    oView:SetOwnerView("VIEW_DIR", "DIREITA")
    
    oView:EnableTitleView("VIEW_ESQ", "Cadastrais")
    oView:EnableTitleView("VIEW_DIR", "Comerciais")
Return oView

/*
EXEMPLO 5: Layout Completo
Combina folders e boxes
*/

User Function MVCEX10()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Layout Completo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX10" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX10" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX10" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX10M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_COD|A1_LOJA|A1_NOME|A1_NREDUZ|A1_CGC"})
    Local oStru2 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_END|A1_EST|A1_MUN|A1_CEP|A1_BAIRRO"})
    Local oStru3 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_VEND|A1_LC|A1_VENCLC|A1_NATUREZ|A1_COND"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_CAD", oStru1, "SA1MASTER")
    oView:AddField("VIEW_END", oStru2, "SA1MASTER")
    oView:AddField("VIEW_COM", oStru3, "SA1MASTER")
    
    // Box superior: 30%
    oView:CreateHorizontalBox("TOPO", 30)
    oView:SetOwnerView("VIEW_CAD", "TOPO")
    
    // Box inferior: 70% com folder
    oView:CreateHorizontalBox("BAIXO", 70)
    oView:CreateFolder("PASTAS", "BAIXO")
    oView:AddSheet("PASTAS", "ABA1", "Endereço")
    oView:AddSheet("PASTAS", "ABA2", "Comercial")
    
    oView:CreateHorizontalBox("BOX1", 100, , , "PASTAS", "ABA1")
    oView:CreateHorizontalBox("BOX2", 100, , , "PASTAS", "ABA2")
    
    oView:SetOwnerView("VIEW_END", "BOX1")
    oView:SetOwnerView("VIEW_COM", "BOX2")
    
    oView:EnableTitleView("VIEW_CAD", "Dados Principais")
Return oView
