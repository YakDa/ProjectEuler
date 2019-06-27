import matplotlib.pyplot as plt
import pandas as pd
import datetime


headers = ['Time', 'Humidity(%)', 'Temperature(C)']

def LinePlot_ht(filename):
	df = pd.read_csv('log/' + filename, names=headers)
	t = df['Time']
	humi = [float(i) for i in (df['Humidity(%)'])[1:]]
	temp = [float(i) for i in (df['Temperature(C)'])[1:]]


	fig, axs = plt.subplots(2, 1)
	plt.setp(axs[0].get_xticklabels(), rotation=45)
	plt.setp(axs[1].get_xticklabels(), rotation=45)

	axs[0].plot(t[1:], humi)
	axs[0].set_xlabel('time')
	axs[0].set_ylabel('Humidity(%)')
	axs[0].grid(True)

	axs[1].plot(t[1:], temp)
	axs[1].set_xlabel('time')
	axs[1].set_ylabel('Temperature(C)')
	axs[1].grid(True)

	fig.tight_layout()
	plt.savefig('graph/' + filename.replace(".csv", ".png"))

#yersterday = datetime.date.today() - datetime.timedelta(1)
#print yersterday
#LinePlot_ht(str(yersterday) + '.csv')