# Carregar pacotes necessários
if (!require(dplyr)) install.packages("dplyr")

library(dplyr)

# Carregar tabelas anterior e atual
tabela_anterior <- read.csv("cursos_senai_2024-12-20_10-49-30.csv", stringsAsFactors = FALSE)
tabela_atual <- read.csv("cursos_senai_2024-12-20_10-57-59.csv", stringsAsFactors = FALSE)

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
