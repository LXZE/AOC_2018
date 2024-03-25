file = 'input3.txt'
data = File.readlines(file).map do |line| line.chomp end
data = data.map do |elem|
	elem.split(' ').keep_if.with_index { |x, i| [0, 2, 3].include?(i) }
end.map do |id, dp, sz|
	[
		id[1, id.size].to_i,
		dp.chomp(':').split(',').map do |e| e.to_i end,
		sz.split('x').map do |e| e.to_i end
	]
end

max_x, max_y = 0, 0
data.each do |id, dp, sz|
	max_x = dp[0] +  sz[0] > max_x ? dp[0]+sz[0] : max_x
	max_y = dp[1] +  sz[1] > max_y ? dp[1]+sz[1] : max_y
end

map = Array.new(max_x+1) { Array.new(max_y+1, Array.new) }
valid = Array.new(data.size+1, true)
valid[0] = false

# def show_map(map)
# 	for row in map do
# 		p row
# 	end
# end

def claim(map, x, y, id)
	# show_map(map)
	# p '---'
	map[x][y] += [id]
end

for id, dp, sz  in data do
	for i in dp[0]..dp[0]+sz[0]-1 do
		for j in dp[1]..dp[1]+sz[1]-1 do
			claim(map, i, j, id)
		end
	end
end


for row in map do
	for elem in row do
		if elem.size > 1
			for id in elem do
				valid[id] = false
			end
		end
	end
end

p valid.index(true)