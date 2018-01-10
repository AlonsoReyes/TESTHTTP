import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns


def heatmap_w_m(file='TESTHTTP/results/A8http2_client.csv', var='AVG_CPU',min=0,max=37):
	a_df=pd.read_csv(file)
	df=pd.concat([a_df['W'], a_df['M'], a_df[var]], axis=1, keys=['W','M',var])
	pivotted=df.pivot('W','M',var)
	ax=plt.axes()
	sns.heatmap(pivotted.fillna(0), cmap='Oranges', vmin=0, vmax=max, ax=ax)
	ax.set_title(var)
	plt.show()


client_file='results/A8http2_client.csv'
server_file='results/A8http2_server.csv'

client_df=pd.read_csv(client_file)
server_df=pd.read_csv(server_file)

client_cpumax=client_df.loc[client_df['AVG_CPU'].idxmax()]['AVG_CPU']
server_cpumax=server_df.loc[server_df['AVG_CPU'].idxmax()]['AVG_CPU']

client_memmax=client_df.loc[client_df['AVG_MEM'].idxmax()]['AVG_MEM']
server_memmax=server_df.loc[server_df['AVG_MEM'].idxmax()]['AVG_MEM']

heatmap_w_m(file=client_file, var='AVG_CPU', max=client_cpumax)
heatmap_w_m(file=server_file, var='AVG_CPU', max=server_cpumax)
heatmap_w_m(file=client_file, var='AVG_MEM', max=client_memmax)
heatmap_w_m(file=server_file, var='AVG_MEM', max=server_memmax)