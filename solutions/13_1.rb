file = 'input13.txt'
map = File.readlines(file).map do |line| line.chomp end

$direction = {
	"^" => 'u',
	"v" => 'd',
	"<" => 'l',
	">" => 'r',
}

def printmap(map)
	for row in 0..(map.length-1) do
		print(map[row])
		print("\n")
	end
end

def listcartpos(map)
	res = []
	for row in 0..(map.length-1) do
		for col in 0..(map[row].length-1) do
			x = col
			y = row
			char = map[row][col]
			if $direction.has_key?(char)
				if ['^','v'].include?(char)
					res.push([$direction[char], x, y, 1, '|'])
				else
					res.push([$direction[char], x, y, 1, '-'])
				end
			end
		end
	end
	return res
end

$crash = false
$crashpos = [0,0]

def walk(map, carts)
	newmap = map

	# note: cart must have to sort before run
	carts.sort! { |a,b| [a[2], a[1]] <=> [b[2], b[1]] }
	# p carts
	newcarts = carts.map do |(cartdir, x, y, state, under)|
		newmap[y][x] = under
		case cartdir
		when 'r'  # cart to right
			case newmap[y][x+1]
			when '-'
				newmap[y][x+1] = '>'
				['r', x+1, y, state, '-']
			when '+'
				case state
				when 1
					newmap[y][x+1] = '^'
					['u', x+1, y, state+1, '+']
				when 2
					newmap[y][x+1] = '>'
					['r', x+1, y, state+1, '+']
				when 3
					newmap[y][x+1] = 'v'
					['d', x+1, y, 1, '+']
				end
			when '\\'
				newmap[y][x+1] = 'v'
				['d', x+1, y, state, '\\']
			when '/'
				newmap[y][x+1] = '^'
				['u', x+1, y, state, '/']
			else
				newmap[y][x+1] = 'X'
				$crash = true
				$crashpos = [x+1,y]
			end

		when 'l'  # cart to left
			case newmap[y][x-1]
			when '-'
				newmap[y][x-1] = '<'
				['l', x-1, y, state, '-']
			when '+'
				case state
				when 1
					newmap[y][x-1] = 'v'
					['d', x-1, y, state+1, '+']
				when 2
					newmap[y][x-1] = '<'
					['l', x-1, y, state+1, '+']
				when 3
					newmap[y][x-1] = '^'
					['u', x-1, y, 1, '+']
				end
			when '\\'
				newmap[y][x-1] = '^'
				['u', x-1, y, state, '\\']
			when '/'
				newmap[y][x-1] = 'v'
				['d', x-1, y, state, '/']
			else
				newmap[y][x-1] = 'X'
				$crash = true
				$crashpos = [x-1,y]
			end

		when 'u'  # cart to up
			case newmap[y-1][x]
			when '|'
				newmap[y-1][x] = '^'
				['u', x, y-1, state, '|']
			when '+'
				case state
				when 1
					newmap[y-1][x] = '<'
					['l', x, y-1, state+1, '+']
				when 2
					newmap[y-1][x] = '^'
					['u', x, y-1, state+1, '+']
				when 3
					newmap[y-1][x] = '>'
					['r', x, y-1, 1, '+']
				end
			when '\\'
				newmap[y-1][x] = '<'
				['l', x, y-1, state, '\\']
			when '/'
				newmap[y-1][x] = '>'
				['r', x, y-1, state, '/']
			else
				newmap[y-1][x] = 'X'
				$crash = true
				$crashpos = [x,y-1]
			end

		when 'd'  # cart to down
			case newmap[y+1][x]
			when '|'
				newmap[y+1][x] = 'v'
				['d', x, y+1, state, '|']
			when '+'
				case state
				when 1
					newmap[y+1][x] = '>'
					['r', x, y+1, state+1, '+']
				when 2
					newmap[y+1][x] = 'v'
					['d', x, y+1, state+1, '+']
				when 3
					newmap[y+1][x] = '<'
					['l', x, y+1, 1, '+']
				end
			when '\\'
				newmap[y+1][x] = '>'
				['r', x, y+1, state, '\\']
			when '/'
				newmap[y+1][x] = '<'
				['l', x, y+1, state, '/']
			else
				$crash = true
				$crashpos = [x,y+1]
				newmap[y+1][x] = 'X'
			end
		end
	end
	return [newmap, newcarts]
end

carts = listcartpos(map)

i = 0
while $crash == false
	map, carts = walk(map, carts)
	# p "step: #{i+1}"
	# printmap(map)
	i+=1
end
# p "step: #{i+1}"
# printmap(map)
print("#{$crashpos[0]},#{$crashpos[1]}\n")
