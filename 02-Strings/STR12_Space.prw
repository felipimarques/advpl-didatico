// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR12
Exemplos práticos da função Space() em situações reais

A função Space() gera espaços em branco:
- Inicializar variáveis caractere
- Criar espaçamentos em relatórios
- Limpar campos
- Alinhar colunas
- Gerar buffers

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs Space(nQuantidade)

@example
U_STR12()

@see
https://tdn.totvs.com/display/tec/Space
/*/

User Function STR12()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Space() - Exemplos", ;
                     "1-Inicializar variáveis" + CRLF + ;
                     "2-Alinhar colunas" + CRLF + ;
                     "3-Espaçamento visual" + CRLF + ;
                     "4-Limpar buffer" + CRLF + ;
                     "5-Indentação texto" + CRLF + ;
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
EXEMPLO 1: Inicializar Variáveis
*/
Static Function fEx01()
    Local cCodigo := Space(6)
    Local cNome := Space(40)
    Local cCGC := Space(14)
    Local cMsg := ""
    
    cMsg := "?? INICIALIZAÇÃO DE VARIÁVEIS" + CRLF + CRLF
    cMsg += "Código [" + cCodigo + "] = " + cValToChar(Len(cCodigo)) + " chars" + CRLF
    cMsg += "Nome [" + cNome + "] = " + cValToChar(Len(cNome)) + " chars" + CRLF
    cMsg += "CGC [" + cCGC + "] = " + cValToChar(Len(cCGC)) + " chars" + CRLF + CRLF
    cMsg += "? Variáveis prontas para receber dados"
    
    MsgInfo(cMsg, "Space()")
Return

/*
EXEMPLO 2: Alinhar Colunas em Relatório
*/
Static Function fEx02()
    Local cRel := ""
    Local cCol1 := "Código"
    Local cCol2 := "Descrição"
    Local cCol3 := "Valor"
    
    // Alinha cada coluna
    cRel := "RELATÓRIO DE PRODUTOS" + CRLF + CRLF
    
    // Cabeçalho
    cRel += cCol1 + Space(10 - Len(cCol1))
    cRel += cCol2 + Space(30 - Len(cCol2))
    cRel += cCol3 + CRLF
    cRel += Replicate("-", 50) + CRLF
    
    // Dados
    cRel += "PA001" + Space(5)
    cRel += "PRODUTO A" + Space(21)
    cRel += "1.250,00" + CRLF
    
    cRel += "PA002" + Space(5)
    cRel += "PRODUTO B LONGO" + Space(15)
    cRel += "2.500,00" + CRLF
    
    MsgInfo(cRel, "Alinhamento")
Return

/*
EXEMPLO 3: Espaçamento Visual
*/
Static Function fEx03()
    Local cMsg := ""
    
    cMsg := "SISTEMA PROTHEUS" + CRLF + CRLF
    cMsg += Space(5) + "• Módulo Estoque" + CRLF
    cMsg += Space(10) + "- Entrada" + CRLF
    cMsg += Space(10) + "- Saída" + CRLF
    cMsg += Space(10) + "- Inventário" + CRLF + CRLF
    cMsg += Space(5) + "• Módulo Vendas" + CRLF
    cMsg += Space(10) + "- Pedidos" + CRLF
    cMsg += Space(10) + "- Faturamento" + CRLF
    
    MsgInfo(cMsg, "Indentação")
Return

/*
EXEMPLO 4: Limpar Buffer de String
*/
Static Function fEx04()
    Local cBuffer := "DADOS ANTIGOS"
    Local cMsg := ""
    
    cMsg := "??? LIMPEZA DE BUFFER" + CRLF + CRLF
    cMsg += "Antes: [" + cBuffer + "]" + CRLF + CRLF
    
    // Limpa substituindo por espaços
    cBuffer := Space(Len(cBuffer))
    
    cMsg += "Depois: [" + cBuffer + "]" + CRLF + CRLF
    cMsg += "? Buffer limpo e pronto para reutilização"
    
    MsgInfo(cMsg, "Space()")
Return

/*
EXEMPLO 5: Indentação de Texto Hierárquico
*/
Static Function fEx05()
    Local cHier := ""
    Local nNivel1 := 0
    Local nNivel2 := 5
    Local nNivel3 := 10
    
    cHier := "ESTRUTURA ORGANIZACIONAL" + CRLF + CRLF
    
    cHier += Space(nNivel1) + "? Diretoria" + CRLF
    cHier += Space(nNivel2) + "?? Gerência Comercial" + CRLF
    cHier += Space(nNivel3) + "?? Vendas" + CRLF
    cHier += Space(nNivel3) + "?? Pós-vendas" + CRLF
    cHier += Space(nNivel2) + "?? Gerência Financeira" + CRLF
    cHier += Space(nNivel3) + "?? Contas a Pagar" + CRLF
    cHier += Space(nNivel3) + "?? Contas a Receber"
    
    MsgInfo(cHier, "Hierarquia")
Return
