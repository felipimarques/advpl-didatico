// ==========================================================================
// Bibliotecas Totvs
// ==========================================================================
#Include "TOTVS.ch"

/*/{Protheus.doc} UI03
Exemplos práticos de alertas framework

Funções abordadas:
- FwAlertInfo() - informação moderna
- FwAlertWarning() - aviso moderno
- FwAlertError() - erro moderno
- FwAlertSuccess() - sucesso
- FwAlertHelp() - ajuda

@type User Function
@author Felipi Marques
@since 18/01/2026

@example
U_UI03()
/*/

User Function UI03()
    Local aArea := GetArea()
    Local nOpc := 0
    
    While .T.
        nOpc := Aviso("Alertas Framework", ;
                     "1-FwAlertInfo" + CRLF + ;
                     "2-FwAlertWarning" + CRLF + ;
                     "3-FwAlertError" + CRLF + ;
                     "4-FwAlertSuccess" + CRLF + ;
                     "5-FwAlertHelp" + CRLF + ;
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
EXEMPLO 1: FwAlertInfo - Informação
*/
Static Function fEx01()
    
    // Exemplo 1: Simples
    FwAlertInfo("Cliente cadastrado com sucesso!", "Cadastro")
    
    // Exemplo 2: Com detalhes
    FwAlertInfo("Pedido incluído com sucesso!" + CRLF + CRLF + ;
                "Número: 000456" + CRLF + ;
                "Cliente: JOSE SILVA" + CRLF + ;
                "Valor: R$ 5.450,00", ;
                "Pedido de Venda")
    
    // Exemplo 3: Importação
    FwAlertInfo("Importação concluída!" + CRLF + CRLF + ;
                "? 15 clientes importados" + CRLF + ;
                "? 0 erros" + CRLF + ;
                "? 0 duplicados", ;
                "Importação Clientes")
    
    // Exemplo 4: Processamento
    FwAlertInfo("Processamento finalizado" + CRLF + CRLF + ;
                "Produtos atualizados: 125" + CRLF + ;
                "Tempo decorrido: 00:01:30", ;
                "Atualização Preços")
Return

/*
EXEMPLO 2: FwAlertWarning - Aviso
*/
Static Function fEx02()
    
    // Exemplo 1: Estoque baixo
    FwAlertWarning("?? ESTOQUE BAIXO" + CRLF + CRLF + ;
                   "Produto: NOTEBOOK" + CRLF + ;
                   "Código: PA001" + CRLF + ;
                   "Saldo: 3 unidades" + CRLF + CRLF + ;
                   "Ponto de pedido: 10 unidades", ;
                   "Atenção Estoque")
    
    // Exemplo 2: Pendência financeira
    FwAlertWarning("Cliente possui pendências" + CRLF + CRLF + ;
                   "• 2 títulos em atraso" + CRLF + ;
                   "• Valor total: R$ 5.450,00" + CRLF + ;
                   "• Maior atraso: 15 dias" + CRLF + CRLF + ;
                   "Verifique antes de liberar pedido", ;
                   "Pendências Financeiras")
    
    // Exemplo 3: Limite de crédito
    FwAlertWarning("Limite de crédito próximo ao máximo" + CRLF + CRLF + ;
                   "Utilizado: R$ 9.500,00" + CRLF + ;
                   "Limite: R$ 10.000,00" + CRLF + ;
                   "Disponível: R$ 500,00", ;
                   "Limite de Crédito")
    
    // Exemplo 4: Cadastro incompleto
    FwAlertWarning("Cadastro incompleto!" + CRLF + CRLF + ;
                   "Campos não preenchidos:" + CRLF + ;
                   "• Email" + CRLF + ;
                   "• Telefone" + CRLF + ;
                   "• Condição de pagamento" + CRLF + CRLF + ;
                   "Complete o cadastro para melhor atendimento", ;
                   "Dados Incompletos")
Return

/*
EXEMPLO 3: FwAlertError - Erro
*/
Static Function fEx03()
    
    // Exemplo 1: Validação
    FwAlertError("? CNPJ INVÁLIDO" + CRLF + CRLF + ;
                 "O CNPJ informado não é válido" + CRLF + CRLF + ;
                 "CNPJ: 12.345.678/0001-XX" + CRLF + CRLF + ;
                 "Digite apenas números", ;
                 "Erro de Validação")
    
    // Exemplo 2: Produto não encontrado
    FwAlertError("Produto não encontrado!" + CRLF + CRLF + ;
                 "Código: PA999" + CRLF + CRLF + ;
                 "Verifique o código e tente novamente", ;
                 "Erro na Busca")
    
    // Exemplo 3: Operação bloqueada
    FwAlertError("OPERAÇÃO BLOQUEADA" + CRLF + CRLF + ;
                 "Não é possível excluir este cliente" + CRLF + CRLF + ;
                 "Motivos:" + CRLF + ;
                 "• Possui 5 pedidos em aberto" + CRLF + ;
                 "• Possui 3 títulos a receber" + CRLF + CRLF + ;
                 "Regularize a situação antes de excluir", ;
                 "Exclusão Bloqueada")
    
    // Exemplo 4: Erro de processamento
    FwAlertError("ERRO NO PROCESSAMENTO" + CRLF + CRLF + ;
                 "Falha ao gerar NF-e" + CRLF + CRLF + ;
                 "Erro retornado:" + CRLF + ;
                 "IE do destinatário inválida" + CRLF + CRLF + ;
                 "Corrija o cadastro e tente novamente", ;
                 "Erro NF-e")
Return

/*
EXEMPLO 4: FwAlertSuccess - Sucesso
*/
Static Function fEx04()
    
    // Exemplo 1: Inclusão
    FwAlertSuccess("?? CLIENTE CADASTRADO!" + CRLF + CRLF + ;
                   "Código: 000789" + CRLF + ;
                   "Nome: MARIA SANTOS LTDA" + CRLF + ;
                   "CNPJ: 98.765.432/0001-88" + CRLF + CRLF + ;
                   "Cliente já pode realizar pedidos", ;
                   "Cadastro Concluído")
    
    // Exemplo 2: Aprovação
    FwAlertSuccess("? PEDIDO APROVADO!" + CRLF + CRLF + ;
                   "Número: 000456" + CRLF + ;
                   "Valor: R$ 15.750,00" + CRLF + CRLF + ;
                   "Aprovado por: GERENTE" + CRLF + ;
                   "Data/Hora: " + DToC(Date()) + " " + Time(), ;
                   "Aprovação")
    
    // Exemplo 3: Integração
    FwAlertSuccess("INTEGRAÇÃO CONCLUÍDA" + CRLF + CRLF + ;
                   "NF-e transmitida com sucesso" + CRLF + CRLF + ;
                   "Chave: 35210512345678000199550010000001231000000001" + CRLF + ;
                   "Protocolo: 999123456789012" + CRLF + ;
                   "Data: " + DToC(Date()) + " " + Time(), ;
                   "NF-e Autorizada")
    
    // Exemplo 4: Reajuste
    FwAlertSuccess("REAJUSTE APLICADO" + CRLF + CRLF + ;
                   "Produtos atualizados: 150" + CRLF + ;
                   "Percentual aplicado: 10%" + CRLF + ;
                   "Tempo decorrido: 00:00:45" + CRLF + CRLF + ;
                   "Novos preços já estão em vigor", ;
                   "Reajuste Concluído")
Return

/*
EXEMPLO 5: FwAlertHelp - Ajuda
*/
Static Function fEx05()
    
    // Exemplo 1: Instruções
    FwAlertHelp("?? COMO IMPORTAR CLIENTES" + CRLF + CRLF + ;
                "1. Prepare arquivo Excel com colunas:" + CRLF + ;
                "   • Código" + CRLF + ;
                "   • Nome" + CRLF + ;
                "   • CNPJ" + CRLF + ;
                "   • Cidade" + CRLF + ;
                "   • Estado" + CRLF + CRLF + ;
                "2. Salve como CSV (separado por ponto-vírgula)" + CRLF + CRLF + ;
                "3. Clique em Importar" + CRLF + CRLF + ;
                "4. Selecione o arquivo", ;
                "Importação de Clientes", ;
                "Importação")
    
    // Exemplo 2: Dicas
    FwAlertHelp("?? DICAS DE PREENCHIMENTO" + CRLF + CRLF + ;
                "CNPJ:" + CRLF + ;
                "• Digite apenas números" + CRLF + ;
                "• Exemplo: 12345678000199" + CRLF + CRLF + ;
                "CEP:" + CRLF + ;
                "• Digite 8 dígitos" + CRLF + ;
                "• Exemplo: 01234000" + CRLF + ;
                "• Sistema busca endereço automaticamente" + CRLF + CRLF + ;
                "Telefone:" + CRLF + ;
                "• Digite DDD + número" + CRLF + ;
                "• Exemplo: 11999999999", ;
                "Ajuda - Cadastro", ;
                "Cadastro")
    
    // Exemplo 3: Informação de campo
    FwAlertHelp("CAMPO: CONDIÇÃO DE PAGAMENTO" + CRLF + CRLF + ;
                "Define como o cliente irá pagar" + CRLF + CRLF + ;
                "Exemplos:" + CRLF + ;
                "• 001 = À vista" + CRLF + ;
                "• 002 = 30 dias" + CRLF + ;
                "• 003 = 30/60 dias" + CRLF + ;
                "• 004 = 30/60/90 dias" + CRLF + CRLF + ;
                "Consulte com o financeiro a melhor" + CRLF + ;
                "condição para cada cliente", ;
                "Ajuda - Campo", ;
                "Condição Pagamento")
    
    // Exemplo 4: Troubleshooting
    FwAlertHelp("?? SOLUÇÃO DE PROBLEMAS" + CRLF + CRLF + ;
                "PROBLEMA: Cliente não aparece na consulta" + CRLF + CRLF + ;
                "POSSÍVEIS CAUSAS:" + CRLF + ;
                "1. Cliente está bloqueado" + CRLF + ;
                "   Solução: Desbloquear no cadastro" + CRLF + CRLF + ;
                "2. Filtro aplicado" + CRLF + ;
                "   Solução: Limpar filtros (F12)" + CRLF + CRLF + ;
                "3. Cadastro incompleto" + CRLF + ;
                "   Solução: Complete campos obrigatórios" + CRLF + CRLF + ;
                "Ainda com problemas? Contate o suporte", ;
                "Troubleshooting", ;
                "Solução Problemas")
Return
