// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC04
Grid - Múltiplas Linhas

Exemplos de grid/tabela editável:
- Grid simples de itens
- Grid com totalização
- Grid com validação
- Grid com cálculo automático
- Grid completo

@type User Function
@author Felipi Marques
@since 07/12/2025

@example
U_MVC04()
/*/

User Function MVC04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Grid", ;
                     "1-Grid Simples" + CRLF + ;
                     "2-Grid com Totalização" + CRLF + ;
                     "3-Grid com Validação" + CRLF + ;
                     "4-Grid com Cálculo" + CRLF + ;
                     "5-Grid Completo" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX11()
            Case nOpc == 2
                U_MVCEX12()
            Case nOpc == 3
                U_MVCEX13()
            Case nOpc == 4
                U_MVCEX14()
            Case nOpc == 5
                U_MVCEX15()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Grid Simples
Cadastro de orçamento com itens
*/

User Function MVCEX11()
    Local oBrowse
    
    // Cria tabela temporária se não existir
    fCriaTab()
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription("Orçamento - Grid Simples")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX11" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX11" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX11" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX11" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab := FWFormStruct(1, "ZZA")
    Local oStruIte := FWFormStruct(1, "ZZB")
    
    oModel := MPFormModel():New("MVCEX11M")
    
    // Adiciona cabeçalho
    oModel:AddFields("ZZAMASTER", , oStruCab)
    
    // Adiciona grid de itens
    oModel:AddGrid("ZZBDETAIL", "ZZAMASTER", oStruIte)
    
    // Relacionamento cabeçalho x itens
    oModel:SetRelation("ZZBDETAIL", {;
        {"ZZB_FILIAL", "xFilial('ZZB')"},;
        {"ZZB_NUM", "ZZA_NUM"}}, ZZB->(IndexKey(1)))
    
    // Chave única do grid
    oModel:GetModel("ZZBDETAIL"):SetUniqueLine({"ZZB_ITEM"})
    
    oModel:SetPrimaryKey({"ZZA_FILIAL", "ZZA_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "ZZA")
    Local oStruIte := FWFormStruct(2, "ZZB")
    
    // Remove campos do grid
    oStruIte:RemoveField("ZZB_FILIAL")
    oStruIte:RemoveField("ZZB_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_CAB", oStruCab, "ZZAMASTER")
    oView:AddGrid("VIEW_ITE", oStruIte, "ZZBDETAIL")
    
    // Layout: 40% cabeçalho, 60% grid
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITE", "INFERIOR")
    
    // Incrementa item automaticamente (01, 02, 03...)
    oView:AddIncrementField("VIEW_ITE", "ZZB_ITEM")
Return oView

/*
EXEMPLO 2: Grid com Totalização
Soma total do pedido automaticamente
*/

User Function MVCEX12()
    Local oBrowse
    
    fCriaTab()
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription("Orçamento - Com Totalização")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX12" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX12" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX12" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab := FWFormStruct(1, "ZZA")
    Local oStruIte := FWFormStruct(1, "ZZB")
    
    oModel := MPFormModel():New("MVCEX12M")
    oModel:AddFields("ZZAMASTER", , oStruCab)
    oModel:AddGrid("ZZBDETAIL", "ZZAMASTER", oStruIte, , {|oMdlGrid| fLinePos(oMdlGrid)})
    
    oModel:SetRelation("ZZBDETAIL", {;
        {"ZZB_FILIAL", "xFilial('ZZB')"},;
        {"ZZB_NUM", "ZZA_NUM"}}, ZZB->(IndexKey(1)))
    
    oModel:GetModel("ZZBDETAIL"):SetUniqueLine({"ZZB_ITEM"})
    oModel:SetPrimaryKey({"ZZA_FILIAL", "ZZA_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "ZZA")
    Local oStruIte := FWFormStruct(2, "ZZB")
    
    oStruIte:RemoveField("ZZB_FILIAL")
    oStruIte:RemoveField("ZZB_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_CAB", oStruCab, "ZZAMASTER")
    oView:AddGrid("VIEW_ITE", oStruIte, "ZZBDETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITE", "INFERIOR")
    oView:AddIncrementField("VIEW_ITE", "ZZB_ITEM")
Return oView

// Totaliza após validar linha
Static Function fLinePos(oMdlGrid)
    Local oModel := oMdlGrid:GetModel()
    Local oMdlCab := oModel:GetModel("ZZAMASTER")
    Local nI, nTotal := 0
    
    // Soma todos os itens
    For nI := 1 To oMdlGrid:Length()
        oMdlGrid:GoLine(nI)
        If !oMdlGrid:IsDeleted()
            nTotal += oMdlGrid:GetValue("ZZB_TOTAL")
        EndIf
    Next
    
    // Atualiza total no cabeçalho
    oMdlCab:LoadValue("ZZA_TOTAL", nTotal)
Return .T.

/*
EXEMPLO 3: Grid com Validação
Valida estoque antes de incluir item
*/

User Function MVCEX13()
    Local oBrowse
    
    fCriaTab()
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription("Orçamento - Com Validação")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX13" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX13" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX13" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab := FWFormStruct(1, "ZZA")
    Local oStruIte := FWFormStruct(1, "ZZB")
    
    // Validação no campo produto
    oStruIte:SetProperty("ZZB_PROD", MODEL_FIELD_VALID, {|| fVldProd()})
    
    // Validação no campo quantidade
    oStruIte:SetProperty("ZZB_QUANT", MODEL_FIELD_VALID, {|| fVldQuant()})
    
    oModel := MPFormModel():New("MVCEX13M")
    oModel:AddFields("ZZAMASTER", , oStruCab)
    oModel:AddGrid("ZZBDETAIL", "ZZAMASTER", oStruIte)
    
    oModel:SetRelation("ZZBDETAIL", {;
        {"ZZB_FILIAL", "xFilial('ZZB')"},;
        {"ZZB_NUM", "ZZA_NUM"}}, ZZB->(IndexKey(1)))
    
    oModel:GetModel("ZZBDETAIL"):SetUniqueLine({"ZZB_ITEM"})
    oModel:SetPrimaryKey({"ZZA_FILIAL", "ZZA_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "ZZA")
    Local oStruIte := FWFormStruct(2, "ZZB")
    
    oStruIte:RemoveField("ZZB_FILIAL")
    oStruIte:RemoveField("ZZB_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_CAB", oStruCab, "ZZAMASTER")
    oView:AddGrid("VIEW_ITE", oStruIte, "ZZBDETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITE", "INFERIOR")
    oView:AddIncrementField("VIEW_ITE", "ZZB_ITEM")
Return oView

// Valida se produto existe
Static Function fVldProd()
    Local oModel := FWModelActive()
    Local oMdlGrid := oModel:GetModel("ZZBDETAIL")
    Local cProd := oMdlGrid:GetValue("ZZB_PROD")
    Local lRet := .T.
    
    If !Empty(cProd)
        DbSelectArea("SB1")
        SB1->(DbSetOrder(1))
        If !SB1->(DbSeek(xFilial("SB1") + cProd))
            Help(, , "HELP", , "Produto não cadastrado!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

// Valida estoque
Static Function fVldQuant()
    Local oModel := FWModelActive()
    Local oMdlGrid := oModel:GetModel("ZZBDETAIL")
    Local cProd := oMdlGrid:GetValue("ZZB_PROD")
    Local nQuant := oMdlGrid:GetValue("ZZB_QUANT")
    Local nSaldo := 0
    Local lRet := .T.
    
    If !Empty(cProd) .And. nQuant > 0
        DbSelectArea("SB2")
        SB2->(DbSetOrder(1))
        If SB2->(DbSeek(xFilial("SB2") + cProd))
            nSaldo := SB2->B2_QATU - SB2->B2_RESERVA
            If nQuant > nSaldo
                Help(, , "HELP", , "Quantidade maior que saldo (" + AllTrim(Str(nSaldo)) + ")", 1, 0)
                lRet := .F.
            EndIf
        EndIf
    EndIf
Return lRet

/*
EXEMPLO 4: Grid com Cálculo Automático
Calcula total do item ao digitar qtde e preço
*/

User Function MVCEX14()
    Local oBrowse
    
    fCriaTab()
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription("Orçamento - Com Cálculo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX14" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX14" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX14" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab := FWFormStruct(1, "ZZA")
    Local oStruIte := FWFormStruct(1, "ZZB")
    Local bCalcTot := {|oMdl| fCalcTotal(oMdl)}
    
    // Gatilho para calcular total ao mudar qtde ou preço
    oStruIte:SetProperty("ZZB_QUANT", MODEL_FIELD_VALID, bCalcTot)
    oStruIte:SetProperty("ZZB_PRECO", MODEL_FIELD_VALID, bCalcTot)
    
    oModel := MPFormModel():New("MVCEX14M")
    oModel:AddFields("ZZAMASTER", , oStruCab)
    oModel:AddGrid("ZZBDETAIL", "ZZAMASTER", oStruIte)
    
    oModel:SetRelation("ZZBDETAIL", {;
        {"ZZB_FILIAL", "xFilial('ZZB')"},;
        {"ZZB_NUM", "ZZA_NUM"}}, ZZB->(IndexKey(1)))
    
    oModel:GetModel("ZZBDETAIL"):SetUniqueLine({"ZZB_ITEM"})
    oModel:SetPrimaryKey({"ZZA_FILIAL", "ZZA_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "ZZA")
    Local oStruIte := FWFormStruct(2, "ZZB")
    
    oStruIte:RemoveField("ZZB_FILIAL")
    oStruIte:RemoveField("ZZB_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_CAB", oStruCab, "ZZAMASTER")
    oView:AddGrid("VIEW_ITE", oStruIte, "ZZBDETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITE", "INFERIOR")
    oView:AddIncrementField("VIEW_ITE", "ZZB_ITEM")
Return oView

// Calcula total do item
Static Function fCalcTotal(oMdl)
    Local oModel := FWModelActive()
    Local oMdlGrid := oModel:GetModel("ZZBDETAIL")
    Local nQuant := oMdlGrid:GetValue("ZZB_QUANT")
    Local nPreco := oMdlGrid:GetValue("ZZB_PRECO")
    Local nTotal := nQuant * nPreco
    
    // Atualiza campo total
    oMdlGrid:LoadValue("ZZB_TOTAL", nTotal)
Return .T.

/*
EXEMPLO 5: Grid Completo
Junta todas as funcionalidades
*/

User Function MVCEX15()
    Local oBrowse
    
    fCriaTab()
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription("Orçamento - Completo")
    oBrowse:AddLegend("ZZA_STATUS == '1'", "GREEN", "Aberto")
    oBrowse:AddLegend("ZZA_STATUS == '2'", "BLUE", "Aprovado")
    oBrowse:AddLegend("ZZA_STATUS == '3'", "RED", "Cancelado")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX15" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX15" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX15" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX15" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruCab := FWFormStruct(1, "ZZA")
    Local oStruIte := FWFormStruct(1, "ZZB")
    Local bCalcTot := {|oMdl| fCalcTotal(oMdl)}
    
    // Validações
    oStruIte:SetProperty("ZZB_PROD", MODEL_FIELD_VALID, {|| fVldProd()})
    oStruIte:SetProperty("ZZB_QUANT", MODEL_FIELD_VALID, {|| fVldQuant()})
    oStruIte:SetProperty("ZZB_QUANT", MODEL_FIELD_VALID, bCalcTot)
    oStruIte:SetProperty("ZZB_PRECO", MODEL_FIELD_VALID, bCalcTot)
    
    oModel := MPFormModel():New("MVCEX15M")
    oModel:AddFields("ZZAMASTER", , oStruCab)
    oModel:AddGrid("ZZBDETAIL", "ZZAMASTER", oStruIte, , {|oMdlGrid| fLinePos(oMdlGrid)})
    
    oModel:SetRelation("ZZBDETAIL", {;
        {"ZZB_FILIAL", "xFilial('ZZB')"},;
        {"ZZB_NUM", "ZZA_NUM"}}, ZZB->(IndexKey(1)))
    
    oModel:GetModel("ZZBDETAIL"):SetUniqueLine({"ZZB_ITEM"})
    oModel:SetPrimaryKey({"ZZA_FILIAL", "ZZA_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruCab := FWFormStruct(2, "ZZA")
    Local oStruIte := FWFormStruct(2, "ZZB")
    
    oStruIte:RemoveField("ZZB_FILIAL")
    oStruIte:RemoveField("ZZB_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_CAB", oStruCab, "ZZAMASTER")
    oView:AddGrid("VIEW_ITE", oStruIte, "ZZBDETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_CAB", "SUPERIOR")
    oView:SetOwnerView("VIEW_ITE", "INFERIOR")
    oView:AddIncrementField("VIEW_ITE", "ZZB_ITEM")
    oView:EnableTitleView("VIEW_CAB", "Cabeçalho do Orçamento")
    oView:EnableTitleView("VIEW_ITE", "Itens do Orçamento")
Return oView

// Função auxiliar: Cria tabelas de exemplo (ZZA e ZZB)
Static Function fCriaTab()
    // Esta função criaria as tabelas temporárias ZZA e ZZB
    // Para fins didáticos, assume que já existem
Return
