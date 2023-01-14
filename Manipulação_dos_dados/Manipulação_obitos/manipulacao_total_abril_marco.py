import os 
os.chdir(r'C:\Users\guilh\Documents\Messias-Influence\Manipulação_dos_dados\Manipulação_obitos')
from manipulacao_ano_ano import create_df_ano_ano
import pandas as pd

df_2017,df_2018,df_2019,df_2020,df_2021,df_2022 = create_df_ano_ano()

dfs = [df_2017,df_2018,df_2019,df_2020,df_2021,df_2022]
df_main = pd.concat(dfs,axis=1)

#Substituindo a expressão '-' por zeros e transformando todos os valores em numéricos
df_main = df_main.replace({'-':0})
df_main.fillna(0,inplace=True)
df_main = df_main.astype('int')

#Por meio desse loop nós passamos pelos anos e pelas faixas etárias obtendo a informação
#do número de óbitos de Abril a Março do ano seguinte
ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]
la = [2017,2018,2019,2020,2021,2022]
df_total = {}
for i in la:
    if i != 2022:
        for j in ls:
            df_aux0 = df_main.loc[:,f'obitos_{i}_total_Abril_{j[0]}_{j[1]}_anos':f'obitos_{i}_total_Dezembro_{j[0]}_{j[1]}_anos']
            df_aux1 = df_main.loc[:,f'obitos_{i+1}_total_Janeiro_{j[0]}_{j[1]}_anos':f'obitos_{i+1}_total_Março_{j[0]}_{j[1]}_anos']
            df_aux = pd.concat([df_aux0,df_aux1],axis=1)
            df_total[f'obitos_{i}/{i+1}_total_{j[0]}_{j[1]}_anos'] = df_aux.sum(axis=1)
df_total = pd.DataFrame(df_total)  

#Criação dos dados trimestrais
df_total_trimestre = []
aux_ = df_main.loc[:,df_main.columns[df_main.columns.str.contains('0_9_anos')]]
aux__ = aux_.T.rolling(3).sum().T
df_total_trimestre.append(aux__) 
for z in ls[1:]:
    aux_ = df_main.loc[:,df_main.columns[df_main.columns.str.contains(f'{z[0]}')&df_main.columns.str.contains(f'{z[1]}')]]
    aux__ = aux_.T.rolling(3).sum().T
    df_total_trimestre.append(aux__) 
df_total_trimestre = pd.concat(df_total_trimestre,axis=1).dropna(axis=1)

#Total por distrito e trimestre sem distinguir faixa etária
meses = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro']
df_total_trimestre_todos = {}
for c in la:
    for b in meses:
        aux_ = df_total_trimestre.loc[:,df_total_trimestre.columns[df_total_trimestre.columns.str.contains(f'{c}')&df_total_trimestre.columns.str.contains(f'{b}')]]
        df_total_trimestre_todos[f'obitos_{c}_total_{b}_todos'] = aux_.sum(axis=1)
df_total_trimestre_todos = pd.DataFrame.from_dict(df_total_trimestre_todos,orient='index').T

df_total.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_novo.csv')
df_total_trimestre.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_trimestre.csv')
df_total_trimestre_todos.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_trimestre_todos.csv')
