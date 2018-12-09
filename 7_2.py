import functools
import operator

def flatten(l):
	return functools.reduce(operator.iconcat, l, [])

filename = 'input7.txt'
file = open(filename, 'r')
data = list(map(lambda line: line[:-1], file.readlines()))

step_i = 1 if 'test' in filename else 61

state2time = {chr(i).upper(): i-(97-step_i) for i in range(97, 123)}
data = list(map(lambda x: [x.split(' ')[i] for i in [1,7]], data))

cterm = {}
for row in data:
	if not row[1] in cterm:
		cterm[row[1]] = 1
	else:
		cterm[row[1]] += 1

allchar = list(set(flatten(data)))
remain_cmd = list(map(lambda x: (x, cterm[x] if x in cterm else 0 ), allchar))
remain_cmd = dict((k, v) for [k, v] in remain_cmd)

sortchar = lambda x: sorted(x, key = lambda elem: (elem[1], elem[0]))

worker_num = 2 if 'test' in filename else 5
workers = [{'state': '.', 'remain': 0} for i in range(worker_num)]
second = 0

def checkidle(allworkers):
	res = True
	for worker in allworkers:
		if worker['state'] != '.':
			res = False
			break
	return res

def update_state(worker, state):
	res = worker
	res['state'] = state
	res['remain'] = state2time[state]
	return res['']


done = False
acc = ''
while len(remain_cmd) > 0 or not done:
	# remove state
	finishstates = []
	for worker in workers:
		if worker['remain'] == 0 and worker['state'] != '.':
			finishstates.append(worker['state'])
			acc += worker['state']
			worker['state'] = '.'

	# get reduct state
	reduce_state = []
	for state in finishstates:
		val = list(map(lambda a: a[1], filter(lambda x: x[0] == state, data)))
		for v in val:
			reduce_state.append(v)

	# reduce constrain
	for state in reduce_state:
		remain_cmd[state] -= 1

	# get action
	actions = list(map(lambda x: x[0], filter(lambda x: x[1] == 0, remain_cmd.items())))
	actions.sort()
	# suggest
	suggested_action = []
	for idx, worker in enumerate(workers):
		if len(actions) > 0:
			if worker['state'] == '.':
				workers[idx]['state'] = actions[0]
				workers[idx]['remain'] = state2time[actions[0]]
				suggested_action.append(actions.pop(0))
				# actions = actions[1:]
		else:
			break

	# check after suggested
	if second > 0 and checkidle(workers):
		done = True
		break

	for action in suggested_action:
		del(remain_cmd[action])

	second += 1
	for worker in workers:
		if worker['state'] != '.':
			worker['remain'] -= 1

print(second)