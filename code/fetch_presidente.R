library(tidyverse, warn.conflicts = F)
library(rvest)
library(futile.logger)

BASE_URL = "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/agenda-do-presidente-da-republica"

read_html_sleep = function(u) {
  flog.info(u)
  safe_read = safely(read_html, otherwise = NULL, quiet = F)
  h = safe_read(u)
  Sys.sleep(.2)
  h
}

compromissos_html2df = function(html_pagina) {
  html_pagina %>%
    rvest::html_nodes(".item-compromisso") %>%
    map_df(~ {
      tibble(
        inicio = html_node(.x, '.compromisso-inicio') %>% html_text(),
        fim = html_node(.x, '.compromisso-fim') %>% html_text(),
        descricao = html_node(.x, '.compromisso-titulo') %>% html_text(),
        local = html_node(.x, '.compromisso-local') %>% html_text()
      )
    })
}

fetch_agenda <- function(datas) {
  htmls = tibble(dia = datas,
                 url = str_glue("{BASE_URL}/{dia}")) %>%
    mutate(html = map(url, read_html_sleep))
  
  compromissos_df = htmls %>%
    mutate(
      result = map(html, ~ .x[['result']]),
      compromissos = map(result, compromissos_html2df)
    ) %>%
    unnest(compromissos) %>%
    select(-html,-result)
  
  compromissos_df
}

fetch_save_periodo <- function(periodo, out_file) {
  compromissos_df = fetch_agenda(periodo)
  flog.info(str_glue("{NROW(compromissos_df)} compromissos encontrados"))
  
  compromissos_df %>%
    write_csv(here::here(out_file))
  flog.info(str_glue("Salvo em {out_file}"))
}

main <- function(args) {
  fetch_save_periodo(
    seq(as.Date("2019-01-01"), as.Date("2019-12-31"), "days"), 
    str_glue("data/raw/presidente-2019_em_{Sys.Date()}.csv")
  )
  
  fetch_save_periodo(
    seq(as.Date("2020-01-01"), as.Date("2020-12-31"), "days"), 
    str_glue("data/raw/presidente-2020_em_{Sys.Date()}.csv")
  )
  
  fetch_save_periodo(
    seq(as.Date("2021-01-01"), Sys.Date(), "days"),
    str_glue("data/raw/presidente-2021_em_{Sys.Date()}.csv")
  )
}


if (!interactive()) {
  argv <- commandArgs(TRUE)
  main(argv)
}
