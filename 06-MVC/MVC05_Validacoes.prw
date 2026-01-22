// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC05
Validações - Regras de negócio

Exemplos de validações em MVC:
- Validação de campo
- Pré-validação do model
- Pós-validação do model
- Validação de linha do grid
- Validação completa

@type User Function
@author Felipi Marques
@since 13/12/2025

@example
U_MVC05()
/*/

User Function MVC05()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Validações", ;
                     "1-Validação de Campo" + CRLF + ;
                     "2-Pré-Validação Model" + CRLF + ;
                     "3-Pós-Validação Model" + CRLF + ;
                     "4-Validação de Linha" + CRLF + ;
                     "5-Validação Completa" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX16()
            Case nOpc == 2
                U_MVCEX17()
            Case nOpc == 3
                U_MVCEX18()
            Case nOpc == 4
                U_MVCEX19()
            Case nOpc == 5
                U_MVCEX20()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Validação de Campo
Valida CGC/CNPJ do cliente
*/

User Function MVCEX16()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Validação Campo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX16" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX16" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Define validação no campo CGC
    oStruSA1:SetProperty("A1_CGC", MODEL_FIELD_VALID, {|| fVldCGC()})
    
    // Define validação no campo Email
    oStruSA1:SetProperty("A1_EMAIL", MODEL_FIELD_VALID, {|| fVldEmail()})
    
    oModel := MPFormModel():New("MVCEX16M")
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

// Valida CGC/CNPJ
Static Function fVldCGC()
    Local oModel := FWModelActive()
    Local cCGC := oModel:GetValue("SA1MASTER", "A1_CGC")
    Local lRet := .T.
    
    If !Empty(cCGC)
        // Remove formatação
        cCGC := AllTrim(StrTran(StrTran(StrTran(cCGC, ".", ""), "/", ""), "-", ""))
        
        // Valida tamanho (11=CPF, 14=CNPJ)
        If Len(cCGC) != 11 .And. Len(cCGC) != 14
            Help(, , "ATENÇÃO", , "CGC/CPF inválido!" + CRLF + ;
                 "CPF deve ter 11 dígitos" + CRLF + ;
                 "CNPJ deve ter 14 dígitos", 1, 0)
            lRet := .F.
        EndIf
        
        // Verifica se não é sequência
        If lRet .And. cCGC $ "00000000000|11111111111|22222222222|33333333333"
            Help(, , "ATENÇÃO", , "CGC/CPF inválido!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

// Valida Email
Static Function fVldEmail()
    Local oModel := FWModelActive()
    Local cEmail := oModel:GetValue("SA1MASTER", "A1_EMAIL")
    Local lRet := .T.
    
    If !Empty(cEmail)
        // Valida formato básico do email
        If !("@" $ cEmail) .Or. !("." $ cEmail)
            Help(, , "ATENÇÃO", , "Email inválido!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

/*
EXEMPLO 2: Pré-Validação do Model
Verifica permissão antes de processar
*/

User Function MVCEX17()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Pré-Validação")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX17" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX17" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX17" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Define pré-validação
    oModel := MPFormModel():New("MVCEX17M", {|oModel| fPreValid(oModel)})
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

// Pré-Validação: Executa ANTES de validar os campos
Static Function fPreValid(oModel)
    Local nOperation := oModel:GetOperation()
    Local lRet := .T.
    
    // Se for exclusão, verifica se pode excluir
    If nOperation == MODEL_OPERATION_DELETE
        // Verifica se cliente tem pedidos
        If fTemPedidos(SA1->A1_COD, SA1->A1_LOJA)
            Help(, , "ATENÇÃO", , "Cliente possui pedidos!" + CRLF + ;
                 "Não pode ser excluído!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
    
    // Se for alteração, verifica se está bloqueado
    If nOperation == MODEL_OPERATION_UPDATE
        If SA1->A1_MSBLQL == "1"
            Help(, , "ATENÇÃO", , "Cliente bloqueado!" + CRLF + ;
                 "Não pode ser alterado!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

// Verifica se cliente tem pedidos
Static Function fTemPedidos(cCodigo, cLoja)
    Local lRet := .F.
    
    DbSelectArea("SC5")
    SC5->(DbSetOrder(3))  // C5_FILIAL+C5_CLIENTE+C5_LOJA
    If SC5->(DbSeek(xFilial("SC5") + cCodigo + cLoja))
        lRet := .T.
    EndIf
Return lRet

/*
EXEMPLO 3: Pós-Validação do Model
Valida após processar todos os campos
*/

User Function MVCEX18()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Pós-Validação")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX18" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX18" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Pré e Pós-validação
    oModel := MPFormModel():New("MVCEX18M", , {|oModel| fPosValid(oModel)})
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

// Pós-Validação: Executa DEPOIS de validar todos os campos
Static Function fPosValid(oModel)
    Local cTipo := oModel:GetValue("SA1MASTER", "A1_TIPO")
    Local cCGC := oModel:GetValue("SA1MASTER", "A1_CGC")
    Local lRet := .T.
    
    // Remove formatação do CGC
    cCGC := AllTrim(StrTran(StrTran(StrTran(cCGC, ".", ""), "/", ""), "-", ""))
    
    // Valida tipo pessoa x tamanho CGC
    If cTipo == "F"  // Pessoa Física
        If Len(cCGC) != 11
            Help(, , "ATENÇÃO", , "Pessoa Física deve ter CPF (11 dígitos)!", 1, 0)
            lRet := .F.
        EndIf
    ElseIf cTipo == "J"  // Pessoa Jurídica
        If Len(cCGC) != 14
            Help(, , "ATENÇÃO", , "Pessoa Jurídica deve ter CNPJ (14 dígitos)!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

/*
EXEMPLO 4: Validação de Linha do Grid
Valida cada linha do grid de itens
*/

User Function MVCEX19()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC5")
    oBrowse:SetDescription("Pedidos - Validação Linha")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX19" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX19" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSC5 := FWFormStruct(1, "SC5")
    Local oStruSC6 := FWFormStruct(1, "SC6")
    
    oModel := MPFormModel():New("MVCEX19M")
    oModel:AddFields("SC5MASTER", , oStruSC5)
    
    // Adiciona grid com validação de linha
    oModel:AddGrid("SC6DETAIL", "SC5MASTER", oStruSC6, ;
        {|oMdlGrid, nLine, cAction, cField| fLinePre(oMdlGrid, nLine, cAction, cField)}, ;
        {|oMdlGrid| fLinePos(oMdlGrid)})
    
    oModel:SetRelation("SC6DETAIL", {;
        {"C6_FILIAL", "xFilial('SC6')"},;
        {"C6_NUM", "C5_NUM"}}, SC6->(IndexKey(1)))
    
    oModel:GetModel("SC6DETAIL"):SetUniqueLine({"C6_ITEM"})
    oModel:SetPrimaryKey({"C5_FILIAL", "C5_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSC5 := FWFormStruct(2, "SC5")
    Local oStruSC6 := FWFormStruct(2, "SC6")
    
    oStruSC6:RemoveField("C6_FILIAL")
    oStruSC6:RemoveField("C6_NUM")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SC5", oStruSC5, "SC5MASTER")
    oView:AddGrid("VIEW_SC6", oStruSC6, "SC6DETAIL")
    
    oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("INFERIOR", 60)
    oView:SetOwnerView("VIEW_SC5", "SUPERIOR")
    oView:SetOwnerView("VIEW_SC6", "INFERIOR")
    oView:AddIncrementField("VIEW_SC6", "C6_ITEM")
Return oView

// Pré-validação da linha
Static Function fLinePre(oMdlGrid, nLine, cAction, cField)
    Local lRet := .T.
    
    // Se está deletando, verifica se é a última linha
    If cAction == "DELETE"
        If oMdlGrid:Length() <= 1
            Help(, , "ATENÇÃO", , "Pedido precisa ter ao menos 1 item!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

// Pós-validação da linha
Static Function fLinePos(oMdlGrid)
    Local cProduto := oMdlGrid:GetValue("C6_PRODUTO")
    Local nQuant := oMdlGrid:GetValue("C6_QTDVEN")
    Local nPreco := oMdlGrid:GetValue("C6_PRCVEN")
    Local lRet := .T.
    
    // Valida se produto foi informado
    If Empty(cProduto)
        Help(, , "ATENÇÃO", , "Produto é obrigatório!", 1, 0)
        lRet := .F.
    EndIf
    
    // Valida quantidade
    If lRet .And. nQuant <= 0
        Help(, , "ATENÇÃO", , "Quantidade deve ser maior que zero!", 1, 0)
        lRet := .F.
    EndIf
    
    // Valida preço
    If lRet .And. nPreco <= 0
        Help(, , "ATENÇÃO", , "Preço deve ser maior que zero!", 1, 0)
        lRet := .F.
    EndIf
Return lRet

/*
EXEMPLO 5: Validação Completa
Todas as validações juntas
*/

User Function MVCEX20()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Validação Completa")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX20" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX20" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX20" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Validações de campo
    oStruSA1:SetProperty("A1_CGC", MODEL_FIELD_VALID, {|| fVldCGC()})
    oStruSA1:SetProperty("A1_EMAIL", MODEL_FIELD_VALID, {|| fVldEmail()})
    
    // Campo obrigatório
    oStruSA1:SetProperty("A1_NOME", MODEL_FIELD_OBRIGAT, .T.)
    
    // Model com pré e pós validação
    oModel := MPFormModel():New("MVCEX20M", ;
        {|oModel| fPreValid(oModel)}, ;
        {|oModel| fPosValid(oModel)})
    
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
    oModel:SetDescription("Cadastro Completo de Clientes")
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
    oView:EnableTitleView("VIEW_SA1", "Dados do Cliente")
Return oView
