# ?? Módulo 02 - Strings

> **Manipulação de Textos em ADVPL**

Este módulo ensina como trabalhar com strings (textos) em ADVPL, desde operações básicas até manipulações avançadas.

---

## ?? O que você vai aprender

- ? Verificar se um texto contém outro texto
- ? Extrair partes de um texto (substring)
- ? Converter maiúsculas e minúsculas
- ? Remover espaços em branco
- ? Dividir e juntar textos
- ? Comparar textos de forma eficiente

---

## ??? Conteúdo do Módulo

| Código | Tópico | Nível | Tempo | Status |
|:------:|--------|:-----:|:-----:|:------:|
| **STR01** | [Operador Cifrão ($)](STR01_Manual.md) | ?? Iniciante | 15 min | ? |
| **STR02** | SubStr - Extrair texto | ?? Iniciante | 20 min | ? |
| **STR03** | At - Posição de texto | ?? Iniciante | 15 min | ? |
| **STR04** | Upper/Lower - Maiúsculas | ?? Iniciante | 10 min | ? |
| **STR05** | AllTrim/LTrim/RTrim | ?? Iniciante | 15 min | ? |
| **STR06** | Len - Tamanho do texto | ?? Iniciante | 10 min | ? |
| **STR07** | Left/Right - Extremidades | ?? Intermediário | 15 min | ? |
| **STR08** | StrTran - Substituir texto | ?? Intermediário | 20 min | ? |
| **STR09** | Stuff - Inserir texto | ?? Intermediário | 20 min | ? |
| **STR10** | Split - Dividir texto | ?? Intermediário | 25 min | ? |
| **STR11** | Replicate - Repetir texto | ?? Intermediário | 15 min | ? |
| **STR12** | Space - Espaços em branco | ?? Intermediário | 10 min | ? |
| **STR13** | PadL/PadR/PadC - Preencher | ?? Intermediário | 20 min | ? |
| **STR14** | StrZero - Zeros à esquerda | ?? Intermediário | 15 min | ? |
| **STR15** | Validação de Textos | ?? Avançado | 30 min | ? |

**Tempo total estimado:** 4-5 horas

---

## ?? Ordem Sugerida de Estudo

### ?? Fase 1 - Fundamentos (Comece aqui)

```
STR01 ($) ? STR04 (Upper/Lower) ? STR05 (AllTrim) ? STR06 (Len)
```

Essas são as funções mais usadas no dia a dia. Domine-as primeiro!

### ?? Fase 2 - Manipulação

```
STR02 (SubStr) ? STR03 (At) ? STR07 (Left/Right) ? STR08 (StrTran)
```

Aprenda a extrair, localizar e modificar partes de textos.

### ?? Fase 3 - Operações Avançadas

```
STR09 (Stuff) ? STR10 (Split) ? STR13 (Pad) ? STR14 (StrZero)
```

Técnicas para formatação e processamento de dados.

### ?? Fase 4 - Aplicações Práticas

```
STR15 (Validações)
```

Combine tudo que aprendeu em validações reais.

---

## ?? Casos de Uso Reais

### 1. Validação de E-mail
```advpl
// Verifica se e-mail é válido
If !("@" $ cEmail) .Or. !("." $ cEmail)
    MsgStop("E-mail inválido!", "Validação")
EndIf
```

### 2. Formatação de CPF
```advpl
// Formata CPF: 12345678900 ? 123.456.789-00
cCPF := SubStr(cCPF,1,3) + "." + SubStr(cCPF,4,3) + "." + ;
        SubStr(cCPF,7,3) + "-" + SubStr(cCPF,10,2)
```

### 3. Extração de Nome
```advpl
// Extrai primeiro nome de "Felipi Marques"
cPrimeiroNome := SubStr(cNome, 1, At(" ", cNome) - 1)
```

### 4. Limpeza de Dados
```advpl
// Remove espaços e converte para maiúsculo
cTexto := Upper(AllTrim(cTexto))
```

---

## ?? Tabela de Referência Rápida

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `$` | Verifica se contém | `"ABC" $ "ABCDEF"` ? .T. |
| `SubStr()` | Extrai parte do texto | `SubStr("ABCDEF",1,3)` ? "ABC" |
| `At()` | Posição do texto | `At("C","ABCDEF")` ? 3 |
| `Upper()` | Maiúsculas | `Upper("abc")` ? "ABC" |
| `Lower()` | Minúsculas | `Lower("ABC")` ? "abc" |
| `AllTrim()` | Remove espaços | `AllTrim(" ABC ")` ? "ABC" |
| `Len()` | Tamanho | `Len("ABCDEF")` ? 6 |
| `Left()` | Primeiros N caracteres | `Left("ABCDEF",3)` ? "ABC" |
| `Right()` | Últimos N caracteres | `Right("ABCDEF",3)` ? "DEF" |
| `StrTran()` | Substitui texto | `StrTran("ABC","A","X")` ? "XBC" |

---

## ?? Erros Comuns

### 1. Confundir ordem do operador $

```advpl
// ? ERRADO
"FELIPI MARQUES" $ "FELIPI"  // Procura o maior no menor

// ? CORRETO
"FELIPI" $ "FELIPI MARQUES"  // Procura o menor no maior
```

### 2. Esquecer de converter maiúsculas

```advpl
// ? ERRADO - Case-sensitive
"felipi" $ "FELIPI"  // .F.

// ? CORRETO
"felipi" $ Lower("FELIPI")  // .T.
```

### 3. Não validar antes de usar

```advpl
// ? ERRADO - Pode dar erro se Nil
cTexto $ cOutroTexto

// ? CORRETO
If cTexto != Nil .And. !Empty(cTexto)
    lResult := cTexto $ cOutroTexto
EndIf
```

---

## ?? Projeto Prático

Ao final deste módulo, você será capaz de criar um **Validador de Dados Completo**:

```advpl
User Function VALID()
    Local cNome    := "  Felipi Marques  "
    Local cEmail   := "contato@empresa.com.br"
    Local cCPF     := "12345678900"
    Local cTel     := "(11) 98765-4321"
    
    // Limpa e valida nome
    cNome := Upper(AllTrim(cNome))
    If Empty(cNome)
        FWAlertError("Nome obrigatório!", "Validação")
        Return
    EndIf
    
    // Valida e-mail
    If !("@" $ cEmail) .Or. !("." $ cEmail)
        FWAlertError("E-mail inválido!", "Validação")
        Return
    EndIf
    
    // Formata CPF
    If Len(cCPF) == 11
        cCPF := Transform(cCPF, "@R 999.999.999-99")
    EndIf
    
    // Valida telefone
    If !("(" $ cTel) .Or. !(")" $ cTel)
        FWAlertError("Telefone sem DDD!", "Validação")
        Return
    EndIf
    
    FWAlertSuccess("Todos os dados estão válidos!", "Sucesso")
Return
```

---

## ?? Recursos Adicionais

### Documentação Oficial
- [TDN - Funções de String](https://tdn.totvs.com/display/tec/String+Functions)
- [TDN - Operadores](https://tdn.totvs.com/display/tec/Operadores+Comuns)

### Exemplos da Base MSYSR
- MSYSR001 - Operador Cifrão
- MSYSR024 - SubStr
- MSYSR025 - At
- MSYSR026 - Upper/Lower

---

## ? Checklist de Conclusão

Você completou este módulo quando conseguir:

- [ ] Usar o operador $ sem consultar exemplos
- [ ] Extrair partes de textos com SubStr
- [ ] Converter maiúsculas e minúsculas
- [ ] Limpar e formatar dados
- [ ] Criar validações de CPF, e-mail e telefone
- [ ] Resolver os exercícios de todos os tópicos

---

## ?? Navegação

- [?? Voltar para 01-Fundamentos](../01-Fundamentos/README.md)
- [?? Voltar ao Índice Principal](../README.md)
- [?? Avançar para 03-Arrays](../03-Arrays/README.md)

---

<div align="center">

**?? Bons estudos!**

**Dúvidas?** [Abra uma issue](https://github.com/felipimarques/advpl-didatico/issues) ou [inicie uma discussão](https://github.com/felipimarques/advpl-didatico/discussions)

</div>
