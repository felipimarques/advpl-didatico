// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD02
Exemplos práticos de navegação em tabelas

Funções abordadas:
- DbSeek() - buscar registro
- DbSkip() - avançar/voltar
- DbGoTop() / DbGoBottom() - ir para início/fim
- Eof() / Bof() - testar limites
- RecNo() - número do registro

@type User Function
@author Felipi Marques
@since 15/11/2025

@example
U_BD02()
/*/

User Function BD02()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Navegação", ;
                     "1-DbSeek (buscar)" + CRLF + ;
                     "2-DbSkip (navegar)" + CRLF + ;
                     "3-DbGoTop/DbGoBottom" + CRLF + ;
                     "4-Eof/Bof (limites)" + CRLF + ;
                     "5-Buscar produto" + CRLF + ;
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
EXEMPLO 1: DbSeek - Buscar Registro
*/
Static Function fEx01()
    Local cCodigo := Space(6)
    Local cMsg := ""
    
    cMsg := "?? DbSeek()" + CRLF + CRLF
    
    cMsg += "Busca registro pela chave do índice" + CRLF + CRLF
    
    cMsg += "Sintaxe:" + CRLF
    cMsg += "DbSeek(xFilial('SA1') + cCodigo)" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)  // Filial + Código + Loja
    
    // Pega primeiro cliente
    DbGoTop()
    If !Eof()
        cCodigo := SA1->A1_COD
        
        cMsg += "Buscando código: " + AllTrim(cCodigo) + CRLF + CRLF
        
        If DbSeek(xFilial("SA1") + cCodigo)
            cMsg += "? ENCONTRADO!" + CRLF + CRLF
            cMsg += "Código: " + AllTrim(SA1->A1_COD) + CRLF
            cMsg += "Loja: " + SA1->A1_LOJA + CRLF
            cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
            
            cMsg += "?? DbSeek retorna .T. se achar"
        Else
            cMsg += "? NÃO ENCONTRADO" + CRLF + CRLF
            cMsg += "DbSeek retorna .F."
        EndIf
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "DbSeek()")
Return

/*
EXEMPLO 2: DbSkip - Navegar Registros
*/
Static Function fEx02()
    Local cMsg := ""
    Local nReg := 0
    
    cMsg := "?? DbSkip()" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cMsg += "NAVEGAÇÃO:" + CRLF + CRLF
        
        // Registro atual
        nReg := RecNo()
        cMsg += "Posição inicial: " + cValToChar(nReg) + CRLF
        cMsg += "Cliente: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        // Avança 1
        DbSkip()
        If !Eof()
            nReg := RecNo()
            cMsg += "DbSkip() ? Posição: " + cValToChar(nReg) + CRLF
            cMsg += "Cliente: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        EndIf
        
        // Avança 2
        DbSkip(2)
        If !Eof()
            nReg := RecNo()
            cMsg += "DbSkip(2) ? Posição: " + cValToChar(nReg) + CRLF
            cMsg += "Cliente: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        EndIf
        
        // Volta 1
        DbSkip(-1)
        nReg := RecNo()
        cMsg += "DbSkip(-1) ? Posição: " + cValToChar(nReg) + CRLF
        cMsg += "Cliente: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        cMsg += "?? Negativo volta, positivo avança"
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "DbSkip()")
Return

/*
EXEMPLO 3: DbGoTop e DbGoBottom
*/
Static Function fEx03()
    Local cMsg := ""
    
    cMsg := "???? DbGoTop / DbGoBottom" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(3)  // Por nome
    
    If SA1->(RecCount()) > 0
        // Vai para o topo
        DbGoTop()
        cMsg += "DbGoTop() - PRIMEIRO:" + CRLF
        cMsg += "Rec: " + cValToChar(RecNo()) + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        // Vai para o fim
        DbGoBottom()
        cMsg += "DbGoBottom() - ÚLTIMO:" + CRLF
        cMsg += "Rec: " + cValToChar(RecNo()) + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        cMsg += "Total registros: " + cValToChar(RecCount()) + CRLF + CRLF
        
        cMsg += "?? Útil para percorrer toda tabela"
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "DbGoTop/Bottom")
Return

/*
EXEMPLO 4: Eof e Bof (Limites)
*/
Static Function fEx04()
    Local cMsg := ""
    
    cMsg := "?? Eof() e Bof()" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    If SA1->(RecCount()) > 0
        // Teste Eof
        DbGoBottom()
        cMsg += "DbGoBottom()" + CRLF
        cMsg += "Eof() = " + If(Eof(), ".T.", ".F.") + CRLF + CRLF
        
        DbSkip()
        cMsg += "DbSkip() após último" + CRLF
        cMsg += "Eof() = " + If(Eof(), ".T. ?", ".F.") + CRLF + CRLF
        
        // Teste Bof
        DbGoTop()
        cMsg += "DbGoTop()" + CRLF
        cMsg += "Bof() = " + If(Bof(), ".T.", ".F.") + CRLF + CRLF
        
        DbSkip(-1)
        cMsg += "DbSkip(-1) antes do primeiro" + CRLF
        cMsg += "Bof() = " + If(Bof(), ".T. ?", ".F.") + CRLF + CRLF
        
        cMsg += "USO COMUM:" + CRLF
        cMsg += "While !Eof()" + CRLF
        cMsg += "   // Processar" + CRLF
        cMsg += "   DbSkip()" + CRLF
        cMsg += "EndDo" + CRLF + CRLF
        
        cMsg += "?? Sempre teste Eof() em loops!"
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "Eof/Bof")
Return

/*
EXEMPLO 5: Buscar Produto Completo
*/
Static Function fEx05()
    Local cCodProd := Space(15)
    Local cMsg := ""
    Local lAchou := .F.
    
    // Pega código de um produto
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cCodProd := SB1->B1_COD
    Else
        MsgAlert("Nenhum produto cadastrado!", "Atenção")
        Return
    EndIf
    
    cMsg := "?? BUSCAR PRODUTO" + CRLF + CRLF
    
    // Busca produto
    DbSelectArea("SB1")
    DbSetOrder(1)  // Filial + Código
    
    lAchou := DbSeek(xFilial("SB1") + cCodProd)
    
    If lAchou
        cMsg += "? PRODUTO ENCONTRADO" + CRLF + CRLF
        
        cMsg += "=== DADOS CADASTRAIS ===" + CRLF
        cMsg += "Código: " + AllTrim(SB1->B1_COD) + CRLF
        cMsg += "Descrição: " + AllTrim(SB1->B1_DESC) + CRLF
        cMsg += "Tipo: " + SB1->B1_TIPO + CRLF
        cMsg += "UM: " + SB1->B1_UM + CRLF + CRLF
        
        // Busca saldo
        DbSelectArea("SB2")
        DbSetOrder(1)  // Filial + Código + Local
        
        If DbSeek(xFilial("SB2") + cCodProd)
            cMsg += "=== ESTOQUE ===" + CRLF
            
            While !Eof() .And. SB2->B2_FILIAL == xFilial("SB2") ;
                           .And. SB2->B2_COD == cCodProd
                
                cMsg += "Local " + SB2->B2_LOCAL + ": "
                cMsg += Transform(SB2->B2_QATU, "@E 999,999.99") + " " + SB1->B1_UM + CRLF
                
                DbSkip()
            EndDo
        Else
            cMsg += "Sem estoque"
        EndIf
        
        cMsg += CRLF + "?? Busca em múltiplas tabelas"
    Else
        cMsg += "? Produto não encontrado: " + AllTrim(cCodProd)
    EndIf
    
    MsgInfo(cMsg, "Buscar Produto")
Return
