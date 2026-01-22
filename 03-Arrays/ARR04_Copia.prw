// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} ARR04
Exemplos práticos de cópia de arrays

Funções abordadas:
- aClone() - cópia profunda (deep copy)
- := - atribuição por referência
- Diferença entre cópia e referência
- Cuidados com arrays aninhados

@type User Function
@author Felipi Marques
@since 21/01/2026

@example
U_ARR04()
/*/

User Function ARR04()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Cópia de Arrays", ;
                     "1-Atribuição (referência)" + CRLF + ;
                     "2-aClone (cópia)" + CRLF + ;
                     "3-Problema com referência" + CRLF + ;
                     "4-Backup de dados" + CRLF + ;
                     "5-Histórico de carrinho" + CRLF + ;
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
EXEMPLO 1: Atribuição = Referência (CUIDADO!)
*/
Static Function fEx01()
    Local aOriginal := {"A", "B", "C"}
    Local aCopia := aOriginal  // NÃO é cópia!
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? ATRIBUIÇÃO = REFERÊNCIA" + CRLF + CRLF
    
    cMsg += "aOriginal := {'A', 'B', 'C'}" + CRLF
    cMsg += "aCopia := aOriginal" + CRLF + CRLF
    
    cMsg += "Original: "
    For nI := 1 To Len(aOriginal)
        cMsg += aOriginal[nI] + " "
    Next nI
    cMsg += CRLF
    
    cMsg += "Cópia: "
    For nI := 1 To Len(aCopia)
        cMsg += aCopia[nI] + " "
    Next nI
    cMsg += CRLF + CRLF
    
    // Modifica "cópia"
    aCopia[2] := "X"
    
    cMsg += "Modificando aCopia[2] := 'X'" + CRLF + CRLF
    
    cMsg += "Original AGORA: "
    For nI := 1 To Len(aOriginal)
        cMsg += aOriginal[nI] + " "
    Next nI
    cMsg += CRLF
    
    cMsg += "Cópia AGORA: "
    For nI := 1 To Len(aCopia)
        cMsg += aCopia[nI] + " "
    Next nI
    cMsg += CRLF + CRLF
    
    cMsg += "? AMBOS MUDARAM!" + CRLF
    cMsg += "São o MESMO array (referência)" + CRLF + CRLF
    cMsg += "?? Use aClone() para cópia real"
    
    MsgInfo(cMsg, "Referência")
Return

/*
EXEMPLO 2: aClone = Cópia Real
*/
Static Function fEx02()
    Local aOriginal := {"A", "B", "C"}
    Local aCopia := aClone(aOriginal)  // Cópia real!
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "? aClone() = CÓPIA REAL" + CRLF + CRLF
    
    cMsg += "aOriginal := {'A', 'B', 'C'}" + CRLF
    cMsg += "aCopia := aClone(aOriginal)" + CRLF + CRLF
    
    cMsg += "Original: "
    For nI := 1 To Len(aOriginal)
        cMsg += aOriginal[nI] + " "
    Next nI
    cMsg += CRLF
    
    cMsg += "Cópia: "
    For nI := 1 To Len(aCopia)
        cMsg += aCopia[nI] + " "
    Next nI
    cMsg += CRLF + CRLF
    
    // Modifica cópia
    aCopia[2] := "X"
    aAdd(aCopia, "D")
    
    cMsg += "Modificando aCopia:" + CRLF
    cMsg += "aCopia[2] := 'X'" + CRLF
    cMsg += "aAdd(aCopia, 'D')" + CRLF + CRLF
    
    cMsg += "Original AGORA: "
    For nI := 1 To Len(aOriginal)
        cMsg += aOriginal[nI] + " "
    Next nI
    cMsg += CRLF
    
    cMsg += "Cópia AGORA: "
    For nI := 1 To Len(aCopia)
        cMsg += aCopia[nI] + " "
    Next nI
    cMsg += CRLF + CRLF
    
    cMsg += "? Original PRESERVADO!" + CRLF
    cMsg += "São arrays INDEPENDENTES"
    
    MsgInfo(cMsg, "aClone()")
Return

/*
EXEMPLO 3: Problema Real com Referência
*/
Static Function fEx03()
    Local aProdutos := {}
    Local aTemp := {}
    Local cMsg := ""
    Local nI := 0
    
    // Carrega produtos
    aAdd(aProdutos, {"PA001", "NOTEBOOK", 3500.00})
    aAdd(aProdutos, {"PA002", "MOUSE", 35.00})
    
    cMsg := "?? PROBLEMA COM REFERÊNCIA" + CRLF + CRLF
    cMsg += "Produtos cadastrados: " + cValToChar(Len(aProdutos)) + CRLF + CRLF
    
    // ERRADO: atribuição por referência
    aTemp := aProdutos
    
    // Tenta limpar temp
    aSize(aTemp, 0)
    
    cMsg += "aTemp := aProdutos" + CRLF
    cMsg += "aSize(aTemp, 0)  // Limpa temp" + CRLF + CRLF
    
    cMsg += "Produtos AGORA: " + cValToChar(Len(aProdutos)) + CRLF + CRLF
    
    If Len(aProdutos) == 0
        cMsg += "? PRODUTOS APAGADOS!" + CRLF
        cMsg += "aTemp era referência" + CRLF
        cMsg += "Limpou os dois!" + CRLF + CRLF
        cMsg += "SOLUÇÃO: aClone()" + CRLF
        cMsg += "aTemp := aClone(aProdutos)"
    EndIf
    
    MsgInfo(cMsg, "Problema")
Return

/*
EXEMPLO 4: Backup de Dados Antes de Processar
*/
Static Function fEx04()
    Local aDados := {}
    Local aBackup := {}
    Local cMsg := ""
    Local nI := 0
    Local lErro := .F.
    
    // Carrega dados
    aAdd(aDados, {"CLI001", 1000.00})
    aAdd(aDados, {"CLI002", 2500.00})
    aAdd(aDados, {"CLI003", 1500.00})
    
    cMsg := "?? BACKUP ANTES DE PROCESSAR" + CRLF + CRLF
    cMsg += "Dados originais: " + cValToChar(Len(aDados)) + CRLF + CRLF
    
    // Faz backup
    aBackup := aClone(aDados)
    
    // Processa com desconto de 10%
    For nI := 1 To Len(aDados)
        aDados[nI][2] := aDados[nI][2] * 0.9
    Next nI
    
    cMsg += "Aplicando desconto 10%..." + CRLF + CRLF
    
    // Simula erro
    lErro := .T.
    
    If lErro
        cMsg += "? ERRO NO PROCESSAMENTO!" + CRLF + CRLF
        
        // Restaura backup
        aDados := aClone(aBackup)
        
        cMsg += "? BACKUP RESTAURADO" + CRLF + CRLF
        
        cMsg += "Dados restaurados:" + CRLF
        For nI := 1 To Len(aDados)
            cMsg += aDados[nI][1] + " - R$ " + Transform(aDados[nI][2], "@E 999,999.99") + CRLF
        Next nI
    EndIf
    
    cMsg += CRLF + "?? Backup previne perda de dados"
    
    MsgInfo(cMsg, "Backup")
Return

/*
EXEMPLO 5: Histórico de Carrinho
*/
Static Function fEx05()
    Local aCarrinho := {}
    Local aHistorico := {}
    Local cMsg := ""
    Local nI := 0
    
    cMsg := "?? HISTÓRICO DE ALTERAÇÕES" + CRLF + CRLF
    
    // Estado 1: Adiciona produtos
    aAdd(aCarrinho, {"NOTEBOOK", 1, 3500.00})
    aAdd(aCarrinho, {"MOUSE", 2, 35.00})
    aAdd(aHistorico, aClone(aCarrinho))  // Salva snapshot
    
    cMsg += "1?? Adicionou 2 produtos" + CRLF
    cMsg += "Itens: " + cValToChar(Len(aCarrinho)) + CRLF + CRLF
    
    // Estado 2: Adiciona mais um
    aAdd(aCarrinho, {"TECLADO", 1, 125.00})
    aAdd(aHistorico, aClone(aCarrinho))  // Salva snapshot
    
    cMsg += "2?? Adicionou teclado" + CRLF
    cMsg += "Itens: " + cValToChar(Len(aCarrinho)) + CRLF + CRLF
    
    // Estado 3: Remove mouse
    aDel(aCarrinho, 2)
    aSize(aCarrinho, Len(aCarrinho)-1)
    aAdd(aHistorico, aClone(aCarrinho))  // Salva snapshot
    
    cMsg += "3?? Removeu mouse" + CRLF
    cMsg += "Itens: " + cValToChar(Len(aCarrinho)) + CRLF + CRLF
    
    cMsg += "=== HISTÓRICO SALVO ===" + CRLF
    cMsg += "Total snapshots: " + cValToChar(Len(aHistorico)) + CRLF + CRLF
    
    // Mostra snapshot 1
    cMsg += "Snapshot 1 (tinha " + cValToChar(Len(aHistorico[1])) + " itens):" + CRLF
    For nI := 1 To Len(aHistorico[1])
        cMsg += "• " + aHistorico[1][nI][1] + CRLF
    Next nI
    
    cMsg += CRLF + "?? aClone para auditoria/histórico"
    
    MsgInfo(cMsg, "Histórico")
Return
