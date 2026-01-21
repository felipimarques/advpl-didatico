// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} STR03
Exemplos práticos da função At() em situações reais do Protheus

A função At() encontra a posição de um texto dentro de outro. É essencial para:
- Validar formato de dados (email, telefone, CNPJ)
- Separar strings compostas (nome completo, endereço)
- Encontrar separadores em códigos estruturados
- Processar arquivos de importação (CSV, TXT)

@type User Function
@author Felipi Marques
@since 21/01/2026

@obs At(cBusca, cTexto) retorna a posição onde cBusca aparece em cTexto
@obs Retorna 0 (zero) se não encontrar
@obs Retorna a posição do PRIMEIRO caractere encontrado

@example
U_STR03()

@see
https://tdn.totvs.com/display/tec/At
/*/

// ==========================================================================
// Função Principal - Menu de Exemplos
// ==========================================================================
User Function STR03()
    Local aArea   := GetArea()
    Local nOpcao  := 0
    
    While .T.
        nOpcao := fMenuEx()
        
        If nOpcao == 0
            Exit
        EndIf
        
        Do Case
            Case nOpcao == 1
                fEx01()  // Validar formato de email
            Case nOpcao == 2
                fEx02()  // Separar nome e sobrenome
            Case nOpcao == 3
                fEx03()  // Validar formato de CNPJ
            Case nOpcao == 4
                fEx04()  // Processar linha CSV (importação)
            Case nOpcao == 5
                fEx05()  // Extrair domínio de email
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
    
    aAdd(aOpcoes, "1 - Validar formato de email")
    aAdd(aOpcoes, "2 - Separar nome e sobrenome")
    aAdd(aOpcoes, "3 - Validar formato de CNPJ")
    aAdd(aOpcoes, "4 - Processar importação CSV")
    aAdd(aOpcoes, "5 - Extrair domínio de email")
    aAdd(aOpcoes, "0 - Sair")
    
    nOpcao := Val(Aviso("At() - Exemplos", ;
                        "Escolha um exemplo:", ;
                        aOpcoes, 3))
Return nOpcao

// ==========================================================================
// Exemplo 1: Validar Formato de Email (Cadastro SA1/SA2/SA3)
// ==========================================================================
/*
SITUAÇÃO REAL:
Ao cadastrar clientes, fornecedores ou vendedores, o email precisa ter:
- Um @ (arroba)
- Um ponto depois do @
- Caracteres antes e depois

Você usa At() para encontrar as posições e validar a estrutura.
*/
Static Function fEx01()
    Local aEmails := {}
    Local cMsg    := ""
    Local nI      := 0
    
    // Simula emails de cadastros
    aAdd(aEmails, "contato@empresa.com.br")    // Válido
    aAdd(aEmails, "vendedor@totvs.com")        // Válido
    aAdd(aEmails, "cliente.empresa.com")       // Inválido (sem @)
    aAdd(aEmails, "suporte@protheus")          // Inválido (sem ponto após @)
    aAdd(aEmails, "@semprefico.com")           // Inválido (sem texto antes @)
    
    cMsg := "?? VALIDAÇÃO DE EMAILS - CADASTROS" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aEmails)
        cMsg += cValToChar(nI) + ". " + aEmails[nI] + CRLF
        cMsg += "   " + fVldEmail(aEmails[nI]) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   cEmail := SA1->A1_EMAIL" + CRLF
    cMsg += "   nPosArr := At('@', cEmail)" + CRLF
    cMsg += "   If nPosArr == 0" + CRLF
    cMsg += "      MsgStop('Email sem @!')" + CRLF
    cMsg += "   EndIf"
    
    MsgInfo(cMsg, "At() - Validação de Email")
Return

Static Function fVldEmail(cEmail)
    Local nPosArr := 0
    Local nPosPto := 0
    Local cResult := ""
    
    // Procura @ no email
    nPosArr := At("@", cEmail)
    
    If nPosArr == 0
        Return "? INVÁLIDO - Não contém @"
    EndIf
    
    If nPosArr == 1
        Return "? INVÁLIDO - Não tem texto antes do @"
    EndIf
    
    // Procura ponto DEPOIS do @
    // SubStr pega texto após o @, depois procura o ponto
    nPosPto := At(".", SubStr(cEmail, nPosArr + 1))
    
    If nPosPto == 0
        Return "? INVÁLIDO - Não tem ponto após o @"
    EndIf
    
    If nPosPto == 1
        Return "? INVÁLIDO - Ponto logo após @ (ex: user@.com)"
    EndIf
    
    cResult := "? VÁLIDO - @ na posição " + cValToChar(nPosArr)
    cResult += ", ponto " + cValToChar(nPosPto) + " posições após @"
Return cResult

// ==========================================================================
// Exemplo 2: Separar Nome e Sobrenome (Cadastro SA1/SA3/SRA)
// ==========================================================================
/*
SITUAÇÃO REAL:
Cadastros podem ter nome completo em um único campo.
Você precisa separar em Nome e Sobrenome para:
- Relatórios personalizados
- Etiquetas de correspondência
- Integração com outros sistemas
- Envio de emails personalizados
*/
Static Function fEx02()
    Local aNomes := {}
    Local cMsg   := ""
    Local nI     := 0
    Local cNome  := ""
    Local cSobre := ""
    Local nPos   := 0
    
    // Simula nomes de cadastros
    aAdd(aNomes, "João Silva")
    aAdd(aNomes, "Maria Santos Oliveira")
    aAdd(aNomes, "Pedro")
    aAdd(aNomes, "Ana Paula Costa")
    
    cMsg := "?? SEPARAÇÃO DE NOME E SOBRENOME" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aNomes)
        // Procura o primeiro espaço
        nPos := At(" ", aNomes[nI])
        
        cMsg += "Nome completo: " + aNomes[nI] + CRLF
        
        If nPos > 0
            // Tem espaço - separa nome e sobrenome
            cNome  := SubStr(aNomes[nI], 1, nPos - 1)
            cSobre := SubStr(aNomes[nI], nPos + 1)
            
            cMsg += "   ?? Nome: " + cNome + CRLF
            cMsg += "   ?? Sobrenome: " + cSobre + CRLF
        Else
            // Não tem espaço - só tem nome
            cMsg += "   ?? Nome: " + aNomes[nI] + CRLF
            cMsg += "   ?? Sem sobrenome" + CRLF
        EndIf
        
        cMsg += CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? USO EM RELATÓRIOS:" + CRLF
    cMsg += "   cNomeCom := SA1->A1_NOME" + CRLF
    cMsg += "   nPos := At(' ', cNomeCom)" + CRLF
    cMsg += "   cNome := SubStr(cNomeCom, 1, nPos-1)" + CRLF + CRLF
    cMsg += "   'Olá, ' + cNome + '!'"
    
    MsgInfo(cMsg, "At() - Nome e Sobrenome")
Return

// ==========================================================================
// Exemplo 3: Validar Formato de CNPJ (Cadastro SA1/SA2)
// ==========================================================================
/*
SITUAÇÃO REAL:
CNPJ pode ser digitado de duas formas:
- Formatado: 12.345.678/0001-95
- Sem formatação: 12345678000195

Você precisa validar se tem os separadores corretos quando formatado.
*/
Static Function fEx03()
    Local aCNPJs := {}
    Local cMsg   := ""
    Local nI     := 0
    
    // Simula CNPJs digitados pelos usuários
    aAdd(aCNPJs, "12.345.678/0001-95")    // Formato correto
    aAdd(aCNPJs, "12345678000195")        // Sem formatação
    aAdd(aCNPJs, "12.345.678.0001-95")    // Formato errado (ponto em vez de barra)
    aAdd(aCNPJs, "12.345.678/000195")     // Formato errado (sem hífen)
    
    cMsg := "?? VALIDAÇÃO DE FORMATO DE CNPJ" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    For nI := 1 To Len(aCNPJs)
        cMsg += cValToChar(nI) + ". " + aCNPJs[nI] + CRLF
        cMsg += "   " + fVldCNPJ(aCNPJs[nI]) + CRLF + CRLF
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? VALIDAÇÃO NO CADASTRO:" + CRLF
    cMsg += "   cCNPJ := SA1->A1_CGC" + CRLF
    cMsg += "   nPosBarra := At('/', cCNPJ)" + CRLF
    cMsg += "   nPosHifen := At('-', cCNPJ)" + CRLF + CRLF
    cMsg += "   // Se tem formatação, validar posições" + CRLF
    cMsg += "   If nPosBarra > 0" + CRLF
    cMsg += "      // Barra deve estar na posição 12"
    
    MsgInfo(cMsg, "At() - Validação CNPJ")
Return

Static Function fVldCNPJ(cCNPJ)
    Local nPosBarra := 0
    Local nPosHifen := 0
    Local cResult   := ""
    
    // Remove espaços
    cCNPJ := AllTrim(cCNPJ)
    
    // Procura barra e hífen
    nPosBarra := At("/", cCNPJ)
    nPosHifen := At("-", cCNPJ)
    
    // Se não tem formatação (só números)
    If nPosBarra == 0 .And. nPosHifen == 0
        If Len(cCNPJ) == 14
            Return "? SEM FORMATAÇÃO - 14 dígitos corretos"
        Else
            Return "? INVÁLIDO - Deveria ter 14 dígitos"
        EndIf
    EndIf
    
    // Tem formatação - validar posições
    If nPosBarra == 0
        Return "? FORMATO INVÁLIDO - Falta barra (/)"
    EndIf
    
    If nPosHifen == 0
        Return "? FORMATO INVÁLIDO - Falta hífen (-)"
    EndIf
    
    // Formato: XX.XXX.XXX/XXXX-XX
    // Barra deve estar na posição 12
    // Hífen deve estar na posição 17
    If nPosBarra == 12 .And. nPosHifen == 17 .And. Len(cCNPJ) == 18
        cResult := "? FORMATO CORRETO - XX.XXX.XXX/XXXX-XX"
    Else
        cResult := "? FORMATO INCORRETO" + CRLF
        cResult += "      Barra: pos " + cValToChar(nPosBarra) + " (esperado: 12)" + CRLF
        cResult += "      Hífen: pos " + cValToChar(nPosHifen) + " (esperado: 17)"
    EndIf
Return cResult

// ==========================================================================
// Exemplo 4: Processar Linha CSV - Importação de Dados
// ==========================================================================
/*
SITUAÇÃO REAL:
Importação de dados de arquivos CSV é muito comum no Protheus:
- Importar produtos
- Importar clientes
- Importar notas fiscais
- Integração com sistemas externos

Você usa At() para encontrar os separadores (;) e extrair cada campo.
*/
Static Function fEx04()
    Local cLinha  := ""
    Local aCampos := {}
    Local cMsg    := ""
    Local nPos    := 0
    Local cResto  := ""
    Local nCampo  := 0
    
    // Simula linha de arquivo CSV (exemplo: importação de produtos)
    cLinha := "PA0001;NOTEBOOK DELL;5500.00;UN;12;INFORMATICA"
    
    cMsg := "?? PROCESSAMENTO DE IMPORTAÇÃO CSV" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "Linha original:" + CRLF
    cMsg += cLinha + CRLF + CRLF
    cMsg += Replicate("-", 60) + CRLF + CRLF
    
    // Processa a linha extraindo campos separados por ;
    cResto := cLinha
    nCampo := 1
    
    While .T.
        nPos := At(";", cResto)
        
        If nPos > 0
            // Encontrou separador - extrai campo
            aAdd(aCampos, SubStr(cResto, 1, nPos - 1))
            
            // Atualiza resto da string (pula o separador)
            cResto := SubStr(cResto, nPos + 1)
            
            nCampo++
        Else
            // Não tem mais separador - último campo
            aAdd(aCampos, cResto)
            Exit
        EndIf
    EndDo
    
    // Exibe campos extraídos
    cMsg += "Campos extraídos:" + CRLF + CRLF
    cMsg += "Campo 1 - Código: " + aCampos[1] + CRLF
    cMsg += "Campo 2 - Descrição: " + aCampos[2] + CRLF
    cMsg += "Campo 3 - Preço: R$ " + Transform(Val(aCampos[3]), "@E 9,999.99") + CRLF
    cMsg += "Campo 4 - Unidade: " + aCampos[4] + CRLF
    cMsg += "Campo 5 - Estoque: " + aCampos[5] + " unidades" + CRLF
    cMsg += "Campo 6 - Grupo: " + aCampos[6] + CRLF + CRLF
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? IMPORTAÇÃO NO PROTHEUS:" + CRLF
    cMsg += "   While !FT_FEof()  // Lê arquivo" + CRLF
    cMsg += "      cLinha := FT_FReadLn()" + CRLF
    cMsg += "      nPos := At(';', cLinha)" + CRLF
    cMsg += "      cCodigo := SubStr(cLinha, 1, nPos-1)" + CRLF
    cMsg += "      // Grava no banco..." + CRLF
    cMsg += "   EndDo"
    
    MsgInfo(cMsg, "At() - Importação CSV")
Return

// ==========================================================================
// Exemplo 5: Extrair Domínio de Email (Relatórios e Filtros)
// ==========================================================================
/*
SITUAÇÃO REAL:
Você precisa agrupar clientes por domínio de email:
- Vendas corporativas (todos @mesmaempresa.com)
- Relatórios por fornecedor de email
- Validação de emails corporativos vs pessoais
- Estatísticas de origem de clientes
*/
Static Function fEx05()
    Local aEmails := {}
    Local aDomin  := {}
    Local cMsg    := ""
    Local nI      := 0
    Local cDomin  := ""
    Local nPos    := 0
    
    // Simula emails de diferentes clientes
    aAdd(aEmails, "compras@empresaabc.com.br")
    aAdd(aEmails, "vendas@empresaabc.com.br")
    aAdd(aEmails, "joao@gmail.com")
    aAdd(aEmails, "contato@totvs.com.br")
    aAdd(aEmails, "suporte@totvs.com.br")
    aAdd(aEmails, "maria@hotmail.com")
    
    cMsg := "?? ANÁLISE DE DOMÍNIOS DE EMAIL" + CRLF
    cMsg += Replicate("=", 60) + CRLF + CRLF
    
    // Extrai domínios
    For nI := 1 To Len(aEmails)
        nPos := At("@", aEmails[nI])
        
        If nPos > 0
            cDomin := SubStr(aEmails[nI], nPos + 1)
            
            cMsg += aEmails[nI] + CRLF
            cMsg += "   ?? Domínio: " + cDomin + CRLF
            cMsg += "   ?? Tipo: " + fTipoDom(cDomin) + CRLF + CRLF
            
            // Adiciona ao array de domínios (para contar depois)
            aAdd(aDomin, cDomin)
        EndIf
    Next nI
    
    cMsg += Replicate("=", 60) + CRLF + CRLF
    cMsg += "?? ESTATÍSTICAS:" + CRLF
    cMsg += "   Total de emails: " + cValToChar(Len(aEmails)) + CRLF
    cMsg += "   Corporativos: " + cValToChar(fContaTipo(aDomin, .T.)) + CRLF
    cMsg += "   Pessoais: " + cValToChar(fContaTipo(aDomin, .F.)) + CRLF + CRLF
    
    cMsg += "?? FILTRO NO PROTHEUS:" + CRLF
    cMsg += "   cEmail := SA1->A1_EMAIL" + CRLF
    cMsg += "   nPos := At('@', cEmail)" + CRLF
    cMsg += "   cDominio := SubStr(cEmail, nPos+1)" + CRLF + CRLF
    cMsg += "   If 'gmail' $ cDominio" + CRLF
    cMsg += "      // Email pessoal"
    
    MsgInfo(cMsg, "At() - Domínios de Email")
Return

Static Function fTipoDom(cDomin)
    Local cTipo := ""
    
    If "gmail" $ cDomin .Or. "hotmail" $ cDomin .Or. "yahoo" $ cDomin
        cTipo := "PESSOAL"
    Else
        cTipo := "CORPORATIVO"
    EndIf
Return cTipo

Static Function fContaTipo(aDomin, lCorpo)
    Local nConta := 0
    Local nI     := 0
    
    For nI := 1 To Len(aDomin)
        If lCorpo
            // Conta corporativos
            If fTipoDom(aDomin[nI]) == "CORPORATIVO"
                nConta++
            EndIf
        Else
            // Conta pessoais
            If fTipoDom(aDomin[nI]) == "PESSOAL"
                nConta++
            EndIf
        EndIf
    Next nI
Return nConta
