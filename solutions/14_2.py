filename = 'input14.txt'
file = open(filename, 'r')
data = list(map(lambda line: line[:-1], file.readlines()))

target = int(data[0])
str_target = data[0]
board = ['3','7']
elf_idx = [0, 1]

def create_recipe(board, indices):
	newval = int(board[indices[0]]) + int(board[indices[1]])
	if newval > 9:
		board.extend(['1', str(newval-10)])
	else:
		board.append(str(newval))

def calc(board, idx):
	step = int(board[idx])+idx+1
	return step%(len(board))

while str_target not in ''.join(board[-(len(str(target))*2):]):
	create_recipe(board, elf_idx)
	elf_idx = list(map(lambda e: calc(board, e), elf_idx))

str_board = ''.join(board)
res = str_board.index(str_target)
print(res)
