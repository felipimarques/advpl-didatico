# ?? ADVPL Didático - Aprenda ADVPL na Prática

![ADVPL](https://img.shields.io/badge/ADVPL-Protheus-blue)
![Status](https://img.shields.io/badge/Status-Em_Desenvolvimento-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

> **Projeto Open Source** para ensinar ADVPL/TLPP através de exemplos práticos e progressivos.

**Autor:** [Felipi Marques](https://github.com/felipimarques)  
**Base:** 551 exemplos padronizados da biblioteca MSYSR

---

## ?? Objetivo

Este repositório foi criado para ajudar desenvolvedores (iniciantes e intermediários) a **aprenderem ADVPL** de forma estruturada, com:

- ? **Exemplos práticos** organizados por dificuldade
- ? **Mini manuais explicativos** para cada conceito
- ? **Código limpo** seguindo as melhores práticas (ERPServ)
- ? **Exercícios práticos** para fixação

---

## ?? Como Usar Este Repositório

### Para Iniciantes
1. Comece pela pasta [00-Introducao](./00-Introducao) para entender o ambiente
2. Siga a **Trilha de Aprendizado** abaixo na ordem sugerida
3. Leia o `README.md` de cada módulo antes de começar
4. Execute os códigos `.prw` no seu ambiente Protheus
5. Pratique com os exercícios propostos

### Para Intermediários
Vá direto para os módulos que precisa:
- [04-Banco-de-Dados](./04-Banco-de-Dados) - SQL e manipulação de dados
- [06-MVC](./06-MVC) - Padrão MVC do Protheus
- [07-Services](./07-Services) - Arquitetura moderna com TLPP

---

## ??? Estrutura do Projeto

```
advpl-didatico/
??? ?? 00-Introducao/              ? Comece aqui
?   ??? README.md                   (O que é ADVPL, ambiente, etc.)
?   ??? SETUP.md                    (Como configurar ambiente)
?
??? ?? 01-Fundamentos/              ? Essencial
?   ??? 01-Variaveis/
?   ?   ??? VAR01_TiposBasicos.prw
?   ?   ??? VAR01_Manual.md
?   ??? 02-Operadores/
?       ??? OPE01_Aritmeticos.prw
?       ??? OPE02_Logicos.prw
?
??? ?? 02-Strings/                  ? Manipulação de textos
?   ??? STR01_Cifrao.prw            (Operador $)
?   ??? STR01_Manual.md
?   ??? STR02_SubStr.prw
?
??? ?? 03-Arrays/                   ? Trabalho com arrays
?   ??? ARR01_Criacao.prw
?   ??? ARR02_Manipulacao.prw
?
??? ?? 04-Banco-de-Dados/           ? SQL e DBF
?   ??? SQL01_Select.prw
?   ??? SQL02_Insert.prw
?
??? ?? 05-Interface/                ? Telas e diálogos
?   ??? UI01_MsgBox.prw
?   ??? UI02_Dialog.prw
?
??? ??? 06-MVC/                      ? MVC Protheus
?   ??? MVC01_Cadastro.prw
?   ??? MVC01_Manual.md
?
??? ?? 07-Services/                 ? Padrão Service (TLPP)
?   ??? SVC01_ClienteService.prw
?   ??? SVC01_Manual.md
?
??? ?? 08-WebServices/              ? REST APIs
?   ??? WS01_REST.prw
?
??? ??? 99-Utilitarios/              ? Funções úteis
    ??? UTL01_Log.prw
```

---

## ?? Trilha de Aprendizado

### ?? Nível 1 - Iniciante (Comece aqui)

| Status | Módulo | Tópico | Descrição |
|:------:|--------|--------|-----------|
| ? | 00-Introducao | Ambiente | O que é ADVPL e como configurar |
| ? | 01-Fundamentos/01-Variaveis | Tipos de dados | Character, Numeric, Date, Logical |
| ? | 01-Fundamentos/02-Operadores | Operadores básicos | +, -, *, /, ==, <, > |
| ? | 02-Strings | Manipulação de texto | SubStr, Upper, Lower, $ |
| ? | 03-Arrays | Arrays básicos | Criação, acesso, percorrimento |
| ? | 05-Interface | Mensagens | MsgInfo, MsgAlert, MsgStop |

**Tempo estimado:** 2-3 semanas

---

### ?? Nível 2 - Intermediário

| Status | Módulo | Tópico | Descrição |
|:------:|--------|--------|-----------|
| ? | 04-Banco-de-Dados | SQL Básico | SELECT, WHERE, JOIN |
| ? | 04-Banco-de-Dados | DBF | DbSeek, RecLock, DbSkip |
| ? | 05-Interface | Diálogos | TDialog, TButton, TGet |
| ? | 06-MVC | MVC Básico | ModelDef, ViewDef |
| ? | 03-Arrays | Arrays avançados | aSort, aScan, aEval |

**Tempo estimado:** 1-2 meses

---

### ?? Nível 3 - Avançado

| Status | Módulo | Tópico | Descrição |
|:------:|--------|--------|-----------|
| ? | 07-Services | TLPP Classes | Namespace, Classes, Methods |
| ? | 07-Services | Service Pattern | Separação de responsabilidades |
| ? | 08-WebServices | REST API | GET, POST, PUT, DELETE |
| ? | 04-Banco-de-Dados | Transações | Begin/End Transaction |
| ? | 99-Utilitarios | Logs e Erros | ErrorBlock, FWLogMsg |

**Tempo estimado:** 2-3 meses

---

## ?? Padrões e Convenções

- ? **Nomenclatura consistente** (Notação Húngara)
- ? **Tipagem forte** do TLPP (`as Numeric`, `as Character`)
- ? **Código limpo** (Clean Code adaptado para ADVPL)
- ? **Documentação ProtheusDoc** em todos os arquivos
- ? **Separação de responsabilidades** (MVC vs Service)

---

## ?? Como Contribuir

Contribuições são bem-vindas! Para contribuir:

1. Fork este repositório
2. Crie uma branch: `git checkout -b minha-contribuicao`
3. Faça suas alterações seguindo os padrões do projeto
4. Commit: `git commit -m 'feat: adiciona exemplo de XYZ'`
5. Push: `git push origin minha-contribuicao`
6. Abra um Pull Request

### Tipos de Contribuições Aceitas
- ?? Novos exemplos práticos
- ?? Melhorias na documentação
- ?? Correções de bugs
- ?? Sugestões de novos módulos
- ?? Exercícios práticos

---

## ?? Recursos Adicionais

### Documentação Oficial
- [TOTVS TDN](https://tdn.totvs.com/)
- [TLPP Docs](https://tdn.totvs.com/display/tec/TLPP)

### Comunidade
- [Portal do Programador ADVPL](https://www.portal-programador.com.br/)
- [Fórum TOTVS](https://suporte.totvs.com/)



## ? Agradecimentos

- **Comunidade ADVPL** por compartilhar conhecimento
- **TOTVS** pela linguagem e plataforma Protheus
- **Todos os contribuidores** deste projeto

---

## ?? Contato

**Felipi Marques**
- GitHub: [@felipimarques](https://github.com/felipimarques)

---

<div align="center">

**? Se este projeto te ajudou, deixe uma estrela no repositório!**

[? Voltar ao topo](#-advpl-didático---aprenda-advpl-na-prática)

</div>
