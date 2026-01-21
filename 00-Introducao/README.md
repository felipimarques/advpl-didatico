# ?? Bem-vindo ao ADVPL Didático!

> **Sua jornada de aprendizado em ADVPL começa aqui**

---

## ?? O que é ADVPL?

**ADVPL** (Advanced Protheus Language) é a linguagem de programação proprietária da **TOTVS** usada para desenvolver customizações, relatórios, integrações e novas funcionalidades no **ERP Protheus**.

### Por que aprender ADVPL?

- ? **Alta demanda no mercado** - Milhares de empresas usam Protheus
- ? **Salários atrativos** - Profissionais ADVPL são bem remunerados
- ? **Flexibilidade** - Pode trabalhar remoto para qualquer lugar do Brasil
- ? **Evolução constante** - TOTVS investe continuamente na linguagem
- ? **Comunidade ativa** - Fóruns, grupos e eventos frequentes

---

## ?? Para quem é este curso?

### ?? Você é iniciante em programação?

**Ótimo!** Este curso foi pensado para você. Começaremos do zero:
- O que são variáveis
- Como funcionam os operadores
- Estruturas de decisão (If/Else)
- Laços de repetição (For/While)

**Tempo estimado:** 3-4 meses para dominar o básico

---

### ?? Você já programa em outra linguagem?

**Perfeito!** Você vai aprender ADVPL rapidamente:
- Pule para os módulos intermediários
- Foque nas particularidades do ADVPL
- Aprenda a trabalhar com o Protheus

**Tempo estimado:** 1-2 meses para se tornar produtivo

---

### ?? Você já conhece ADVPL clássico?

**Excelente!** Vamos modernizar seu código:
- Aprenda TLPP (ADVPL moderno)
- Padrões de arquitetura (Service Pattern)
- Clean Code adaptado para ADVPL

**Tempo estimado:** 2-3 semanas para dominar as novidades

---

## ??? O que você precisa para começar?

### 1. Ambiente Protheus

Você vai precisar de:

- **Protheus AppServer** (servidor de aplicação)
- **SmartClient** (interface do usuário)
- **VSCode** com extensão TOTVS (recomendado para desenvolvimento)

### 2. Opções de Ambiente

#### Opção A: Ambiente Local (Recomendado para iniciantes)

**Vantagens:**
- ? Não precisa de internet
- ? Controle total
- ? Pode testar à vontade sem medo

**Como conseguir:**
1. Baixe o [Protheus Trial](https://suporte.totvs.com/) (versão de testes gratuita por 30 dias)
2. Instale seguindo o [guia oficial](https://tdn.totvs.com/)

#### Opção B: Ambiente em Nuvem

**Vantagens:**
- ? Não precisa instalar nada
- ? Acesso de qualquer lugar
- ? Sempre atualizado

**Como conseguir:**
- Entre em contato com TOTVS para ambiente cloud

#### Opção C: Trabalha em empresa com Protheus

**Perfeito!**
- Peça acesso ao ambiente de desenvolvimento/testes
- **NUNCA** teste em produção
- Converse com seu gestor sobre aprender ADVPL

---

## ?? Configurando o VSCode

### 1. Instale o VSCode

Baixe em: [code.visualstudio.com](https://code.visualstudio.com/)

### 2. Instale a Extensão TOTVS

1. Abra o VSCode
2. Vá em **Extensões** (Ctrl+Shift+X)
3. Busque por **"TOTVS"**
4. Instale a extensão oficial da TOTVS

### 3. Configure a Conexão

```json
// settings.json do VSCode
{
    "totvsLanguageServer.welcomePage": false,
    "totvsLanguageServer.editor.toggle.autocomplete": true,
    "totvsLanguageServer.editor.toggle.tdsReplay": true
}
```

### 4. Teste sua Conexão

1. Pressione **Ctrl+Shift+P**
2. Digite **"TOTVS: Add Server"**
3. Preencha os dados do seu servidor
4. Teste a conexão

---

## ?? Como Estudar ADVPL?

### ?? Método Recomendado (4 Passos)

#### 1?? **Leia a Teoria** (10 min)
- Abra o manual do módulo
- Leia a seção "Teoria"
- Entenda o conceito antes de ver código

#### 2?? **Analise o Código** (15 min)
- Abra o arquivo `.prw` no VSCode
- Leia linha por linha
- Tente entender o que cada parte faz

#### 3?? **Execute o Exemplo** (10 min)
- Compile o código no seu ambiente
- Execute a função
- Veja o resultado na prática

#### 4?? **Pratique** (30 min)
- Faça os exercícios propostos
- Modifique o código original
- Crie suas próprias variações

**Total por módulo:** ~1 hora

---

### ?? Plano de Estudos Sugerido

#### Semana 1-2: Fundamentos
```
Segunda: Variáveis (VAR01, VAR02)
Terça: Operadores (OPE01, OPE02)
Quarta: If/Else (CON01, CON02)
Quinta: For (LAC01)
Sexta: While (LAC02)
Sábado: Revisão + Exercícios
Domingo: Descanso ??
```

#### Semana 3-4: Strings e Arrays
```
Segunda-Quarta: Strings (STR01-STR05)
Quinta-Sexta: Arrays (ARR01-ARR03)
Sábado: Projeto prático
Domingo: Descanso ??
```

#### Semana 5-8: Banco de Dados
```
Semana 5: SQL Básico (SQL01-SQL03)
Semana 6: DBF (DBF01-DBF03)
Semana 7: Transações (TRX01-TRX02)
Semana 8: Projeto integrado
```

---

## ?? Seu Primeiro Programa

Vamos começar com o clássico **"Olá Mundo"** em ADVPL:

```advpl
#Include "TOTVS.ch"

/*/{Protheus.doc} HELLO
Seu primeiro programa em ADVPL!

@type User Function
@author Seu Nome
@since 21/01/2026
/*/
User Function HELLO()
    Local aArea := GetArea()
    
    // Exibe mensagem
    MsgInfo("Olá, mundo ADVPL!", "Meu Primeiro Programa")
    
    // Restaura ambiente
    RestArea(aArea)
Return
```

### Como executar?

1. Copie o código acima
2. Cole em um arquivo `HELLO.prw`
3. Compile no VSCode
4. Execute com `U_HELLO()`

**Parabéns!** ?? Você acabou de criar seu primeiro programa ADVPL!

---

## ?? Estrutura do Curso

```
?? ADVPL Didático
?
??? ?? 01-Fundamentos          ? Comece aqui
?   ??? Variáveis
?   ??? Operadores
?   ??? Estruturas de Controle
?
??? ?? 02-Strings
?   ??? Manipulação de textos
?
??? ?? 03-Arrays
?   ??? Listas e coleções
?
??? ?? 04-Banco-de-Dados
?   ??? SQL e DBF
?
??? ?? 05-Interface
?   ??? Telas e diálogos
?
??? ??? 06-MVC
?   ??? Padrão MVC do Protheus
?
??? ?? 07-Services
?   ??? TLPP e arquitetura moderna
?
??? ?? 08-WebServices
    ??? REST APIs
```

---

## ?? Dicas de Ouro

### ? Faça

- **Pratique todos os dias** (mesmo que seja 30 min)
- **Digite o código** ao invés de copiar/colar
- **Erre e aprenda** com os erros
- **Participe de comunidades** (fóruns, grupos)
- **Documente** seu código desde o início

### ? Evite

- **Pular etapas** (cada conceito é importante)
- **Decorar código** (entenda a lógica)
- **Ter medo de errar** (erro é parte do aprendizado)
- **Estudar sem praticar** (teoria + prática = sucesso)
- **Desistir no primeiro obstáculo** (programação exige persistência)

---

## ?? Precisa de Ajuda?

### Recursos Oficiais

- ?? [TDN TOTVS](https://tdn.totvs.com/) - Documentação oficial
- ?? [Fórum TOTVS](https://suporte.totvs.com/) - Tire dúvidas
- ?? [TOTVS Developers](https://developers.totvs.com/) - Vídeos e tutoriais

### Comunidades

- ?? [Portal do Programador](https://www.portal-programador.com.br/)
- ?? Grupos no Telegram: "ADVPL Brasil"
- ?? LinkedIn: Siga hashtag #ADVPL

### Este Projeto

- ?? [Abra uma Issue](https://github.com/felipimarques/advpl-didatico/issues) - Reporte bugs ou dúvidas
- ?? [Discussões](https://github.com/felipimarques/advpl-didatico/discussions) - Pergunte e ajude outros

---

## ?? Certificação

Embora não haja certificação oficial neste curso, ao completar todos os módulos você terá:

- ? **Portfolio no GitHub** com seus códigos
- ? **Conhecimento prático** para trabalhar com Protheus
- ? **Base sólida** para certificações TOTVS oficiais

---

## ?? Próximo Passo

**Pronto para começar?**

1. Configure seu ambiente seguindo o [SETUP.md](SETUP.md)
2. Vá para [01-Fundamentos](../01-Fundamentos/README.md)
3. Comece com variáveis (VAR01)

---

<div align="center">

## ?? Vamos Começar!

**"A melhor maneira de aprender é fazendo."**

[?? Configurar Ambiente (SETUP.md)](SETUP.md) | [?? Ir para Fundamentos](../01-Fundamentos/README.md)

---

**? Boa jornada de aprendizado!**

[?? Voltar ao Índice Principal](../README.md)

</div>
