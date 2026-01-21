// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR09
Exemplos práticos da função Stuff() em situações reais do Protheus

A função Stuff() insere ou substitui texto em posição específica:
- Inserir texto no meio de string
- Substituir parte de texto
- Mascarar dados sensíveis (cartão, senha)
- Formatar códigos e documentos
- Corrigir erros em posições específicas

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs Stuff(cTexto, nInicio, nQuantidade, cInserir)
@obs nInicio = posição onde vai inserir/substituir
@obs nQuantidade = quantos caracteres apagar (0=só inserir)
@obs cInserir = texto a inserir

@example
U_STR09()

@see
https://tdn.totvs.com/display/tec/Stuff
/*/

User Function STR09()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Stuff() - Exemplos", ;
                     "1-Formatar CPF/CNPJ" + CRLF + ;
                     "2-Mascarar cartão" + CRLF + ;
                     "3-Inserir traço código" + CRLF + ;
                     "4-Formatar CEP" + CRLF + ;
                     "5-Corrigir posição específica" + CRLF + ;
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
EXEMPLO 1: Formatar CPF/CNPJ
CPF: 12345678900 ? 123.456.789-00
CNPJ: 12345678000195 ? 12.345.678/0001-95
*/
Static Function fEx01()
    Local cMsg := "?? FORMATAÇÃO COM STUFF()" + CRLF + CRLF
    
    Local cCPF := "12345678900"
    Local cCNPJ := "12345678000195"
    
    // Formata CPF
    cCPF := Stuff(cCPF, 10, 0, "-")   // Insere - na posição 10
    cCPF := Stuff(cCPF, 7, 0, ".")    // Insere . na posição 7
    cCPF := Stuff(cCPF, 4, 0, ".")    // Insere . na posição 4
    
    cMsg += "CPF: " + cCPF + CRLF + CRLF
    
    // Formata CNPJ
    cCNPJ := Stuff(cCNPJ, 13, 0, "-")  // Insere - na posição 13
    cCNPJ := Stuff(cCNPJ, 9, 0, "/")   // Insere / na posição 9
    cCNPJ := Stuff(cCNPJ, 6, 0, ".")   // Insere . na posição 6
    cCNPJ := Stuff(cCNPJ, 3, 0, ".")   // Insere . na posição 3
    
    cMsg += "CNPJ: " + cCNPJ
    
    MsgInfo(cMsg, "Stuff()")
Return

/*
EXEMPLO 2: Mascarar Cartão de Crédito
4111111111111111 ? 4111 **** **** 1111
*/
Static Function fEx02()
    Local cCartao := "4111111111111111"
    Local cMasc := ""
    Local cMsg := ""
    
    // Mantém 4 primeiros e 4 últimos
    cMasc := Left(cCartao, 4) + " **** **** " + Right(cCartao, 4)
    
    cMsg := "?? MASCARAMENTO SEGURO" + CRLF + CRLF
    cMsg += "Original: " + cCartao + CRLF
    cMsg += "Mascarado: " + cMasc
    
    MsgInfo(cMsg, "Stuff()")
Return

/*
EXEMPLO 3: Inserir Traço em Código
PA001234 ? PA-001234
*/
Static Function fEx03()
    Local cCod := "PA001234"
    Local cForm := ""
    Local cMsg := ""
    
    // Insere traço após PA
    cForm := Stuff(cCod, 3, 0, "-")
    
    cMsg := "?? INSERÇÃO DE TRAÇO" + CRLF + CRLF
    cMsg += "Antes: " + cCod + CRLF
    cMsg += "Depois: " + cForm
    
    MsgInfo(cMsg, "Stuff()")
Return

/*
EXEMPLO 4: Formatar CEP
01310100 ? 01310-100
*/
Static Function fEx04()
    Local cCEP := "01310100"
    Local cForm := ""
    Local cMsg := ""
    
    // Insere hífen na posição 6
    cForm := Stuff(cCEP, 6, 0, "-")
    
    cMsg := "?? FORMATAÇÃO DE CEP" + CRLF + CRLF
    cMsg += "Sem formato: " + cCEP + CRLF
    cMsg += "Formatado: " + cForm
    
    MsgInfo(cMsg, "Stuff()")
Return

/*
EXEMPLO 5: Corrigir Erro em Posição Específica
Digitado: EMPREGA (erro na posição 7)
Correto: EMPRESA
*/
Static Function fEx05()
    Local cErro := "EMPREGA"
    Local cCorr := ""
    Local cMsg := ""
    
    // Substitui GA por SA na posição 6
    cCorr := Stuff(cErro, 6, 2, "SA")
    
    cMsg := "?? CORREÇÃO PONTUAL" + CRLF + CRLF
    cMsg += "Errado: " + cErro + CRLF
    cMsg += "Corrigido: " + cCorr
    
    MsgInfo(cMsg, "Stuff()")
Return