# coordenadas_seções.R

# Esse script:
# > associa coordenadas geográficas aos endereços de locais de votação
# > junta as coordenadas à delimitação dos distritos de São Paulo
# > salva o arquivo com os distritos de cada seção eleitoral como csv

###########################################################################

# Passo 0: Definir diretório e carregar bibliotecas

rm(list = ls())

setwd("C:/Users/lucam/OneDrive/Área de Trabalho/Economia/R/GEPE")

library(dplyr)
library(tidyr)
library(readr)
library(sf)

options(scipen = 999) # disable scientific notation

###########################################################################

# Passo 1: Obter os endereços de cada seção eleitoral

# O arquivo está disponível em 
# https://www.tse.jus.br/eleicoes/estatisticas/repositorio-de-dados-eleitorais-1/
# Eleitorado > 2018 > Eleitorado por local de votação

locais = read.csv("eleitorado_local_votacao_2018.csv", sep = ";") %>%
         filter(NM_MUNICIPIO == "SÃO PAULO" &
               DS_ELEICAO == "1º Turno"  ) %>% 
         select(NR_ZONA, NR_SECAO, NM_LOCAL_VOTACAO, DS_ENDERECO, NR_CEP) 

###########################################################################

# Passo 2: Obter as coordenadas de cada local de votação

# Registrar chave da API do Google Maps
# insira sua chave API register_google(key = "", write = TRUE) 

# Criando dataframe a ser preenchido com as coordenadas
df = locais %>% select(-c(NR_ZONA, NR_SECAO)) %>% unique()

df = df %>% data.frame("Longitude" = 0, "Latitude" = 0)

# Extrair coordenadas usando nome, endereço e CEP - quando há erro, 
# usamos apenas o endereço (isso ocorre em dois dos 2041 locais de voto)

for (i in 1:length(df$Longitude)){
  
  nome = df[i, 1]
  endereço = df[i, 2]
  CEP = df[i, 3]
  
  address = paste(nome, endereço, CEP, ", São Paulo, Brazil")
  
  geo = geocode(location = address)
  
  if(is.na(geo$lon)){geo = geocode(location = paste(
                                   endereço, ", São Paulo, Brazil"))}
  
  df[i, "Longitude"] = geo$lon
  df[i, "Latitude"] =geo$lat

  cat("| address", i, "out of", length(df$Longitude), " ") # status do loop
  
}

df = df %>% select(-NR_CEP) %>% rename(Endereço = DS_ENDERECO,
                                    Nome = NM_LOCAL_VOTACAO)

rm(list = setdiff(ls(), c("df", "locais"))) # limpar o environment

###########################################################################

# Passo 3: Localizando os locais de votação nos distritos

# Abrir shapefile do município de São Paulo 
# Pode ser obtido em http://dados.prefeitura.sp.gov.br/dataset/distritos
map = read_sf("./SIRGAS_SHP_distrito/SIRGAS_SHP_distrito_polygon.shp", layer="SIRGAS_SHP_distrito_polygon")

# Identificando o referencial geodésico do shapefile (conforme metadados)
map = st_set_crs(map, 31983) # SIRGAS 2000/UTM 23S

pontos = df %>% select(Endereço, Nome, Longitude, Latitude)

pontos_sf = pontos %>% select(-c(Endereço, Nome))

# Criando simple feature com as coordenadas em latitude/longitude
# O sistema geodésico é EPSG:4626
pontos_sf = lapply(1:nrow(pontos_sf), 
                   function(i) {st_point(as.numeric(pontos_sf[i, ]))}) %>%
                   st_sfc("crs" = 4626) # proj=longlat +datum=WGS84

pontos_sf = st_transform(pontos_sf, 31983) # converter para SIRGAS 2000/UTM 23S

# Encontrando a intersecção e extraindo nome do distrito
pontos$Distrito = apply(st_intersects(map, pontos_sf, sparse = FALSE), 2, 
                    function(col) { 
                      map[which(col), ]$ds_nome
                    })

# Organizando o dataframe final
distritos = left_join(df, pontos, by = c("Endereço",
                                         "Nome",
                                         "Latitude",
                                         "Longitude"))
                
distritos$Distrito = distritos$Distrito %>% as.character()


###########################################################################

# Passo 4: Juntando com os endereços de locais de votação e salvando

locais = left_join(locais, distritos, by = c("NM_LOCAL_VOTACAO" = "Nome",
                                             "DS_ENDERECO" = "Endereço")) %>%
         rename(c(Nome = NM_LOCAL_VOTACAO, Endereço = DS_ENDERECO))


# Salvar como csv
write_csv(locais, file = "coordenadas_seções.csv")





