# ??? Guia de Configuração do Ambiente ADVPL

> **Passo a passo completo para configurar seu ambiente de desenvolvimento**

---

## ?? Índice

1. [Requisitos Mínimos](#requisitos-mínimos)
2. [Instalação do Protheus](#instalação-do-protheus)
3. [Instalação do VSCode](#instalação-do-vscode)
4. [Configuração da Extensão TOTVS](#configuração-da-extensão-totvs)
5. [Primeiro Teste](#primeiro-teste)
6. [Troubleshooting](#troubleshooting)

---

## ?? Requisitos Mínimos

### Hardware

- **Processador:** Intel Core i3 ou superior
- **RAM:** 4 GB (recomendado: 8 GB)
- **HD:** 10 GB livres
- **SO:** Windows 7/10/11 (64 bits)

### Software

- ? Windows atualizado
- ? Conexão com internet (para downloads)
- ? Permissões de administrador

---

## ?? Instalação do Protheus

### Opção 1: Protheus Trial (Recomendado para estudos)

#### Passo 1: Download

1. Acesse [TOTVS Developers](https://developers.totvs.com/)
2. Faça login ou crie uma conta
3. Baixe o **Protheus Trial** (versão de testes)

#### Passo 2: Instalação

```powershell
# Extraia o arquivo ZIP
# Execute o instalador como Administrador
protheus_trial_setup.exe
```

**Durante a instalação:**
- ? Instale em `C:\TOTVS\Protheus`
- ? Marque "Ambiente de Desenvolvimento"
- ? Selecione "Instalar SmartClient"
- ? Configure porta padrão: `7890`

#### Passo 3: Primeiro Start

1. Abra o **SmartClient**
2. Configure a conexão:
   - **Servidor:** localhost
   - **Porta:** 7890
   - **Ambiente:** ENVIRONMENT
   - **Usuário:** admin
   - **Senha:** (em branco ou conforme documentação)

---

### Opção 2: Ambiente Corporativo

Se você trabalha em uma empresa que usa Protheus:

1. Solicite ao TI:
   - Acesso ao ambiente de **desenvolvimento** ou **testes**
   - IP/Porta do servidor
   - Usuário e senha
   - Ambiente (ENVIRONMENT)

2. Configure o SmartClient com os dados fornecidos

?? **NUNCA use ambiente de produção para testes!**

---

## ??? Instalação do VSCode

### Passo 1: Download e Instalação

1. Acesse [code.visualstudio.com](https://code.visualstudio.com/)
2. Baixe a versão para Windows
3. Execute o instalador

**Durante a instalação, marque:**
- ? Adicionar ao PATH
- ? Criar atalho na área de trabalho
- ? Adicionar "Abrir com Code" ao menu de contexto

### Passo 2: Primeiro Start

1. Abra o VSCode
2. Familiarize-se com a interface:
   - **Explorer** (Ctrl+Shift+E): Arquivos do projeto
   - **Search** (Ctrl+Shift+F): Busca global
   - **Extensions** (Ctrl+Shift+X): Extensões
   - **Terminal** (Ctrl+`): Terminal integrado

---

## ?? Configuração da Extensão TOTVS

### Passo 1: Instalar Extensão

1. Abra o VSCode
2. Pressione **Ctrl+Shift+X** (abre Extensions)
3. Busque: **"TOTVS Language Server"**
4. Clique em **Install**

### Passo 2: Configurar Servidor

1. Pressione **Ctrl+Shift+P** (abre Command Palette)
2. Digite: **"TOTVS: Add Server"**
3. Preencha os dados:

```json
{
    "id": "localhost",
    "type": "totvs_server_protheus",
    "name": "Meu Servidor Local",
    "address": "localhost",
    "port": 7890,
    "buildVersion": "12.1.27",
    "secure": false,
    "includes": [
        "C:\\TOTVS\\Protheus\\includes"
    ],
    "environments": [
        "ENVIRONMENT"
    ]
}
```

### Passo 3: Conectar

1. Pressione **Ctrl+Shift+P**
2. Digite: **"TOTVS: Connect"**
3. Selecione seu servidor
4. Informe usuário e senha

? **Conectado!** Você verá um ícone verde na barra inferior.

---

## ?? Primeiro Teste

### Criar Estrutura de Pastas

```powershell
# Crie uma pasta para seus projetos
mkdir C:\Projetos\ADVPL
cd C:\Projetos\ADVPL
```

### Criar Primeiro Programa

1. No VSCode, abra a pasta `C:\Projetos\ADVPL`
2. Crie um arquivo: `TESTE01.prw`
3. Cole o código:

```advpl
#Include "TOTVS.ch"

User Function TESTE01()
    Local aArea := GetArea()
    
    MsgInfo("Ambiente configurado com sucesso!", "Teste")
    
    RestArea(aArea)
Return
```

### Compilar e Executar

1. Salve o arquivo (Ctrl+S)
2. Compile:
   - Pressione **Ctrl+F9** ou
   - Clique direito ? **TOTVS: Compile**
3. Execute no SmartClient:
   ```
   U_TESTE01()
   ```

**Resultado esperado:**
- ? Mensagem "Ambiente configurado com sucesso!" aparece
- ? Não há erros no console

?? **Parabéns! Seu ambiente está pronto!**

---

## ?? Configurações Recomendadas

### settings.json do VSCode

Pressione **Ctrl+Shift+P** ? **"Preferences: Open Settings (JSON)"**

Cole estas configurações:

```json
{
    // TOTVS
    "totvsLanguageServer.welcomePage": false,
    "totvsLanguageServer.editor.toggle.autocomplete": true,
    "totvsLanguageServer.editor.toggle.tdsReplay": true,
    
    // Editor
    "editor.fontSize": 14,
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.rulers": [80, 120],
    "editor.wordWrap": "on",
    
    // Arquivos
    "files.encoding": "windows1252",
    "files.eol": "\r\n",
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    
    // Terminal
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    
    // Formato ADVPL
    "[advpl]": {
        "editor.formatOnSave": true,
        "editor.tabSize": 4
    }
}
```

---

## ?? Atalhos Úteis

### VSCode

| Atalho | Ação |
|--------|------|
| **Ctrl+Shift+P** | Command Palette |
| **Ctrl+P** | Buscar arquivo |
| **Ctrl+F** | Buscar no arquivo |
| **Ctrl+H** | Substituir |
| **Ctrl+/** | Comentar linha |
| **Ctrl+Shift+K** | Deletar linha |
| **Alt+?/?** | Mover linha |
| **Ctrl+D** | Selecionar próxima ocorrência |

### TOTVS Extension

| Atalho | Ação |
|--------|------|
| **Ctrl+F9** | Compilar |
| **Ctrl+F10** | Recompilar |
| **Ctrl+Shift+F9** | Compilar múltiplos |
| **F1** | Ajuda sobre função |

---

## ?? Troubleshooting

### Problema 1: Não Conecta no Servidor

**Sintomas:**
- Erro: "Não foi possível conectar ao servidor"

**Soluções:**
1. Verifique se o AppServer está rodando
2. Confirme IP e porta corretos
3. Desative temporariamente firewall/antivírus
4. Tente: `telnet localhost 7890`

---

### Problema 2: Erro ao Compilar

**Sintomas:**
- Erro: "Include não encontrado"

**Soluções:**
1. Configure o caminho dos includes:
   ```json
   "includes": ["C:\\TOTVS\\Protheus\\includes"]
   ```
2. Verifique se o arquivo `.ch` existe
3. Reconecte ao servidor

---

### Problema 3: Caracteres Estranhos

**Sintomas:**
- Acentos aparecem errados

**Soluções:**
1. Configure encoding:
   ```json
   "files.encoding": "windows1252"
   ```
2. Reabra o arquivo
3. No VSCode: Clique no encoding (canto inferior direito) ? Reopen with Encoding ? Windows 1252

---

### Problema 4: SmartClient não Abre

**Sintomas:**
- SmartClient fecha imediatamente

**Soluções:**
1. Execute como Administrador
2. Reinstale o SmartClient
3. Verifique logs em `C:\TOTVS\Protheus\logs`

---

## ?? Recursos de Apoio

### Documentação Oficial

- [TDN - Instalação](https://tdn.totvs.com/display/public/framework/Instalacao)
- [TOTVS Developers](https://developers.totvs.com/)

### Vídeos

- [Instalando Protheus - YouTube](https://youtube.com)
- [Configurando VSCode - YouTube](https://youtube.com)

### Comunidades

- Fórum TOTVS
- Grupos no Telegram

---

## ? Checklist Final

Antes de começar a estudar, certifique-se:

- [ ] Protheus instalado e funcionando
- [ ] SmartClient conecta sem erros
- [ ] VSCode instalado
- [ ] Extensão TOTVS instalada e configurada
- [ ] Consegue compilar e executar `TESTE01.prw`
- [ ] Atalhos configurados

---

## ?? Próximo Passo

Ambiente pronto? **Vamos começar a programar!**

?? [Ir para 01-Fundamentos](../01-Fundamentos/README.md)

---

<div align="center">

**?? Ambiente configurado! Vamos codar!**

[?? Voltar](README.md) | [?? Índice Principal](../README.md)

</div>
