import pandas as pd

df = pd.read_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\evolucao_msp_sexo_idade2000_50.csv',
                 encoding='Latin1',sep=';')

df['populacao'] = df['populacao'].astype('str').str.replace('.','').astype('int')
df = df.groupby(['codigo_distrito','distrito','ano','faixa_etaria']).sum().reset_index()

df_ = {}
for i in df.index.to_list():
    if i == 0 or i%2 == 0:
        print(i)
        dff = df.loc[i]
        dff['populacao'] = dff['populacao'] + df.loc[i+1,'populacao']
        df_[i] = dff

df_ = pd.DataFrame(df_).T

df_.loc[df['faixa_etaria'] == '00 a 04','faixa_etaria'] = '0_9_anos'
df_.loc[df['faixa_etaria'] == '10 a 14','faixa_etaria'] = '10_19_anos'
df_.loc[df['faixa_etaria'] == '20 a 24','faixa_etaria'] = '20_29_anos'
df_.loc[df['faixa_etaria'] == '30 a 34','faixa_etaria'] = '30_39_anos'
df_.loc[df['faixa_etaria'] == '40 a 44','faixa_etaria'] = '40_49_anos'
df_.loc[df['faixa_etaria'] == '50 a 54','faixa_etaria'] = '50_59_anos'
df_.loc[df['faixa_etaria'] == '60 a 64','faixa_etaria'] = '60_69_anos'
df_.loc[df['faixa_etaria'] == '70 a 74','faixa_etaria'] = '70_inf_anos'

df_[['codigo_distrito','ano','populacao']] = df_[['codigo_distrito','ano','populacao']].astype('int')

df__ = pd.merge(df_,df_.groupby(['codigo_distrito','distrito','ano']).sum().reset_index(),how='left',on=['codigo_distrito','distrito','ano'])
df__['share_pop'] = (df__['populacao_x']/df__['populacao_y'])*100

df__.to_csv(r'C:\Users\guilh\Documents\Apoio_p_18_COVID19_\share_pop_distritos.csv')
