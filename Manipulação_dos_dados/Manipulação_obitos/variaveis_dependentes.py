import pandas as pd

df = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_novo.csv')
df_ = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_trimestre.csv')
df__ = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\age_standardized_obitos_distrito_15.csv')
df___ = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\age_standardized_obitos_distrito_20.csv')


ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]

#%%
#Excedente medio anual (2017-2020)
df_total_anual = []

aux = df[df.columns[(df.columns.str.contains('0_9_anos'))]]
aux['obitos_2017/2020_media_0_9_anos'] = aux.iloc[:,[0,1,2]].mean(axis=1)
aux_ = aux.iloc[:-2,-3:]
df_total_anual.append(aux_)

for i in ls[1:]:
    print(i)
    aux = df[df.columns[(df.columns.str.contains(f'{i[0]}'))]]
    aux[f'obitos_2017/2020_media_{i[0]}_{i[1]}_anos'] = aux.iloc[:,[0,1,2]].mean(axis=1)
    aux_ = aux.iloc[:-2,-3:]
    df_total_anual.append(aux_)

df_total_anual = pd.concat(df_total_anual,axis=1)
df_total_anual['distrito'] = df['Distrito Admin residência'].iloc[:-2]

#%%
#Excedente médio trimestral 
meses = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto',
         'Setembro','Outubro','Novembro','Dezembro']

df_total_trimestral = []

ax = df_[df_.columns[(df_.columns.str.contains('0_9_anos'))]]
ls_meses = []
for j in meses:
    print(j)
    ax_ = ax[ax.columns[ax.columns.str.contains(f'{j}')]]
    ax_[f'obitos_2017_2019_media_{j}_0_9_anos'] = ax_.iloc[:-2,:3].mean(axis=1)
    ax_ = ax_.iloc[:,-4:]
    ls_meses.append(ax_)
df_total_trimestral.append(pd.concat(ls_meses,axis=1))
    
for i in ls[1:]:
    print(i)
    ax = df_[df_.columns[(df_.columns.str.contains(f'{i[0]}'))]]
    ls_meses = []
    for j in meses:
        print(j)
        ax_ = ax[ax.columns[ax.columns.str.contains(f'{j}')]]
        ax_[f'obitos_2017_2019_media_{j}_{i[0]}_{i[1]}_anos'] = ax_.iloc[:-2,:3].mean(axis=1)
        ax_ = ax_.iloc[:,-4:]
        ls_meses.append(ax_)
    df_total_trimestral.append(pd.concat(ls_meses,axis=1))
df_total_trimestral = pd.concat(df_total_trimestral,axis=1)
df_total_trimestral['distrito'] = df_['Distrito Admin residência'].iloc[:-2]

#%%
#Excedente médio age_standardized (pop 2015)
df_total_anual_std_15 = []

axl = df__[df__.columns[(df__.columns.str.contains('0_9_anos'))]]
axl['obitos_2017/2020_media_0_9_anos'] = axl.iloc[:,[0,1,2]].mean(axis=1)
axl_ = axl.iloc[:-2,-3:]
df_total_anual_std_15.append(axl_)

for i in ls[1:]:
    print(i)
    axl = df__[df__.columns[(df__.columns.str.contains(f'{i[0]}'))]]
    axl[f'obitos_2017/2020_media_{i[0]}_{i[1]}_anos'] = axl.iloc[:,[0,1,2]].mean(axis=1)
    axl_ = axl.iloc[:-2,-3:]
    df_total_anual_std_15.append(axl_)

df_total_anual_std_15 = pd.concat(df_total_anual_std_15,axis=1)
df_total_anual_std_15['distrito'] = df__['distrito']

#%%
#Excedente médio age_standardized (pop 2020)
df_total_anual_std_20 = []

axr = df___[df___.columns[(df___.columns.str.contains('0_9_anos'))]]
axr['obitos_2017/2020_media_0_9_anos'] = axr.iloc[:,[0,1,2]].mean(axis=1)
axr_ = axr.iloc[:-2,-3:]
df_total_anual_std_20.append(axr_)

for i in ls[1:]:
    print(i)
    axr = df___[df___.columns[(df___.columns.str.contains(f'{i[0]}'))]]
    axr[f'obitos_2017/2020_media_{i[0]}_{i[1]}_anos'] = axr.iloc[:,[0,1,2]].mean(axis=1)
    axr_ = axr.iloc[:-2,-3:]
    df_total_anual_std_20.append(axr_)

df_total_anual_std_20 = pd.concat(df_total_anual_std_20,axis=1)
df_total_anual_std_20['distrito'] = df___['distrito']

#%%
#Exportação
df_total_anual.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\dependente_total_obitos_distrito_novo.csv')
df_total_trimestral.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\dependente_total_obitos_distrito_trimestre.csv')
df_total_anual_std_15.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\dependente_age_standardized_obitos_distrito_15.csv')
df_total_anual_std_20.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\dependente_age_standardized_obitos_distrito_20.csv')
