file = 'input8.txt'
data = File.readlines(file).map do |line| line.chomp end
data = data.map do |elem|
	elem.split(' ').map {|x| x.to_i }
end.flatten!

$meta = []

def getmeta(line)
	cnode, metasize = line.shift(2)
	if cnode == 0
		tmp = line.shift(metasize)
		return tmp.sum()
	else
		result = []
		for i in 0..cnode-1 do
			result += [getmeta(line)]
		end
		metadata = line.shift(metasize)
		metadata.map! {|v| result[v-1] or 0 }
		return metadata.sum()
	end
end

p getmeta(data)