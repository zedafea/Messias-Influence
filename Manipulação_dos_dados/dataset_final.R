# dataset_final.R

# Esse script:
# > junta dados eleitorais com dados sobre demografia e mortes
# > salva o arquivo como csv

###########################################################################

# Passo 0: Definir diretório e carregar bibliotecas

rm(list = ls())

setwd("C:/Users/lucam/OneDrive/Área de Trabalho/Economia/R/GEPE")

library(dplyr)
library(tidyr)
library(readr)

options(scipen = 999) # disable scientific notation

###########################################################################

# Passo 1: Associando dados de resultados eleitorais aos distritos

votos = read.csv("eleicao_18_sp_ZE_SE.csv") %>% select(-X) %>%
        mutate(across(starts_with("NR"), as.numeric))

locais = read.csv("coordenadas_seções.csv", encoding = "UTF-8")

data = left_join(votos, locais, by = c("NR_ZONA", "NR_SECAO")) %>%
       mutate(across(starts_with("NR"), as.numeric)) %>%
       arrange(NR_ZONA, NR_SECAO, Distrito) %>%
       select(-c("Nome", "Endereço", "NR_CEP", "Latitude", "Longitude"))
 
data = unite(data, "SECAO", NR_ZONA:NR_SECAO, sep= "_") 
       
data_distrito = aggregate(. ~ Distrito, data = select(data, -c(1, 4, 7)), 
                          sum)

data_distrito = data_distrito %>% 
                mutate(votos_2018_Bolsonaro_1_percentual =
                                 votos_2018_Bolsonaro_1_total /
                                 votos_2018_todos_1_total,
                       votos_2018_Bolsonaro_2_percentual =
                                 votos_2018_Bolsonaro_2_total /
                                 votos_2018_todos_2_total)

###########################################################################

# Passo 2: Juntando com dados de casos e óbitos

casos_obitos = read.csv("casos_obitos.csv")

data_distrito = left_join(data_distrito, casos_obitos, by = "Distrito")

###########################################################################

# Passo 3: Juntando com dados de controle e salvando como .csv

controles = read.csv("controles.csv")

data_distrito = left_join(data_distrito, controles, by = "Distrito")

write_csv(data_distrito, file = "dataset_final.csv")

###########################################################################

       