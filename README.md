# 🏫 Monitoramento de Cursos do SENAI

Este projeto realiza **web scraping** da página de cursos do **SENAI**, compara as novas ofertas com as existentes e envia alertas por **e-mail** caso haja alterações.

## 📌 Funcionalidades

✅ **Extração de cursos do SENAI via web scraping**  
✅ **Comparação automática entre os cursos novos e anteriores**  
✅ **Envio de e-mail para notificação de mudanças**  
✅ **Salvamento da base consolidada em um arquivo CSV**  

---

## 🛠 Tecnologias Utilizadas

- **Linguagem:** R  
- **Pacotes:** `chromote`, `rvest`, `dplyr`, `gmailr`  
- **Fontes de dados:** [SENAI AL](https://al.senai.br/nossos-cursos/)  

---

## 📂 Estrutura do Código

```
📁 /  (Diretório Raiz)
├── 01_captura_dados.R   # Script para extrair cursos do SENAI via web scraping
├── 02_compara_bases.R   # Compara os cursos capturados com a última versão salva
├── 03_envia_email.R     # Envia um e-mail se houver mudanças na lista de cursos
├── 99_consolidado.R     # Script completo que executa todos os passos
└── ultima_consulta.csv  # Arquivo CSV com a última captura de cursos
```

---

## 🚀 Como Executar

### 1️⃣ **Instalar os pacotes necessários**

Se ainda não estiverem instalados, execute no R:

```r
install.packages(c("chromote", "rvest", "dplyr", "gmailr"))
```

### 2️⃣ **Configurar o Chrome para o Web Scraping**

Certifique-se de que o **Google Chrome** está instalado e ajuste o caminho no script `01_captura_dados.R`:

```r
Sys.setenv(CHROMOTE_CHROME = "C:/Users/SEU_USUARIO/AppData/Local/Google/Chrome/Application/chrome.exe")
```

### 3️⃣ **Executar a Captura de Dados**

```r
source("01_captura_dados.R")
```

Isso irá buscar a lista de cursos disponíveis no SENAI e salvar um arquivo CSV.

### 4️⃣ **Comparar as Bases e Identificar Mudanças**

```r
source("02_compara_bases.R")
```

Se houver cursos novos ou removidos, o script exibirá um relatório.

### 5️⃣ **Configurar e Enviar Notificação por E-mail**

- Configure a **API do Gmail** e salve o JSON de autenticação.
- No script `03_envia_email.R`, ajuste as credenciais:

```r
gm_auth_configure(path = "SEU_CLIENT_SECRET.json")
```

- Modifique o remetente e o destinatário:

```r
de <- "seuemail@gmail.com"
para <- "destinatario@gmail.com"
```

- Para enviar a notificação:

```r
source("03_envia_email.R")
```

### 6️⃣ **Executar o Processo Completo**

Para capturar cursos, comparar com a última versão e enviar e-mails automaticamente:

```r
source("99_consolidado.R")
```

---

## 📊 Estrutura do Arquivo de Saída (`ultima_consulta.csv`)

A saída será um CSV com as seguintes colunas:

| Curso | Data Início | Investimento |
|--------|------------|-------------|
| Nome do Curso | 2024-02-14 | R$ 250,00 |

---

## 🛑 Possíveis Problemas e Soluções

### ⚠️ **Erro ao acessar o site do SENAI**
Se a conexão falhar, tente executar o script novamente ou verificar sua conexão de internet.

### 🔄 **Erro na Autenticação do Gmail**
Certifique-se de que sua conta do Gmail permite **acesso via API** e que o JSON de autenticação foi configurado corretamente.

### ⏳ **Web Scraping está lento?**
Caso o site tenha restrições, tente aumentar o tempo de espera antes de capturar os dados:

```r
Sys.sleep(15)  # Aguarda 15 segundos para carregar toda a página
```

---

 

🚀 **Agora você pode monitorar cursos automaticamente!** Qualquer dúvida, me avise! 😊
