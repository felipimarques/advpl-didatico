// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI07
Exemplos práticos de diálogos personalizados

Funções abordadas:
- TDialog - janela de diálogo
- TButton - botões
- TGet - campos de entrada
- TComboBox - combo
- TCheckBox - checkbox
- Componentes básicos de interface

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_UI07()
/*/

User Function UI07()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Diálogos Personalizados", ;
                     "1-Conceito TDialog" + CRLF + ;
                     "2-Diálogo simples" + CRLF + ;
                     "3-Cadastro rápido" + CRLF + ;
                     "4-Filtro avançado" + CRLF + ;
                     "5-Formulário completo" + CRLF + ;
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
EXEMPLO 1: Conceito de TDialog
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? TDIALOG" + CRLF + CRLF
    
    cMsg += "Permite criar janelas personalizadas" + CRLF
    cMsg += "com diversos componentes" + CRLF + CRLF
    
    cMsg += "ESTRUTURA BÁSICA:" + CRLF + CRLF
    
    cMsg += "// Variáveis" + CRLF
    cMsg += "Local oDlg" + CRLF
    cMsg += "Local cNome := Space(40)" + CRLF
    cMsg += "Local lOk := .F." + CRLF + CRLF
    
    cMsg += "// Cria dialog" + CRLF
    cMsg += "DEFINE DIALOG oDlg TITLE 'Título' ;" + CRLF
    cMsg += "  FROM 0,0 TO 200,400 PIXEL" + CRLF + CRLF
    
    cMsg += "  // Campo de entrada" + CRLF
    cMsg += "  @ 10,10 SAY 'Nome:' PIXEL OF oDlg" + CRLF
    cMsg += "  @ 20,10 GET cNome SIZE 180,10 PIXEL OF oDlg" + CRLF + CRLF
    
    cMsg += "  // Botões" + CRLF
    cMsg += "  @ 80,120 BUTTON 'Confirmar' ;" + CRLF
    cMsg += "    SIZE 40,12 PIXEL OF oDlg ;" + CRLF
    cMsg += "    ACTION (lOk := .T., oDlg:End())" + CRLF + CRLF
    
    cMsg += "ACTIVATE DIALOG oDlg CENTERED" + CRLF + CRLF
    
    cMsg += "COMPONENTES:" + CRLF
    cMsg += "• SAY - Rótulo de texto" + CRLF
    cMsg += "• GET - Campo de entrada" + CRLF
    cMsg += "• BUTTON - Botão" + CRLF
    cMsg += "• COMBOBOX - Lista suspensa" + CRLF
    cMsg += "• CHECKBOX - Caixa de seleção" + CRLF + CRLF
    
    cMsg += "USO:" + CRLF
    cMsg += "• Cadastros rápidos" + CRLF
    cMsg += "• Formulários customizados" + CRLF
    cMsg += "• Filtros avançados" + CRLF
    cMsg += "• Configurações"
    
    MsgInfo(cMsg, "Conceito")
Return

/*
EXEMPLO 2: Diálogo Simples
*/
Static Function fEx02()
    Local oDlg
    Local cTexto := Space(50)
    Local lOk := .F.
    
    DEFINE DIALOG oDlg TITLE "Digite algo" FROM 0,0 TO 120,400 PIXEL
        
        @ 10,10 SAY "Digite um texto:" SIZE 100,10 PIXEL OF oDlg
        @ 25,10 GET cTexto SIZE 180,10 PIXEL OF oDlg
        
        @ 50,120 BUTTON "OK" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := .T., oDlg:End())
        
        @ 50,165 BUTTON "Cancelar" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := .F., oDlg:End())
        
    ACTIVATE DIALOG oDlg CENTERED
    
    If lOk
        If !Empty(AllTrim(cTexto))
            MsgInfo("Você digitou:" + CRLF + CRLF + AllTrim(cTexto), "Resultado")
        Else
            MsgAlert("Nenhum texto foi digitado", "Atenção")
        EndIf
    EndIf
Return

/*
EXEMPLO 3: Cadastro Rápido de Cliente
*/
Static Function fEx03()
    Local oDlg
    Local cCodigo := Space(6)
    Local cLoja := Space(2)
    Local cNome := Space(40)
    Local cCNPJ := Space(14)
    Local cTelefone := Space(15)
    Local lOk := .F.
    
    DEFINE DIALOG oDlg TITLE "Cadastro Rápido de Cliente" FROM 0,0 TO 240,450 PIXEL
        
        // Código
        @ 10,10 SAY "Código:" SIZE 40,10 PIXEL OF oDlg
        @ 20,10 GET cCodigo SIZE 30,10 PIXEL OF oDlg
        
        @ 10,70 SAY "Loja:" SIZE 40,10 PIXEL OF oDlg
        @ 20,70 GET cLoja SIZE 20,10 PIXEL OF oDlg
        
        // Nome
        @ 40,10 SAY "Nome/Razão:" SIZE 60,10 PIXEL OF oDlg
        @ 50,10 GET cNome SIZE 200,10 PIXEL OF oDlg
        
        // CNPJ
        @ 70,10 SAY "CNPJ:" SIZE 40,10 PIXEL OF oDlg
        @ 80,10 GET cCNPJ SIZE 80,10 PIXEL OF oDlg
        
        // Telefone
        @ 70,100 SAY "Telefone:" SIZE 40,10 PIXEL OF oDlg
        @ 80,100 GET cTelefone SIZE 80,10 PIXEL OF oDlg
        
        // Botões
        @ 105,120 BUTTON "? Salvar" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := fValidaCad(cNome, cCNPJ), If(lOk, oDlg:End(), Nil))
        
        @ 105,165 BUTTON "? Cancelar" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := .F., oDlg:End())
        
    ACTIVATE DIALOG oDlg CENTERED
    
    If lOk
        MsgInfo("? CLIENTE CADASTRADO" + CRLF + CRLF + ;
                "Código: " + AllTrim(cCodigo) + "/" + AllTrim(cLoja) + CRLF + ;
                "Nome: " + AllTrim(cNome) + CRLF + ;
                "CNPJ: " + AllTrim(cCNPJ) + CRLF + ;
                "Telefone: " + AllTrim(cTelefone), "Sucesso")
    EndIf
Return

Static Function fValidaCad(cNome, cCNPJ)
    If Empty(AllTrim(cNome))
        MsgAlert("Nome é obrigatório", "Validação")
        Return .F.
    EndIf
    
    If Empty(AllTrim(cCNPJ))
        MsgAlert("CNPJ é obrigatório", "Validação")
        Return .F.
    EndIf
    
Return .T.

/*
EXEMPLO 4: Filtro Avançado de Produtos
*/
Static Function fEx04()
    Local oDlg
    Local cGrupo := Space(4)
    Local cTipo := "1"
    Local aTipo := {"1=Produto Acabado", "2=Matéria Prima", "3=Serviço"}
    Local nPrecoIni := 0
    Local nPrecoFim := 999999
    Local lAtivo := .T.
    Local lEstoque := .F.
    Local lOk := .F.
    
    DEFINE DIALOG oDlg TITLE "Filtro de Produtos" FROM 0,0 TO 280,450 PIXEL
        
        // Grupo
        @ 10,10 SAY "Grupo:" SIZE 40,10 PIXEL OF oDlg
        @ 20,10 GET cGrupo SIZE 40,10 PIXEL OF oDlg 
        
        // Tipo
        @ 40,10 SAY "Tipo:" SIZE 40,10 PIXEL OF oDlg
        @ 50,10 COMBOBOX cTipo ITEMS aTipo SIZE 100,40 PIXEL OF oDlg
        
        // Preço
        @ 80,10 SAY "Preço de:" SIZE 40,10 PIXEL OF oDlg
        @ 90,10 GET nPrecoIni SIZE 60,10 PIXEL OF oDlg PICTURE "@E 999,999.99"
        
        @ 80,100 SAY "até:" SIZE 40,10 PIXEL OF oDlg
        @ 90,100 GET nPrecoFim SIZE 60,10 PIXEL OF oDlg PICTURE "@E 999,999.99"
        
        // Opções
        @ 115,10 CHECKBOX lAtivo PROMPT "Somente ativos" SIZE 80,10 PIXEL OF oDlg
        @ 130,10 CHECKBOX lEstoque PROMPT "Com estoque" SIZE 80,10 PIXEL OF oDlg
        
        // Botões
        @ 125,140 BUTTON "?? Buscar" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := .T., oDlg:End())
        
        @ 125,185 BUTTON "? Fechar" SIZE 40,12 PIXEL OF oDlg ;
            ACTION (lOk := .F., oDlg:End())
        
    ACTIVATE DIALOG oDlg CENTERED
    
    If lOk
        MsgInfo("?? FILTROS APLICADOS" + CRLF + CRLF + ;
                "Grupo: " + If(Empty(cGrupo), "Todos", AllTrim(cGrupo)) + CRLF + ;
                "Tipo: " + SubStr(aTipo[Val(cTipo)], 3) + CRLF + ;
                "Preço: R$ " + Transform(nPrecoIni, "@E 999,999.99") + ;
                " até R$ " + Transform(nPrecoFim, "@E 999,999.99") + CRLF + ;
                "Somente ativos: " + If(lAtivo, "Sim", "Não") + CRLF + ;
                "Com estoque: " + If(lEstoque, "Sim", "Não") + CRLF + CRLF + ;
                "Buscando produtos...", "Filtro")
    EndIf
Return

/*
EXEMPLO 5: Formulário Completo de Pedido
*/
Static Function fEx05()
    Local oDlg
    Local cCliente := Space(6)
    Local cLoja := Space(2)
    Local cNome := "Cliente não selecionado"
    Local dEmissao := Date()
    Local cCondPag := "001"
    Local aCondPag := {"001=A Vista", "002=30 dias", "003=30/60"}
    Local cTipo := "1"
    Local aTipo := {"1=Normal", "2=Bonificação", "3=Retorno"}
    Local cObs := Space(100)
    Local lOk := .F.
    
    DEFINE DIALOG oDlg TITLE "Pedido de Vendas" FROM 0,0 TO 320,500 PIXEL
        
        // Cliente
        @ 10,10 SAY "Cliente:" SIZE 40,10 PIXEL OF oDlg
        @ 20,10 GET cCliente SIZE 30,10 PIXEL OF oDlg VALID fBuscaCli(@cNome, cCliente, cLoja)
        
        @ 20,50 GET cLoja SIZE 20,10 PIXEL OF oDlg
        
        @ 20,80 SAY cNome SIZE 160,10 PIXEL OF oDlg
        
        // Emissão
        @ 40,10 SAY "Emissão:" SIZE 40,10 PIXEL OF oDlg
        @ 50,10 GET dEmissao SIZE 60,10 PIXEL OF oDlg
        
        // Condição
        @ 40,100 SAY "Condição:" SIZE 40,10 PIXEL OF oDlg
        @ 50,100 COMBOBOX cCondPag ITEMS aCondPag SIZE 120,40 PIXEL OF oDlg
        
        // Tipo
        @ 70,10 SAY "Tipo:" SIZE 40,10 PIXEL OF oDlg
        @ 80,10 COMBOBOX cTipo ITEMS aTipo SIZE 100,40 PIXEL OF oDlg
        
        // Observação
        @ 110,10 SAY "Observação:" SIZE 60,10 PIXEL OF oDlg
        @ 120,10 GET cObs SIZE 230,30 PIXEL OF oDlg MEMO
        
        // Botões
        @ 145,140 BUTTON "?? Gravar" SIZE 45,12 PIXEL OF oDlg ;
            ACTION (lOk := fValidaPed(cCliente), If(lOk, oDlg:End(), Nil))
        
        @ 145,190 BUTTON "? Cancelar" SIZE 45,12 PIXEL OF oDlg ;
            ACTION (lOk := .F., oDlg:End())
        
    ACTIVATE DIALOG oDlg CENTERED
    
    If lOk
        MsgInfo("?? PEDIDO GRAVADO" + CRLF + CRLF + ;
                "Cliente: " + AllTrim(cCliente) + "/" + AllTrim(cLoja) + " - " + AllTrim(cNome) + CRLF + ;
                "Emissão: " + DtoC(dEmissao) + CRLF + ;
                "Condição: " + SubStr(aCondPag[Val(cCondPag)], 5) + CRLF + ;
                "Tipo: " + SubStr(aTipo[Val(cTipo)], 3) + CRLF + CRLF + ;
                "Obs: " + AllTrim(cObs) + CRLF + CRLF + ;
                "Pedido criado com sucesso!", "Sucesso")
    EndIf
Return

Static Function fBuscaCli(cNome, cCliente, cLoja)
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    If DbSeek(xFilial("SA1") + cCliente + cLoja)
        cNome := SA1->A1_NOME
    Else
        cNome := "Cliente não encontrado"
    EndIf
Return .T.

Static Function fValidaPed(cCliente)
    If Empty(AllTrim(cCliente))
        MsgAlert("Cliente é obrigatório", "Validação")
        Return .F.
    EndIf
Return .T.
