import numpy as np
from scipy.spatial.distance import cityblock as d
import multiprocessing as mp
from collections import Counter as c

file = open('input6.txt', 'r')
data = list(map(lambda line: line[:-1], file.readlines()))
data = list(map(lambda e: (e[0], list(map(int, e[1].split(', ')))), enumerate(data)))

max_x, max_y = 0,0
for (idx, val) in data:
	if val[0] > max_x:
		max_x = val[0]
	if val[1] > max_y:
		max_y = val[1]
max_x += 1
max_y += 1
co_map = [['%d,%d' % (i,j) for j in range(max_y)] for i in range(max_x)]
co_map = np.array(co_map)

getx = lambda dp: int(dp.split(',')[0])
gety = lambda dp: int(dp.split(',')[1])

tocoord = lambda dp: list(map(int, dp.split(',')))

limit = 10000

def process(dps, data, core, acc_result):
	global max_x, max_y
	start_y, end_y = getx(dps[0][0]), getx(dps[-1][0])
	res = dps
	for x in range(0, dps.shape[0]):
		for y in range(0, max_y):
			point = tocoord(dps[x][y])
			tmp = ''
			dist = [0 for i in range(len(data))]
			for (idx, coord) in data:
				dist[idx] = d(coord, point)
			if sum(dist) < limit:
				tmp = '#'
			res[x][y] = tmp
	acc_result.append([core, res])

ncore = mp.cpu_count()
output_list = mp.Manager().list()
map_chunks = np.array_split(co_map, ncore)

processes = [mp.Process(target=process, args=(map_chunks[core], data, core, output_list)) for core in range(ncore)]

for p in processes:
	p.start()

for p in processes:
	p.join()

results_tup = sorted(output_list, key=lambda x: x[0])
result = map(lambda x: x[1], results_tup)
result = np.concatenate(result)

count = [0 for i in range(len(data))]
counter = c(result.flatten())
print(counter['#'])