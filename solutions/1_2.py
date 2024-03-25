import bisect as b
file = open('input1.txt', 'r')
data = list(map(lambda line: int(line[:-1]), file.readlines()))
complete = False
state = 0
states = [0]
while not complete:
	for e in data:
		state += e
		print(state, len(states))
		idx = b.bisect_left(states, state)
		if idx < len(states) and state == states[idx]:
			print(state)
			complete = True
			break
		else:
			b.insort(states, state)