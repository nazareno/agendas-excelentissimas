library(tidyverse, warn.conflicts = F)

COLUNAS_RAW = cols(
  dia = col_date(format = ""),
  url = col_character(),
  inicio = col_character(),
  fim = col_character(),
  descricao = col_character(),
  local = col_character()
)

main <- function(files = NULL) {
  if (is.null(files)) {
    files = list.files(
      path = here::here("data/raw/"),
      pattern = "presidente",
      full.names = T
    )
  }
  tudo_raw = map_df(files, read_csv, col_types = COLUNAS_RAW)
  
  out_file = "data/ready/presidente.csv"
  
  tudo_raw %>%
    filter(descricao != "Sem compromisso oficial") %>%
    write_csv(here::here(out_file))
  
  message(str_glue("Dados em {out_file}"))
}

if (!interactive()) {
  argv <- commandArgs(TRUE)
  main(argv)
}
