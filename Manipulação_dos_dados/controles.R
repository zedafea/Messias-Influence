# controles.R

# Esse script:
# > abre dados sobre IPVS, população por idade e renda
# > junta os dados e salva como .csv

###########################################################################

# Passo 0: Definir diretório e carregar bibliotecas

rm(list = ls())

setwd("C:/Users/lucam/OneDrive/Área de Trabalho/Economia/R/GEPE")

library(dplyr)
library(tidyr)
library(readr)

options(scipen = 999) # disable scientific notation

###########################################################################

# Passo 1: Abrindo dados de idade, renda e IPVS

# Dados de população
populacao = read.csv("populacao_por_idade.csv", encoding = "UTF-8", sep = ";", dec = ",", ) %>%
            rename(Distrito = 1)


populacao$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                            toupper(populacao$Distrito)) %>%
                     trimws()

populacao$Distrito[populacao$Distrito=="MARSILLAC"] = "MARSILAC"

# Dados de vulnerabilidade
ipvs = read.csv("imp_2021-04-20_22-08.csv", sep = ";") %>% select(1,6,7,8) 

ipvs = ipvs %>% mutate(vuln = rowSums(.[2:4])) %>% select(1, 5) %>%
      rename(Distrito = 1, ipvs = 2)

ipvs$Distrito = gsub("\\(distrito da capital\\)", "", ipvs$Distrito)

ipvs$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                        toupper(ipvs$Distrito)) %>%
                trimws()

# Ajustar ortografia
ipvs$Distrito[ipvs$Distrito=="MARSILLAC"] = "MARSILAC"

# Dados de renda
income = read.csv("renda_media_distrito_2017 - Página1.csv", encoding = "UTF-8",
                 header = FALSE) %>% rename(Distrito = 1, renda = 2)

# Formatar os valores
income$renda = gsub("R\\$ ", "", income$renda)
income$renda = gsub("\\.", "", income$renda)
income$renda = gsub(",", ".", income$renda)
income$renda = as.numeric(income$renda)

# Ajustar ortografia
income$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                        toupper(income$Distrito)) %>%
                  trimws()

income$Distrito[income$Distrito=="MARSILLAC"] = "MARSILAC"

income = income %>% mutate(log_renda = log(renda))

###########################################################################

# Passo 2: Abrindo outros dados socioeconômicos

# Dados de água
agua = read.csv("[ODS.06.01] Proporção de Domicílios não conectados a rede geral de Água (%)20210512.csv", 
                sep = ";", dec = ",") %>% select(REGIÃO, RESULTADO)

agua$REGIÃO = gsub("\\(Distrito\\)", "", agua$REGIÃO)

agua = agua %>% rename(Distrito = 1, agua = 2)

agua$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                          toupper(agua$Distrito)) %>%
  trimws()

# Dados do mapa da desigualdade

dados = read.csv("mapa da desigualdade.csv", sep = ";", encoding = "UTF-8", dec = ",") %>%
        rename(Distrito = 1, transporte = 2, num_favelas = 3, etnia = 4, 
               cobertura = 5, escolas =6)




dados$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔÜ", "AEIOUCAAOOU", 
                       toupper(dados$Distrito)) %>%
  trimws()



###########################################################################

# Passo 3: Juntando dados e salvando como .csv

controles = left_join(income, ipvs, by = "Distrito") %>% 
            left_join(populacao, by = "Distrito") %>%
            left_join(agua, by = "Distrito") %>%
            left_join(dados, by = "Distrito")


write_csv(controles, file = "controles.csv")

