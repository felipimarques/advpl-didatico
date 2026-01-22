// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC02
Model Simples - Cadastro básico completo

Exemplos de MVC funcional com Model e View:
- Cadastro de clientes (visualizar/incluir)
- Cadastro de produtos (com todas operações)
- Cadastro com campos personalizados
- Cadastro com validações
- Cadastro completo

@type User Function
@author Felipi Marques
@since 29/11/2025

@example
U_MVC02()
/*/

User Function MVC02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Model Simples", ;
                     "1-Cadastro Clientes (básico)" + CRLF + ;
                     "2-Cadastro Produtos (completo)" + CRLF + ;
                     "3-Cadastro Fornecedores" + CRLF + ;
                     "4-Cadastro com Validação" + CRLF + ;
                     "5-Cadastro Customizado" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX01()  // Chama cadastro de clientes
            Case nOpc == 2
                U_MVCEX02()  // Chama cadastro de produtos
            Case nOpc == 3
                U_MVCEX03()  // Chama cadastro de fornecedores
            Case nOpc == 4
                U_MVCEX04()  // Chama cadastro com validação
            Case nOpc == 5
                U_MVCEX05()  // Chama cadastro customizado
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Cadastro Básico de Clientes
MVC mais simples possível
*/

User Function MVCEX01()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes - MVC Básico")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX01" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX01" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX01" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX01" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")  // 1=Model
    
    // Cria o model
    oModel := MPFormModel():New("MVCEX01M")
    
    // Adiciona os campos
    oModel:AddFields("SA1MASTER", , oStruSA1)
    
    // Define chave primária
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
    
    // Descrição
    oModel:SetDescription("Modelo de Dados - Clientes")
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA1 := FWFormStruct(2, "SA1")  // 2=View
    
    // Cria a view
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    // Adiciona os campos na tela
    oView:AddField("VIEW_SA1", oStruSA1, "SA1MASTER")
    
    // Cria o box (área da tela)
    oView:CreateHorizontalBox("TELA", 100)
    
    // Relaciona o campo com o box
    oView:SetOwnerView("VIEW_SA1", "TELA")
Return oView

/*
EXEMPLO 2: Cadastro Completo de Produtos
Todas as operações + menu personalizado
*/

User Function MVCEX02()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SB1")
    oBrowse:SetDescription("Produtos - MVC Completo")
    
    // Adiciona legenda
    oBrowse:AddLegend("B1_TIPO == 'PA'", "GREEN", "Produto Acabado")
    oBrowse:AddLegend("B1_TIPO == 'MP'", "BLUE", "Matéria Prima")
    oBrowse:AddLegend("B1_TIPO == 'ME'", "YELLOW", "Mercadoria")
    
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX02" OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX02" OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX02" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX02" OPERATION MODEL_OPERATION_DELETE ACCESS 0
    ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.MVCEX02" OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSB1 := FWFormStruct(1, "SB1")
    
    oModel := MPFormModel():New("MVCEX02M")
    oModel:AddFields("SB1MASTER", , oStruSB1)
    oModel:SetPrimaryKey({"B1_FILIAL", "B1_COD"})
    oModel:SetDescription("Cadastro de Produtos")
    oModel:GetModel("SB1MASTER"):SetDescription("Dados do Produto")
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSB1 := FWFormStruct(2, "SB1")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SB1", oStruSB1, "SB1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SB1", "TELA")
Return oView

/*
EXEMPLO 3: Cadastro de Fornecedores
Com campos específicos na tela
*/

User Function MVCEX03()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA2")
    oBrowse:SetDescription("Fornecedores")
    
    // Mostra só alguns campos no browse
    oBrowse:SetOnlyFields({"A2_COD", "A2_LOJA", "A2_NOME", "A2_EST", "A2_MUN"})
    
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX03" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX03" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX03" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX03" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA2 := FWFormStruct(1, "SA2")
    
    oModel := MPFormModel():New("MVCEX03M")
    oModel:AddFields("SA2MASTER", , oStruSA2)
    oModel:SetPrimaryKey({"A2_FILIAL", "A2_COD", "A2_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA2 := FWFormStruct(2, "SA2")
    
    // Remove campos desnecessários da tela
    oStruSA2:RemoveField("A2_FILIAL")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SA2", oStruSA2, "SA2MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SA2", "TELA")
    oView:EnableTitleView("VIEW_SA2", "Dados do Fornecedor")
Return oView

/*
EXEMPLO 4: Cadastro com Validação
Model com validação de campos
*/

User Function MVCEX04()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes - Com Validação")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX04" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX04" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX04" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Adiciona validação no campo CGC
    oStruSA1:SetProperty("A1_CGC", MODEL_FIELD_VALID, {|| fValidaCGC() })
    
    oModel := MPFormModel():New("MVCEX04M", , {|oModel| fPosValid(oModel)})
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA1 := FWFormStruct(2, "SA1")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SA1", oStruSA1, "SA1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SA1", "TELA")
Return oView

// Validação do CGC
Static Function fValidaCGC()
    Local oModel := FWModelActive()
    Local cCGC := oModel:GetValue("SA1MASTER", "A1_CGC")
    Local lRet := .T.
    
    // Valida se CGC tem 14 dígitos
    If !Empty(cCGC) .And. Len(AllTrim(cCGC)) < 14
        Help(, , "HELP", , "CGC deve ter 14 dígitos", 1, 0)
        lRet := .F.
    EndIf
Return lRet

// Pós-validação do model
Static Function fPosValid(oModel)
    Local lRet := .T.
    Local cNome := oModel:GetValue("SA1MASTER", "A1_NOME")
    
    // Valida se nome foi preenchido
    If Empty(cNome)
        Help(, , "HELP", , "Nome do cliente é obrigatório", 1, 0)
        lRet := .F.
    EndIf
Return lRet

/*
EXEMPLO 5: Cadastro Customizado
Com campos calculados e folders
*/

User Function MVCEX05()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Clientes - Customizado")
    oBrowse:AddLegend("A1_MSBLQL == '1'", "RED", "Bloqueado")
    oBrowse:AddLegend("A1_MSBLQL != '1'", "GREEN", "Ativo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX05" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX05" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX05" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Adiciona campo virtual calculado
    oStruSA1:AddField(;
        "Limite Disponível",;      // Título
        "Limite Disponível",;      // Tooltip
        "A1_LIMDISP",;             // ID do campo
        "N",;                      // Tipo
        14,;                       // Tamanho
        2,;                        // Decimal
        ,;                         // Valid
        ,;                         // When
        ,;                         // Lista
        .F.,;                      // Obrigatório
        {|| A1_LC - A1_SALDUP },;  // Inicializador
        ,;                         // Key
        .F.,;                      // No Update
        .T.)                       // Virtual
    
    oModel := MPFormModel():New("MVCEX05M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA1 := FWFormStruct(2, "SA1")
    
    // Adiciona o campo virtual na view
    oStruSA1:AddField(;
        "A1_LIMDISP",;             // ID
        "99",;                     // Ordem
        "Lim.Disponível",;         // Título
        "Limite Disponível",;      // Descrição
        ,;                         // Help
        "GET",;                    // Tipo
        "@E 999,999.99",;          // Picture
        ,;                         // PictVar
        ,;                         // F3
        .F.,;                      // Editável
        ,;                         // Folder
        ,;                         // Group
        ,;                         // Lista Combo
        ,;                         // Tamanho Combo
        ,;                         // Inicializador
        .T.)                       // Virtual
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SA1", oStruSA1, "SA1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SA1", "TELA")
    oView:EnableTitleView("VIEW_SA1", "Cadastro Customizado")
Return oView
