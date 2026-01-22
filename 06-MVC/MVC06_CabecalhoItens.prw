// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC06
Cabeçalho + Itens - Master-Detail

Exemplos de cadastros com cabeçalho e itens:
- Pedido de vendas
- Ordem de produção
- Nota fiscal entrada
- Requisição materiais
- Cotação completa

@type User Function
@author Felipi Marques
@since 18/12/2025

@example
U_MVC06()
/*/

User Function MVC06()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Cabeçalho+Itens", ;
                     "1-Pedido de Vendas" + CRLF + ;
                     "2-Nota Fiscal Entrada" + CRLF + ;
                     "3-Requisição Materiais" + CRLF + ;
                     "4-Ordem de Produção" + CRLF + ;
                     "5-Cotação Completa" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX21()
            Case nOpc == 2
                U_MVCEX22()
            Case nOpc == 3
                U_MVCEX23()
            Case nOpc == 4
                U_MVCEX24()
            Case nOpc == 5
                U_MVCEX25()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Pedido de Vendas
Cabeçalho SC5 + Itens SC6
*/

User Function MVCEX21()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC5")
    oBrowse:SetDescription("Pedido de Vendas")
    oBrowse:SetMenuDef("MVC06")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX21" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX21" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX21" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSC5 := FWFormStruct(1, "SC5")
    Local oStruSC6 := FWFormStruct(1, "SC6")
    
    oModel := MPFormModel():New("MVCEX21M")
    
    // Cabeçalho
    oModel:AddFields("SC5MASTER", , oStruSC5)
    
    // Grid de itens
    oModel:AddGrid("SC6DETAIL", "SC5MASTER", oStruSC6, , {|oGrid| fTotPedido(oGrid)})
    
    // Relacionamento
    oModel:SetRelation("SC6DETAIL", {;
        {"C6_FILIAL", "xFilial('SC6')"},;
        {"C6_NUM", "C5_NUM"}}, SC6->(IndexKey(1)))
    
    // Chave única do grid
    oModel:GetModel("SC6DETAIL"):SetUniqueLine({"C6_ITEM"})
    
    oModel:SetPrimaryKey({"C5_FILIAL", "C5_NUM"})
    oModel:SetDescription("Pedido de Vendas MVC")
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSC5 := FWFormStruct(2, "SC5")
    Local oStruSC6 := FWFormStruct(2, "SC6")
    
    // Remove campos do grid
    oStruSC6:RemoveField("C6_FILIAL")
    oStruSC6:RemoveField("C6_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_SC5", oStruSC5, "SC5MASTER")
    oView:AddGrid("VIEW_SC6", oStruSC6, "SC6DETAIL")
    
    // Layout
    oView:CreateHorizontalBox("SUPERIOR", 35)
    oView:CreateHorizontalBox("INFERIOR", 65)
    
    oView:SetOwnerView("VIEW_SC5", "SUPERIOR")
    oView:SetOwnerView("VIEW_SC6", "INFERIOR")
    
    // Incrementa item
    oView:AddIncrementField("VIEW_SC6", "C6_ITEM")
    
    // Títulos
    oView:EnableTitleView("VIEW_SC5", "Cabeçalho do Pedido")
    oView:EnableTitleView("VIEW_SC6", "Itens do Pedido")
Return oView

// Totaliza pedido
Static Function fTotPedido(oMdlGrid)
    Local oModel := oMdlGrid:GetModel()
    Local oMdlCab := oModel:GetModel("SC5MASTER")
    Local nI, nTotal := 0
    
    For nI := 1 To oMdlGrid:Length()
        oMdlGrid:GoLine(nI)
        If !oMdlGrid:IsDeleted()
            nTotal += oMdlGrid:GetValue("C6_VALOR")
        EndIf
    Next
    
    oMdlCab:LoadValue("C5_TOTAL", nTotal)
Return .T.

/*
EXEMPLO 2: Nota Fiscal Entrada
Cabeçalho SF1 + Itens SD1
*/

User Function MVCEX22()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SF1")
    oBrowse:SetDescription("Nota Fiscal Entrada")
    oBrowse:SetMenuDef("MVC06")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX22" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX22" OPERATION 3 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSF1 := FWFormStruct(1, "SF1")
    Local oStruSD1 := FWFormStruct(1, "SD1")
    
    oModel := MPFormModel():New("MVCEX22M")
    oModel:AddFields("SF1MASTER", , oStruSF1)
    oModel:AddGrid("SD1DETAIL", "SF1MASTER", oStruSD1)
    
    oModel:SetRelation("SD1DETAIL", {;
        {"D1_FILIAL", "xFilial('SD1')"},;
        {"D1_DOC", "F1_DOC"},;
        {"D1_SERIE", "F1_SERIE"},;
        {"D1_FORNECE", "F1_FORNECE"},;
        {"D1_LOJA", "F1_LOJA"}}, SD1->(IndexKey(1)))
    
    oModel:GetModel("SD1DETAIL"):SetUniqueLine({"D1_ITEM"})
    oModel:SetPrimaryKey({"F1_FILIAL", "F1_DOC", "F1_SERIE", "F1_FORNECE", "F1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSF1 := FWFormStruct(2, "SF1")
    Local oStruSD1 := FWFormStruct(2, "SD1")
    
    oStruSD1:RemoveField("D1_FILIAL")
    oStruSD1:RemoveField("D1_DOC")
    oStruSD1:RemoveField("D1_SERIE")
    oStruSD1:RemoveField("D1_FORNECE")
    oStruSD1:RemoveField("D1_LOJA")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SF1", oStruSF1, "SF1MASTER")
    oView:AddGrid("VIEW_SD1", oStruSD1, "SD1DETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_SF1", "SUPERIOR")
    oView:SetOwnerView("VIEW_SD1", "INFERIOR")
    oView:AddIncrementField("VIEW_SD1", "D1_ITEM")
Return oView

/*
EXEMPLO 3: Requisição de Materiais
Cabeçalho SCP + Itens SCP (mesmo alias)
*/

User Function MVCEX23()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SCP")
    oBrowse:SetDescription("Requisição ao Armazém")
    oBrowse:SetFilterDefault("CP_STATUS != 'E'")  // Não encerradas
    oBrowse:SetMenuDef("MVC06")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX23" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX23" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX23" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSCP := FWFormStruct(1, "SCP", {|cCampo| AllTrim(cCampo) $ "CP_NUM|CP_EMISSAO|CP_SOLICIT|CP_CC"})
    Local oStruItem := FWFormStruct(1, "SCP", {|cCampo| AllTrim(cCampo) $ "CP_ITEM|CP_PRODUTO|CP_DESCRI|CP_QUANT|CP_LOCAL"})
    
    oModel := MPFormModel():New("MVCEX23M")
    oModel:AddFields("SCPMASTER", , oStruSCP)
    oModel:AddGrid("SCPDETAIL", "SCPMASTER", oStruItem)
    
    oModel:SetRelation("SCPDETAIL", {;
        {"CP_FILIAL", "xFilial('SCP')"},;
        {"CP_NUM", "CP_NUM"}}, SCP->(IndexKey(1)))
    
    oModel:GetModel("SCPDETAIL"):SetUniqueLine({"CP_ITEM"})
    oModel:SetPrimaryKey({"CP_FILIAL", "CP_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "SCP", {|cCampo| AllTrim(cCampo) $ "CP_NUM|CP_EMISSAO|CP_SOLICIT|CP_CC"})
    Local oStruItem := FWFormStruct(2, "SCP", {|cCampo| AllTrim(cCampo) $ "CP_ITEM|CP_PRODUTO|CP_DESCRI|CP_QUANT|CP_LOCAL"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_CAB", oStruCab, "SCPMASTER")
    oView:AddGrid("VIEW_ITEM", oStruItem, "SCPDETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 30)
    oView:CreateHorizontalBox("INFERIOR", 70)
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITEM", "INFERIOR")
    oView:AddIncrementField("VIEW_ITEM", "CP_ITEM")
    oView:EnableTitleView("VIEW_CAB", "Dados da Requisição")
    oView:EnableTitleView("VIEW_ITEM", "Materiais Requisitados")
Return oView

/*
EXEMPLO 4: Ordem de Produção
Cabeçalho SC2 + Componentes (SG1)
*/

User Function MVCEX24()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC2")
    oBrowse:SetDescription("Ordem de Produção")
    oBrowse:SetMenuDef("MVC06")
    oBrowse:AddLegend("C2_DATRF == ' '", "GREEN", "Em Aberto")
    oBrowse:AddLegend("C2_DATRF != ' '", "RED", "Encerrada")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX24" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX24" OPERATION 3 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSC2 := FWFormStruct(1, "SC2")
    Local oStruSG1 := FWFormStruct(1, "SG1")
    
    oModel := MPFormModel():New("MVCEX24M")
    oModel:AddFields("SC2MASTER", , oStruSC2)
    oModel:AddGrid("SG1DETAIL", "SC2MASTER", oStruSG1)
    
    // Relacionamento: componentes do produto
    oModel:SetRelation("SG1DETAIL", {;
        {"G1_FILIAL", "xFilial('SG1')"},;
        {"G1_COD", "C2_PRODUTO"}}, SG1->(IndexKey(1)))
    
    oModel:GetModel("SG1DETAIL"):SetOptional(.T.)  // Grid opcional
    oModel:GetModel("SG1DETAIL"):SetUniqueLine({"G1_COMP"})
    oModel:SetPrimaryKey({"C2_FILIAL", "C2_NUM", "C2_ITEM", "C2_SEQUEN"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSC2 := FWFormStruct(2, "SC2")
    Local oStruSG1 := FWFormStruct(2, "SG1")
    
    oStruSG1:RemoveField("G1_FILIAL")
    oStruSG1:RemoveField("G1_COD")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SC2", oStruSC2, "SC2MASTER")
    oView:AddGrid("VIEW_SG1", oStruSG1, "SG1DETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 45)
    oView:CreateHorizontalBox("INFERIOR", 55)
    oView:SetOwnerView("VIEW_SC2", "SUPERIOR")
    oView:SetOwnerView("VIEW_SG1", "INFERIOR")
    oView:EnableTitleView("VIEW_SC2", "Ordem de Produção")
    oView:EnableTitleView("VIEW_SG1", "Componentes (Estrutura)")
Return oView

/*
EXEMPLO 5: Cotação Completa
Com folders e validações
*/

User Function MVCEX25()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC8")
    oBrowse:SetDescription("Cotação de Compras")
    oBrowse:SetMenuDef("MVC06")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX25" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX25" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX25" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX25" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSC8 := FWFormStruct(1, "SC8")
    
    // Validação: preço deve ser maior que zero
    oStruSC8:SetProperty("C8_PRECO", MODEL_FIELD_VALID, {|| fVldPreco()})
    
    oModel := MPFormModel():New("MVCEX25M")
    oModel:AddFields("SC8MASTER", , oStruSC8)
    oModel:SetPrimaryKey({"C8_FILIAL", "C8_NUM", "C8_FORNECE", "C8_LOJA", "C8_ITEM"})
    oModel:SetDescription("Cotação de Compras MVC")
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SC8", {|cCampo| AllTrim(cCampo) $ "C8_NUM|C8_EMISSAO|C8_FORNECE|C8_LOJA|C8_NFORNEC"})
    Local oStru2 := FWFormStruct(2, "SC8", {|cCampo| AllTrim(cCampo) $ "C8_PRODUTO|C8_DESCRI|C8_QUANT|C8_PRECO|C8_TOTAL"})
    Local oStru3 := FWFormStruct(2, "SC8", {|cCampo| AllTrim(cCampo) $ "C8_COND|C8_DATPRF|C8_LOCAL|C8_OBS"})
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_CAB", oStru1, "SC8MASTER")
    oView:AddField("VIEW_PROD", oStru2, "SC8MASTER")
    oView:AddField("VIEW_OBS", oStru3, "SC8MASTER")
    
    // Layout com topo e folder
    oView:CreateHorizontalBox("TOPO", 30)
    oView:CreateHorizontalBox("MEIO", 70)
    
    oView:SetOwnerView("VIEW_CAB", "TOPO")
    
    // Cria folder
    oView:CreateFolder("FOLDER1", "MEIO")
    oView:AddSheet("FOLDER1", "ABA1", "Produto")
    oView:AddSheet("FOLDER1", "ABA2", "Observações")
    
    oView:CreateHorizontalBox("BOX1", 100, , , "FOLDER1", "ABA1")
    oView:CreateHorizontalBox("BOX2", 100, , , "FOLDER1", "ABA2")
    
    oView:SetOwnerView("VIEW_PROD", "BOX1")
    oView:SetOwnerView("VIEW_OBS", "BOX2")
    
    oView:EnableTitleView("VIEW_CAB", "Dados da Cotação")
Return oView

// Valida preço
Static Function fVldPreco()
    Local oModel := FWModelActive()
    Local nPreco := oModel:GetValue("SC8MASTER", "C8_PRECO")
    Local lRet := .T.
    
    If nPreco <= 0
        Help(, , "ATENÇÃO", , "Preço deve ser maior que zero!", 1, 0)
        lRet := .F.
    EndIf
Return lRet
