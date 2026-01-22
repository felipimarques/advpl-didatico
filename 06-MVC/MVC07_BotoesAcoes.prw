// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC07
Botões e Ações - Customizações

Exemplos de botões e ações personalizadas:
- Botões no cabeçalho
- Botões na barra
- Ações automáticas
- Gatilhos entre campos
- Integração com relatórios

@type User Function
@author Felipi Marques
@since 27/12/2025

@example
U_MVC07()
/*/

User Function MVC07()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Botões e Ações", ;
                     "1-Botão Simples" + CRLF + ;
                     "2-Múltiplos Botões" + CRLF + ;
                     "3-Botões com Ações" + CRLF + ;
                     "4-Gatilhos de Campos" + CRLF + ;
                     "5-Ações Completas" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX26()
            Case nOpc == 2
                U_MVCEX27()
            Case nOpc == 3
                U_MVCEX28()
            Case nOpc == 4
                U_MVCEX29()
            Case nOpc == 5
                U_MVCEX30()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Botão Simples
Adiciona botão "Copiar Endereço"
*/

User Function MVCEX26()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Botão Simples")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX26" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX26" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX26M")
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
    
    // Adiciona botão personalizado
    oView:AddUserButton("Copiar Endereço", "BUDGET", {|| fCopiaEnd()}, "Copia endereço de cobrança para entrega")
Return oView

// Copia endereço de cobrança para entrega
Static Function fCopiaEnd()
    Local oModel := FWModelActive()
    Local oMdlSA1 := oModel:GetModel("SA1MASTER")
    
    If MsgYesNo("Copiar endereço de cobrança para entrega?", "Confirma")
        oMdlSA1:SetValue("A1_ENDENT", oMdlSA1:GetValue("A1_END"))
        oMdlSA1:SetValue("A1_BAIRROE", oMdlSA1:GetValue("A1_BAIRRO"))
        oMdlSA1:SetValue("A1_MUNE", oMdlSA1:GetValue("A1_MUN"))
        oMdlSA1:SetValue("A1_ESTE", oMdlSA1:GetValue("A1_EST"))
        oMdlSA1:SetValue("A1_CEPE", oMdlSA1:GetValue("A1_CEP"))
        
        MsgInfo("Endereço copiado com sucesso!", "Sucesso")
    EndIf
Return

/*
EXEMPLO 2: Múltiplos Botões
Vários botões com funções diferentes
*/

User Function MVCEX27()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Múltiplos Botões")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX27" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX27" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX27M")
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
    
    // Botão 1: Ver Pedidos
    oView:AddUserButton("Ver Pedidos", "PEDIDO", {|| fVerPed()}, "Consulta pedidos do cliente")
    
    // Botão 2: Ver Títulos
    oView:AddUserButton("Ver Títulos", "HISTORIC", {|| fVerTit()}, "Consulta títulos do cliente")
    
    // Botão 3: Enviar Email
    oView:AddUserButton("Enviar Email", "EMAIL", {|| fEnvEmail()}, "Envia email para o cliente")
    
    // Botão 4: Calcular Idade
    oView:AddUserButton("Calcular Idade", "CALCULATOR", {|| fCalcIdade()}, "Calcula idade do cadastro")
Return oView

// Ver pedidos do cliente
Static Function fVerPed()
    Local oModel := FWModelActive()
    Local cCliente := oModel:GetValue("SA1MASTER", "A1_COD")
    Local cLoja := oModel:GetValue("SA1MASTER", "A1_LOJA")
    Local nPedidos := 0
    
    DbSelectArea("SC5")
    SC5->(DbSetOrder(3))  // C5_FILIAL+C5_CLIENTE+C5_LOJA
    SC5->(DbSeek(xFilial("SC5") + cCliente + cLoja))
    
    While SC5->(!Eof()) .And. SC5->C5_CLIENTE == cCliente .And. SC5->C5_LOJA == cLoja
        nPedidos++
        SC5->(DbSkip())
    EndDo
    
    MsgInfo("Cliente possui " + AllTrim(Str(nPedidos)) + " pedido(s)", "Pedidos")
Return

// Ver títulos do cliente
Static Function fVerTit()
    Local oModel := FWModelActive()
    Local cCliente := oModel:GetValue("SA1MASTER", "A1_COD")
    Local cLoja := oModel:GetValue("SA1MASTER", "A1_LOJA")
    Local nTitulos := 0
    Local nValor := 0
    
    DbSelectArea("SE1")
    SE1->(DbSetOrder(2))  // E1_FILIAL+E1_CLIENTE+E1_LOJA
    SE1->(DbSeek(xFilial("SE1") + cCliente + cLoja))
    
    While SE1->(!Eof()) .And. SE1->E1_CLIENTE == cCliente .And. SE1->E1_LOJA == cLoja
        nTitulos++
        nValor += SE1->E1_SALDO
        SE1->(DbSkip())
    EndDo
    
    MsgInfo("Títulos: " + AllTrim(Str(nTitulos)) + CRLF + ;
            "Saldo: R$ " + Transform(nValor, "@E 999,999.99"), "Títulos a Receber")
Return

// Enviar email
Static Function fEnvEmail()
    Local oModel := FWModelActive()
    Local cEmail := oModel:GetValue("SA1MASTER", "A1_EMAIL")
    
    If Empty(cEmail)
        MsgStop("Cliente não possui email cadastrado!", "Atenção")
    Else
        MsgInfo("Email seria enviado para: " + cEmail, "Email")
    EndIf
Return

// Calcular idade do cadastro
Static Function fCalcIdade()
    Local oModel := FWModelActive()
    Local dData := oModel:GetValue("SA1MASTER", "A1_DTCAD")
    Local nDias := Date() - dData
    Local nAnos := Int(nDias / 365)
    
    MsgInfo("Cliente cadastrado há:" + CRLF + ;
            AllTrim(Str(nAnos)) + " ano(s)" + CRLF + ;
            AllTrim(Str(nDias)) + " dia(s)", "Idade do Cadastro")
Return

/*
EXEMPLO 3: Botões com Ações no Browse
Adiciona opções personalizadas no menu do browse
*/

User Function MVCEX28()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Menu Customizado")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX28" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX28" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX28" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX28" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "??????????" ACTION "" OPERATION 0 ACCESS 0
    ADD OPTION aRotina TITLE "?? Relatório" ACTION "U_RELCLI" OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE "?? Mala Direta" ACTION "U_MALADIR" OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE "?? Bloquear" ACTION "U_BLQCLI" OPERATION 6 ACCESS 0
    ADD OPTION aRotina TITLE "?? Desbloquear" ACTION "U_DESBLQ" OPERATION 6 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX28M")
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

// Funções do menu customizado
User Function RELCLI()
    MsgInfo("Aqui seria gerado um relatório do cliente", "Relatório")
Return

User Function MALADIR()
    MsgInfo("Aqui seria enviada mala direta", "Mala Direta")
Return

User Function BLQCLI()
    If MsgYesNo("Confirma bloqueio do cliente?", "Bloquear")
        RecLock("SA1", .F.)
        SA1->A1_MSBLQL := "1"
        MsUnlock()
        MsgInfo("Cliente bloqueado!", "Sucesso")
    EndIf
Return

User Function DESBLQ()
    If MsgYesNo("Confirma desbloqueio do cliente?", "Desbloquear")
        RecLock("SA1", .F.)
        SA1->A1_MSBLQL := "2"
        MsUnlock()
        MsgInfo("Cliente desbloqueado!", "Sucesso")
    EndIf
Return

/*
EXEMPLO 4: Gatilhos entre Campos
Ao mudar um campo, atualiza outros automaticamente
*/

User Function MVCEX29()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Com Gatilhos")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX29" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX29" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    Local bGatMun := {|oMdl, cField, xValue| fGatMunicipio(oMdl, cField, xValue)}
    Local bGatEst := {|oMdl, cField, xValue| fGatEstado(oMdl, cField, xValue)}
    
    // Gatilho: ao mudar município, busca UF
    oStruSA1:AddTrigger("A1_COD_MUN", "A1_EST", {|| .T.}, bGatMun)
    
    // Gatilho: ao mudar estado, limpa município
    oStruSA1:AddTrigger("A1_EST", "A1_MUN", {|| .T.}, bGatEst)
    
    oModel := MPFormModel():New("MVCEX29M")
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

// Gatilho: busca estado do município
Static Function fGatMunicipio(oModel, cField, xValue)
    Local cEstado := ""
    Local cMun := ""
    
    If !Empty(xValue)
        DbSelectArea("CC2")
        CC2->(DbSetOrder(1))  // CC2_CODMUN
        If CC2->(DbSeek(xValue))
            cEstado := CC2->CC2_EST
            cMun := CC2->CC2_MUN
            
            // Atualiza campos
            oModel:SetValue("A1_EST", cEstado)
            oModel:SetValue("A1_MUN", cMun)
        EndIf
    EndIf
Return cEstado

// Gatilho: limpa município ao mudar estado
Static Function fGatEstado(oModel, cField, xValue)
    // Se mudou o estado, limpa o município
    oModel:SetValue("A1_COD_MUN", "")
Return ""

/*
EXEMPLO 5: Ações Completas
Junta tudo: botões, gatilhos e validações
*/

User Function MVCEX30()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - Tudo Junto")
    oBrowse:AddLegend("A1_MSBLQL == '1'", "RED", "Bloqueado")
    oBrowse:AddLegend("A1_MSBLQL != '1'", "GREEN", "Ativo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX30" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX30" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX30" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX30" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "??????????" ACTION "" OPERATION 0 ACCESS 0
    ADD OPTION aRotina TITLE "Relatório" ACTION "U_RELCLI" OPERATION 6 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    // Validação de CGC
    oStruSA1:SetProperty("A1_CGC", MODEL_FIELD_VALID, {|| fVldCGC()})
    
    // Gatilho município -> estado
    oStruSA1:AddTrigger("A1_COD_MUN", "A1_EST", {|| .T.}, {|oMdl, cField, xValue| fGatMunicipio(oMdl, cField, xValue)})
    
    oModel := MPFormModel():New("MVCEX30M")
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
    
    // Botões personalizados
    oView:AddUserButton("Ver Pedidos", "PEDIDO", {|| fVerPed()})
    oView:AddUserButton("Ver Títulos", "HISTORIC", {|| fVerTit()})
    oView:AddUserButton("Copiar Endereço", "BUDGET", {|| fCopiaEnd()})
    oView:AddUserButton("Enviar Email", "EMAIL", {|| fEnvEmail()})
Return oView

// Validação CGC
Static Function fVldCGC()
    Local oModel := FWModelActive()
    Local cCGC := AllTrim(StrTran(StrTran(StrTran(oModel:GetValue("SA1MASTER", "A1_CGC"), ".", ""), "/", ""), "-", ""))
    Local lRet := .T.
    
    If !Empty(cCGC)
        If Len(cCGC) != 11 .And. Len(cCGC) != 14
            Help(, , "ATENÇÃO", , "CGC/CPF inválido!", 1, 0)
            lRet := .F.
        EndIf
    EndIf
Return lRet
