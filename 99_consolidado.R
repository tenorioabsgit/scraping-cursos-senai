# Instalar e carregar pacotes necessários
if (!require(chromote)) install.packages("chromote")
if (!require(rvest)) install.packages("rvest")
if (!require(dplyr)) install.packages("dplyr")

library(chromote)
library(rvest)
library(dplyr)

Sys.setenv(CHROMOTE_CHROME = "C:/Users/tenor/AppData/Local/Google/Chrome/Application/chrome.exe")

# Criar uma instância do navegador
b <- ChromoteSession$new()

# URL desejada
url <- "https://al.senai.br/nossos-cursos/?unidade=poco"

# Navegar para a URL
b$Page$navigate(url)

# Aguardar o carregamento completo da página
Sys.sleep(10)

# Capturar o HTML da página
html_content <- b$Runtime$evaluate(
  expression = "document.documentElement.outerHTML"
)$result$value

# Parsear o HTML usando rvest
html_parsed <- read_html(html_content)

# Capturar todos os cartões de curso
cards <- html_parsed %>%
  html_nodes(".card-content")

# Inicializar listas para armazenar os dados
nomes <- c()
datas <- c()
investimentos <- c()

# Iterar sobre cada cartão e extrair informações
for (card in cards) {
  # Nome do curso
  nome <- card %>%
    html_node("h3.card-title.card-title-curso-b2c") %>%
    html_text(trim = TRUE)
  
  # Data de início
  data <- card %>%
    html_node("p.card-text:contains('Inicio:') strong") %>%
    html_text(trim = TRUE)
  
  # Investimento
  investimento <- card %>%
    html_node("p.card-text:contains('Investimento:') strong") %>%
    html_text(trim = TRUE)
  
  # Adicionar os dados às listas
  nomes <- c(nomes, nome)
  datas <- c(datas, data)
  investimentos <- c(investimentos, investimento)
}

# Criar um dataframe com os dados
cursos_df <- data.frame(
  Curso = nomes,
  DataInicio = datas,
  Investimento = investimentos,
  stringsAsFactors = FALSE
)

# Visualizar os primeiros cursos capturados
print(head(cursos_df))


cat("Os cursos, datas e investimentos foram capturados e salvos em 'cursos_senai.csv'\n")

# Finalizar a sessão do navegador
b$close()

cat("A sessão do navegador foi encerrada com sucesso.\n")


# Carregar pacotes necessários
if (!require(dplyr)) install.packages("dplyr")

library(dplyr)

# Carregar tabelas anterior e atual
tabela_anterior <- read.csv("utlima_consulta.csv", stringsAsFactors = FALSE)
tabela_atual <- cursos_df

# Comparar as tabelas
cursos_novos <- setdiff(tabela_atual$Curso, tabela_anterior$Curso)
cursos_removidos <- setdiff(tabela_anterior$Curso, tabela_atual$Curso)

# Verificar se houve alterações
if (length(cursos_novos) == 0 && length(cursos_removidos) == 0) {
  status <- "Sem alterações nos cursos."
} else {
  status <- paste(
    if (length(cursos_novos) > 0) {
      paste("Cursos novos:\n", paste(cursos_novos, collapse = "\n"))
    },
    if (length(cursos_removidos) > 0) {
      paste("Cursos removidos:\n", paste(cursos_removidos, collapse = "\n"))
    },
    sep = "\n\n"
  )
}

# Exibir o status no console
cat(status)

# Carregar a biblioteca necessária
library(gmailr)

# Configurar a API do Gmail
# Certifique-se de que você configurou as credenciais do Google API e salvou o arquivo JSON correspondente
gm_auth_configure(path = "client_secret_208328056935-62acfnpgaf7i4jicavur7g99kur1rv64.apps.googleusercontent.com.json")

gm_auth(email = TRUE)

# Função para enviar e-mail
enviar_email <- function(de, para, assunto, corpo) {
  tryCatch({
    # Criar a mensagem
    mensagem <- gm_mime(
      To = para,
      From = de,
      Subject = assunto,
      body = corpo
    )
    
    # Enviar o e-mail
    gm_send_message(mensagem)
    cat("E-mail enviado com sucesso!\n")
  }, error = function(e) {
    cat("Erro ao enviar o e-mail:\n", e$message, "\n")
  })
}

# Configurar os detalhes do e-mail
de <- "tenorioabs@gmail.com"
para <- "tenorioabs@hotmail.com"
assunto <- "Teste do gmail para o hotmail"
corpo <- status

# Enviar o e-mail
enviar_email(de, para, assunto, corpo)



# Salvar o dataframe em um arquivo CSV
#file_name <- paste0("cursos_senai_", Sys.Date(), "_", format(Sys.time(), "%H-%M-%S"), ".csv")
file_name <- "utlima_consulta.csv"
file_name
write.csv(cursos_df, file_name, row.names = FALSE)