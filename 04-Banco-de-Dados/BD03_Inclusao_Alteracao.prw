// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} BD03
Exemplos práticos de inclusão e alteração

Funções abordadas:
- RecLock() - travar registro
- MsUnlock() - liberar registro
- Incluir novos registros
- Alterar registros existentes
- GetSx8Num() - próximo número

@type User Function
@author Felipi Marques
@since 22/11/2025

@example
U_BD03()
/*/

User Function BD03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Inclusão e Alteração", ;
                     "1-RecLock conceito" + CRLF + ;
                     "2-Incluir registro" + CRLF + ;
                     "3-Alterar registro" + CRLF + ;
                     "4-Incluir cliente" + CRLF + ;
                     "5-Atualizar preço" + CRLF + ;
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
EXEMPLO 1: RecLock - Conceito
*/
Static Function fEx01()
    Local cMsg := ""
    
    cMsg := "?? RecLock()" + CRLF + CRLF
    
    cMsg += "Trava registro para edição" + CRLF + CRLF
    
    cMsg += "SINTAXE:" + CRLF
    cMsg += "RecLock(cAlias, lIncluir)" + CRLF + CRLF
    
    cMsg += "PARÂMETROS:" + CRLF
    cMsg += "cAlias = Nome da tabela" + CRLF
    cMsg += "lIncluir = .T. novo, .F. alterar" + CRLF + CRLF
    
    cMsg += "=== INCLUIR ===" + CRLF
    cMsg += "RecLock('SA1', .T.)" + CRLF
    cMsg += "SA1->A1_FILIAL := xFilial('SA1')" + CRLF
    cMsg += "SA1->A1_COD := '000001'" + CRLF
    cMsg += "SA1->A1_NOME := 'JOSE SILVA'" + CRLF
    cMsg += "MsUnlock()" + CRLF + CRLF
    
    cMsg += "=== ALTERAR ===" + CRLF
    cMsg += "DbSeek(xFilial('SA1')+'000001')" + CRLF
    cMsg += "RecLock('SA1', .F.)" + CRLF
    cMsg += "SA1->A1_NOME := 'MARIA SANTOS'" + CRLF
    cMsg += "MsUnlock()" + CRLF + CRLF
    
    cMsg += "?? SEMPRE use MsUnlock()!" + CRLF
    cMsg += "Senão trava o banco!"
    
    MsgInfo(cMsg, "RecLock()")
Return

/*
EXEMPLO 2: Incluir Registro Simples
*/
Static Function fEx02()
    Local cMsg := ""
    Local cProxCod := ""
    
    cMsg := "? INCLUIR REGISTRO" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Gera próximo código
    cProxCod := GetSx8Num("SA1", "A1_COD")
    
    cMsg += "Próximo código: " + cProxCod + CRLF + CRLF
    
    // Verifica se já existe
    If DbSeek(xFilial("SA1") + cProxCod)
        cMsg += "? Código já existe!" + CRLF
        cMsg += "Cliente: " + AllTrim(SA1->A1_NOME)
    Else
        // Inclui
        RecLock("SA1", .T.)
        SA1->A1_FILIAL := xFilial("SA1")
        SA1->A1_COD := cProxCod
        SA1->A1_LOJA := "01"
        SA1->A1_NOME := "TESTE INCLUSAO"
        SA1->A1_NREDUZ := "TESTE"
        SA1->A1_TIPO := "R"
        SA1->A1_EST := "SP"
        SA1->A1_MUN := "SAO PAULO"
        MsUnlock()
        
        ConfirmSx8()
        
        cMsg += "? INCLUÍDO COM SUCESSO!" + CRLF + CRLF
        cMsg += "Código: " + cProxCod + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        cMsg += "?? GetSx8Num gera próximo código" + CRLF
        cMsg += "?? ConfirmSx8 confirma numeração"
    EndIf
    
    MsgInfo(cMsg, "Incluir")
Return

/*
EXEMPLO 3: Alterar Registro
*/
Static Function fEx03()
    Local cMsg := ""
    Local cCodigo := ""
    
    cMsg := "?? ALTERAR REGISTRO" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        cCodigo := SA1->A1_COD
        
        cMsg += "ANTES:" + CRLF
        cMsg += "Código: " + AllTrim(SA1->A1_COD) + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        // Altera
        RecLock("SA1", .F.)
        SA1->A1_NOME := "NOME ALTERADO"
        SA1->A1_NREDUZ := "ALTERADO"
        MsUnlock()
        
        cMsg += "DEPOIS:" + CRLF
        cMsg += "Código: " + AllTrim(SA1->A1_COD) + CRLF
        cMsg += "Nome: " + AllTrim(SA1->A1_NOME) + CRLF + CRLF
        
        cMsg += "? Alterado com sucesso!" + CRLF + CRLF
        
        cMsg += "?? RecLock com .F. para alterar"
    Else
        cMsg += "? Nenhum cliente para alterar"
    EndIf
    
    MsgInfo(cMsg, "Alterar")
Return

/*
EXEMPLO 4: Incluir Cliente Completo
*/
Static Function fEx04()
    Local cCodigo := ""
    Local cLoja := "01"
    Local cNome := Space(40)
    Local cCnpj := Space(14)
    Local cMsg := ""
    
    // Solicita dados
    cNome := "CLIENTE EXEMPLO LTDA"
    cCnpj := "12345678000199"
    
    cMsg := "?? INCLUIR CLIENTE" + CRLF + CRLF
    
    DbSelectArea("SA1")
    DbSetOrder(1)
    
    // Gera código
    cCodigo := GetSx8Num("SA1", "A1_COD")
    
    // Verifica se existe
    If !DbSeek(xFilial("SA1") + cCodigo + cLoja)
        
        RecLock("SA1", .T.)
        
        // Dados principais
        SA1->A1_FILIAL := xFilial("SA1")
        SA1->A1_COD := cCodigo
        SA1->A1_LOJA := cLoja
        SA1->A1_NOME := cNome
        SA1->A1_NREDUZ := SubStr(cNome, 1, 20)
        SA1->A1_CGC := cCnpj
        SA1->A1_TIPO := "J"  // Jurídica
        
        // Endereço
        SA1->A1_END := "RUA EXEMPLO, 100"
        SA1->A1_MUN := "SAO PAULO"
        SA1->A1_EST := "SP"
        SA1->A1_CEP := "01234000"
        SA1->A1_BAIRRO := "CENTRO"
        
        // Contato
        SA1->A1_TEL := "11999999999"
        SA1->A1_EMAIL := "contato@exemplo.com"
        
        // Comercial
        SA1->A1_VEND := "000001"
        SA1->A1_COND := "001"
        SA1->A1_TABELA := "001"
        
        MsUnlock()
        
        ConfirmSx8()
        
        cMsg += "? CLIENTE CADASTRADO!" + CRLF + CRLF
        cMsg += "=== DADOS ===" + CRLF
        cMsg += "Código: " + cCodigo + "/" + cLoja + CRLF
        cMsg += "Nome: " + AllTrim(cNome) + CRLF
        cMsg += "CNPJ: " + cCnpj + CRLF
        cMsg += "Cidade: " + AllTrim(SA1->A1_MUN) + "/" + SA1->A1_EST + CRLF + CRLF
        
        cMsg += "?? Cliente completo cadastrado!"
    Else
        RollbackSx8()
        cMsg += "? Cliente já existe!" + CRLF
        cMsg += AllTrim(SA1->A1_NOME)
    EndIf
    
    MsgInfo(cMsg, "Incluir Cliente")
Return

/*
EXEMPLO 5: Atualizar Preço de Produtos
*/
Static Function fEx05()
    Local nPerc := 10  // 10%
    Local nCont := 0
    Local cMsg := ""
    
    cMsg := "?? ATUALIZAR PREÇOS" + CRLF + CRLF
    cMsg += "Reajuste: " + cValToChar(nPerc) + "%" + CRLF + CRLF
    
    DbSelectArea("SB1")
    DbSetOrder(1)
    DbGoTop()
    
    If !Eof()
        
        While !Eof()
            
            If SB1->B1_PRV1 > 0
                
                RecLock("SB1", .F.)
                SB1->B1_PRV1 := SB1->B1_PRV1 * (1 + (nPerc/100))
                MsUnlock()
                
                nCont++
                
                If nCont <= 5
                    cMsg += AllTrim(SB1->B1_COD) + " - "
                    cMsg += Transform(SB1->B1_PRV1, "@E 999,999.99") + CRLF
                EndIf
            EndIf
            
            DbSkip()
        EndDo
        
        If nCont > 5
            cMsg += "... mais " + cValToChar(nCont - 5) + " produtos" + CRLF
        EndIf
        
        cMsg += CRLF + "? " + cValToChar(nCont) + " produtos atualizados!" + CRLF + CRLF
        
        cMsg += "?? Loop com RecLock para atualizar lote"
    Else
        cMsg += "? Nenhum produto cadastrado"
    EndIf
    
    MsgInfo(cMsg, "Atualizar Preços")
Return
