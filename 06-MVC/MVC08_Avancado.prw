// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC08
Recursos Avançados - Técnicas especiais

Exemplos avançados de MVC:
- Campos virtuais calculados
- SetProperty dinâmico
- When condicional
- Commit customizado
- MVC completo profissional

@type User Function
@author Felipi Marques
@since 04/01/2026

@example
U_MVC08()
/*/

User Function MVC08()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Avançado", ;
                     "1-Campos Virtuais" + CRLF + ;
                     "2-SetProperty Dinâmico" + CRLF + ;
                     "3-When Condicional" + CRLF + ;
                     "4-Commit Customizado" + CRLF + ;
                     "5-MVC Profissional" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX31()
            Case nOpc == 2
                U_MVCEX32()
            Case nOpc == 3
                U_MVCEX33()
            Case nOpc == 4
                U_MVCEX34()
            Case nOpc == 5
                U_MVCEX35()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Campos Virtuais Calculados
Campos que não existem na tabela mas aparecem na tela
*/

User Function MVCEX31()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Campos Virtuais")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX31" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX31" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Campo virtual: Limite Disponível
    oStruSA1:AddField(;
        "Limite Disponível",;                    // Título
        "Limite disponível para compra",;        // Tooltip
        "A1_LIMDISP",;                           // ID do campo
        "N",;                                    // Tipo
        14,;                                     // Tamanho
        2,;                                      // Decimal
        ,;                                       // Valid
        ,;                                       // When
        ,;                                       // Lista
        .F.,;                                    // Obrigatório
        {|| A1_LC - A1_SALDUP },;                // Inicializador (fórmula)
        ,;                                       // Key
        .F.,;                                    // No Update
        .T.)                                     // Virtual
    
    // Campo virtual: Dias desde cadastro
    oStruSA1:AddField(;
        "Dias Cliente",;
        "Dias desde o cadastro",;
        "A1_DIASCA",;
        "N",;
        6,;
        0,;
        ,,,,.F.,;
        {|| Date() - A1_DTCAD },;
        ,,.F.,.T.)
    
    // Campo virtual: Status textual
    oStruSA1:AddField(;
        "Status",;
        "Status do cliente",;
        "A1_STATUS",;
        "C",;
        15,;
        0,;
        ,,,,.F.,;
        {|| If(A1_MSBLQL=='1', 'BLOQUEADO', 'ATIVO') },;
        ,,.F.,.T.)
    
    oModel := MPFormModel():New("MVCEX31M")
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA1 := FWFormStruct(2, "SA1")
    
    // Adiciona campos virtuais na view
    oStruSA1:AddField(;
        "A1_LIMDISP",;                           // ID
        "99",;                                   // Ordem
        "Lim.Disponível",;                       // Título
        "Limite Disponível",;                    // Descrição
        ,;                                       // Help
        "GET",;                                  // Tipo
        "@E 999,999.99",;                        // Picture
        ,;                                       // PictVar
        ,;                                       // F3
        .F.,;                                    // Editável
        ,;                                       // Folder
        ,;                                       // Group
        ,;                                       // Lista Combo
        ,;                                       // Tamanho Combo
        ,;                                       // Inicializador
        .T.)                                     // Virtual
    
    oStruSA1:AddField(;
        "A1_DIASCA",;
        "99",;
        "Dias Cliente",;
        "Dias desde cadastro",;
        ,;
        "GET",;
        "@E 999999",;
        ,;
        ,;
        .F.,;
        ,,,,,;
        .T.)
    
    oStruSA1:AddField(;
        "A1_STATUS",;
        "99",;
        "Status",;
        "Status do Cliente",;
        ,;
        "GET",;
        "@!",;
        ,;
        ,;
        .F.,;
        ,,,,,;
        .T.)
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SA1", oStruSA1, "SA1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SA1", "TELA")
Return oView

/*
EXEMPLO 2: SetProperty Dinâmico
Muda propriedades dos campos em tempo de execução
*/

User Function MVCEX32()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Property Dinâmico")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX32" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX32" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    Local bTipo := {|oMdl| fMudaTipo(oMdl)}
    
    // Gatilho: ao mudar tipo de pessoa, ajusta campos
    oStruSA1:AddTrigger("A1_TIPO", "A1_CGC", {|| .T.}, bTipo)
    
    oModel := MPFormModel():New("MVCEX32M")
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

// Muda propriedades conforme tipo de pessoa
Static Function fMudaTipo(oModel)
    Local cTipo := oModel:GetValue("A1_TIPO")
    Local oStru := oModel:GetStruct()
    
    // Se Pessoa Física
    If cTipo == "F"
        oStru:SetProperty("A1_CGC", MODEL_FIELD_TAMANHO, 11)
        oStru:SetProperty("A1_INSCR", MODEL_FIELD_OBRIGAT, .F.)
        MsgInfo("Modo Pessoa Física" + CRLF + "CGC deve ter 11 dígitos (CPF)", "Atenção")
    // Se Pessoa Jurídica
    ElseIf cTipo == "J"
        oStru:SetProperty("A1_CGC", MODEL_FIELD_TAMANHO, 14)
        oStru:SetProperty("A1_INSCR", MODEL_FIELD_OBRIGAT, .T.)
        MsgInfo("Modo Pessoa Jurídica" + CRLF + "CGC deve ter 14 dígitos (CNPJ)", "Atenção")
    EndIf
Return cTipo

/*
EXEMPLO 3: When Condicional
Campos habilitados/desabilitados dinamicamente
*/

User Function MVCEX33()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - When Dinâmico")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX33" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX33" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // When: só permite editar limite se não bloqueado
    oStruSA1:SetProperty("A1_LC", MODEL_FIELD_WHEN, {|| fWhenLimite()})
    
    // When: só permite editar vendedor se tem limite
    oStruSA1:SetProperty("A1_VEND", MODEL_FIELD_WHEN, {|| fWhenVend()})
    
    oModel := MPFormModel():New("MVCEX33M")
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

// When do limite: só edita se não bloqueado
Static Function fWhenLimite()
    Local oModel := FWModelActive()
    Local lRet := .T.
    
    If oModel:GetOperation() == MODEL_OPERATION_UPDATE
        If oModel:GetValue("SA1MASTER", "A1_MSBLQL") == "1"
            lRet := .F.
            Help(, , "BLOQUEADO", , "Cliente bloqueado não pode ter limite alterado", 1, 0)
        EndIf
    EndIf
Return lRet

// When do vendedor: só edita se tem limite
Static Function fWhenVend()
    Local oModel := FWModelActive()
    Local nLimite := oModel:GetValue("SA1MASTER", "A1_LC")
    Local lRet := .T.
    
    If nLimite == 0
        lRet := .F.
    EndIf
Return lRet

/*
EXEMPLO 4: Commit Customizado
Grava dados em múltiplas tabelas
*/

User Function MVCEX34()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Commit Custom")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX34" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX34" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX34M", , , {|oModel| fCommit(oModel)})
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

// Commit customizado: grava também em log
Static Function fCommit(oModel)
    Local lRet := .T.
    Local cCodigo := oModel:GetValue("SA1MASTER", "A1_COD")
    Local cNome := oModel:GetValue("SA1MASTER", "A1_NOME")
    Local nOper := oModel:GetOperation()
    
    // Chama commit padrão do MVC
    FWFormCommit(oModel)
    
    // Grava log em tabela customizada (exemplo)
    If nOper == MODEL_OPERATION_INSERT
        fGravaLog("INCLUSÃO", cCodigo, cNome)
    ElseIf nOper == MODEL_OPERATION_UPDATE
        fGravaLog("ALTERAÇÃO", cCodigo, cNome)
    ElseIf nOper == MODEL_OPERATION_DELETE
        fGravaLog("EXCLUSÃO", cCodigo, cNome)
    EndIf
    
    MsgInfo("Registro gravado com sucesso!" + CRLF + "Log gerado.", "Sucesso")
Return lRet

// Grava log de operações
Static Function fGravaLog(cTipo, cCod, cNome)
    // Exemplo: gravaria em uma tabela de log (ZZZ)
    ConOut("LOG: " + cTipo + " - Cliente: " + cCod + " - " + cNome)
Return

/*
EXEMPLO 5: MVC Profissional Completo
Junta todas as técnicas avançadas
*/

User Function MVCEX35()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - MVC Profissional")
    oBrowse:AddLegend("A1_MSBLQL == '1'", "RED", "Bloqueado")
    oBrowse:AddLegend("A1_MSBLQL != '1' .And. A1_LC == 0", "YELLOW", "Sem Limite")
    oBrowse:AddLegend("A1_MSBLQL != '1' .And. A1_LC > 0", "GREEN", "Ativo com Limite")
    oBrowse:SetFilterDefault("A1_MSBLQL != '1'")  // Só ativos
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX35" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX35" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX35" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX35" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "??????????" ACTION "" OPERATION 0 ACCESS 0
    ADD OPTION aRotina TITLE "Relatório" ACTION "U_RELCLI" OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE "Consulta Pedidos" ACTION "U_CONPED" OPERATION 6 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Validações
    oStruSA1:SetProperty("A1_CGC", MODEL_FIELD_VALID, {|| fVldCGC()})
    oStruSA1:SetProperty("A1_EMAIL", MODEL_FIELD_VALID, {|| fVldEmail()})
    
    // When condicionais
    oStruSA1:SetProperty("A1_LC", MODEL_FIELD_WHEN, {|| fWhenLimite()})
    
    // Gatilhos
    oStruSA1:AddTrigger("A1_COD_MUN", "A1_EST", {|| .T.}, {|oMdl, cField, xValue| fGatMunicipio(oMdl, cField, xValue)})
    
    // Campo virtual: Limite Disponível
    oStruSA1:AddField(;
        "Limite Disponível",;
        "Limite disponível",;
        "A1_LIMDISP",;
        "N", 14, 2,;
        ,,,,.F.,;
        {|| A1_LC - A1_SALDUP },;
        ,,.F.,.T.)
    
    // Model com pré/pós validação e commit customizado
    oModel := MPFormModel():New("MVCEX35M", ;
        {|oModel| fPreValid(oModel)}, ;
        {|oModel| fPosValid(oModel)}, ;
        {|oModel| fCommit(oModel)})
    
    oModel:AddFields("SA1MASTER", , oStruSA1)
    oModel:SetPrimaryKey({"A1_FILIAL", "A1_COD", "A1_LOJA"})
    oModel:SetDescription("Cadastro Profissional de Clientes")
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStru1 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_COD|A1_LOJA|A1_NOME|A1_NREDUZ|A1_TIPO|A1_CGC|A1_EMAIL"})
    Local oStru2 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_END|A1_EST|A1_COD_MUN|A1_MUN|A1_CEP|A1_BAIRRO"})
    Local oStru3 := FWFormStruct(2, "SA1", {|cCampo| AllTrim(cCampo) $ "A1_VEND|A1_LC|A1_VENCLC|A1_SALDUP|A1_NATUREZ|A1_COND"})
    
    // Adiciona campo virtual
    oStru3:AddField("A1_LIMDISP", "99", "Lim.Disponível", "Limite Disponível", , "GET", "@E 999,999.99", , , .F., , , , , , .T.)
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_CAD", oStru1, "SA1MASTER")
    oView:AddField("VIEW_END", oStru2, "SA1MASTER")
    oView:AddField("VIEW_COM", oStru3, "SA1MASTER")
    
    // Layout: topo + folder
    oView:CreateHorizontalBox("TOPO", 35)
    oView:CreateHorizontalBox("FOLDER", 65)
    oView:SetOwnerView("VIEW_CAD", "TOPO")
    
    oView:CreateFolder("PASTAS", "FOLDER")
    oView:AddSheet("PASTAS", "ABA1", "Endereço")
    oView:AddSheet("PASTAS", "ABA2", "Comercial")
    
    oView:CreateHorizontalBox("BOX1", 100, , , "PASTAS", "ABA1")
    oView:CreateHorizontalBox("BOX2", 100, , , "PASTAS", "ABA2")
    oView:SetOwnerView("VIEW_END", "BOX1")
    oView:SetOwnerView("VIEW_COM", "BOX2")
    
    // Botões customizados
    oView:AddUserButton("Ver Pedidos", "PEDIDO", {|| fVerPedidos()})
    oView:AddUserButton("Ver Títulos", "HISTORIC", {|| fVerTitulos()})
    oView:AddUserButton("Enviar Email", "EMAIL", {|| fEnviarEmail()})
    
    oView:EnableTitleView("VIEW_CAD", "Dados Cadastrais")
Return oView

// Validação CGC
Static Function fVldCGC()
    Local oModel := FWModelActive()
    Local cCGC := AllTrim(StrTran(StrTran(StrTran(oModel:GetValue("SA1MASTER", "A1_CGC"), ".", ""), "/", ""), "-", ""))
    Local lRet := .T.
    
    If !Empty(cCGC) .And. Len(cCGC) != 11 .And. Len(cCGC) != 14
        Help(, , "ATENÇÃO", , "CGC/CPF inválido!", 1, 0)
        lRet := .F.
    EndIf
Return lRet

// Validação Email
Static Function fVldEmail()
    Local oModel := FWModelActive()
    Local cEmail := oModel:GetValue("SA1MASTER", "A1_EMAIL")
    Local lRet := .T.
    
    If !Empty(cEmail) .And. (!("@" $ cEmail) .Or. !("." $ cEmail))
        Help(, , "ATENÇÃO", , "Email inválido!", 1, 0)
        lRet := .F.
    EndIf
Return lRet

// Pré-validação
Static Function fPreValid(oModel)
    Local nOperation := oModel:GetOperation()
    Local lRet := .T.
    
    If nOperation == MODEL_OPERATION_DELETE
        // Verifica se tem pedidos
        DbSelectArea("SC5")
        SC5->(DbSetOrder(3))
        If SC5->(DbSeek(xFilial("SC5") + SA1->A1_COD + SA1->A1_LOJA))
            Help(, , "ATENÇÃO", , "Cliente possui pedidos! Não pode ser excluído!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet

// Pós-validação
Static Function fPosValid(oModel)
    Local cTipo := oModel:GetValue("SA1MASTER", "A1_TIPO")
    Local cCGC := AllTrim(StrTran(StrTran(StrTran(oModel:GetValue("SA1MASTER", "A1_CGC"), ".", ""), "/", ""), "-", ""))
    Local lRet := .T.
    
    If cTipo == "F" .And. Len(cCGC) != 11
        Help(, , "ATENÇÃO", , "Pessoa Física deve ter CPF (11 dígitos)!", 1, 0)
        lRet := .F.
    ElseIf cTipo == "J" .And. Len(cCGC) != 14
        Help(, , "ATENÇÃO", , "Pessoa Jurídica deve ter CNPJ (14 dígitos)!", 1, 0)
        lRet := .F.
    EndIf
Return lRet

// Funções auxiliares
Static Function fVerPedidos()
    MsgInfo("Consulta de pedidos do cliente", "Pedidos")
Return

Static Function fVerTitulos()
    MsgInfo("Consulta de títulos do cliente", "Títulos")
Return

Static Function fEnviarEmail()
    Local oModel := FWModelActive()
    Local cEmail := oModel:GetValue("SA1MASTER", "A1_EMAIL")
    
    If !Empty(cEmail)
        MsgInfo("Email enviado para: " + cEmail, "Email")
    Else
        MsgStop("Cliente sem email cadastrado!", "Atenção")
    EndIf
Return

User Function CONPED()
    MsgInfo("Consulta pedidos do cliente posicionado", "Pedidos")
Return
