file = 'input8.txt'
data = File.readlines(file).map do |line| line.chomp end
data = data.map do |elem|
	elem.split(' ').map {|x| x.to_i }
end.flatten!

$meta = []

def getmeta(line)
	cnode, metasize = line.shift(2)
	if cnode == 0
		$meta += line.shift(metasize)
		return
	else
		for i in 0..cnode-1 do
			getmeta(line)
		end
		$meta += line.shift(metasize)
	end
end

getmeta(data)

p $meta.sum()