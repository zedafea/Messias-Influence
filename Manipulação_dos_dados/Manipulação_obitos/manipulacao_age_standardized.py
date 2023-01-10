import pandas as pd

df_age = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\share_pop_distritos.csv')
df_ = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\total_obitos_distrito_novo.csv')

df_age.loc[df_age['distrito'] == 'Cangaiba','distrito'] = 'Cangaíba'
df_age.loc[df_age['distrito'] == 'Cidade Lider','distrito'] = 'Cidade Líder'

#Usando dados de 2015
df_age_ = df_age[df_age['ano'] == 2015]

ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]

df_main_15 = []

ls_ = df_.columns[df_.columns.str.contains('0_9_anos')].to_list()
ls_.insert(0,'Distrito Admin residência')
aux = df_.loc[:,ls_]
aux_ = df_age_[df_age_['faixa_etaria'].str.contains('0_9_anos')]
aux__ = pd.merge(aux_,aux,how='left',left_on=['distrito'],right_on=['Distrito Admin residência'])
aux___ = aux__.iloc[:,-5:].div(aux__.populacao_x,axis=0)
aux___.columns = aux___.columns.str.replace('total','age_standardized')
df_main_15.append(aux___)

for i in ls[1:]:
    print(i)    
    ls_ = df_.columns[(df_.columns.str.contains(f'{i[0]}'))&(df_.columns.str.contains(f'{i[1]}'))].to_list()
    ls_.insert(0,'Distrito Admin residência')
    aux = df_.loc[:,ls_]
    aux_ = df_age_[df_age_['faixa_etaria'].str.contains(f'{i[0]}')]
    aux__ = pd.merge(aux_,aux,how='left',left_on=['distrito'],right_on=['Distrito Admin residência'])
    aux___ = aux__.iloc[:,-5:].div(aux__.populacao_x,axis=0)
    aux___.columns = aux___.columns.str.replace('total','age_standardized')
    df_main_15.append(aux___)

df_main_15 = pd.concat(df_main_15,axis=1)
df_main_15['distrito'] = df_['Distrito Admin residência'].unique()[:-2]

#Usando dados de 2020
df_age_ = df_age[df_age['ano'] == 2020]

ls = [[0,9],[10,19],[20,29],[30,39],[40,49],[50,59],[60,69],[70,'inf']]

df_main_20 = []

ls_ = df_.columns[df_.columns.str.contains('0_9_anos')].to_list()
ls_.insert(0,'Distrito Admin residência')
aux = df_.loc[:,ls_]
aux_ = df_age_[df_age_['faixa_etaria'].str.contains('0_9_anos')]
aux__ = pd.merge(aux_,aux,how='left',left_on=['distrito'],right_on=['Distrito Admin residência'])
aux___ = aux__.iloc[:,-5:].div(aux__.populacao_x,axis=0)
aux___.columns = aux___.columns.str.replace('total','age_standardized')
df_main_20.append(aux___)

for i in ls[1:]:
    print(i)    
    ls_ = df_.columns[(df_.columns.str.contains(f'{i[0]}'))&(df_.columns.str.contains(f'{i[1]}'))].to_list()
    ls_.insert(0,'Distrito Admin residência')
    aux = df_.loc[:,ls_]
    aux_ = df_age_[df_age_['faixa_etaria'].str.contains(f'{i[0]}')]
    aux__ = pd.merge(aux_,aux,how='left',left_on=['distrito'],right_on=['Distrito Admin residência'])
    aux___ = aux__.iloc[:,-5:].div(aux__.populacao_x,axis=0)
    aux___.columns = aux___.columns.str.replace('total','age_standardized')
    df_main_20.append(aux___)

df_main_20 = pd.concat(df_main_20,axis=1)
df_main_20['distrito'] = df_['Distrito Admin residência'].unique()[:-2]

#Exportação
df_main_15.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\age_standardized_obitos_distrito_15.csv')
df_main_20.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\age_standardized_obitos_distrito_20.csv')
   