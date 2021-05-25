# mapas_figuras.R

# Esse script:
# > Gera mapas com as principais variáveis em análise por distrito
# > Gera gráficos de correlação entre principais variáveis sob análise

###########################################################################

# Passo 0: Definir diretório e carregar bibliotecas

rm(list = ls())

setwd("C:/Users/lucam/OneDrive/Área de Trabalho/Economia/R/GEPE")

library(dplyr)
library(tidyr)
library(sf)
library(ggplot2)
library(ggmap)
library(viridis)
library(ggthemes)
library(gridExtra)
library(purrr)

options(scipen = 999) # disable scientific notation

###########################################################################

# Passo 1: Preparando arquivos

# Carregando os datasets iniciais
locais = read.csv("coordenadas_seções.csv", encoding = "UTF-8") %>%
         arrange(NR_ZONA, NR_SECAO, Distrito) 

map = read_sf("./SIRGAS_SHP_distrito/SIRGAS_SHP_distrito_polygon.shp", layer="SIRGAS_SHP_distrito_polygon")

map = st_set_crs(map, 31983) # sistema SIRGAS 2000 UTM 23S

map = map %>% st_transform("crs" = 4626) # sistema long/lat


votos = read.csv("eleicao_18_sp_ZE_SE.csv") %>% select(-X) %>%
        mutate(across(starts_with("NR"), as.numeric))

votos = left_join(votos, locais, by = c("NR_ZONA", "NR_SECAO")) %>%
        mutate(across(starts_with("NR"), as.numeric)) %>%
        arrange(NR_ZONA, NR_SECAO, Distrito) 

data_final = read.csv("dataset_final.csv", encoding = "UTF-8")

# Agregar as mortes e casos (estão separadas por idade e ano)
data_final = data_final %>% mutate(obitos_total = 
                                     select(., starts_with("obitos")) %>%
                                     rowSums / 
                                     populacao_2017_total * 100000)

data_final = data_final %>% mutate(casos_total = 
                                     select(., starts_with("casos")) %>%
                                     rowSums / 
                                     populacao_2017_total * 100000)

data_final = data_final %>% mutate(excedente_total = 
                                     select(., starts_with("excedente")) %>%
                                     rowSums / 
                                     populacao_2017_total * 100000)

# Juntar as coordenadas e geometria com o dataset completo
data_final = left_join(data_final, map, by = c("Distrito" = "ds_nome"))

###########################################################################

# Passo 2: Montar e exportar os mapas

# Mapa de votos por local de votação
a = ggplot(data = map) +
    geom_sf(fill = "grey", color = "white") +
    geom_point(data = votos,
               aes(x = Longitude, y = Latitude, 
                  color = votos_2018_Bolsonaro_1_percentual * 100 ),
               size = 1.4, 
               shape = 16) +
    labs(title = "Resultado eleitoral no primeiro turno", 
         subtitle = "Votos em Jair Bolsonaro por local de votação do município de São Paulo, 2018", 
         caption = "Geometria: Prefeitura de São Paulo. Dados: TSE") +
    theme_void() +
    scale_color_viridis(option = "magma", direction = -1,
                        name = "Votos (%)",
                        guide = guide_colorbar(direction = "horizontal",
                                       barheight = unit(2, units = "mm"),
                                       barwidth = unit(50, units = "mm"),
                                       title.position = 'top',
                                       title.hjust = 0.5,
                                       label.hjust = 0.5))
# Mapa de votos por distrito
b = ggplot(data = data_final) +
    geom_sf(data = data_final$geometry, color = "white",
            aes(fill = data_final$votos_2018_Bolsonaro_1_percentual * 100)) +
    labs(title = "Resultado eleitoral no primeiro turno", 
         subtitle = "Votos em Jair Bolsonaro por distrito do município de São Paulo, 2018", 
         caption = "Geometria: Prefeitura de São Paulo. Dados: TSE") +
    theme_void() +
    scale_fill_viridis(option = "magma", direction = -1,
                       name = "Votos (%)",
                       guide = guide_colorbar(direction = "horizontal",
                                              barheight = unit(2, units = "mm"),
                                              barwidth = unit(50, units = "mm"),
                                              title.position = 'top',
                                              title.hjust = 0.5,
                                              label.hjust = 0.5))
# Mapa de renda por distrito
c = ggplot(data = data_final) +
    geom_sf(data = data_final$geometry, color = "white",
            aes(fill = data_final$renda)) +
    labs(title = "Distribuição de Renda", 
         subtitle = "Renda média familiar mensal por distrito do município de São Paulo, 2020", 
         caption = "Geometria: Prefeitura de São Paulo. Dados: Mapa da Desigualdade 2020 (RNSP)") +
    theme_void() +
    scale_fill_viridis(option = "magma", direction = -1,
                       name = "Renda média familiar (R$)",
                       guide = guide_colorbar(direction = "horizontal",
                                              barheight = unit(2, units = "mm"),
                                              barwidth = unit(50, units = "mm"),
                                              title.position = 'top',
                                              title.hjust = 0.5,
                                              label.hjust = 0.5))
# Mapa de IPVS por distrito
d = ggplot(data = data_final) +
    geom_sf(data = data_final$geometry, color = "white",
            aes(fill = data_final$ipvs)) +
    labs(title = "Índice Paulista de Vulnerabilidade Social", 
         subtitle = "População com IPVS médio ou maior por distrito do município de São Paulo, 2010", 
         caption = "Geometria: Prefeitura de São Paulo. Dados: SEADE") +
    theme_void() +
    scale_fill_viridis(option = "magma", direction = -1,
                       name = "População exposta (%)",
                       guide = guide_colorbar(direction = "horizontal",
                                              barheight = unit(2, units = "mm"),
                                              barwidth = unit(50, units = "mm"),
                                              title.position = 'top',
                                              title.hjust = 0.5,
                                              label.hjust = 0.5))

# Mapa de casos por distrito
e = ggplot(data = data_final) +
  geom_sf(data = data_final$geometry, color = "white",
          aes(fill = data_final$casos_total)) +
  labs(title = "Casos confirmados de COVID-19", 
       subtitle = "Casos acumulados por distrito do município de São Paulo, até março de 2021", 
       caption = "Geometria: Prefeitura de São Paulo. Dados: SIVEP-GRIPE SMS-SP") +
  theme_void() +
  scale_fill_viridis(option = "magma", direction = -1,
                     name = "Casos por 100k habitantes",
                     guide = guide_colorbar(direction = "horizontal",
                                            barheight = unit(2, units = "mm"),
                                            barwidth = unit(50, units = "mm"),
                                            title.position = 'top',
                                            title.hjust = 0.5,
                                            label.hjust = 0.5))

# Mapa de mortes por distrito
f = ggplot(data = data_final) +
  geom_sf(data = data_final$geometry, color = "white",
          aes(fill = data_final$obitos_total)) +
  labs(title = "Óbitos confirmados por COVID-19", 
       subtitle = "Óbitos acumulados por distrito do município de São Paulo, até março de 2021", 
       caption = "Geometria: Prefeitura de São Paulo. Dados: SIM/PROAIM SMS-SP") +
  theme_void() +
  scale_fill_viridis(option = "magma", direction = -1,
                     name = "Óbitos por 100k habitantes",
                     guide = guide_colorbar(direction = "horizontal",
                                            barheight = unit(2, units = "mm"),
                                            barwidth = unit(50, units = "mm"),
                                            title.position = 'top',
                                            title.hjust = 0.5,
                                            label.hjust = 0.5))
# Mapa de excedente de óbitos
g = ggplot(data = data_final) +
    geom_sf(data = data_final$geometry, color = "white",
            aes(fill = data_final$excedente_total)) +
    labs(title = "Excedentes de óbitos em relação aos três anos anteriores", 
         subtitle = "Excedente de óbitos acumulados por distrito do município de São Paulo, até março de 2021", 
         caption = "Geometria: Prefeitura de São Paulo. Dados: SIM/PROAIM SMS-SP") +
    theme_void() +
    scale_fill_viridis(option = "magma", direction = -1,
                       name = "Óbitos por 100k habitantes",
                       guide = guide_colorbar(direction = "horizontal",
                                              barheight = unit(2, units = "mm"),
                                              barwidth = unit(50, units = "mm"),
                                              title.position = 'top',
                                              title.hjust = 0.5,
                                              label.hjust = 0.5))

# Exportar todos os mapas como png
paths = c(1:7)

paths = paste0("mapa", paths,".png")

plots = list(a, b, c, d, e, f, g)

pwalk(list(filename = paths, plot = plots), ggsave, dpi = 700, width = 6, height = 8)

###########################################################################

# Passo 3: Montar e exportar os gráficos

# Gráfico de IPVS vs Renda
i = ggplot(data = data_final, aes(x = log_renda, 
                                  y = ipvs)) +
         geom_point(color = "black", alpha = 0.6) + 
         geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
         labs(x = "Renda Média Familiar Mensal (Log)",
              y = "População com IPVS médio ou maior (%)",
              title = "Correlação entre Renda e IPVS")+
         theme_calc() +
    theme(plot.caption = element_text(face = "italic"))
  
# Gráfico de Votos vs Renda   
j = ggplot(data = data_final, aes(x = log_renda, 
                                  y = votos_2018_Bolsonaro_1_percentual,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Renda Média Familiar Mensal (Log)",
       y = "Votos em Jair Bolsonaro (%)",
       title = "Correlação entre Renda e Votos", 
       caption = "Nota: Votos no Primeiro Turno.")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Votos vs Excedente
k = ggplot(data = data_final, aes(x = votos_2018_Bolsonaro_1_percentual, 
                                  y = excedente_total,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Votos em Jair Bolsonaro (%)",
       y = "Excedente de Óbitos por 100k habit.",
       title = "Correlação entre Votos e Excedente de Óbitos", 
       caption = "Nota: Votos no Primeiro Turno.")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Votos vs Óbitos
l = ggplot(data = data_final, aes(x = votos_2018_Bolsonaro_1_percentual, 
                                  y = obitos_total,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Votos em Jair Bolsonaro (%)",
       y = "Óbitos por COVID-19 por 100k habit.",
       title = "Correlação entre Votos e Óbitos por COVID-19", 
       caption = "Nota: Votos no Primeiro Turno.")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Renda vs Óbitos
m = ggplot(data = data_final, aes(x = log_renda, 
                                  y = obitos_total,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Renda Média Familiar Mensal (Log)",
       y = "Óbitos por COVID-19 por 100k habit.",
       title = "Correlação entre Renda e Óbitos por COVID-19")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Renda vs Excedente
n = ggplot(data = data_final, aes(x = log_renda, 
                                  y = excedente_total,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Renda Média Familiar Mensal (Log)",
       y = "Excedente de Óbitos por 100k habit.",
       title = "Correlação entre Renda e Excedente de Óbitos")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Calculando a Aceleração de Óbitos
# 2020: De 18 de março a 31 de dezembro = 289 dias
data_final = data_final %>% mutate(obitos2020_dia = 
                                         select(., starts_with("obitos_2020")) %>%
                                         rowSums / 
                                         289)

# 2021: De 1 de janeiro a 31 de março = 90 dias
data_final = data_final %>% mutate(obitos2021_dia = 
                                     select(., starts_with("obitos_2021")) %>%
                                     rowSums / 
                                     90)

# Definindo aceleração de óbitos
data_final = data_final %>% mutate(aceleracao = 
                                   (obitos2021_dia / obitos2020_dia - 1) * 100)

# Gráfico de Aceleração de Óbitos vs Votos
o = ggplot(data = data_final, aes(x = votos_2018_Bolsonaro_1_percentual, 
                                  y = aceleracao,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Votos em Jair Bolsonaro (%)",
       y = "Aceleração de Óbitos em 2021 (%)",
       title = "Correlação entre Votos e Aceleração de Óbitos", 
       caption = "Nota: Votos no Primeiro Turno.")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Aceleração de Óbitos vs Renda
p = ggplot(data = data_final, aes(x = log_renda, 
                                  y = aceleracao,)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_smooth(method = "lm", formula = y ~ x, color = "darkblue") +
  
  labs(x = "Renda Média Familiar Mensal (Log)",
       y = "Aceleração de Óbitos em 2021 (%)",
       title = "Correlação entre Renda e Aceleração de Óbitos")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))

# Gráfico de Distritos excluídos
df_ricos <- data_final %>%
  filter(log_renda >= 8.305727)
df_ricos_ig <- df_ricos %>%
  filter(ipvs <= 14.5)
df_2 <- data_final %>%
  filter(log_renda < 8.305727)
df_main <- rbind(df_2,df_ricos_ig)
df_ricos_desig <- df_ricos %>%
  filter(ipvs >= 14.5)

z = ggplot(data = data_final, aes(x = log_renda, 
                                  y = ipvs)) +
  geom_point(color = "black", alpha = 0.6) + 
  geom_point(data=df_ricos_desig, 
             aes(x= log_renda,y= ipvs), 
             color='red') +
  labs(x = "Renda Média Familiar Mensal (Log)",
       y = "População com IPVS médio ou maior (%)",
       title = "Correlação entre Renda e IPVS")+
  theme_calc() +
  theme(plot.caption = element_text(face = "italic"))


# Exportar todos os gráficos como png
paths = c(1:9)

paths = paste0("grafico", paths,".png")

plots = list(i, j, k, l, m, n, o, p, z)

pwalk(list(filename = paths, plot = plots), ggsave, dpi = 700, width = 8, height = 4)
