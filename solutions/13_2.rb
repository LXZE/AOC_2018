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

$stop = false
$stoppos = [0,0]

def walk(map, carts)
	newmap = map

	carts.sort! { |a,b| [a[2], a[1]] <=> [b[2], b[1]] }
	newcarts = []
	for (cartdir, x, y, state, under) in carts do
		newmap[y][x] = under
		case cartdir
		when 'r'  # cart to right
			case newmap[y][x+1]
			when '-'
				newmap[y][x+1] = '>'
				newcarts.push(['r', x+1, y, state, '-'])
			when '+'
				case state
				when 1
					newmap[y][x+1] = '^'
					newcarts.push(['u', x+1, y, state+1, '+'])
				when 2
					newmap[y][x+1] = '>'
					newcarts.push(['r', x+1, y, state+1, '+'])
				when 3
					newmap[y][x+1] = 'v'
					newcarts.push(['d', x+1, y, 1, '+'])
				end
			when '\\'
				newmap[y][x+1] = 'v'
				newcarts.push(['d', x+1, y, state, '\\'])
			when '/'
				newmap[y][x+1] = '^'
				newcarts.push(['u', x+1, y, state, '/'])
			else
				tmp = ''
				carts.select! do |cart|
					if [x+1,y] == cart[1,2] then tmp = cart end
					[x+1,y] != cart[1,2]
				end
				if tmp == ''
					newcarts.select! do |cart|
						if [x+1,y] == cart[1,2] then tmp = cart end
						[x+1,y] != cart[1,2]
					end
				end
				newmap[y][x+1] = tmp[4]
			end

		when 'l'  # cart to left
			case newmap[y][x-1]
			when '-'
				newmap[y][x-1] = '<'
				newcarts.push(['l', x-1, y, state, '-'])
			when '+'
				case state
				when 1
					newmap[y][x-1] = 'v'
					newcarts.push(['d', x-1, y, state+1, '+'])
				when 2
					newmap[y][x-1] = '<'
					newcarts.push(['l', x-1, y, state+1, '+'])
				when 3
					newmap[y][x-1] = '^'
					newcarts.push(['u', x-1, y, 1, '+'])
				end
			when '\\'
				newmap[y][x-1] = '^'
				newcarts.push(['u', x-1, y, state, '\\'])
			when '/'
				newmap[y][x-1] = 'v'
				newcarts.push(['d', x-1, y, state, '/'])
			else
				tmp = ''
				carts.select! do |cart|
					if [x-1,y] == cart[1,2] then tmp = cart end
					[x-1,y] != cart[1,2]
				end
				if tmp == ''
					newcarts.select! do |cart|
						if [x-1,y] == cart[1,2] then tmp = cart end
						[x-1,y] != cart[1,2]
					end
				end
				newmap[y][x-1] = tmp[4]
			end

		when 'u'  # cart to up
			case newmap[y-1][x]
			when '|'
				newmap[y-1][x] = '^'
				newcarts.push(['u', x, y-1, state, '|'])
			when '+'
				case state
				when 1
					newmap[y-1][x] = '<'
					newcarts.push(['l', x, y-1, state+1, '+'])
				when 2
					newmap[y-1][x] = '^'
					newcarts.push(['u', x, y-1, state+1, '+'])
				when 3
					newmap[y-1][x] = '>'
					newcarts.push(['r', x, y-1, 1, '+'])
				end
			when '\\'
				newmap[y-1][x] = '<'
				newcarts.push(['l', x, y-1, state, '\\'])
			when '/'
				newmap[y-1][x] = '>'
				newcarts.push(['r', x, y-1, state, '/'])
			else
				tmp = ''
				carts.select! do |cart|
					if [x,y-1] == cart[1,2] then tmp = cart end
					[x,y-1] != cart[1,2]
				end
				if tmp == ''
					newcarts.select! do |cart|
						if [x,y-1] == cart[1,2] then tmp = cart end
						[x,y-1] != cart[1,2]
					end
				end
				newmap[y-1][x] = tmp[4]
			end

		when 'd'  # cart to down
			case newmap[y+1][x]
			when '|'
				newmap[y+1][x] = 'v'
				newcarts.push(['d', x, y+1, state, '|'])
			when '+'
				case state
				when 1
					newmap[y+1][x] = '>'
					newcarts.push(['r', x, y+1, state+1, '+'])
				when 2
					newmap[y+1][x] = 'v'
					newcarts.push(['d', x, y+1, state+1, '+'])
				when 3
					newmap[y+1][x] = '<'
					newcarts.push(['l', x, y+1, 1, '+'])
				end
			when '\\'
				newmap[y+1][x] = '>'
				newcarts.push(['r', x, y+1, state, '\\'])
			when '/'
				newmap[y+1][x] = '<'
				newcarts.push(['l', x, y+1, state, '/'])
			else
				tmp = ''
				carts.select! do |cart|
					if [x,y+1] == cart[1,2] then tmp = cart end
					[x,y+1] != cart[1,2]
				end
				if tmp == ''
					newcarts.select! do |cart|
						if [x,y+1] == cart[1,2] then tmp = cart end
						[x,y+1] != cart[1,2]
					end
				end
				newmap[y+1][x] = tmp[4]
			end
		end
	end

	if newcarts.length == 1
		$stop = true
		$stoppos = newcarts[0][1,2]
	end

	return [newmap, newcarts]
end

carts = listcartpos(map)
while $stop == false
	map, carts = walk(map, carts)
end
print("#{$stoppos[0]},#{$stoppos[1]}\n")