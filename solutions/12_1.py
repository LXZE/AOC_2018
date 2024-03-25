filename = 'input12.txt'
file = open(filename, 'r')
data = list(map(lambda line: line[:-1], file.readlines()))

state = data[0].split(' ')[2]
shiftsize = len(state)
state = ( '.'*shiftsize ) + state + ( '.'*shiftsize )

patterns = list(map(lambda item: item.split(' => '), data[2:]))
patterns = {k:v for [k,v] in patterns}

def substr(state):
	res = []
	for idx in range(len(state)):
		s = state[idx-2:idx+3]
		res.append(patterns.get(s, '.'))
	return ''.join(res)

gens = 20
for step in range(gens):
	state = substr(state)

res = 0
for idx, char in enumerate(state):
	if char == '#':
		res += (idx - shiftsize)
print(res)