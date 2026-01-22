// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR04
Exemplos práticos das funções Trim em situações reais do Protheus

As funções de Trim removem espaços em branco e são cruciais para:
- Limpar dados digitados pelo usuário
- Comparar strings do banco de dados (campos CHAR têm espaços à direita)
- Preparar dados para exportação/integração
- Validar campos obrigatórios
- Evitar problemas em chaves compostas

@type User Function
@author Felipi Marques
@since 16/11/2025

@obs AllTrim(c) = Remove espaços à esquerda E à direita
@obs LTrim(c) = Remove espaços à esquerda (Left)
@obs RTrim(c) = Remove espaços à direita (Right)

@example
U_STR04()

@see
https://tdn.totvs.com/display/tec/AllTrim
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR04()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Comparar códigos do banco
            Case nOpcao == 2
                fEx02()  // Validar campos obrigatórios
            Case nOpcao == 3
                fEx03()  // Preparar dados para exportação
            Case nOpcao == 4
                fEx04()  // Montar chave composta
            Case nOpcao == 5
                fEx05()  // Formatar dados para exibição
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
    
    aAdd(aOpcoes, "1 - Comparar códigos do banco")
    aAdd(aOpcoes, "2 - Validar campos obrigatórios")
    aAdd(aOpcoes, "3 - Preparar dados p/ exportação")
    aAdd(aOpcoes, "4 - Montar chave composta")
    aAdd(aOpcoes, "5 - Formatar dados p/ exibição")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("Trim - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Comparar Códigos do Banco (SB1/SA1/SA2)
// ==========================================================================
/*
SITUAÇÃO REAL:
Campos CHAR no banco Protheus são preenchidos com espaços à direita:
  Campo no banco: "0001      " (15 caracteres)
  Digitado: "0001"

Sem AllTrim(), a comparação "0001" == "0001      " retorna FALSO!
Isso causa problemas em:
- Buscas de produtos
- Validação de códigos
- Filtros de relatórios
*/
Static Function fEx01()
    Local cProdBD  := "PA0001         "  // Simula campo do banco (15 chars)
    Local cProdDig := "PA0001"           // Digitado pelo usuário
    Local cMsg     := ""
    
    cMsg := "?? PROBLEMA: COMPARAÇÃO DE CÓDIGOS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    // Demonstra o problema
    cMsg += "? COMPARAÇÃO DIRETA (ERRADA):" + CRLF + CRLF
    cMsg += "Código do banco: '" + cProdBD + "'" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cProdBD)) + " caracteres" + CRLF + CRLF
    cMsg += "Código digitado: '" + cProdDig + "'" + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cProdDig)) + " caracteres" + CRLF + CRLF
    
    If cProdBD == cProdDig
        cMsg += "Resultado: IGUAL ?" + CRLF
    Else
        cMsg += "Resultado: DIFERENTE ?" + CRLF
        cMsg += "Por quê? Banco tem espaços à direita!" + CRLF
    EndIf
    
    cMsg += CRLF + Replicate("-", 60) + CRLF + CRLF
    
    // Solução com AllTrim
    cMsg += "? COMPARAÇÃO COM ALLTRIM (CORRETA):" + CRLF + CRLF
    
    If AllTrim(cProdBD) == AllTrim(cProdDig)
        cMsg += "Resultado: IGUAL ?" + CRLF
        cMsg += "AllTrim removeu os espaços!" + CRLF
    Else
        cMsg += "Resultado: DIFERENTE ?" + CRLF
    EndIf
    
    cMsg += CRLF + Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? USO NO PROTHEUS:" + CRLF
    cMsg += "   cCodDig := '0001'" + CRLF
    cMsg += "   DbSelectArea('SB1')" + CRLF
    cMsg += "   DbSetOrder(1)  // B1_FILIAL+B1_COD" + CRLF + CRLF
    cMsg += "   // ERRADO (não vai achar):" + CRLF
    cMsg += "   DbSeek(xFilial('SB1')+cCodDig)" + CRLF + CRLF
    cMsg += "   // CORRETO:" + CRLF
    cMsg += "   DbSeek(xFilial('SB1')+PadR(cCodDig,15))" + CRLF
    cMsg += "   // OU validar com AllTrim:" + CRLF
    cMsg += "   If AllTrim(SB1->B1_COD) == AllTrim(cCodDig)"
    
    MsgInfo(cMsg, "AllTrim() - Comparação")
Return

// ==========================================================================
// Exemplo 2: Validar Campos Obrigatórios (MVC/Validações)
// ==========================================================================
/*
SITUAÇÃO REAL:
Usuário pode digitar só espaços em campos obrigatórios:
  Nome: "     " (vários espaços)
  
Empty() retorna FALSO (string não está vazia)
Mas AllTrim() + Empty() detecta o problema!
*/
Static Function fEx02()
    Local aCampos := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cNome   := ""
    
    // Simula dados digitados em cadastro de clientes
    aAdd(aCampos, {"Nome",     "João Silva",       .F.})
    aAdd(aCampos, {"Email",    "joao@email.com",   .F.})
    aAdd(aCampos, {"Telefone", "         ",        .F.})  // Só espaços!
    aAdd(aCampos, {"Endereço", "",                 .F.})  // Vazio
    aAdd(aCampos, {"Cidade",   "  ",               .F.})  // 2 espaços
    
    cMsg := "? VALIDAÇÃO DE CAMPOS OBRIGATÓRIOS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aCampos)
        cNome  := aCampos[nI][1]
        cMsg += PadR(cNome, 12) + ": "
        
        // Validação ERRADA (só Empty)
        If Empty(aCampos[nI][2])
            cMsg += "? Vazio (Empty)" + CRLF
        Else
            cMsg += "? Preenchido (Empty)" + CRLF
        EndIf
        
        // Validação CORRETA (AllTrim + Empty)
        cMsg += Space(14)
        If Empty(AllTrim(aCampos[nI][2]))
            cMsg += "? Vazio (AllTrim+Empty) ?? REAL" + CRLF
        Else
            cMsg += "? Preenchido (AllTrim+Empty)" + CRLF
        EndIf
        
        cMsg += CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO EM MVC:" + CRLF
    cMsg += "   // No modelo (Model)" + CRLF
    cMsg += "   oStruSA1:SetProperty('A1_NOME', " + CRLF
    cMsg += "      MODEL_FIELD_VALID, {||fVldNome()})" + CRLF + CRLF
    cMsg += "   Static Function fVldNome()" + CRLF
    cMsg += "      Local cNome := M->A1_NOME" + CRLF
    cMsg += "      If Empty(AllTrim(cNome))" + CRLF
    cMsg += "         Help(,,'NOME_OBR',,'Nome obrigatório!',1)" + CRLF
    cMsg += "         Return .F." + CRLF
    cMsg += "      EndIf" + CRLF
    cMsg += "   Return .T."
    
    MsgInfo(cMsg, "AllTrim() - Validação")
Return

// ==========================================================================
// Exemplo 3: Preparar Dados para Exportação (Integração)
// ==========================================================================
/*
SITUAÇÃO REAL:
Ao exportar dados para XML, JSON ou CSV, espaços extras:
- Aumentam tamanho do arquivo
- Causam problemas em sistemas externos
- Dificultam validações
- Geram erros em layouts fixos
*/
Static Function fEx03()
    Local aProduto := {}
    Local cMsg     := ""
    Local cArqSem  := ""
    Local cArqCom  := ""
    
    // Simula dados do produto vindo do banco (com espaços)
    aAdd(aProduto, "PA0001         ")  // Código (15 chars)
    aAdd(aProduto, "NOTEBOOK       ")  // Descrição (15 chars)
    aAdd(aProduto, "5500.00")          // Preço
    aAdd(aProduto, "UN  ")             // Unidade (4 chars)
    
    cMsg := "?? EXPORTAÇÃO DE DADOS - CSV" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    // Exportação SEM AllTrim (errada)
    cArqSem := aProduto[1] + ";" + aProduto[2] + ";" + aProduto[3] + ";" + aProduto[4]
    
    cMsg += "? SEM ALLTRIM:" + CRLF
    cMsg += cArqSem + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cArqSem)) + " bytes" + CRLF
    cMsg += "Problema: Espaços desnecessários!" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Exportação COM AllTrim (correta)
    cArqCom := AllTrim(aProduto[1]) + ";" + ;
               AllTrim(aProduto[2]) + ";" + ;
               AllTrim(aProduto[3]) + ";" + ;
               AllTrim(aProduto[4])
    
    cMsg += "? COM ALLTRIM:" + CRLF
    cMsg += cArqCom + CRLF
    cMsg += "Tamanho: " + cValToChar(Len(cArqCom)) + " bytes" + CRLF
    cMsg += "Economia: " + cValToChar(Len(cArqSem) - Len(cArqCom)) + " bytes" + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? EXPORTAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   While !SB1->(Eof())" + CRLF
    cMsg += "      cLinha := AllTrim(SB1->B1_COD) + ';'" + CRLF
    cMsg += "      cLinha += AllTrim(SB1->B1_DESC) + ';'" + CRLF
    cMsg += "      cLinha += cValToChar(SB1->B1_PRV1)" + CRLF
    cMsg += "      FWrite(nHandle, cLinha + CRLF)" + CRLF
    cMsg += "      SB1->(DbSkip())" + CRLF
    cMsg += "   EndDo"
    
    MsgInfo(cMsg, "AllTrim() - Exportação")
Return

// ==========================================================================
// Exemplo 4: Montar Chave Composta (Seeks e Índices)
// ==========================================================================
/*
SITUAÇÃO REAL:
Chaves compostas precisam ter tamanhos exatos:
  Filial (2) + Produto (15) + Local (2) = 19 caracteres
  
Se não usar PadR ou AllTrim corretamente, o DbSeek não funciona!
*/
Static Function fEx04()
    Local cFilMsg  := "01"
    Local cProduto := "PA0001"
    Local cLocal   := "01"
    Local cChave1  := ""
    Local cChave2  := ""
    Local cChave3  := ""
    Local cMsg     := ""
    
    cMsg := "?? MONTAGEM DE CHAVES COMPOSTAS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "?? ESTRUTURA DO ÍNDICE SB2 (Saldos):" + CRLF
    cMsg += "   B2_FILIAL (2) + B2_COD (15) + B2_LOCAL (2)" + CRLF
    cMsg += "   Total: 19 caracteres" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Forma 1: ERRADA (tamanhos diferentes)
    cChave1 := cFilMsg + cProduto + cLocal
    cMsg += "? FORMA 1 - CONCATENAÇÃO DIRETA:" + CRLF
    cMsg += "   cChave := cFilMsg + cProduto + cLocal" + CRLF
    cMsg += "   Resultado: '" + cChave1 + "'" + CRLF
    cMsg += "   Tamanho: " + cValToChar(Len(cChave1)) + " chars" + CRLF
    cMsg += "   Problema: Só 10 chars! Faltam 9!" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Forma 2: CORRETA (usando PadR)
    cChave2 := PadR(cFilMsg, 2) + PadR(cProduto, 15) + PadR(cLocal, 2)
    cMsg += "? FORMA 2 - COM PADR:" + CRLF
    cMsg += "   cChave := PadR(cFilMsg,2) + " + CRLF
    cMsg += "             PadR(cProduto,15) + " + CRLF
    cMsg += "             PadR(cLocal,2)" + CRLF
    cMsg += "   Resultado: '" + cChave2 + "'" + CRLF
    cMsg += "   Tamanho: " + cValToChar(Len(cChave2)) + " chars ?" + CRLF + CRLF
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Forma 3: CORRETA (usando xFilial)
    cChave3 := xFilial("SB2") + PadR("PA0001", 15) + PadR("01", 2)
    cMsg += "? FORMA 3 - FORMA PROTHEUS:" + CRLF
    cMsg += "   cChave := xFilial('SB2') + " + CRLF
    cMsg += "             PadR(cProduto, TamSX3('B2_COD')[1]) + " + CRLF
    cMsg += "             PadR(cLocal, TamSX3('B2_LOCAL')[1])" + CRLF
    cMsg += "   Resultado: '" + cChave3 + "'" + CRLF
    cMsg += "   Tamanho: " + cValToChar(Len(cChave3)) + " chars ?" + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? BUSCA NO PROTHEUS:" + CRLF
    cMsg += "   DbSelectArea('SB2')" + CRLF
    cMsg += "   DbSetOrder(1)  // B2_FILIAL+B2_COD+B2_LOCAL" + CRLF + CRLF
    cMsg += "   cChave := xFilial('SB2') + " + CRLF
    cMsg += "             PadR('PA0001', 15) + " + CRLF
    cMsg += "             PadR('01', 2)" + CRLF + CRLF
    cMsg += "   If DbSeek(cChave)" + CRLF
    cMsg += "      // Achou o registro!"
    
    MsgInfo(cMsg, "PadR() - Chaves Compostas")
Return

// ==========================================================================
// Exemplo 5: Formatar Dados para Exibição (Relatórios)
// ==========================================================================
/*
SITUAÇÃO REAL:
Relatórios precisam de dados "limpos" para boa apresentação:
- Remover espaços extras
- Alinhar textos
- Formatar endereços
- Compor descrições
*/
Static Function fEx05()
    Local aClient := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cNome   := ""
    Local cEnd    := ""
    Local cCidade := ""
    Local cUF     := ""
    
    // Simula dados do banco SA1 (com espaços)
    aAdd(aClient, {"EMPRESA ABC LTDA       ", "RUA DAS FLORES  ", "SAO PAULO       ", "SP"})
    aAdd(aClient, {"INDUSTRIA XYZ SA       ", "AV PAULISTA     ", "SAO PAULO       ", "SP"})
    aAdd(aClient, {"COMERCIO 123           ", "RUA COMERCIO    ", "CAMPINAS        ", "SP"})
    
    cMsg := "?? FORMATAÇÃO PARA RELATÓRIOS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    cMsg += "? SEM FORMATAÇÃO:" + CRLF + CRLF
    For nI := 1 To Len(aClient)
        cMsg += aClient[nI][1] + " - " + aClient[nI][2] + CRLF
        cMsg += aClient[nI][3] + "/" + aClient[nI][4] + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    cMsg += "? COM FORMATAÇÃO (ALLTRIM):" + CRLF + CRLF
    For nI := 1 To Len(aClient)
        cNome   := AllTrim(aClient[nI][1])
        cEnd    := AllTrim(aClient[nI][2])
        cCidade := AllTrim(aClient[nI][3])
        cUF     := AllTrim(aClient[nI][4])
        
        cMsg += "?? " + cNome + CRLF
        cMsg += "?? " + cEnd + " - " + cCidade + "/" + cUF + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? FORMATAÇÃO EM RELATÓRIOS:" + CRLF
    cMsg += "   // Mount Block no TReport" + CRLF
    cMsg += "   oSection:Cell('NOME'):SetValue(" + CRLF
    cMsg += "      AllTrim(SA1->A1_NOME))" + CRLF + CRLF
    cMsg += "   // Endereço completo" + CRLF
    cMsg += "   cEndereco := AllTrim(SA1->A1_END) + ', '" + CRLF
    cMsg += "   cEndereco += AllTrim(SA1->A1_MUN) + '/' + CRLF
    cMsg += "   cEndereco += AllTrim(SA1->A1_EST)"
    
    MsgInfo(cMsg, "AllTrim() - Formatação")
Return
