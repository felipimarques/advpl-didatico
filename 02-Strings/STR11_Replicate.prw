// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR11
Exemplos práticos da função Replicate() em situações reais

A função Replicate() repete um caractere N vezes:
- Criar separadores visuais
- Gerar linhas de relatórios
- Preencher espaços/zeros
- Criar máscaras
- Testes e debug

@type User Function
@author Felipi Marques
@since 14/12/2025

@obs Replicate(cCaractere, nQuantidade)

@example
U_STR11()

@see
https://tdn.totvs.com/display/tec/Replicate
/*/

User Function STR11()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Replicate() - Exemplos", ;
                     "1-Separador visual" + CRLF + ;
                     "2-Cabeçalho relatório" + CRLF + ;
                     "3-Máscara senha" + CRLF + ;
                     "4-Preenchimento campos" + CRLF + ;
                     "5-Linha totalizadora" + CRLF + ;
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
EXEMPLO 1: Separador Visual em Logs
*/
Static Function fEx01()
    Local cLog := ""
    
    cLog := "INÍCIO DO PROCESSAMENTO" + CRLF
    cLog += Replicate("-", 50) + CRLF
    cLog += "Processando cliente: 000001" + CRLF
    cLog += "Status: OK" + CRLF
    cLog += Replicate("-", 50) + CRLF
    cLog += "FIM DO PROCESSAMENTO"
    
    MsgInfo(cLog, "Separador Visual")
Return

/*
EXEMPLO 2: Cabeçalho de Relatório
*/
Static Function fEx02()
    Local cRel := ""
    
    cRel := Replicate("=", 70) + CRLF
    cRel += Space(20) + "RELATÓRIO DE VENDAS" + CRLF
    cRel += Space(25) + "Janeiro/2026" + CRLF
    cRel += Replicate("=", 70) + CRLF + CRLF
    
    cRel += "Código  Descrição           Qtde      Valor" + CRLF
    cRel += Replicate("-", 70) + CRLF
    cRel += "PA001   PRODUTO A             10    1.250,00" + CRLF
    cRel += "PA002   PRODUTO B             25    3.750,00" + CRLF
    cRel += Replicate("-", 70) + CRLF
    cRel += "TOTAL:                        35    5.000,00" + CRLF
    cRel += Replicate("=", 70)
    
    MsgInfo(cRel, "Relatório")
Return

/*
EXEMPLO 3: Máscara de Senha
*/
Static Function fEx03()
    Local cSenha := "Senha123"
    Local cMasc := ""
    Local cMsg := ""
    
    // Mostra asteriscos no lugar da senha
    cMasc := Replicate("*", Len(cSenha))
    
    cMsg := "?? MÁSCARA DE SENHA" + CRLF + CRLF
    cMsg += "Senha digitada: " + cMasc + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cSenha)) + " caracteres" + CRLF + CRLF
    cMsg += "? Senha aceita!"
    
    MsgInfo(cMsg, "Replicate()")
Return

/*
EXEMPLO 4: Preenchimento de Campos Fixos
*/
Static Function fEx04()
    Local cCod := "PA001"
    Local cDesc := "PRODUTO A"
    Local nTamCod := 15
    Local nTamDesc := 40
    Local cLinha := ""
    Local cMsg := ""
    
    // Completa com espaços para layout fixo
    cCod := cCod + Replicate(" ", nTamCod - Len(cCod))
    cDesc := cDesc + Replicate(" ", nTamDesc - Len(cDesc))
    
    cLinha := cCod + cDesc + "1250.00"
    
    cMsg := "?? LAYOUT FIXO (TXT)" + CRLF + CRLF
    cMsg += "Código (15): [" + cCod + "]" + CRLF
    cMsg += "Descrição (40): [" + cDesc + "]" + CRLF + CRLF
    cMsg += "Linha completa:" + CRLF
    cMsg += "[" + cLinha + "]" + CRLF + CRLF
    cMsg += "Total: " + cValToChar(Len(cLinha)) + " caracteres"
    
    MsgInfo(cMsg, "Replicate()")
Return

/*
EXEMPLO 5: Linha Totalizadora
*/
Static Function fEx05()
    Local cRel := ""
    Local nTotal := 125750.50
    
    cRel := "Vendedor  Região      Valor" + CRLF
    cRel += Replicate("-", 35) + CRLF
    cRel += "João      Sul     25.000,00" + CRLF
    cRel += "Maria     Norte   50.000,00" + CRLF
    cRel += "Pedro     Leste   50.750,50" + CRLF
    cRel += Replicate("=", 35) + CRLF
    cRel += "TOTAL GERAL   " + Transform(nTotal, "@E 999,999.99") + CRLF
    cRel += Replicate("=", 35)
    
    MsgInfo(cRel, "Linha Totalizadora")
Return
