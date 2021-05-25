# casos_obitos.R

# Esse script:
# > gera variáveis de excedentes de mortes por distrito
# > junta com dados de casos e mortes por COVID-19
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

# Passo 1: Obtendo excedentes de mortes por distrito

mortes_total = read.csv("total_obitos_distrito.csv", encoding = "UTF-8") %>%
  rename(Distrito = 1)

mortes_total$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                               toupper(mortes_total$Distrito)) %>%
  trimws() 

idades = c("0_9", "10_19", "20_29", "30_39", 
           "40_49", "50_59", "60_69", "70_inf")

# Usamos um loop para gerar as variáveis de média e excedente para as idades
for (i in 1:length(idades)){
  
  idade = idades[i]
  
  mortes_total = mortes_total %>% 
    
    mutate(!!paste0("media_mortes_total_", idade) := 
             select(., matches("(2017|2018|2019)")) %>%
             select(matches(idade)) %>% rowMeans) %>% 
    
    mutate(!!paste0("excedente_mortes_", idade) :=
             select(., intersect(matches("2021"),
                                  matches(idade))) %>% pull -
             select(., intersect(matches("media"),
                                 matches(idade))) %>% pull)
}

mortes_total = mortes_total %>% select(Distrito, contains("excedente"))

###########################################################################

# Passo 2: Obtendo casos e obitos de COVID por distrito

casos_2020 = read.csv("casos_2020.csv", skip = 4, sep = ";",
                      nrows = 96)

casos_2021 = read.csv("casos_2021.csv", skip = 4, sep = ";", 
                      nrows = 96)

obitos_2020_COVID = read.csv("obitoscovid_2020.csv", 
                             skip = 4, sep = ";", nrows = 96)

obitos_2021_COVID = read.csv("obitoscovid_2021.csv", 
                             skip = 5, sep = ";", nrows = 96)


names(casos_2020) = c("Distrito",
                      paste("casos_2020", idades, sep = "_"),
                     "Ign",
                     "Total")

names(casos_2021) = c("Distrito",
                      paste("casos_2021", idades, sep = "_"),
                     "Ign",
                     "Total")

names(obitos_2020_COVID) = c("Distrito",
                           paste("obitos_2020_COVID", idades, sep = "_"),
                          "Ign",
                          "Total")

names(obitos_2021_COVID) = c("Distrito",
                             paste("obitos_2021_COVID", idades, sep = "_"),
                            "Ign",
                            "Total")

###########################################################################

# Passo 3: Juntando o dataset final de casos e óbitos

casos_obitos = left_join(casos_2020, casos_2021, by = "Distrito") %>%
               left_join(obitos_2020_COVID, by = "Distrito") %>%
               left_join(obitos_2021_COVID, by = "Distrito") %>%
               select(-contains("Ign"), -contains("Total"))

casos_obitos$Distrito = chartr("ÁÉÍÓÚÇÃÂÕÔ", "AEIOUCAAOO", 
                               toupper(mortes_total$Distrito)) %>%
                       trimws() 
  
casos_obitos = left_join(mortes_total, casos_obitos, by = "Distrito")

write_csv(casos_obitos, file = "casos_obitos.csv")
###########################################################################

