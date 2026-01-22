// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD01
Exemplos práticos de abertura e seleção de tabelas

Funções abordadas:
- DbSelectArea() - selecionar tabela
- DbSetOrder() - definir índice
- (Alias)->Campo - acesso a campos
- Verificar se tabela existe
- GetArea/RestArea - salvar contexto

@type User Function
@author Felipi Marques
@since 08/11/2025

@example
U_BD01()
/*/

User Function BD01()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Abertura de Tabelas", ;
                     "1-Selecionar tabela" + CRLF + ;
                     "2-Definir índice" + CRLF + ;
                     "3-Acessar campos" + CRLF + ;
                     "4-GetArea/RestArea" + CRLF + ;
                     "5-Listar clientes" + CRLF + ;
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
EXEMPLO 1: Selecionar Tabela (DbSelectArea)
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? DbSelectArea()" + CRLF + CRLF
    
    cMsg += "Seleciona a tabela (alias) para trabalhar" + CRLF + CRLF
    
    cMsg += "Sintaxe:" + CRLF
    cMsg += "DbSelectArea('SA1')  // Clientes" + CRLF
    cMsg += "DbSelectArea('SA2')  // Fornecedores" + CRLF
    cMsg += "DbSelectArea('SB1')  // Produtos" + CRLF + CRLF
    
    // Seleciona clientes
    DbSelectArea("SA1")
    
    cMsg += "Tabela atual: " + Alias() + CRLF
    cMsg += "Total registros: " + cValToChar(RecCount()) + CRLF + CRLF
    
    cMsg += "?? Sempre selecione antes de usar!" + CRLF + CRLF
    
    cMsg += "PRINCIPAIS TABELAS:" + CRLF
    cMsg += "SA1 - Clientes" + CRLF
    cMsg += "SA2 - Fornecedores" + CRLF
    cMsg += "SB1 - Produtos" + CRLF
    cMsg += "SB2 - Saldos" + CRLF
    cMsg += "SC5 - Pedidos de Venda" + CRLF
    cMsg += "SC6 - Itens Pedido Venda" + CRLF
    cMsg += "SE1 - Contas a Receber" + CRLF
    cMsg += "SE2 - Contas a Pagar"
    
    MsgInfo(cMsg, "DbSelectArea()")
Return

/*
EXEMPLO 2: Definir Índice (DbSetOrder)
*/
Static Function fEx02()
    Local cMsg := ""
    
    cMsg := "?? DbSetOrder()" + CRLF + CRLF
    
    cMsg += "Define qual índice usar na tabela" + CRLF + CRLF
    
    DbSelectArea("SA1")
    
    cMsg += "ÍNDICES DA SA1 (Clientes):" + CRLF + CRLF
    
    DbSetOrder(1)
    cMsg += "Ordem 1: " + IndexKey() + CRLF
    cMsg += "(Filial + Código + Loja)" + CRLF + CRLF
    
    DbSetOrder(2)
    cMsg += "Ordem 2: " + IndexKey() + CRLF
    cMsg += "(Filial + CGC/CPF)" + CRLF + CRLF
    
    DbSetOrder(3)
    cMsg += "Ordem 3: " + IndexKey() + CRLF
    cMsg += "(Filial + Nome)" + CRLF + CRLF
    
    // Volta para ordem 1
    DbSetOrder(1)
    
    cMsg += "?? Índice define ordem de busca!" + CRLF + CRLF
    
    cMsg += "Uso:" + CRLF
    cMsg += "DbSetOrder(1)  // Por código" + CRLF
    cMsg += "DbSetOrder(3)  // Por nome"
    
    MsgInfo(cMsg, "DbSetOrder()")
Return

/*
EXEMPLO 3: Acessar Campos
*/
Static Function fEx03()
    Local cMsg := ""
    
    cMsg := "?? ACESSAR CAMPOS" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cMsg += "3 FORMAS DE ACESSAR:" + CRLF + CRLF
        
        // Forma 1: Direto
        cMsg += "1. Direto:" + CRLF
        cMsg += "A1_COD = " + A1_COD + CRLF
        cMsg += "A1_NOME = " + A1_NOME + CRLF + CRLF
        
        // Forma 2: Prefixo alias
        cMsg += "2. Com alias:" + CRLF
        cMsg += "SA1->A1_COD = " + SA1->A1_COD + CRLF
        cMsg += "SA1->A1_NOME = " + SA1->A1_NOME + CRLF + CRLF
        
        // Forma 3: FieldGet
        cMsg += "3. FieldGet:" + CRLF
        cMsg += "FieldGet(FieldPos('A1_COD')) = " + FieldGet(FieldPos("A1_COD")) + CRLF + CRLF
        
        cMsg += "?? Use SA1->campo quando trabalha" + CRLF
        cMsg += "com múltiplas tabelas!"
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "Acessar Campos")
Return

/*
EXEMPLO 4: GetArea e RestArea
*/
Static Function fEx04()
    Local aAreaSA1 := {}
    Local cCodCli := ""
    Local cNomCli := ""
    Local cMsg := ""
    
    cMsg := "?? GetArea / RestArea" + CRLF + CRLF
    
    // Posiciona em um cliente
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cCodCli := SA1->A1_COD
        cNomCli := SA1->A1_NOME
        
        cMsg += "Cliente atual:" + CRLF
        cMsg += cCodCli + " - " + cNomCli + CRLF + CRLF
        
        // Salva posição
        aAreaSA1 := SA1->(GetArea())
        
        cMsg += "GetArea() salvo!" + CRLF + CRLF
        
        // Navega para outro registro
        DbSkip()
        If !Eof()
            cMsg += "Mudou para:" + CRLF
            cMsg += SA1->A1_COD + " - " + SA1->A1_NOME + CRLF + CRLF
        EndIf
        
        // Restaura posição
        RestArea(aAreaSA1)
        
        cMsg += "RestArea() executado!" + CRLF + CRLF
        
        cMsg += "Voltou para:" + CRLF
        cMsg += SA1->A1_COD + " - " + SA1->A1_NOME + CRLF + CRLF
        
        cMsg += "?? Use para preservar contexto!" + CRLF + CRLF
        
        cMsg += "Boas práticas:" + CRLF
        cMsg += "Local aArea := GetArea()" + CRLF
        cMsg += "// ... código ..." + CRLF
        cMsg += "RestArea(aArea)"
    Else
        cMsg += "? Nenhum cliente cadastrado"
    EndIf
    
    MsgInfo(cMsg, "GetArea/RestArea")
Return

/*
EXEMPLO 5: Listar Clientes (Prático)
*/
Static Function fEx05()
    Local cMsg := ""
    Local nCont := 0
    
    cMsg := "?? LISTAR CLIENTES" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(3)  // Por nome
    DbGoTop()
    
    If !Eof()
        cMsg += "=== CADASTRO DE CLIENTES ===" + CRLF + CRLF
        
        While !Eof() .And. nCont < 10
            nCont++
            
            cMsg += cValToChar(nCont) + ". "
            cMsg += AllTrim(SA1->A1_COD) + "/" + AllTrim(SA1->A1_LOJA) + " - "
            cMsg += AllTrim(SA1->A1_NOME) + CRLF
            
            // Mostra cidade/estado
            cMsg += "   " + AllTrim(SA1->A1_MUN) + "/" + SA1->A1_EST + CRLF
            
            DbSkip()
        EndDo
        
        If !Eof()
            cMsg += CRLF + "... mais registros ..."
        EndIf
        
        cMsg += CRLF + "Total: " + cValToChar(SA1->(RecCount())) + " clientes" + CRLF + CRLF
        
        cMsg += "?? Listagem básica com While"
    Else
        cMsg += "? Nenhum cliente cadastrado" + CRLF + CRLF
        cMsg += "Execute:" + CRLF
        cMsg += "1. Entre no módulo Faturamento" + CRLF
        cMsg += "2. Cadastre alguns clientes" + CRLF
        cMsg += "3. Execute novamente"
    EndIf
    
    MsgInfo(cMsg, "Listar Clientes")
Return
