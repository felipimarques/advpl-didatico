// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR05
Exemplos práticos das funções Upper() e Lower() em situações reais do Protheus

As funções de conversão de maiúsculas/minúsculas são essenciais para:
- Padronizar dados antes de gravar no banco
- Comparações case-insensitive (ignora maiúsculas/minúsculas)
- Buscar dados independente de como foram digitados
- Formatar nomes próprios e títulos
- Validações de códigos e senhas

@type User Function
@author Felipi Marques
@since 20/11/2025

@obs Upper(c) = Converte para MAIÚSCULAS
@obs Lower(c) = Converte para minúsculas

@example
U_STR05()

@see
https://tdn.totvs.com/display/tec/Upper
https://tdn.totvs.com/display/tec/Lower
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR05()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Padronizar cadastros (Upper)
            Case nOpcao == 2
                fEx02()  // Busca case-insensitive
            Case nOpcao == 3
                fEx03()  // Formatar nome próprio
            Case nOpcao == 4
                fEx04()  // Validar login/senha
            Case nOpcao == 5
                fEx05()  // Filtrar por descrição
        EndCase
    EndDo
    
    RestArea(aArea)
Return

// ==========================================================================
// Menu de Seleção
// ==========================================================================
Static Function fMenuEx()
    Local nOpcao := 0
    Local aOpcoes := {}
    
    aAdd(aOpcoes, "1 - Padronizar cadastros")
    aAdd(aOpcoes, "2 - Busca case-insensitive")
    aAdd(aOpcoes, "3 - Formatar nome próprio")
    aAdd(aOpcoes, "4 - Validar login/senha")
    aAdd(aOpcoes, "5 - Filtrar por descrição")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("Upper/Lower - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Padronizar Cadastros - Upper() (SA1/SA2/SB1)
// ==========================================================================
/*
SITUAÇÃO REAL:
No Protheus, a maioria dos cadastros é gravada em MAIÚSCULAS para:
- Padronização visual
- Evitar duplicidades (JOSE vs Jose vs jose)
- Facilitar buscas
- Seguir padrão do sistema

Sempre use Upper() antes de gravar campos importantes!
*/
Static Function fEx01()
    Local aDados  := {}
    Local cMsg    := ""
    Local nI      := 0
    
    // Simula dados digitados pelo usuário (mix de maiúsculas/minúsculas)
    aAdd(aDados, {"A1_COD",  "000001",            "Código do Cliente"})
    aAdd(aDados, {"A1_NOME", "João da Silva",     "Nome do Cliente"})
    aAdd(aDados, {"A1_END",  "Rua das Flores",    "Endereço"})
    aAdd(aDados, {"A1_MUN",  "São Paulo",         "Município"})
    aAdd(aDados, {"A1_EST",  "sp",                "Estado"})
    aAdd(aDados, {"A1_EMAIL", "joao@email.com",   "E-mail"})
    
    cMsg := "?? PADRONIZAÇÃO DE CADASTROS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "? DADOS ORIGINAIS (como usuário digitou):" + CRLF + CRLF
    For nI := 1 To Len(aDados)
        cMsg += PadR(aDados[nI][3], 20) + ": " + aDados[nI][2] + CRLF
    Next nI
    
    cMsg += CRLF + Replicate("-", 60) + CRLF + CRLF
    
    cMsg += "? DADOS PADRONIZADOS (com Upper):" + CRLF + CRLF
    For nI := 1 To Len(aDados)
        // Email fica em minúsculo por convenção
        If aDados[nI][1] == "A1_EMAIL"
            cMsg += PadR(aDados[nI][3], 20) + ": " + Lower(aDados[nI][2]) + CRLF
        Else
            cMsg += PadR(aDados[nI][3], 20) + ": " + Upper(aDados[nI][2]) + CRLF
        EndIf
    Next nI
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? GRAVAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   RecLock('SA1', .T.)" + CRLF
    cMsg += "      SA1->A1_FILIAL := xFilial('SA1')" + CRLF
    cMsg += "      SA1->A1_COD    := M->A1_COD" + CRLF
    cMsg += "      SA1->A1_NOME   := Upper(M->A1_NOME)" + CRLF
    cMsg += "      SA1->A1_END    := Upper(M->A1_END)" + CRLF
    cMsg += "      SA1->A1_MUN    := Upper(M->A1_MUN)" + CRLF
    cMsg += "      SA1->A1_EST    := Upper(M->A1_EST)" + CRLF
    cMsg += "      SA1->A1_EMAIL  := Lower(M->A1_EMAIL)" + CRLF
    cMsg += "   SA1->(MsUnlock())" + CRLF + CRLF
    cMsg += "   ?? IMPORTANTE:" + CRLF
    cMsg += "   • Nomes, endereços, cidades: UPPER" + CRLF
    cMsg += "   • Emails: lower (convenção internet)" + CRLF
    cMsg += "   • Códigos: depende do padrão da empresa"
    
    MsgInfo(cMsg, "Upper() - Padronização")
Return

// ==========================================================================
// Exemplo 2: Busca Case-Insensitive (Filtros e Pesquisas)
// ==========================================================================
/*
SITUAÇÃO REAL:
Usuário quer buscar produto "notebook" mas no banco está "NOTEBOOK".
Sem Upper(), a busca não funciona!

Sempre converta AMBOS os lados da comparação para maiúscula/minúscula.
*/
Static Function fEx02()
    Local aProduto := {}
    Local cBusca   := ""
    Local aResult  := {}
    Local cMsg     := ""
    Local nI       := 0
    
    // Simula produtos do banco SB1 (todos em MAIÚSCULAS)
    aAdd(aProduto, {"PA0001", "NOTEBOOK DELL INSPIRON 15"})
    aAdd(aProduto, {"PA0002", "MOUSE LOGITECH MX MASTER"})
    aAdd(aProduto, {"PA0003", "TECLADO MECÂNICO RGB"})
    aAdd(aProduto, {"PA0004", "MONITOR LG 24 POLEGADAS"})
    aAdd(aProduto, {"PA0005", "NOTEBOOK LENOVO THINKPAD"})
    
    // Usuário digitou em minúscula
    cBusca := "notebook"
    
    cMsg := "?? BUSCA CASE-INSENSITIVE" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "Termo buscado: '" + cBusca + "' (minúsculo)" + CRLF
    cMsg += "Banco de dados: MAIÚSCULAS" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Busca CORRETA (converte ambos para maiúscula)
    cMsg += "? BUSCA COM UPPER (funciona):" + CRLF + CRLF
    
    For nI := 1 To Len(aProduto)
        // Converte AMBOS para maiúscula antes de comparar
        If Upper(cBusca) $ Upper(aProduto[nI][2])
            aAdd(aResult, aProduto[nI])
            cMsg += "? " + aProduto[nI][1] + " - " + aProduto[nI][2] + CRLF
        EndIf
    Next nI
    
    cMsg += CRLF + "Total encontrado: " + cValToChar(Len(aResult)) + " produtos" + CRLF
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? FILTRO NO PROTHEUS:" + CRLF
    cMsg += "   cBusca := 'notebook'  // Usuário digitou" + CRLF + CRLF
    cMsg += "   DbSelectArea('SB1')" + CRLF
    cMsg += "   DbSetOrder(1)" + CRLF
    cMsg += "   DbGoTop()" + CRLF + CRLF
    cMsg += "   While !SB1->(Eof())" + CRLF
    cMsg += "      // Converte AMBOS para Upper" + CRLF
    cMsg += "      If Upper(cBusca) $ Upper(SB1->B1_DESC)" + CRLF
    cMsg += "         // Achou! Adiciona no array..." + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "      SB1->(DbSkip())" + CRLF
    cMsg += "   EndDo"
    
    MsgInfo(cMsg, "Upper() - Busca Case-Insensitive")
Return

// ==========================================================================
// Exemplo 3: Formatar Nome Próprio (Relatórios e Etiquetas)
// ==========================================================================
/*
SITUAÇÃO REAL:
Banco de dados: "MARIA SILVA SANTOS"
Para relatórios e etiquetas fica melhor: "Maria Silva Santos"

Você precisa converter: Primeira letra maiúscula, resto minúscula.
*/
Static Function fEx03()
    Local aNomes  := {}
    Local cMsg    := ""
    Local nI      := 0
    
    // Simula nomes do banco (em MAIÚSCULAS)
    aAdd(aNomes, "JOÃO DA SILVA")
    aAdd(aNomes, "MARIA DOS SANTOS")
    aAdd(aNomes, "PEDRO DE OLIVEIRA")
    aAdd(aNomes, "ANA PAULA COSTA")
    
    cMsg := "? FORMATAÇÃO DE NOMES PRÓPRIOS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "??? BANCO DE DADOS (MAIÚSCULAS):" + CRLF + CRLF
    For nI := 1 To Len(aNomes)
        cMsg += "  " + aNomes[nI] + CRLF
    Next nI
    
    cMsg += CRLF + Replicate("-", 60) + CRLF + CRLF
    
    cMsg += "?? FORMATADO PARA RELATÓRIO:" + CRLF + CRLF
    For nI := 1 To Len(aNomes)
        cMsg += "  " + fCapitalize(aNomes[nI]) + CRLF
    Next nI
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? USO EM RELATÓRIOS:" + CRLF
    cMsg += "   // TReport - Mount" + CRLF
    cMsg += "   cNome := SA1->A1_NOME  // MAIÚSCULA" + CRLF
    cMsg += "   cNomeFmt := fCapitalize(cNome)" + CRLF
    cMsg += "   oSection:Cell('NOME'):SetValue(cNomeFmt)" + CRLF + CRLF
    cMsg += "   ?? BONS USOS:" + CRLF
    cMsg += "   • Etiquetas de correspondência" + CRLF
    cMsg += "   • Relatórios gerenciais" + CRLF
    cMsg += "   • Certificados" + CRLF
    cMsg += "   • Notas fiscais (descrição de itens)"
    
    MsgInfo(cMsg, "Upper/Lower - Formatação")
Return

// Função auxiliar para capitalizar (Primeira Maiúscula)
Static Function fCapitalize(cTexto)
    Local aWords  := {}
    Local cResult := ""
    Local nI      := 0
    Local cWord   := ""
    
    // Converte tudo para minúscula primeiro
    cTexto := Lower(cTexto)
    
    // Separa palavras por espaço
    aWords := StrTokArr(cTexto, " ")
    
    For nI := 1 To Len(aWords)
        cWord := aWords[nI]
        
        // Pula preposições pequenas (de, da, do, dos, das)
        If Len(cWord) <= 2 .And. nI > 1
            cResult += cWord + " "
        Else
            // Primeira letra maiúscula + resto minúscula
            cResult += Upper(SubStr(cWord, 1, 1)) + SubStr(cWord, 2) + " "
        EndIf
    Next nI
Return AllTrim(cResult)

// ==========================================================================
// Exemplo 4: Validar Login e Senha (Segurança)
// ==========================================================================
/*
SITUAÇÃO REAL:
Sistemas precisam validar login/senha independente de maiúsculas:
  Login digitado: "Admin"
  Login no banco: "ADMIN"
  Deve funcionar!

ATENÇÃO: Senhas devem ser case-sensitive por segurança!
*/
Static Function fEx04()
    Local aUsers  := {}
    Local cLogin  := ""
    Local cSenha  := ""
    Local lAchou  := .F.
    Local cMsg    := ""
    Local nI      := 0
    
    // Simula tabela de usuários (SU7 ou customizada)
    aAdd(aUsers, {"ADMIN",     "Senha123"})  // Login em MAIÚSCULA
    aAdd(aUsers, {"VENDEDOR1", "Vend@123"})
    aAdd(aUsers, {"GERENTE",   "Ger$2026"})
    
    // Usuário digitou com minúsculas
    cLogin := "admin"      // Minúscula
    cSenha := "Senha123"   // Correta
    
    cMsg := "?? VALIDAÇÃO DE LOGIN/SENHA" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "Tentativa de login:" + CRLF
    cMsg += "  Login: " + cLogin + " (minúscula)" + CRLF
    cMsg += "  Senha: " + cSenha + CRLF + CRLF
    
    cMsg += "Banco de dados:" + CRLF
    cMsg += "  Login: ADMIN (MAIÚSCULA)" + CRLF
    cMsg += "  Senha: Senha123" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Validação CORRETA
    For nI := 1 To Len(aUsers)
        // Login: case-INsensitive (converte ambos)
        // Senha: case-sensitive (compara direto)
        If Upper(cLogin) == Upper(aUsers[nI][1]) .And. cSenha == aUsers[nI][2]
            lAchou := .T.
            Exit
        EndIf
    Next nI
    
    If lAchou
        cMsg += "? LOGIN AUTORIZADO!" + CRLF + CRLF
        cMsg += "• Login encontrado (case-insensitive)" + CRLF
        cMsg += "• Senha correta (case-sensitive)" + CRLF
    Else
        cMsg += "? LOGIN NEGADO!" + CRLF + CRLF
        cMsg += "• Login ou senha incorretos" + CRLF
    EndIf
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   cLogin := M->LOGIN" + CRLF
    cMsg += "   cSenha := M->SENHA" + CRLF + CRLF
    cMsg += "   DbSelectArea('SU7')  // Usuários" + CRLF
    cMsg += "   DbSetOrder(1)  // Login" + CRLF + CRLF
    cMsg += "   // Busca com Upper (case-insensitive)" + CRLF
    cMsg += "   If DbSeek(xFilial('SU7')+Upper(cLogin))" + CRLF
    cMsg += "      // Valida senha (case-sensitive)" + CRLF
    cMsg += "      If AllTrim(SU7->U7_SENHA) == cSenha" + CRLF
    cMsg += "         // Autorizado!" + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "   EndIf" + CRLF + CRLF
    cMsg += "   ?? SEGURANÇA:" + CRLF
    cMsg += "   • LOGIN: Upper() - facilita usuário" + CRLF
    cMsg += "   • SENHA: case-sensitive - mais seguro"
    
    MsgInfo(cMsg, "Upper() - Validação Login")
Return

// ==========================================================================
// Exemplo 5: Filtrar por Descrição (F3 Consulta Padrão)
// ==========================================================================
/*
SITUAÇÃO REAL:
Usuário quer filtrar produtos digitando "mou" e achar:
- MOUSE LOGITECH
- MOUSE MICROSOFT
- MOUSEPAD GAMER

A função Upper() permite busca parcial ignorando maiúsculas/minúsculas.
*/
Static Function fEx05()
    Local aProduto := {}
    Local cFiltro  := ""
    Local aResult  := {}
    Local cMsg     := ""
    Local nI       := 0
    
    // Simula produtos do SB1
    aAdd(aProduto, {"PA0001", "NOTEBOOK DELL 15 POLEGADAS",      5500.00})
    aAdd(aProduto, {"PA0002", "MOUSE LOGITECH MX MASTER 3",      450.00})
    aAdd(aProduto, {"PA0003", "TECLADO MECÂNICO RGB GAMER",      850.00})
    aAdd(aProduto, {"PA0004", "MONITOR LG 27 ULTRAWIDE",        2100.00})
    aAdd(aProduto, {"PA0005", "MOUSE MICROSOFT ERGONÔMICO",      280.00})
    aAdd(aProduto, {"PA0006", "MOUSEPAD GAMER XXL 90CM",         120.00})
    aAdd(aProduto, {"PA0007", "WEBCAM LOGITECH FULL HD",         380.00})
    
    cFiltro := "mou"  // Usuário digitou em minúscula
    
    cMsg := "?? FILTRO EM CONSULTA PADRÃO (F3)" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "Filtro digitado: '" + cFiltro + "' (minúsculo)" + CRLF
    cMsg += "Total de produtos: " + cValToChar(Len(aProduto)) + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    cMsg += "? PRODUTOS ENCONTRADOS:" + CRLF + CRLF
    
    // Filtra com Upper (busca case-insensitive)
    For nI := 1 To Len(aProduto)
        If Upper(cFiltro) $ Upper(aProduto[nI][2])
            aAdd(aResult, aProduto[nI])
            
            cMsg += aProduto[nI][1] + " - " + aProduto[nI][2] + CRLF
            cMsg += "   R$ " + Transform(aProduto[nI][3], "@E 9,999.99") + CRLF + CRLF
        EndIf
    Next nI
    
    cMsg += Replicate("-", 60) + CRLF
    cMsg += "Total filtrado: " + cValToChar(Len(aResult)) + " produtos" + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? CONSULTA PADRÃO CUSTOMIZADA:" + CRLF
    cMsg += "   // SXB - Consulta Padrão" + CRLF
    cMsg += "   // Filtro dinâmico" + CRLF + CRLF
    cMsg += "   Static Function SBIFIL()" + CRLF
    cMsg += "      Local cFiltro := ReadVar()" + CRLF
    cMsg += "      Local cWhere  := ''" + CRLF + CRLF
    cMsg += "      If !Empty(cFiltro)" + CRLF
    cMsg += "         cWhere += Upper(cFiltro) " + CRLF
    cMsg += "      EndIf" + CRLF + CRLF
    cMsg += "   Return cWhere" + CRLF + CRLF
    cMsg += "   ?? Usuário digita 'mou' e acha todos!" + CRLF
    cMsg += "   ?? Upper() em AMBOS os lados"
    
    MsgInfo(cMsg, "Upper() - Filtro F3")
Return
