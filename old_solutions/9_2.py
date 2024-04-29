from collections import deque

filename = 'input9.txt'
file = open(filename, 'r')
data = list(map(lambda line: line[:-1], file.readlines()))

[player_amnt, last_marble] = [int(x) for i, x in enumerate(data[0].split(' ')) if i in [0, 6] ]

def game(player_amnt, last_marble):
	turn = 1
	players = [0]*player_amnt
	cirmap = deque([0])
	idx = 0
	for current_marble in range(1, last_marble+1):
		if current_marble % 23 != 0:
			cirmap.append(current_marble)
			cirmap.rotate(-1)
		else:
			cirmap.rotate(8)
			rm = cirmap.pop()
			players[turn-1] += current_marble+rm
			cirmap.rotate(-2)

		turn += 1
		if turn > player_amnt:
			turn = 1
	return max(players)

print(game(player_amnt, last_marble*100))