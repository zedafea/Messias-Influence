import os 
os.chdir(r'C:\Users\guilh\Documents\Messias-Influence\Manipulação_dos_dados\Manipulação_obitos_COVID')
from manipulacao_ano_ano_COVID import create_df_ano_ano_COVID
import pandas as pd

df_2020_COVID,df_2021_COVID,df_2022_COVID = create_df_ano_ano_COVID()

dfs = [df_2020_COVID,df_2021_COVID,df_2022_COVID]
df_main = pd.concat(dfs,axis=1)

#Substituindo a expressão '-' por zeros e transformando todos os valores em numéricos
df_main = df_main.replace({'-':0})
df_main.fillna(0,inplace=True)
df_main = df_main.astype('int')

#Por meio desse loop nós passamos pelos anos e pelas faixas etárias obtendo a informação
#do número de óbitos de Abril a Março do ano seguinte
ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]
la = [2020,2021,2022]
df_total_COVID = {}
for i in la:
    if i != 2022:
        for j in ls:
            df_aux0 = df_main.loc[:,f'obitos_COVID_{i}_total_Abril_{j[0]}_{j[1]}_anos':f'obitos_COVID_{i}_total_Dezembro_{j[0]}_{j[1]}_anos']
            df_aux1 = df_main.loc[:,f'obitos_COVID_{i+1}_total_Janeiro_{j[0]}_{j[1]}_anos':f'obitos_COVID_{i+1}_total_Março_{j[0]}_{j[1]}_anos']
            df_aux = pd.concat([df_aux0,df_aux1],axis=1)
            df_total_COVID[f'obitos_{i}/{i+1}_total_COVID_{j[0]}_{j[1]}_anos'] = df_aux.sum(axis=1)
df_total_COVID = pd.DataFrame(df_total_COVID)  

df_total_COVID.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_COVID_distrito_novo.csv')
