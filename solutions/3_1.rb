file = 'input3.txt'
data = File.readlines(file).map do |line| line.chomp end
data = data.map do |elem|
	elem.split(' ').slice(2, 3)
end.map do |dp, sz|
	[
		dp.chomp(':').split(',').map do |e| e.to_i end,
		sz.split('x').map do |e| e.to_i end
	]
end


def claim(map, x, y)
	val = map[x][y]
	if val == '.' 
		map[x][y] = '+'
	elsif val == '+'
		map[x][y] = 'X'
	end
end

max_x, max_y = 0, 0
data.each do |dp, sz|
	max_x = dp[0] +  sz[0] > max_x ? dp[0]+sz[0] : max_x
	max_y = dp[1] +  sz[1] > max_y ? dp[1]+sz[1] : max_y
end

map = Array.new(max_x) { Array.new(max_y, '.') }
for dp, sz  in data do
	for i in dp[0]..dp[0]+sz[0]-1 do
		for j in dp[1]..dp[1]+sz[1]-1 do
			claim(map, i, j)
		end
	end
end

def countX(map)
	count = 0
	for row in map do
		count += row.count('X')
	end
	return count
end

p countX(map)