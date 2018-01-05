import csv
import os
import datetime
from math import sqrt



#	HEADER
#	W,M,AVG_CPU,DEV_CPU,AVG_MEM,DEV_MEM,AVG_TIME,AVG_REQ_TIME,MEAN_POWER
#	NEED TO GET STUFF FROM 3 DIFFERENT FILES


def req_parse(t):
	t = t.replace('+', '')
	if 'ms' in t:
		t = t.replace('ms', '')
		t = t / 1000.0
	elif 'us' in t:
		t = t.replace('us', '')
		t = t / 1000000.0
	elif 's' in t:
		t = t.replace('s', '')
	return float(t)


def standard_deviation(lst, population=True):
    """Calculates the standard deviation for a list of numbers."""
    num_items = len(lst)
    mean = sum(lst) / float(num_items)
    differences = [x - mean for x in lst]
    sq_differences = [d ** 2 for d in differences]
    ssd = sum(sq_differences)
 
    # Note: it would be better to return a value and then print it outside
    # the function, but this is just a quick way to print out the values along
    # the way.
    if population is True:
        #print('This is POPULATION standard deviation.')
        variance = ssd / num_items
    else:
        #print('This is SAMPLE standard deviation.')
        variance = ssd / (num_items - 1)
    sd = sqrt(variance)
    return mean, sd


#Returns list with 'W','M','avg_cpu', 'dev_cpu', 'avg_mem', 'dev_mem', 'avg_time'
def topResults(infile='cl_top', W=8, M=100):
	cpu = list()
	mem = list()
	time = list()
	tmptime=0

	#Loops through run_x.csv files
	for filename in os.listdir("{}/W{}_M{}/".format(infile, str(W), str(M))):
		with open("{}/W{}_M{}/{}".format(infile, str(W), str(M), filename), 'r', newline='\n', encoding='utf-8') as topfile:
			reader = csv.reader(topfile, delimiter=',')
			# 8=CPU 9=MEM 10=CPU_TIME
			for line in reader:
				cpu.append(float(line[8]))
				mem.append(float(line[9]))
				tmptime = line[10].split(':')
			time.append(float(tmptime[0])*60 + float(tmptime[1]))
	cpu_mean, cpu_std = standard_deviation(cpu)
	mem_mean, mem_std = standard_deviation(mem)
	time_mean = sum(time)/float(len(time))

	#This is because the server was ran once for the 10 iterations each configuration was tested
	if infile == 'srv_top':
		time_mean = time_mean / 10.0

	row = [W, M, float(format(cpu_mean, '7.4f')), float(format(cpu_std, '7.4f')), float(format(mem_mean, '7.4f')),
	 float(format(mem_std, '7.4f')), float(format(time_mean, '7.4f'))]
	return row						


def requestResults(infile='cl_req', W=8, M=100):
	time = list()
	tmprtime = ''
	for filename in os.listdir("{}/W{}_M{}/".format(infile, str(W), str(M))):
		with open("{}/W{}_M{}/{}".format(infile, str(W), str(M), filename), 'r', newline='\n', encoding='utf-8') as reqfile:
			reader = csv.reader(reqfile, delimiter=',')
			for line in reader:
				tmptime = line[1]
			time.append(req_parse(tmptime))
	time_mean = float(format(sum(time)/float(len(time)), '7.4f'))
	return time_mean

def consumptionResults(infile='client_csv', W=8, M=100):
	power = 0
	length = 0
	with open("consumption/{}/W{}_M{}.csv".format(infile, str(W), str(M)), 'r', newline='\n', encoding='utf-8') as consfile:
		reader = csv.reader(consfile, delimiter=',')
		next(reader)
		for line in reader:
			power = power + float(line[2])
			length = length + 1
	power_mean = float(format(power/float(length), '7.4f'))
	return power_mean


def getResults(side='client'):
	topdir = 'cl_top'
	reqdir = 'cl_req'
	consdir = 'client_csv'
	row =list()
	with open('A8http2_{}.csv'.format(side), 'w', newline='\n', encoding='utf-8',) as csvfile:
		header = ['W', 'M', 'AVG_CPU', 'DEV_CPU', 'AVG_MEM', 'DEV_MEM', 'AVG_TIME', 'AVG_REQ_TIME', 'MEAN_POWER']
		writer = csv.writer(csvfile, delimiter=',')
		if side == 'server':
			header = ['W', 'M', 'AVG_CPU', 'DEV_CPU', 'AVG_MEM', 'DEV_MEM', 'AVG_TIME', 'MEAN_POWER']
			topdir = 'srv_top'
			consdir = 'server_csv'

		#append header
		writer.writerow(header)
		
		#this is done in the order the tests were taken
		for m in range(1, 5):
			for w in range(9, 13):
				row = topResults(infile=topdir, W=w, M=m)
				if side == 'client':
					row.append(requestResults(infile=reqdir, W=w, M=m))
				row.append(consumptionResults(infile=consdir, W=w, M=m))
				writer.writerow(row)

		for m in range(1,9):
			row = topResults(infile=topdir, W=16, M=m)
			if side == 'client':
				row.append(requestResults(infile=reqdir, W=16, M=m))
			row.append(consumptionResults(infile=consdir, W=16, M=m))
			writer.writerow(row)

		for w in range(8, 17):
			row = topResults(infile=topdir, W=w, M=100)
			if side == 'client':
				row.append(requestResults(infile=reqdir, W=w, M=100))
			row.append(consumptionResults(infile=consdir, W=w, M=100))
			writer.writerow(row)




if __name__ == "__main__":
	getResults('client')
	getResults('server')



