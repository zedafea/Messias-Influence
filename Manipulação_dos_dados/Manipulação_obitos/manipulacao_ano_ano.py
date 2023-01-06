# -*- coding: utf-8 -*-
"""
Created on Wed Apr 14 11:39:31 2021

@author: guilh
"""

import pandas as pd

ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]

ex = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2017\obitos_total_50_59_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
ex = ex.iloc[4:,].iloc[:-6,].reset_index(drop=True)
ex = ex.rename(columns={0:'Name'})
ex = ex.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
ex = ex.rename(columns = ex.iloc[0]).drop(ex.index[0]) 

distritos = ex.iloc[:,[0,-1]]

#2017
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2017\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-6,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2017) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2017 = pd.concat(dfs,axis=1)

#2018
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2018\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-6,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2018) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2018 = pd.concat(dfs,axis=1)

#2019
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2019_novo\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-5,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    df.iloc[-2,0] = 'Ign'
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df.loc[df['Distrito Admin residência'] == 'Moóca','Distrito Admin residência'] = 'Mooca'
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2019) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2019 = pd.concat(dfs,axis=1)

#2020
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2020_novo\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-5,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    df.iloc[-2,0] = 'Ign'
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df.loc[df['Distrito Admin residência'] == 'Moóca','Distrito Admin residência'] = 'Mooca'
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2020) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2020 = pd.concat(dfs,axis=1)

#2021
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2021_novo\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-5,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    df.iloc[-2,0] = 'Ign'
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df.loc[df['Distrito Admin residência'] == 'Moóca','Distrito Admin residência'] = 'Mooca'
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2021) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2021 = pd.concat(dfs,axis=1)

#2022
dfs = []
for i in ls:
    df = pd.read_csv(rf'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\obitos_total_distrito_2022_novo\obitos_total_{i[0]}_{i[1]}_anos.csv',
                     sep = 'delimiter', encoding = 'Latin1',header = None)
    df = df.iloc[4:,].iloc[:-5,].reset_index(drop=True)
    df = df.rename(columns={0:'Name'})
    df = df.Name.str.split(';',expand = True).apply(lambda x:x.str.replace('"',""))
    df.iloc[-2,0] = 'Ign'
    faixa_etaria = i
    df = df.rename(columns = df.iloc[0]).drop(df.index[0]) 
    df.loc[df['Distrito Admin residência'] == 'Moóca','Distrito Admin residência'] = 'Mooca'
    df = pd.merge(distritos,df,how='left',on=['Distrito Admin residência'])
    df = df.drop(columns=df.columns[df.columns.str.startswith('Total')])
    df.set_index('Distrito Admin residência',inplace=True)
    col_names = []
    for j in df.columns:
        col_names.append('obitos' + '_' + str(2022) + '_' + 'total' + '_' + j + '_' + str(faixa_etaria[0]) + '_' + str(faixa_etaria[1]) + '_' + 'anos')
    df.set_axis(col_names, axis=1, inplace=True)
    dfs.append(df) 
    
df_2022 = pd.concat(dfs,axis=1)