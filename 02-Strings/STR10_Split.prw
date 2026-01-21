// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR10
Exemplos práticos de separação/divisão de strings em situações reais

Funções para dividir strings:
- StrTokArr() - separa string em array
- StrTok2() - mais rápida que StrTokArr()
- Split por delimitador
- Processar CSV/TXT
- Separar múltiplos valores

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs StrTokArr(cTexto, cDelimitador)
@obs StrTok2(cTexto, cDelimitador, lProcessa)

@example
U_STR10()

@see
https://tdn.totvs.com/display/tec/StrTokArr
/*/

User Function STR10()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Split - Separar Strings", ;
                     "1-Processar CSV" + CRLF + ;
                     "2-Separar nome completo" + CRLF + ;
                     "3-Múltiplos e-mails" + CRLF + ;
                     "4-Hierarquia contábil" + CRLF + ;
                     "5-Tags de produto" + CRLF + ;
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
EXEMPLO 1: Processar Linha CSV
"PA001;PRODUTO A;12.50;UN"
*/
Static Function fEx01()
    Local cLinha := "PA001;PRODUTO A;12.50;UN"
    Local aCampos := {}
    Local cMsg := ""
    Local nI := 0
    
    // Separa por ponto-e-vírgula
    aCampos := StrTokArr(cLinha, ";")
    
    cMsg := "?? IMPORTAÇÃO CSV" + CRLF + CRLF
    cMsg += "Linha completa:" + CRLF
    cMsg += cLinha + CRLF + CRLF
    cMsg += "Campos separados:" + CRLF
    
    For nI := 1 To Len(aCampos)
        cMsg += "[" + cValToChar(nI) + "] " + aCampos[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? Para importar:" + CRLF
    cMsg += "Código: " + aCampos[1] + CRLF
    cMsg += "Descr: " + aCampos[2] + CRLF
    cMsg += "Preço: " + aCampos[3] + CRLF
    cMsg += "UM: " + aCampos[4]
    
    MsgInfo(cMsg, "Split CSV")
Return

/*
EXEMPLO 2: Separar Nome Completo
"João da Silva Santos" ? Nome + Sobrenomes
*/
Static Function fEx02()
    Local cNome := "João da Silva Santos"
    Local aPartes := {}
    Local cMsg := ""
    Local nI := 0
    
    // Separa por espaço
    aPartes := StrTokArr(cNome, " ")
    
    cMsg := "?? PROCESSAMENTO DE NOME" + CRLF + CRLF
    cMsg += "Nome completo: " + cNome + CRLF + CRLF
    cMsg += "Partes do nome:" + CRLF
    
    For nI := 1 To Len(aPartes)
        If nI == 1
            cMsg += "Primeiro nome: " + aPartes[nI] + CRLF
        ElseIf nI == Len(aPartes)
            cMsg += "Último sobrenome: " + aPartes[nI] + CRLF
        Else
            cMsg += "Meio: " + aPartes[nI] + CRLF
        EndIf
    Next nI
    
    cMsg += CRLF + "?? Para cadastro:" + CRLF
    cMsg += "Nome: " + aPartes[1] + CRLF
    cMsg += "Sobrenome: " + aPartes[Len(aPartes)]
    
    MsgInfo(cMsg, "Split Nome")
Return

/*
EXEMPLO 3: Múltiplos E-mails
"vendas@empresa.com;fiscal@empresa.com;suporte@empresa.com"
*/
Static Function fEx03()
    Local cEmails := "vendas@empresa.com;fiscal@empresa.com;suporte@empresa.com"
    Local aLista := {}
    Local cMsg := ""
    Local nI := 0
    
    // Separa por ponto-e-vírgula
    aLista := StrTokArr(cEmails, ";")
    
    cMsg := "?? PROCESSAMENTO DE E-MAILS" + CRLF + CRLF
    cMsg += "Total de destinatários: " + cValToChar(Len(aLista)) + CRLF + CRLF
    
    For nI := 1 To Len(aLista)
        cMsg += cValToChar(nI) + ". " + aLista[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "? Uso: workflow, notificações"
    
    MsgInfo(cMsg, "Split E-mails")
Return

/*
EXEMPLO 4: Hierarquia Contábil
"1.01.001.0001" ? Nível 1, Nível 2, Nível 3, Nível 4
*/
Static Function fEx04()
    Local cConta := "1.01.001.0001"
    Local aNiveis := {}
    Local cMsg := ""
    Local nI := 0
    
    // Separa por ponto
    aNiveis := StrTokArr(cConta, ".")
    
    cMsg := "?? HIERARQUIA CONTÁBIL" + CRLF + CRLF
    cMsg += "Conta: " + cConta + CRLF + CRLF
    
    For nI := 1 To Len(aNiveis)
        cMsg += "Nível " + cValToChar(nI) + ": " + aNiveis[nI] + CRLF
    Next nI
    
    cMsg += CRLF + "?? Análise:" + CRLF
    cMsg += "Classe: " + aNiveis[1] + CRLF
    cMsg += "Grupo: " + aNiveis[2] + CRLF
    cMsg += "Subgrupo: " + aNiveis[3] + CRLF
    cMsg += "Conta analítica: " + aNiveis[4]
    
    MsgInfo(cMsg, "Split Hierarquia")
Return

/*
EXEMPLO 5: Tags de Produto
"promocao,destaque,novo,oferta-relampago"
*/
Static Function fEx05()
    Local cTags := "promocao,destaque,novo,oferta-relampago"
    Local aTags := {}
    Local cMsg := ""
    Local nI := 0
    Local nPromo := 0
    Local nDest := 0
    
    // Separa por vírgula
    aTags := StrTokArr(cTags, ",")
    
    cMsg := "??? PROCESSAMENTO DE TAGS" + CRLF + CRLF
    cMsg += "Tags encontradas: " + cValToChar(Len(aTags)) + CRLF + CRLF
    
    For nI := 1 To Len(aTags)
        cMsg += "• " + aTags[nI] + CRLF
        
        // Verifica tags específicas
        If "promocao" $ Lower(aTags[nI])
            nPromo++
        EndIf
        If "destaque" $ Lower(aTags[nI])
            nDest++
        EndIf
    Next nI
    
    cMsg += CRLF + "?? Análise:" + CRLF
    cMsg += "Tem promoção? " + If(nPromo > 0, "SIM", "NÃO") + CRLF
    cMsg += "É destaque? " + If(nDest > 0, "SIM", "NÃO")
    
    MsgInfo(cMsg, "Split Tags")
Return
