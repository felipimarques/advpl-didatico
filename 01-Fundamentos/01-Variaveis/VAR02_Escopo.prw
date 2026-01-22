// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} VAR02
Exemplos práticos de escopo de variáveis em ADVPL

Tipos de escopo:
- Local = só na função atual
- Private = função atual + subfunções
- Public = toda aplicação (evitar!)
- Static = persiste entre chamadas

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_VAR02()
/*/

User Function VAR02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Escopo de Variáveis", ;
                     "1-Local (recomendado)" + CRLF + ;
                     "2-Private (herança)" + CRLF + ;
                     "3-Public (evitar!)" + CRLF + ;
                     "4-Static (contador)" + CRLF + ;
                     "5-Comparação prática" + CRLF + ;
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
EXEMPLO 1: Local (RECOMENDADO)
Existe só dentro da função
*/
Static Function fEx01()
    Local cProduto := "PA001"
    Local nQtde := 10
    Local cMsg := ""
    
    cMsg := "?? ESCOPO LOCAL" + CRLF + CRLF
    cMsg += "Variáveis declaradas aqui:" + CRLF
    cMsg += "Local cProduto := 'PA001'" + CRLF
    cMsg += "Local nQtde := 10" + CRLF + CRLF
    
    cMsg += "? VANTAGENS:" + CRLF
    cMsg += "• Não conflita com outras funções" + CRLF
    cMsg += "• Memória liberada ao sair" + CRLF
    cMsg += "• Código mais seguro" + CRLF
    cMsg += "• Recomendado 99% dos casos" + CRLF + CRLF
    
    cMsg += "?? Produto: " + cProduto + CRLF
    cMsg += "?? Quantidade: " + cValToChar(nQtde) + CRLF + CRLF
    
    cMsg += "?? SEMPRE use Local quando possível!"
    
    MsgInfo(cMsg, "Local")
Return

/*
EXEMPLO 2: Private (Herança para subfunções)
*/
Static Function fEx02()
    
    Local cMsg := ""

    Private cCliente := "000001"
    Private nPedido := 123456
    
    
    cMsg := "?? ESCOPO PRIVATE" + CRLF + CRLF
    cMsg += "Na função principal:" + CRLF
    cMsg += "Private cCliente := '000001'" + CRLF
    cMsg += "Private nPedido := 123456" + CRLF + CRLF
    
    // Chama subfunção
    fSubFunc()
    
    cMsg += "? USO:" + CRLF
    cMsg += "• Passar variável para subfunções" + CRLF
    cMsg += "• Sem precisar passar parâmetro" + CRLF
    cMsg += "• Útil em validações (MVC)" + CRLF + CRLF
    
    cMsg += "?? CUIDADO:" + CRLF
    cMsg += "• Pode conflitar se mesmo nome" + CRLF
    cMsg += "• Use só quando necessário" + CRLF + CRLF
    
    cMsg += "Cliente: " + cCliente + CRLF
    cMsg += "Pedido: " + cValToChar(nPedido)
    
    MsgInfo(cMsg, "Private")
Return

Static Function fSubFunc()
    // Consegue acessar cCliente e nPedido
    // mesmo sem receber por parâmetro
    cCliente := AllTrim(cCliente)  // Modifica a Private
Return

/*
EXEMPLO 3: Public (EVITAR!)
*/
Static Function fEx03()
    Local cMsg := ""
    
    // Cria variável global (se não existir)
    If Type("cEmpresa") == "U"
        Public cEmpresa := "EMPRESA TESTE"
    EndIf
    
    cMsg := "?? ESCOPO PUBLIC" + CRLF + CRLF
    cMsg += "Public cEmpresa := 'EMPRESA TESTE'" + CRLF + CRLF
    
    cMsg += "? PROBLEMAS:" + CRLF
    cMsg += "• Fica na memória o tempo todo" + CRLF
    cMsg += "• Qualquer função pode alterar" + CRLF
    cMsg += "• Conflitos entre rotinas" + CRLF
    cMsg += "• Dificulta manutenção" + CRLF
    cMsg += "• Causa bugs estranhos" + CRLF + CRLF
    
    cMsg += "? QUANDO USAR:" + CRLF
    cMsg += "• Quase nunca!" + CRLF
    cMsg += "• Prefira parâmetros" + CRLF
    cMsg += "• Ou Static de módulo" + CRLF + CRLF
    
    cMsg += "Empresa: " + cEmpresa
    
    MsgInfo(cMsg, "Public - EVITAR!")
Return

/*
EXEMPLO 4: Static (Contador persistente)
*/
Static Function fEx04()
    Static nContador := 0
    Local cMsg := ""
    
    // Incrementa a cada chamada
    nContador++
    
    cMsg := "?? ESCOPO STATIC" + CRLF + CRLF
    cMsg += "Static nContador := 0" + CRLF + CRLF
    
    cMsg += "? CARACTERÍSTICA:" + CRLF
    cMsg += "• Valor persiste entre chamadas" + CRLF
    cMsg += "• Não reseta ao sair da função" + CRLF
    cMsg += "• Útil para contadores" + CRLF
    cMsg += "• Inicializa só na 1ª vez" + CRLF + CRLF
    
    cMsg += "?? Contador: " + cValToChar(nContador) + CRLF + CRLF
    
    cMsg += "?? Execute várias vezes e veja" + CRLF
    cMsg += "o contador aumentando!"
    
    MsgInfo(cMsg, "Static")
Return

/*
EXEMPLO 5: Comparação Prática
*/
Static Function fEx05()

    Local cMsg       := ""
    Private cPrivate := "Private"
    Static nChamadas := 0
    
    
    nChamadas++
    
    cMsg := "?? COMPARAÇÃO DE ESCOPOS" + CRLF + CRLF
    
    cMsg += "=== LOCAL ===" + CRLF
    cMsg += "• Só nesta função" + CRLF
    cMsg += "• Memória liberada ao sair" + CRLF
    cMsg += "• ? USE SEMPRE" + CRLF + CRLF
    
    cMsg += "=== PRIVATE ===" + CRLF
    cMsg += "• Nesta + subfunções" + CRLF
    cMsg += "• Útil para validações" + CRLF
    cMsg += "• ?? Use com cuidado" + CRLF + CRLF
    
    cMsg += "=== PUBLIC ===" + CRLF
    cMsg += "• Toda aplicação" + CRLF
    cMsg += "• Fica na memória sempre" + CRLF
    cMsg += "• ? EVITE!" + CRLF + CRLF
    
    cMsg += "=== STATIC ===" + CRLF
    cMsg += "• Persiste entre chamadas" + CRLF
    cMsg += "• Contadores, cache" + CRLF
    cMsg += "• ? Útil em casos específicos" + CRLF + CRLF
    
    cMsg += "Chamadas desta função: " + cValToChar(nChamadas) + CRLF + CRLF
    
    cMsg += "?? REGRA DE OURO:" + CRLF
    cMsg += "Local > Private > Static > Public"
    
    MsgInfo(cMsg, "Comparação")
Return
