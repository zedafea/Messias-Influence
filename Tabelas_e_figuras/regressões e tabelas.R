# regressoes_tabelas.R


# Esse script:
# > Gera tabelas descritivas com as principais vari�veis em an�lise por distrito
# > Gera tabelas de regress�o da an�lise

###########################################################################

# Passo 0: Definir diret�rio e carregar bibliotecas

rm(list = ls())

setwd("C:/Users/lucam/OneDrive/�rea de Trabalho/Economia/R/GEPE")

library(dplyr)
library(tidyr)
library(stringr)
library(stargazer)

options(scipen = 999) # disable scientific notation

###########################################################################

# Passo 1: Preparando dataset 

data = read.csv("dataset_final.csv")

#Excedente de mortes
data = data %>% mutate(excedente_mortes_total = excedente_mortes_0_9 +
                         excedente_mortes_10_19 + excedente_mortes_20_29 +
                         excedente_mortes_30_39 + excedente_mortes_40_49 +
                         excedente_mortes_50_59 + excedente_mortes_60_69 +
                         excedente_mortes_70_inf)

data = data %>% mutate(excedente_mortes_total_cap = excedente_mortes_total /
                         populacao_2017_total * 100000)
#�bitos COVID
data = data %>% mutate(obitos_2020_COVID_total = obitos_2020_COVID_0_9 +
                         obitos_2020_COVID_10_19 + obitos_2020_COVID_20_29 +
                         obitos_2020_COVID_30_39 + obitos_2020_COVID_40_49 +
                         obitos_2020_COVID_50_59 + obitos_2020_COVID_60_69 +
                         obitos_2020_COVID_70_inf)

data = data %>% mutate(obitos_2021_COVID_total = obitos_2021_COVID_0_9 +
                         obitos_2021_COVID_10_19 + obitos_2021_COVID_20_29 +
                         obitos_2021_COVID_30_39 + obitos_2021_COVID_40_49 +
                         obitos_2021_COVID_50_59 + obitos_2021_COVID_60_69 +
                         obitos_2021_COVID_70_inf)

#Casos COVID
data = data %>% mutate(casos_2020_total = casos_2020_0_9 +
                         casos_2020_10_19 + casos_2020_20_29 +
                         casos_2020_30_39 + casos_2020_40_49 +
                         casos_2020_50_59 + casos_2020_60_69 +
                         casos_2020_70_inf)

data = data %>% mutate(casos_2021_total = casos_2021_0_9 +
                         casos_2021_10_19 + casos_2021_20_29 +
                         casos_2021_30_39 + casos_2021_40_49 +
                         casos_2021_50_59 + casos_2021_60_69 +
                         casos_2021_70_inf)

#Casos e mortes totais com rela��o a COVID
data = data %>% mutate(casos_COVID_total_cap = (casos_2020_total + casos_2021_total)
                       / populacao_2017_total * 100000)

data = data %>% mutate(obitos_COVID_total_cap = (obitos_2020_COVID_total + obitos_2021_COVID_total)
                       / populacao_2017_total * 100000)


# % de Idosos
data = data %>% mutate(populacao_2017_percentagem_idosos = populacao_2017_percentagem_60_69_anos +
                         populacao_2017_percentagem_70_os_anos)

#Casos e mortes totais com rela��o a COVID
data = data %>% mutate(casos_COVID_total_cap = (casos_2020_total + casos_2021_total)
                       / populacao_2017_total * 100000)

data = data %>% mutate(obitos_COVID_total_cap = (obitos_2020_COVID_total + obitos_2021_COVID_total)
                       / populacao_2017_total * 100000)


# Segmenta��o por faixa et�ria

data['pop_total_60'] <- data %>%
  select(populacao_2017_total_00_09_anos,populacao_2017_total_10_19_anos,
         populacao_2017_total_20_29_anos,populacao_2017_total_30_39_anos,
         populacao_2017_total_40_49_anos,populacao_2017_total_50_59_anos) %>%
  rowSums()

data['pop_total_50'] <- data %>%
  select(populacao_2017_total_00_09_anos,populacao_2017_total_10_19_anos,
         populacao_2017_total_20_29_anos,populacao_2017_total_30_39_anos,
         populacao_2017_total_40_49_anos) %>%
  rowSums()

data['pop_total_60_votante'] <- data %>%
  select(
    populacao_2017_total_20_29_anos,populacao_2017_total_30_39_anos,
    populacao_2017_total_40_49_anos,populacao_2017_total_50_59_anos) %>%
  rowSums()

# Vari�veis de excedente por faixa et�ria

data['excedente_60'] <- (data %>%
  select(excedente_mortes_0_9,excedente_mortes_10_19,excedente_mortes_20_29,
         excedente_mortes_30_39,excedente_mortes_40_49,excedente_mortes_50_59) %>%
  rowSums() / data['pop_total_60']) * 100000

data['excedente_50'] <- (data %>%
  select(excedente_mortes_0_9,excedente_mortes_10_19,excedente_mortes_20_29,
         excedente_mortes_30_39,excedente_mortes_40_49) %>%
  rowSums() / data['pop_total_50'])  *100000

data['excedente_60_votante'] <- (data %>%
  select(excedente_mortes_20_29,
         excedente_mortes_30_39,excedente_mortes_40_49,excedente_mortes_50_59) %>%
  rowSums()  / data['pop_total_60_votante']) * 100000
  

# Vari�veis de morte por COVID em 2021 por faixa et�ria
data['obitos_2021_COVID_60'] <- (data %>%
                           select(obitos_2021_COVID_0_9,obitos_2021_COVID_10_19,obitos_2021_COVID_20_29,
                                  obitos_2021_COVID_30_39,obitos_2021_COVID_40_49,obitos_2021_COVID_50_59) %>%
                           rowSums() / data['pop_total_60']) * 100000

data['obitos_2021_COVID_50'] <- (data %>%
                           select(obitos_2021_COVID_0_9,obitos_2021_COVID_10_19,obitos_2021_COVID_20_29,
                                  obitos_2021_COVID_30_39,obitos_2021_COVID_40_49) %>%
                           rowSums() / data['pop_total_50'])  *100000

data['obitos_2021_COVID_60_votante'] <- (data %>%
                                   select(obitos_2021_COVID_20_29,
                                          obitos_2021_COVID_30_39,obitos_2021_COVID_40_49,obitos_2021_COVID_50_59) %>%
                                   rowSums()  / data['pop_total_60_votante']) * 100000

# Calculando a Acelera��o de �bitos
# 2020: De 18 de mar�o a 31 de dezembro = 289 dias
data = data %>% mutate(obitos2020_dia = 
                                     obitos_2020_COVID_total/ 
                                     289)

# 2021: De 1 de janeiro a 31 de mar�o = 90 dias
data = data %>% mutate(obitos2021_dia = 
                                    obitos_2021_COVID_total/
                                     90)

# Definindo acelera��o de �bitos (varia��o %)
data = data %>% mutate(segunda_onda = 
                       (obitos2021_dia / obitos2020_dia - 1) * 100)

#Multiplicando por 100 as colunas percentuais
data = data %>% mutate(votos_2018_Bolsonaro_1_percentual = votos_2018_Bolsonaro_1_percentual * 100,
                   votos_2018_Bolsonaro_2_percentual = votos_2018_Bolsonaro_2_percentual * 100,
                   populacao_2017_percentagem_idosos = populacao_2017_percentagem_idosos * 100)
data = data %>% mutate(votos_2018_Haddad_1_percentual = votos_2018_Haddad_1_percentual * 100,
                       votos_2018_Haddad_2_percentual = votos_2018_Haddad_2_percentual * 100)
# Threshold para retirarmos distritos de renda m�dia e alta com IPVS maior do que a mediana
df_ricos <- data %>%
  filter(log_renda >= 8.305727)
df_ricos_ig <- df_ricos %>%
  filter(ipvs <= 14.5)
df_2 <- data %>%
  filter(log_renda < 8.305727)
df_main <- rbind(df_2,df_ricos_ig)

# Threshold para distritos com maiores diferen�as de votos
data <- data %>% 
  mutate(quartil_votacao = case_when(votos_2018_Bolsonaro_1_percentual <= 36.06 ~ 1,
                                     votos_2018_Bolsonaro_1_percentual > 36.06 & votos_2018_Bolsonaro_1_percentual <= 41.70 ~ 2,
                                     votos_2018_Bolsonaro_1_percentual > 41.70 & votos_2018_Bolsonaro_1_percentual <= 46.27 ~ 3,
                                     votos_2018_Bolsonaro_1_percentual > 46.27  ~ 4)) %>% 
  filter(quartil_votacao == 2 | quartil_votacao == 3)

###########################################################################

# Passo 2: Tabelas de estat�stica descritiva

#DF summary table
df = data %>% select(Distrito, votos_2018_Bolsonaro_1_percentual, votos_2018_Bolsonaro_2_percentual,
                     renda,ipvs,populacao_2017_total,casos_COVID_total_cap,
                     obitos_COVID_total_cap,excedente_mortes_total_cap,
                     populacao_2017_percentagem_idosos)

df = df[order(-df$excedente_mortes_total_cap),]

df['Distrito'] = str_to_title(df$Distrito)

df$renda = paste("R$", round(df$renda, 0))


#Renomeando as colunas 
df = df %>% rename('Bolsonaro 1� T*' = votos_2018_Bolsonaro_1_percentual,
                   'Bolsonaro 2� T*' = votos_2018_Bolsonaro_2_percentual,
                   'Renda M�dia' = renda, 'IPVS' = ipvs, 'Pop. Total' = populacao_2017_total,
                   'Casos de COVID**' = casos_COVID_total_cap,
                   'Mortes por COVID**' = obitos_COVID_total_cap,
                   'Exc. de mortes***' = excedente_mortes_total_cap,
                   'Idosos *' = populacao_2017_percentagem_idosos)
#Selecionando o top 10
df_top = df[1:20, ]

#Selecionando o bottom 10
df_bot = df[77:96, ]

#Exportando pra Latex
stargazer(df_top,summary=FALSE,title = 'Tabela',out = "tabela_sumario_top.tex",
          rownames = FALSE, digits =  0, column.sep.width = "-5pt", notes = "* = Percentagem ** = Dados per capita com rela��o aos anos de 2020 e 2021 *** = Inserir f�rmula")

stargazer(df_bot,summary=FALSE,title = 'Tabela',out = "tabela_sumario_bot.tex",
          rownames = FALSE, digits =  0, column.sep.width = "-5pt", notes = "* = Percentagem ** = Dados per capita com rela��o aos anos de 2020 e 2021 *** = Inserir f�rmula")


###########################################################################

# Passo 3: Regress�es de mortes por COVID

#Mortes de COVID considerando 88 distritos
model1 = lm(obitos_2021_COVID_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = df_main)
model2 = lm(obitos_2021_COVID_60  ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = df_main)
model3 = lm(obitos_2021_COVID_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = df_main)

#Mortes de COVID considerando 96 distritos
model4 = lm(obitos_2021_COVID_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = data)
model5 = lm(obitos_2021_COVID_60  ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = data)
model6 = lm(obitos_2021_COVID_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = data)

stargazer(model1, model2,model3,model4, model5, model6,
          dep.var.caption = "Mortes de COVID (per capita) em 2021",
          dep.var.labels = c('0-50 anos','0-60 anos','20-60 anos','0-50 anos','0-60 anos','20-60 anos'),
          covariate.labels = c("Votos no Bolsonaro","Log da Renda", "Mobilidade", "Cobertura", "�gua", "IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 2',out = "regressao_covid_ambos.tex")

###########################################################################

# Passo 4: Regress�es de excedente
# Regress�es com 88 distritos
model1 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model2 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model3 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = df_main)
model4 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = df_main)
model5 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua, data = df_main)
model6 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua + ipvs, data = df_main)

model1b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model2b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model3b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = df_main)
model4b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = df_main)
model5b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua, data = df_main)
model6b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua +ipvs, data = df_main)

model1c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model2c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model3c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = df_main)
model4c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = df_main)
model5c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua +ipvs, data = df_main)

stargazer(model1b,model2b,model3b,model4b,model5b,model6b,model1c,model2c,model3c,model4c,model5c,model6c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Renda","Mobilidade", "Cobertura", "�gua", "IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 1',out = "regressao_exc_filtro.tex")

# Regress�es com todos
model1a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual, data = data)
model2a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model3a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = data)
model4a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = data)
model5a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua, data = data)
model6a <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua +ipvs, data = data)

model1b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual, data = data)
model2b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model3b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = data)
model4b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = data)
model5b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua, data = data)
model6b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura +agua + ipvs, data = data)
model7b <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura +agua + ipvs + votos_2018_Haddad_1_percentual, data = data)


model1c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual, data = data)
model2c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model3c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte, data = data)
model4c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura, data = data)
model5c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua, data = data)
model6c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua +ipvs, data = data)
model7c <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + transporte + cobertura + agua +ipvs + votos_2018_Haddad_1_percentual, data = data)


stargazer(model1,model2,model3,model4,model5,model6,model1a,model2a,model3a,model4a,model5a,model6a,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c("0-50 anos"),
          covariate.labels = c("Votos","Renda","Mobilidade", "Cobertura", "�gua", "IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 2',out = "regressao_exc_filtro.tex")

stargazer(model1b,model2b,model3b,model4b,model5b,model6b,model7b,model1c,model2c,model3c,model4c,model5c,model6c,model7c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Renda","Mobilidade", "Cobertura", "�gua", "IPVS","Haddad","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 3',out = "regressao_exc_filtro_haddad_controle.html")


## ANTIGAS REGRESSOES DE EXCEDENTE
#Excedente considerando 88 distritos
model1 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model2 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model3 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = df_main)
model4 <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model5 <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model6 <- lm(excedente_60~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = df_main)
model7 <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model8 <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model9 <- lm(excedente_60_votante~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = df_main)

stargazer(model1,model2,model3,model4,model5,model6,model7,model8,model9,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-50 anos','0-60 anos','20-60 anos',
                             '0-50 anos','0-60 anos','20-60 anos',
                             '0-50 anos','0-60 anos','20-60 anos'),
          covariate.labels = c("Votos no Bolsonaro no 1� Turno (em %)","Log da Renda","IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 2',out = "regressao_exc_filtro.tex")

#Excedente considerando 96 distritos
model1 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual, data = data)
model2 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model3 <- lm(excedente_50 ~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = data)
model4 <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual, data = data)
model5 <- lm(excedente_60 ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model6 <- lm(excedente_60~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = data)
model7 <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual, data = data)
model8 <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model9 <- lm(excedente_60_votante ~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = data)

stargazer(model1,model2,model3,model4,model5,model6,model7,model8,model9,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-50 anos','0-60 anos','20-60 anos',
                             '0-50 anos','0-60 anos','20-60 anos',
                             '0-50 anos','0-60 anos','20-60 anos'),
          covariate.labels = c("Votos no Bolsonaro no 1� Turno (em %)","Log da Renda","IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 3',out = "regressao_exc_todos.tex")

###########################################################################

# Passo 5: Regress�es de segunda onda

# Considerando 88 distritos
model1 = lm(segunda_onda ~ votos_2018_Bolsonaro_1_percentual, data = df_main)
model2 = lm(segunda_onda ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = df_main)
model3 = lm(segunda_onda~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = df_main)

# Considerando 96 distritos
model4 = lm(segunda_onda ~ votos_2018_Bolsonaro_1_percentual, data = data)
model5 = lm(segunda_onda ~ votos_2018_Bolsonaro_1_percentual + log_renda, data = data)
model6 = lm(segunda_onda ~ votos_2018_Bolsonaro_1_percentual + log_renda + ipvs, data = data)

stargazer(model1,model2,model3,model4,model5,model6,
          dep.var.caption = "Vari�vel dependente",
          dep.var.labels = "Segunda onda (2021)",
          covariate.labels = c("Votos no Bolsonaro","Log da Renda","IPVS","Constante"),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 4',out = "regressao_aceleracao_ambos.tex")

###########################################################################

# Passo 6: Lidando com ideologia

media_Aecio <- sum(data$votos_2014_Aecio_1_total)/sum(data$votos_2014_todos_1_total)
media_Doria_2016 <- sum(data$votos_2016_Doria_1_total)/sum(data$votos_2016_todos_1_total)
media_Doria_2018_1 <- sum(data$votos_2018_Doria_1_total)/sum(data$votos_2018_todos_1_total_gov)
media_Doria_2018_2 <- sum(data$votos_2018_Doria_2_total)/sum(data$votos_2018_todos_2_total_gov)
media_Bolsonaro <- sum(data$votos_2018_Bolsonaro_1_total)/sum(data$votos_2018_todos_1_total)

data <- data %>%
  mutate(dif_percentual_Aecio_2014 = data$votos_2014_Aecio_1_percentual - media_Aecio,
         dif_percentual_Bolsonaro_2018 = data$votos_2018_Bolsonaro_1_percentual - media_Bolsonaro,
         dif_percentual_Doria_2016 = data$votos_2016_Doria_1_percentual - media_Doria_2016,
         dif_percentual_Doria_2018_1 = data$votos_2018_Doria_1_percentual - media_Doria_2018_1,
         dif_percentual_Doria_2018_2 = data$votos_2018_Doria_2_percentual - media_Doria_2018_2)

data['ideologia_2018_2014'] <- data$dif_percentual_Bolsonaro_2018 - data$dif_percentual_Aecio_2014*100  
data['ideologia_2018_2016'] <- data$dif_percentual_Bolsonaro_2018 - data$dif_percentual_Doria_2016*100
data['ideologia_2018_2018_Doria_1'] <- data$dif_percentual_Bolsonaro_2018 - data$dif_percentual_Doria_2018_1*100
data['ideologia_2018_2018_Doria_2'] <- data$dif_percentual_Bolsonaro_2018 - data$dif_percentual_Doria_2018_2*100

#Considerando todos os distritos

#A�cio_2014
model1b <- lm(excedente_60 ~ ideologia_2018_2014, data = data)
model2b <- lm(excedente_60 ~ ideologia_2018_2014 + log_renda, data = data)
model3b <- lm(excedente_60 ~ ideologia_2018_2014 + log_renda + transporte, data = data)
model4b <- lm(excedente_60 ~ ideologia_2018_2014 + log_renda + transporte + cobertura, data = data)
model5b <- lm(excedente_60 ~ ideologia_2018_2014 + log_renda + transporte + cobertura + agua, data = data)
model6b <- lm(excedente_60 ~ ideologia_2018_2014 + log_renda + transporte + cobertura +agua + ipvs, data = data)

model1c <- lm(excedente_60_votante ~ ideologia_2018_2014, data = data)
model2c <- lm(excedente_60_votante ~ ideologia_2018_2014 + log_renda, data = data)
model3c <- lm(excedente_60_votante ~ ideologia_2018_2014 + log_renda + transporte, data = data)
model4c <- lm(excedente_60_votante ~ ideologia_2018_2014 + log_renda + transporte + cobertura, data = data)
model5c <- lm(excedente_60_votante ~ ideologia_2018_2014 + log_renda + transporte + cobertura + agua, data = data)
model6c <- lm(excedente_60_votante ~ ideologia_2018_2014 + log_renda + transporte + cobertura + agua +ipvs, data = data)

stargazer(model1b,model6b,model1c,model6c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Constante"),
          omit = c('log_renda','transporte','cobertura','agua','ipvs'),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 1',out = "regressao_exc_filtro_14_18.tex")

#D�ria_2016
model1b <- lm(excedente_60 ~ ideologia_2018_2016, data = data)
model2b <- lm(excedente_60 ~ ideologia_2018_2016 + log_renda, data = data)
model3b <- lm(excedente_60 ~ ideologia_2018_2016 + log_renda + transporte, data = data)
model4b <- lm(excedente_60 ~ ideologia_2018_2016 + log_renda + transporte + cobertura, data = data)
model5b <- lm(excedente_60 ~ ideologia_2018_2016 + log_renda + transporte + cobertura + agua, data = data)
model6b <- lm(excedente_60 ~ ideologia_2018_2016 + log_renda + transporte + cobertura +agua + ipvs, data = data)

model1c <- lm(excedente_60_votante ~ ideologia_2018_2016, data = data)
model2c <- lm(excedente_60_votante ~ ideologia_2018_2016 + log_renda, data = data)
model3c <- lm(excedente_60_votante ~ ideologia_2018_2016 + log_renda + transporte, data = data)
model4c <- lm(excedente_60_votante ~ ideologia_2018_2016 + log_renda + transporte + cobertura, data = data)
model5c <- lm(excedente_60_votante ~ ideologia_2018_2016 + log_renda + transporte + cobertura + agua, data = data)
model6c <- lm(excedente_60_votante ~ ideologia_2018_2016 + log_renda + transporte + cobertura + agua +ipvs, data = data)

stargazer(model1b,model6b,model1c,model6c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Constante"),
          omit = c('log_renda','transporte','cobertura','agua','ipvs'),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 2',out = "regressao_exc_filtro_16_18.tex")

#D�ria_2018_1�
model1b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1, data = data)
model2b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1 + log_renda, data = data)
model3b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1 + log_renda + transporte, data = data)
model4b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura, data = data)
model5b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura + agua, data = data)
model6b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura +agua + ipvs, data = data)

model1c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1, data = data)
model2c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1 + log_renda, data = data)
model3c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1 + log_renda + transporte, data = data)
model4c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura, data = data)
model5c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura + agua, data = data)
model6c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_1 + log_renda + transporte + cobertura + agua +ipvs, data = data)

stargazer(model1b,model6b,model1c,model6c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Constante"),
          omit = c('log_renda','transporte','cobertura','agua','ipvs'),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 3',out = "regressao_exc_filtro_18_1_18.tex")

#D�ria_2018_2�
model1b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2, data = data)
model2b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2 + log_renda, data = data)
model3b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2 + log_renda + transporte, data = data)
model4b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura, data = data)
model5b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura + agua, data = data)
model6b <- lm(excedente_60 ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura +agua + ipvs, data = data)

model1c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2, data = data)
model2c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2 + log_renda, data = data)
model3c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2 + log_renda + transporte, data = data)
model4c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura, data = data)
model5c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura + agua, data = data)
model6c <- lm(excedente_60_votante ~ ideologia_2018_2018_Doria_2 + log_renda + transporte + cobertura + agua +ipvs, data = data)

stargazer(model1b,model6b,model1c,model6c,
          dep.var.caption = "Excedente de mortos at� 2021",
          dep.var.labels = c('0-60 anos','20-60 anos'),
          covariate.labels = c("Votos","Constante"),
          omit = c('log_renda','transporte','cobertura','agua','ipvs'),
          notes.label = "N�veis de signific�ncia",
          title = 'Regress�o 4',out = "regressao_exc_filtro_18_2_18.tex")

