library(dplyr)
library(sqldf)
library(readr)

setwd("~/Documentos/Linguagem R/3.20. Extracao do data frame do projeto 1/data")

covid_sp <- read.csv('dados_covid_sp.csv', sep = ";", encoding="UTF-8")
View(covid_sp)


qry <- "
select nome_munic as municipio, dia, mes, datahora as data, casos, casos_novos, obitos, obitos_novos, letalidade, nome_ra, nome_drs, pop, pop_60, area, latitude, longitude, semana_epidem as semana
from covid_sp
where nome_munic <> 'Ignorado'
"

covid_sp_alterado <- sqldf(qry)
View(covid_sp_alterado)

str(covid_sp_alterado)

covid_sp_alterado$data <- as.Date(covid_sp_alterado$data, format ='%Y-%m-%d')
View(covid_sp_alterado)

covid_sp_alterado2 <- covid_sp_alterado

covid_sp_alterado2$letalidade <- gsub(",", ".", covid_sp_alterado2$letalidade)

covid_sp_alterado2$letalidade <- as.numeric(covid_sp_alterado2$letalidade)
View(covid_sp_alterado2)

sapply(covid_sp_alterado2, function(x) sum(is.na(x)))
sapply(covid_sp_alterado2, function(x) sum(is.nan(x)))
str(covid_sp_alterado2)

covid_sp_alterado3 <- covid_sp_alterado2
View(covid_sp_alterado3)

covid_sp_alterado3$latitude <- gsub(",", ".", covid_sp_alterado3$latitude)
covid_sp_alterado3$longitude <- gsub(",", ".", covid_sp_alterado3$longitude)
View(covid_sp_alterado3)

covid_sp_alterado3$latitude <- as.numeric(covid_sp_alterado3$latitude)
covid_sp_alterado3$longitude <- as.numeric(covid_sp_alterado3$longitude)
View(covid_sp_alterado3)

sapply(covid_sp_alterado3, function(x) sum(is.na(x)))
sapply(covid_sp_alterado3, function(x) sum(is.nan(x)))
str(covid_sp_alterado3)

covid_sp_alterado3$semana[covid_sp_alterado3$data >= '2021-01-01' &
  covid_sp_alterado3$data <= '2021-01-07'] <- 54

covid_sp_alterado3$semana[covid_sp_alterado3$data >= '2021-01-08' &
  covid_sp_alterado3$data <= '2021-01-14'] <- 55

covid_sp_alterado3$semana[covid_sp_alterado3$data >= '2021-01-15' &
  covid_sp_alterado3$data <= '2021-01-21'] <- 56

View(covid_sp_alterado3)

covid_sp_alterado4 <- covid_sp_alterado3

# rm(list = "?")

View(covid_sp_alterado4)

qry2 <- "
select *
from covid_sp_alterado4
where semana is not null
"

covid_sp_alterado5 <- sqldf(qry2)
View(covid_sp_alterado5)

write_delim(covid_sp_alterado5, "covid_sp_tratado.csv", delim = ",")
