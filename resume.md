# Resumo sobre a linguagem R  

##### _Instalando e carregando um pacote para ser usado_  
install.packages("pacote")  
library(pacote)  

##### _Pacotes mais utilizados_  


##### _Definido local de trabalho_  
setwd("local")  
getwd()  

##### _Lendo arquivos com delimitadores (txt e csv)_  
library(utils)  
df <- read.csv("arquivo", header = TRUE, sep = ",", dec = ".", encoding="UTF-8")  
df <- read.delim("arquivo", header = TRUE, sep = ",", dec = ".", encoding="UTF-8")  

Exemplo de separadores (sep):  
* ","  
* "\t"  
* ";"  
* " "  

Exemplo de decimal (dec):  
* "."  
* ","  

##### _Lendo arquivos excel (xls e xlsx)_  
library(readxl)
df2 <- read_excel("teste.xlsx", sheet = 1)  

##### _Lendo tabelas de um banco MSSQL via ODBC_  
library(rodbc)  
conn <- odbcConnect("nomeDaConexao", rows_at_time = 1)  
sql <- "  
SET NOCOUNT ON;  
SELECT * FROM TABELA  
"  
df <- sqlQuery(conn, sql, stringsAsFactors = F)  
View(df)  
odbcClose(conn)  
library(sqldf)  
qry <- "  
SELECT * FROM df  
"  
df2 <- sqldf(qry)  
View(df2)  

_OBS: ao usar o sqldf o padrao de escrita sera do banco SQLite_  

##### _Avaliando tipos de dados e fazendo conversoes_  
library(dplyr)  
str(df)  
glimpse(df)  

df$data <- as.Date(df$data, format ='%Y-%m-%d')  

_OBS: formato da data atual_  

df$campo <- as.numeric(df$campo)  

_OBS: os tipos são character, integer, numeric, logical, complex, factor, date_  

##### _Verificando integridade dos dados_  
sapply(df, function(x) sum(is.na(x)))  
sapply(df, function(x) sum(is.nan(x)))  

##### _Substituindo valores em colunas_  
df$valor <- gsub(",", ".", df$valor)  
df$coluna1[df$coluna2 >= "2021-01-01" & df$coluna2 <= "2021-01-07"] <- 0  

##### _Escrevendo arquivos_  
library(readr)  
write_delim(df, "arquivo.txt", delim = ",")  

##### _Excluir colunas_  
df2 <- select(df, -c(5))  
df2 <- select(df, -c(2,4))  
df2 <- select(df, -c(2:5))  

##### _Renomear colunas_  
df <- rename(df, novonome = antigonome)  

##### _Filtrar linhas_  
df2 <- df %>% filter(campo=="valor")  

##### _Criando colunas com base em outras colunas_  
df["novacoluna"] <- df$coluna1 * df$coluna2  

##### _Medidas de centralidade_  
mean(df2$campo)  
median(df2$campo)  

getmode <- function(v) {  
  uniqv <- unique(v)  
  uniqv[which.max(tabulate(match(v, uniqv)))]  
}  
getmode(df2$campo)  

summarise_at(df, vars(campo1, campo2), mean)  

##### _Medidas de posicao_  
min(df2$campo)  
max(df2$campo)  
range(df2$campo)  
quantile(df2$campo)  
IQR(df2$campo)  

summary(df2$campo)  

##### _Medidas de dispersao_  
_Variancia_  
var(df2$campo)  

_Desvio padrao_  
sd(df2$campo)  

_Testes de normalidade (maior que 0,05 = distribuicao normal)_  
library(nortest)  
ad.test(df2$campo)  
cvm.test(df2$campo)  
lillie.test(df2$campo)  
sf.test(df2$campo)  
pearson.test(df2$campo)  

##### _Correlacao linear_  

_method_   
"pearson" para dados parametricos (normalidade e homocedasticidade)  
"spearman" (volume grande de dados nao parametricos)  
"kendall" (volume pequeno de dados nao parametricos)  

cor(df2$campo1,df2$campo2,method = "pearson")  

regressao <- lm(formula= campo1 ~ campo2, data=df2)  
regressao$coefficients  
summary(regressao)  
