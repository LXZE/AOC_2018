filename = 'input12.txt'
file = open(filename, 'r')
data = list(map(lambda line: line[:-1], file.readlines()))

state = data[0].split(' ')[2]
shiftsize = len(state)
state = ( '.'*shiftsize ) + state + ( '.'*shiftsize )

patterns = list(map(lambda item: item.split(' => '), data[2:]))
patterns = {k:v for [k,v] in patterns}

def expand(state):
	global shiftsize
	newstate = ( '.'*shiftsize ) + state + ( '.'*shiftsize )
	shiftsize += shiftsize
	return newstate

def substr(state):
	res = []
	for idx in range(len(state)):
		s = state[idx-2:idx+3]
		res.append(patterns.get(s, '.'))
	return ''.join(res)

def calcsum(state):
	res = 0
	for idx, char in enumerate(state):
		if char == '#':
			res += (idx - shiftsize)
	return res

def trimming(state):
	return state.lstrip('.').rstrip('.')

patience = 5
gens = 50000000000

prevpatt = ''
magic_number = 0
prevval = 0
base = 0
for step in range(gens):
	state = substr(state)

	if patience == 0:
		break
	if '#' in state[:5] or '#' in state[-5:]:
		state = expand(state)

	patt = trimming(state)
	if prevpatt == patt:
		if magic_number == 0:
			prevval = calcsum(state)
			magic_number = -1
		elif magic_number == -1:
			magic_number = calcsum(state) - prevval
		else:
			base = calcsum(state) - (magic_number*(step+1))
		patience -= 1
	else:
		prevpatt = patt

print(base+(gens*magic_number))