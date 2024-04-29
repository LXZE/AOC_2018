file = 'input10.txt'
data = File.readlines(file).map do |line| line.chomp end
data = data.map do |elem|
	elem.scan(/(<.\d+,\s.\d+>)/).map do |x| x[0] end
end.map do |posi, velo|
	posi = posi[1...-1].split(',').map do |item| item.to_i end
	velo = velo[1...-1].split(',').map do |item| item.to_i end
	[posi, velo]
end

def findhigh(poslist, chkidx)
	max = 0
	poslist.each do |pos| max = pos[chkidx] > max ? pos[chkidx] : max end
	return max
end

def findlow(poslist, chkidx)
	min = 200000
	poslist.each do |pos| min = pos[chkidx] < min ? pos[chkidx] : min end
	return min
end

def normalize(poslist)
	minx, miny = findlow(poslist, 0), findlow(poslist, 1)

	x_minus = minx > 0 ? false : true
	y_minus = miny > 0 ? false : true
	minx = minx.abs
	miny = miny.abs

	data = poslist.each do |item|
		item[0] = x_minus ? item[0]+minx : item[0]-minx
		item[1] = y_minus ? item[1]+miny : item[1]-miny
	end

	return data
end

def update(poslist,vellist)
	return poslist.map.with_index do |item, idx|
		item.zip(vellist[idx]).map do |a,b|
			a+b
		end
	end
end

def calcmap(poslist)
	maxx, maxy = findhigh(poslist, 0)+1, findhigh(poslist, 1)+1
	minx, miny = findlow(poslist, 0).abs, findlow(poslist, 1).abs

	newsize = [maxx-minx,maxy-miny] 
	if newsize[0] <= $prev[0] or newsize[1] <= $prev[1]
		$prev = newsize
		$prev_data = [poslist, maxx, maxy]
		return false
	else
		poslist, maxx, maxy = $prev_data
		sky = Array.new(maxy) { Array.new(maxx, ' ') }
		poslist.each do |item|
			sky[item[1]][item[0]] = '#'
		end
		for row in 0..maxy-1 do
			for col in 0..maxx-1 do
				print sky[row][col]
			end
			print("\n")
		end
		return true
	end
end

allpos = data.map do |item|
	item[0]
end
allvel = data.map do |item|
	item[1]
end

normpos = normalize(allpos)

$prev = [findhigh(normpos, 0)+1, findhigh(normpos, 1)+1]
$prev_data = []

done = false
while not done do
	normpos = normalize(normpos)
	done = calcmap(normpos)
	normpos = update(normpos, allvel)
	if done then break end
end