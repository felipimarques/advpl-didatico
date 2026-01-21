# STR01 - Operador Cifrão ($)

> **Módulo:** 02-Strings  
> **Nível:** ?? Iniciante  
> **Tempo estimado:** 15 minutos

---

## ?? Objetivo

Aprender a usar o **operador $ (cifrão)** para verificar se um texto está contido dentro de outro texto em ADVPL.

**Ao final deste módulo, você será capaz de:**
- ? Entender como funciona o operador $
- ? Verificar se uma palavra existe dentro de um texto
- ? Criar validações simples (ex: verificar se e-mail contém @)
- ? Aplicar o operador em situações práticas do dia a dia

---

## ?? Pré-requisitos

Antes de começar, você deve conhecer:

- [x] Variáveis do tipo Character
- [x] Operadores de comparação básicos (==, !=)
- [x] Estruturas condicionais (If/Else)

**Conhecimentos opcionais (ajudam, mas não são obrigatórios):**
- Funções de string (Upper, Lower, AllTrim)

---

## ?? Teoria

### O que é o Operador $ (Cifrão)?

O operador **$** em ADVPL é usado para **verificar se uma string está contida dentro de outra string**. Ele retorna um valor lógico:
- **.T. (verdadeiro)** se o texto foi encontrado
- **.F. (falso)** se o texto não foi encontrado

**Exemplo do mundo real:**
> Imagine que você tem uma frase: "O programador Felipi usa ADVPL"  
> Se você perguntar: "A palavra 'ADVPL' está nesta frase?"  
> O operador $ responde: "Sim! Está contida nela."

### Quando usar?

- ? **Use quando:** Precisa verificar se uma palavra existe em um texto
- ? **Use quando:** Quer validar formatos (ex: e-mail tem @?)
- ? **Use quando:** Precisa filtrar dados por palavras-chave
- ? **Evite quando:** Precisa de validações complexas (use RegEx)

### Sintaxe

```advpl
lResultado := cTextoBuscado $ cTextoCompleto
```

**Explicação:**
- `cTextoBuscado` = O que você quer procurar
- `cTextoCompleto` = Onde você quer procurar
- `lResultado` = .T. se encontrou, .F. se não encontrou

**Parâmetros:**
| Elemento | Tipo | Obrigatório | Descrição |
|----------|------|:-----------:|-----------|
| `cTextoBuscado` | Character | Sim | Texto que você está procurando |
| `cTextoCompleto` | Character | Sim | Texto onde será feita a busca |

**Retorno:**
- **Tipo:** Logical
- **Descrição:** .T. se o texto foi encontrado, .F. caso contrário

---

## ?? Código Explicado

### Código Completo

Veja o arquivo [STR01_Cifrao.prw](STR01_Cifrao.prw) para o código completo.

### Explicação Linha a Linha

#### Exemplo 1: Busca Básica

```advpl
// Declaramos o texto completo
Local cTexto := "FELIPI MARQUES"

// Declaramos o que queremos buscar
Local cBusca := "FELIPI"

// Usamos o operador $ para verificar
Local lEncont := cBusca $ cTexto

// Resultado: .T. (verdadeiro), pois "FELIPI" está em "FELIPI MARQUES"
```

#### Exemplo 2: Validação de E-mail

```advpl
// Função que valida se um e-mail contém @
Static Function fVldEmail(cEmail)
    // Verifica se o caractere @ está presente
    Local lValido := "@" $ cEmail
    
    // Se não encontrou @, o e-mail é inválido
    If !lValido
        MsgStop("E-mail inválido! Falta o @", "Validação")
    EndIf
    
Return lValido
```

**Como funciona:**
1. O operador `$` procura o caractere `@` dentro do texto do e-mail
2. Se encontrar, retorna `.T.` (e-mail válido)
3. Se não encontrar, retorna `.F.` (e-mail inválido)

#### Exemplo 3: Filtro de Palavras

```advpl
// Função que verifica se um texto contém a palavra "ADVPL"
Static Function fFilPalav(cTexto)
    // Converte para maiúsculo para ignorar maiúsculas/minúsculas
    Local lContem := "ADVPL" $ Upper(cTexto)
    
Return lContem
```

**Dica:** Use `Upper()` para tornar a busca **case-insensitive** (ignora maiúsculas e minúsculas).

### Fluxograma

```
???????????????????????
?  Início da Busca    ?
???????????????????????
           ?
           ?
???????????????????????
? cBusca $ cTexto?    ????? Operador $ faz a verificação
???????????????????????
           ?
     ?????????????
     ?           ?
    SIM         NÃO
     ?           ?
     ?           ?
??????????? ???????????
? .T.     ? ? .F.     ?
?(Encontrou)?(Não Achou)?
??????????? ???????????
```

---

## ?? Pontos de Atenção

### ?? Erros Comuns

**1. Erro:** Confundir a ordem dos operandos

```advpl
// ? ERRADO - Ordem invertida
Local cTexto := "FELIPI"
Local lResult := "FELIPI MARQUES" $ cTexto  // Procura o maior no menor

// Resultado: .F. (falso), pois "FELIPI MARQUES" não cabe em "FELIPI"
```

**Solução:**
```advpl
// ? CORRETO - Ordem correta
Local cTexto := "FELIPI MARQUES"
Local lResult := "FELIPI" $ cTexto  // Procura o menor no maior

// Resultado: .T. (verdadeiro)
```

**Regra de Ouro:** O que você quer **procurar** vem **antes** do $  
O onde você quer **procurar** vem **depois** do $

---

**2. Erro:** Não considerar maiúsculas e minúsculas

```advpl
// ? ERRADO - Case-sensitive
Local cTexto := "Felipi Marques"
Local lResult := "FELIPI" $ cTexto  // Procura maiúscula no texto misto

// Resultado: .F. (falso), pois "FELIPI" ? "Felipi"
```

**Solução:**
```advpl
// ? CORRETO - Converte tudo para maiúsculo
Local cTexto := "Felipi Marques"
Local lResult := "FELIPI" $ Upper(cTexto)

// Resultado: .T. (verdadeiro)
```

---

**3. Erro:** Não validar se a variável está vazia

```advpl
// ? ERRADO - Pode dar erro se variável estiver Nil
Local cTexto
Local lResult := "FELIPI" $ cTexto  // cTexto está Nil!
```

**Solução:**
```advpl
// ? CORRETO - Valida antes de usar
Local cTexto := ""

If cTexto != Nil .And. !Empty(cTexto)
    Local lResult := "FELIPI" $ cTexto
Else
    MsgStop("Texto não informado!", "Erro")
EndIf
```

---

### ?? Dicas de Boas Práticas

- ? **Use Upper()** para buscas que não diferenciam maiúsculas/minúsculas
- ? **Valide entradas** antes de usar o operador $
- ? **Use AllTrim()** para remover espaços em branco nas pontas
- ? **Prefira nomes descritivos** para variáveis: `lEmailValido` é melhor que `lResult`

### ?? Otimizações

```advpl
// ? Versão básica (funciona, mas pode melhorar)
Local cTexto := "  Felipi Marques  "
Local lResult := "FELIPI" $ cTexto  // Pode não encontrar por causa dos espaços

// ? Versão otimizada (melhor resultado)
Local cTexto := "  Felipi Marques  "
Local lResult := "FELIPI" $ Upper(AllTrim(cTexto))  // Remove espaços e converte
```

---

## ?? Exemplos Práticos

### Exemplo 1: Validador de CPF Básico

**Cenário:** Verificar se um CPF contém apenas números (versão simplificada)

```advpl
User Function VALCPF()
    Local cCPF := "123.456.789-00"
    Local lValido := .F.
    
    // Verifica se contém caracteres inválidos
    If "." $ cCPF .Or. "-" $ cCPF
        MsgInfo("CPF contém pontuação. Remova pontos e traços.", "Validação")
        lValido := .F.
    Else
        lValido := .T.
    EndIf
    
Return lValido
```

**Resultado:**
```
[Alerta]
CPF contém pontuação. Remova pontos e traços.
```

---

### Exemplo 2: Filtro de Comentários

**Cenário:** Sistema que bloqueia comentários com palavras proibidas

```advpl
User Function FILCOM()
    Local cComent := "Este produto é muito bom!"
    Local lBloq := .F.
    
    // Lista de palavras proibidas
    If "ruim" $ Lower(cComent) .Or. "péssimo" $ Lower(cComent)
        MsgStop("Comentário bloqueado! Contém palavras proibidas.", "Filtro")
        lBloq := .T.
    Else
        MsgInfo("Comentário aprovado!", "Filtro")
    EndIf
    
Return lBloq
```

**Resultado:**
```
[Sucesso]
Comentário aprovado!
```

---

### Exemplo 3: Busca de CEP

**Cenário:** Verificar se um endereço pertence a São Paulo (CEP inicia com 0)

```advpl
User Function BUSCEP()
    Local cCEP := "01310-100"
    Local lSaoPau := .F.
    
    // CEPs de SP começam com 0
    lSaoPau := "01" $ cCEP .Or. "02" $ cCEP .Or. "03" $ cCEP
    
    If lSaoPau
        MsgInfo("Este CEP é de São Paulo - SP", "Localização")
    Else
        MsgInfo("Este CEP não é de São Paulo", "Localização")
    EndIf
    
Return lSaoPau
```

**Resultado:**
```
[Sucesso]
Este CEP é de São Paulo - SP
```

---

## ?? Exercícios Práticos

### ?? Exercício 1 - Nível Fácil

**Desafio:** Crie uma função que verifica se uma URL contém "https://" (site seguro)

**Dica:** Use o operador $ para procurar "https://" na URL

<details>
<summary>?? Ver Solução</summary>

```advpl
User Function VLDURL()
    Local cURL := "https://www.exemplo.com.br"
    Local lSeguro := "https://" $ Lower(cURL)
    
    If lSeguro
        MsgInfo("? Site SEGURO (HTTPS)", "Validação")
    Else
        MsgStop("? Site INSEGURO (HTTP)", "Validação")
    EndIf
    
Return lSeguro
```

**Explicação:**
- Usa `Lower()` para tornar a busca case-insensitive
- Verifica se "https://" está presente na URL
- Retorna .T. se seguro, .F. se inseguro

</details>

---

### ?? Exercício 2 - Nível Médio

**Desafio:** Crie uma função que valida se um telefone contém o DDD (formato: "(11) 98765-4321")

**Requisitos:**
- [ ] Deve verificar se contém parênteses "(" e ")"
- [ ] Deve retornar .T. se válido, .F. se inválido

<details>
<summary>?? Ver Solução</summary>

```advpl
User Function VLDTEL()
    Local cTel := "(11) 98765-4321"
    Local lValid := .F.
    
    // Verifica se contém ( e )
    If "(" $ cTel .And. ")" $ cTel
        MsgInfo("? Telefone VÁLIDO com DDD", "Validação")
        lValid := .T.
    Else
        MsgStop("? Telefone INVÁLIDO - Falta DDD", "Validação")
        lValid := .F.
    EndIf
    
Return lValid
```

**Explicação:**
- Verifica se ambos os parênteses estão presentes
- Usa operador `.And.` para combinar as verificações
- Retorna resultado lógico

</details>

---

### ?? Exercício 3 - Nível Difícil

**Desafio:** Crie uma função que valida se um e-mail é de domínio corporativo (@empresa.com.br)

**Requisitos:**
- [ ] Deve aceitar apenas e-mails que contenham "@empresa.com.br"
- [ ] Deve rejeitar e-mails de outros domínios
- [ ] Deve exibir mensagem explicativa

<details>
<summary>?? Ver Solução</summary>

```advpl
User Function VLDEMC()
    Local cEmail := "contato@empresa.com.br"
    Local cDomini := "@empresa.com.br"
    Local lCorpo := .F.
    
    // Valida se não está vazio
    If Empty(cEmail)
        MsgStop("E-mail não informado!", "Validação")
        Return .F.
    EndIf
    
    // Verifica se é do domínio corporativo
    lCorpo := cDomini $ Lower(cEmail)
    
    If lCorpo
        MsgInfo("? E-mail CORPORATIVO válido: " + CRLF + cEmail, "Validação")
    Else
        MsgStop("? Apenas e-mails corporativos!" + CRLF + ;
                "Use: seunome@empresa.com.br", "Validação")
    EndIf
    
Return lCorpo
```

**Explicação:**
- Valida entrada vazia primeiro
- Usa `Lower()` para busca case-insensitive
- Verifica se o domínio completo está presente
- Exibe mensagens amigáveis ao usuário

</details>

---

## ?? Checklist de Aprendizado

Antes de avançar, você deve ser capaz de:

- [ ] Explicar com suas palavras o que faz o operador $
- [ ] Identificar qual texto vem antes e qual vem depois do $
- [ ] Criar uma validação simples usando o operador $
- [ ] Usar Upper() para busca case-insensitive
- [ ] Resolver os 3 exercícios práticos sem consultar

---

## ?? Referências

### Documentação Oficial
- [TDN - Operadores Comuns](https://tdn.totvs.com/display/tec/Operadores+Comuns)
- [TDN - Tipos de Dados](https://tdn.totvs.com/display/tec/Tipos+de+Dados)

### Material Complementar
- [Manual Completo MSYSR](../../.github/instructions/Manual_Exemplos_AdvPL_Completo.md)

---

## ?? Próximos Passos

### O que vem depois?

Agora que você dominou o operador $, está pronto para:

1. **[STR02 - SubStr](STR02_Manual.md)** - Extrair partes de um texto
2. **[STR03 - At](STR03_Manual.md)** - Encontrar a posição de um texto

### Sugestão de Ordem

```
01-Fundamentos ? STR01 (Você está aqui) ? STR02 ? STR03
```

---

## ?? Dúvidas?

- ?? Abra uma [Issue](https://github.com/felipimarques/advpl-didatico/issues)
- ?? Inicie uma [Discussão](https://github.com/felipimarques/advpl-didatico/discussions)

---

<div align="center">

**? Gostou? Deixe uma estrela no repositório!**

[?? Voltar](../README.md) | [?? Topo](#str01---operador-cifrão-) | [Próximo: STR02 ??](STR02_Manual.md)

</div>
