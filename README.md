# Agendas Excelentíssimas

Dados da agenda de representates públicos importantes. 

## Presidente da República

Dados prontos [aqui em um csv](https://github.com/nazareno/agendas-excelentissimas/blob/main/data/ready/presidente.csv?raw=true), [aqui no google sheets](https://docs.google.com/spreadsheets/d/1PavhrWj4EGz7yDRMe4ut1vZLqKVfSI3eoZl5GeRLLJM/edit?usp=sharing) ou em `data/ready/presidente.csv` deste repositório. 

Para coletar novos dados (demora cerca de meia hora):

```
Rscript code/fetch_presidente.R 
Rscript code/transform_presidente.R data/raw/presidente*csv
```

