// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} MVC09
Pontos de Entrada em MVC

Exemplos de customização usando Pontos de Entrada:
- PE no Model (MODELPOS)
- PE no Commit (MODELCOMMIT)
- PE nos Fields (FORMFIELD)
- PE no Grid (FORMLINE)
- PE completo (múltiplos PE)

@type User Function
@author Felipi Marques
@since 07/01/2026

@example
U_MVC09()
/*/

User Function MVC09()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("MVC - Pontos de Entrada", ;
                     "1-PE ModelPos" + CRLF + ;
                     "2-PE Commit" + CRLF + ;
                     "3-PE FormField" + CRLF + ;
                     "4-PE FormLine" + CRLF + ;
                     "5-Múltiplos PEs" + CRLF + ;
                     "0-Sair", ;
                     {"1","2","3","4","5","0"}, 3)
        
        nOpc := Val(nOpc)
        
        If nOpc == 0
            Exit
        EndIf
        
        Do Case
            Case nOpc == 1
                U_MVCEX36()
            Case nOpc == 2
                U_MVCEX37()
            Case nOpc == 3
                U_MVCEX38()
            Case nOpc == 4
                U_MVCEX39()
            Case nOpc == 5
                U_MVCEX40()
        EndCase
    EndDo
    
    RestArea(aArea)
Return

/*
EXEMPLO 1: Ponto de Entrada MODELPOS
Validação final antes de gravar
*/

User Function MVCEX36()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SB1")
    oBrowse:SetDescription("Produto - PE ModelPos")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX36" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX36" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX36" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSB1 := FWFormStruct(1, "SB1")
    
    oModel := MPFormModel():New("MVCEX36M")
    oModel:AddFields("SB1MASTER", , oStruSB1)
    oModel:SetPrimaryKey({"B1_FILIAL", "B1_COD"})
    oModel:SetDescription("Cadastro de Produtos")
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
Ponto de Entrada: MATA010 - Cadastro de Produtos
PE MODELPOS - Executado na validação final do modelo
*/
User Function MT010TOK()
    Local oModel := FWModelActive()
    Local lRet := .T.
    Local cTipo := ""
    Local nPreco := 0
    Local cGrupo := ""
    
    If oModel != Nil
        cTipo := oModel:GetValue("SB1MASTER", "B1_TIPO")
        nPreco := oModel:GetValue("SB1MASTER", "B1_PRV1")
        cGrupo := oModel:GetValue("SB1MASTER", "B1_GRUPO")
        
        // Validação 1: Produto acabado deve ter preço
        If cTipo == "PA" .And. nPreco == 0
            Help(, , "ATENÇÃO", , "Produto Acabado deve ter preço de venda informado!", 1, 0)
            lRet := .F.
        EndIf
        
        // Validação 2: Grupo obrigatório
        If Empty(cGrupo)
            Help(, , "ATENÇÃO", , "Grupo de produto é obrigatório!", 1, 0)
            lRet := .F.
        EndIf
        
        If lRet
            MsgInfo("? Validações do PE MT010TOK concluídas com sucesso!", "PE MODELPOS")
        EndIf
    EndIf
Return lRet

/*
EXEMPLO 2: Pontos de Entrada no Commit
Executa antes e depois de gravar
*/

User Function MVCEX37()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA1")
    oBrowse:SetDescription("Cliente - PE Commit")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX37" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX37" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX37" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA1 := FWFormStruct(1, "SA1")
    
    oModel := MPFormModel():New("MVCEX37M")
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

/*
Ponto de Entrada: MATA030 - Cadastro de Clientes
PE MODELCOMMITNTTS - Executado ANTES da gravação (dentro da transação)
*/
User Function MT030BRW()
    Local aParam := PARAMIXB
    Local oModel := Nil
    Local cCodigo := ""
    Local cNome := ""
    Local nOper := 0
    
    If aParam != Nil .And. Len(aParam) > 0
        oModel := aParam[1]
        
        If oModel != Nil
            cCodigo := oModel:GetValue("SA1MASTER", "A1_COD")
            cNome := oModel:GetValue("SA1MASTER", "A1_NOME")
            nOper := oModel:GetOperation()
            
            Do Case
                Case nOper == MODEL_OPERATION_INSERT
                    MsgInfo("PE ANTES de GRAVAR inclusão" + CRLF + ;
                            "Cliente: " + cCodigo + " - " + cNome, "PE COMMITNTTS")
                    
                Case nOper == MODEL_OPERATION_UPDATE
                    MsgInfo("PE ANTES de GRAVAR alteração" + CRLF + ;
                            "Cliente: " + cCodigo + " - " + cNome, "PE COMMITNTTS")
                    
                Case nOper == MODEL_OPERATION_DELETE
                    MsgInfo("PE ANTES de GRAVAR exclusão" + CRLF + ;
                            "Cliente: " + cCodigo, "PE COMMITNTTS")
            EndCase
        EndIf
    EndIf
Return

/*
PE MODELCOMMITTTS - Executado DEPOIS da gravação (fora da transação)
*/
User Function MT030GRV()
    Local aParam := PARAMIXB
    Local oModel := Nil
    Local cCodigo := ""
    Local nOper := 0
    
    If aParam != Nil .And. Len(aParam) > 0
        oModel := aParam[1]
        
        If oModel != Nil
            cCodigo := oModel:GetValue("SA1MASTER", "A1_COD")
            nOper := oModel:GetOperation()
            
            // Aqui pode executar integrações, envios, etc
            MsgInfo("PE DEPOIS de GRAVAR" + CRLF + ;
                    "Cliente: " + cCodigo + CRLF + CRLF + ;
                    "Pode enviar email, integrar sistemas, etc", "PE COMMITTTS")
        EndIf
    EndIf
Return

/*
EXEMPLO 3: Ponto de Entrada em CAMPOS (FormField)
Executado quando campo é alterado
*/

User Function MVCEX38()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SA2")
    oBrowse:SetDescription("Fornecedor - PE FormField")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX38" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX38" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSA2 := FWFormStruct(1, "SA2")
    
    oModel := MPFormModel():New("MVCEX38M")
    oModel:AddFields("SA2MASTER", , oStruSA2)
    oModel:SetPrimaryKey({"A2_FILIAL", "A2_COD", "A2_LOJA"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSA2 := FWFormStruct(2, "SA2")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SA2", oStruSA2, "SA2MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_SA2", "TELA")
Return oView

/*
Ponto de Entrada: MATA020 - Cadastro de Fornecedores
PE A020ESTADO - Quando altera o campo Estado
*/
User Function A020ESTADO()
    Local oModel := FWModelActive()
    Local cEstado := ""
    Local cPais := ""
    
    If oModel != Nil
        cEstado := oModel:GetValue("SA2MASTER", "A2_EST")
        
        // Preenche país automaticamente conforme estado
        If !Empty(cEstado)
            cPais := "105"  // Brasil
            oModel:SetValue("SA2MASTER", "A2_PAIS", cPais)
            MsgInfo("Estado: " + cEstado + CRLF + "País preenchido automaticamente: Brasil", "PE FormField")
        EndIf
    EndIf
Return

/*
PE A020CGC - Quando altera o campo CGC
*/
User Function A020CGC()
    Local oModel := FWModelActive()
    Local cCGC := ""
    Local cTipo := ""
    Local nLen := 0
    
    If oModel != Nil
        cCGC := AllTrim(StrTran(StrTran(StrTran(oModel:GetValue("SA2MASTER", "A2_CGC"), ".", ""), "/", ""), "-", ""))
        nLen := Len(cCGC)
        
        // Define tipo automaticamente
        If nLen == 11
            cTipo := "F"  // Física
            MsgInfo("CPF detectado" + CRLF + "Tipo: Pessoa Física", "PE FormField")
        ElseIf nLen == 14
            cTipo := "J"  // Jurídica
            MsgInfo("CNPJ detectado" + CRLF + "Tipo: Pessoa Jurídica", "PE FormField")
        EndIf
        
        If !Empty(cTipo)
            oModel:SetValue("SA2MASTER", "A2_TIPO", cTipo)
        EndIf
    EndIf
Return

/*
EXEMPLO 4: Ponto de Entrada em GRID (FormLine)
Executado quando muda linha do grid
*/

User Function MVCEX39()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SC5")
    oBrowse:SetDescription("Pedido Venda - PE FormLine")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX39" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX39" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX39" OPERATION 4 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSC5 := FWFormStruct(1, "SC5")
    Local oStruSC6 := FWFormStruct(1, "SC6")
    
    oModel := MPFormModel():New("MVCEX39M")
    oModel:AddFields("SC5MASTER", , oStruSC5)
    oModel:AddGrid("SC6DETAIL", "SC5MASTER", oStruSC6)
    
    oModel:SetRelation("SC6DETAIL", {{"C6_FILIAL", "xFilial('SC6')"}, {"C6_NUM", "C5_NUM"}}, SC6->(IndexKey(1)))
    oModel:GetModel("SC6DETAIL"):SetUniqueLine({"C6_ITEM"})
    
    oModel:SetPrimaryKey({"C5_FILIAL", "C5_NUM"})
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := ModelDef()
    Local oStruSC5 := FWFormStruct(2, "SC5")
    Local oStruSC6 := FWFormStruct(2, "SC6")
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    
    oView:AddField("VIEW_SC5", oStruSC5, "SC5MASTER")
    oView:AddGrid("VIEW_SC6", oStruSC6, "SC6DETAIL")
    
    oView:CreateHorizontalBox("CAB", 30)
    oView:CreateHorizontalBox("GRID", 70)
    
    oView:SetOwnerView("VIEW_SC5", "CAB")
    oView:SetOwnerView("VIEW_SC6", "GRID")
    
    oView:EnableTitleView("VIEW_SC5", "Cabeçalho do Pedido")
    oView:EnableTitleView("VIEW_SC6", "Itens do Pedido")
Return oView

/*
Ponto de Entrada: MATA410 - Pedido de Vendas
PE M410LIOK - Validação da linha do grid (ao sair da linha)
*/
User Function M410LIOK()
    Local oModel := FWModelActive()
    Local oGrid := Nil
    Local lRet := .T.
    Local cProduto := ""
    Local nQuant := 0
    Local nPreco := 0
    
    If oModel != Nil
        oGrid := oModel:GetModel("SC6DETAIL")
        
        If oGrid != Nil .And. !oGrid:IsDeleted()
            cProduto := oGrid:GetValue("C6_PRODUTO")
            nQuant := oGrid:GetValue("C6_QTDVEN")
            nPreco := oGrid:GetValue("C6_PRCVEN")
            
            // Validação: quantidade deve ser maior que zero
            If nQuant <= 0
                Help(, , "ATENÇÃO", , "Quantidade deve ser maior que zero!", 1, 0)
                lRet := .F.
            EndIf
            
            // Validação: preço deve ser maior que zero
            If nPreco <= 0
                Help(, , "ATENÇÃO", , "Preço deve ser maior que zero!", 1, 0)
                lRet := .F.
            EndIf
            
            // Validação: produto existe?
            DbSelectArea("SB1")
            SB1->(DbSetOrder(1))
            If !SB1->(DbSeek(xFilial("SB1") + cProduto))
                Help(, , "ATENÇÃO", , "Produto não encontrado!", 1, 0)
                lRet := .F.
            EndIf
            
            If lRet
                MsgInfo("Item validado com sucesso!" + CRLF + ;
                        "Produto: " + cProduto + CRLF + ;
                        "Quantidade: " + cValToChar(nQuant), "PE FormLine")
            EndIf
        EndIf
    EndIf
Return lRet

/*
PE M410LPOS - Validação do grid completo (ao gravar)
*/
User Function M410LPOS()
    Local oModel := FWModelActive()
    Local oGrid := Nil
    Local lRet := .T.
    Local nTotal := 0
    Local nLinha := 0
    
    If oModel != Nil
        oGrid := oModel:GetModel("SC6DETAIL")
        
        If oGrid != Nil
            // Soma total do pedido
            For nLinha := 1 To oGrid:Length()
                oGrid:GoLine(nLinha)
                If !oGrid:IsDeleted()
                    nTotal += oGrid:GetValue("C6_VALOR")
                EndIf
            Next
            
            // Validação: pedido deve ter valor
            If nTotal == 0
                Help(, , "ATENÇÃO", , "Pedido deve ter valor maior que zero!", 1, 0)
                lRet := .F.
            Else
                MsgInfo("Total do pedido: R$ " + Transform(nTotal, "@E 999,999.99"), "PE FormLine POS")
            EndIf
        EndIf
    EndIf
Return lRet

/*
EXEMPLO 5: Múltiplos Pontos de Entrada
Demonstra vários PEs trabalhando juntos
*/

User Function MVCEX40()
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SB1")
    oBrowse:SetDescription("Produto - Múltiplos PEs")
    oBrowse:AddLegend("B1_MSBLQL == '1'", "RED", "Bloqueado")
    oBrowse:AddLegend("B1_MSBLQL != '1'", "GREEN", "Ativo")
    oBrowse:Activate()
Return

Static Function MenuDef()
    Local aRotina := {}
    
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MVCEX40" OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCEX40" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCEX40" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MVCEX40" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()
    Local oModel
    Local oStruSB1 := FWFormStruct(1, "SB1")
    
    oModel := MPFormModel():New("MVCEX40M")
    oModel:AddFields("SB1MASTER", , oStruSB1)
    oModel:SetPrimaryKey({"B1_FILIAL", "B1_COD"})
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
PE MT010INC - Ao clicar em INCLUIR
*/
User Function MT010INC()
    MsgInfo("PE executado ao clicar em INCLUIR" + CRLF + ;
            "Pode fazer inicializações customizadas", "PE MT010INC")
Return

/*
PE MT010ALT - Ao clicar em ALTERAR
*/
User Function MT010ALT()
    MsgInfo("PE executado ao clicar em ALTERAR" + CRLF + ;
            "Produto: " + SB1->B1_COD + " - " + AllTrim(SB1->B1_DESC), "PE MT010ALT")
Return

/*
PE MT010VLD - Validação ao confirmar
*/
User Function MT010VLD()
    Local oModel := FWModelActive()
    Local lRet := .T.
    Local cCodigo := ""
    Local cDesc := ""
    Local cTipo := ""
    
    If oModel != Nil
        cCodigo := oModel:GetValue("SB1MASTER", "B1_COD")
        cDesc := oModel:GetValue("SB1MASTER", "B1_DESC")
        cTipo := oModel:GetValue("SB1MASTER", "B1_TIPO")
        
        // Validação customizada: descrição não pode ter números
        If !Empty(cDesc)
            If Any(cDesc, {"0","1","2","3","4","5","6","7","8","9"})
                MsgAlert("Descrição não deveria conter números!" + CRLF + ;
                         "(Apenas um aviso - permitindo continuar)", "PE MT010VLD")
                // lRet := .F.  // Descomente para bloquear
            EndIf
        EndIf
        
        MsgInfo("PE de validação executado" + CRLF + ;
                "Produto: " + cCodigo + CRLF + ;
                "Tipo: " + cTipo, "PE MT010VLD")
    EndIf
Return lRet

/*
PE MT010GRV - Após gravar
*/
User Function MT010GRV()
    Local oModel := FWModelActive()
    Local cCodigo := ""
    Local nOper := 0
    
    If oModel != Nil
        cCodigo := oModel:GetValue("SB1MASTER", "B1_COD")
        nOper := oModel:GetOperation()
        
        // Log de auditoria
        ConOut("LOG AUDITORIA: Produto " + cCodigo + " - Operação: " + cValToChar(nOper))
        
        MsgInfo("PE executado APÓS gravar" + CRLF + ;
                "Produto: " + cCodigo + CRLF + CRLF + ;
                "Ideal para:" + CRLF + ;
                "- Logs de auditoria" + CRLF + ;
                "- Integrações" + CRLF + ;
                "- Envio de emails" + CRLF + ;
                "- Replicação de dados", "PE MT010GRV")
    EndIf
Return

/*
PE MT010DEL - Ao excluir
*/
User Function MT010DEL()
    Local lRet := .T.
    Local cProduto := SB1->B1_COD
    
    // Verifica se produto tem movimentação
    DbSelectArea("SD2")
    SD2->(DbSetOrder(1))
    If SD2->(DbSeek(xFilial("SD2") + cProduto))
        MsgAlert("Produto possui movimentação de saída!" + CRLF + ;
                 "Exclusão não recomendada", "PE MT010DEL")
        // lRet := .F.  // Descomente para bloquear exclusão
    Else
        MsgInfo("PE executado ao EXCLUIR" + CRLF + ;
                "Produto: " + cProduto + CRLF + ;
                "Sem movimentação - pode excluir", "PE MT010DEL")
    EndIf
Return lRet

// Função auxiliar: verifica se string contém caracteres de um array
Static Function Any(cTexto, aChars)
    Local nI
    Local lRet := .F.
    
    For nI := 1 To Len(aChars)
        If aChars[nI] $ cTexto
            lRet := .T.
            Exit
        EndIf
    Next
Return lRet
