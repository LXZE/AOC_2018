const fs = require('fs')
const util = require('util');
const readFile = util.promisify(fs.readFile);

let readData = async (fileName) => {
	return await readFile(fileName, 'utf8');
}
let conv = (line) => {
	let tmp = line.split(' ')
	return [tmp[1].slice(3,5), tmp[3]]
}
let sumTime = (timeList) => {
	let res = []
	for(let [start,stop] of timeList){
		res.push(stop-start+1)
	}
	return res.reduce((a,b) => a+b, 0)
}
let argMax = (array) => {
	return array.map((x, i) => [x, i]).reduce((r, a) => (a[0] > r[0] ? a : r))[1];
}

let main = () => {
	let data = []
	readData('input4.txt').then(res => {
		for(let line of res.split('\n')){
			data.push(line)
		}
		data.sort().shift()
		data = data.map((line) => {
			return conv(line)
		})

		let id = 0;
		let table = {}

		let startTime = ''
		let count = false

		data.forEach((elem => {
			let [min, str] = elem
			if(str.includes('#')){
				id = parseInt(str.slice(1))
				if(!(id in table)){
					table[id] = []
				}
			}else if(str == 'asleep'){
				startTime = min
			}
			else{
				table[id].push([parseInt(startTime), parseInt(min)-1])
			}
		}))
		let counttime = {}
		for(let [k,v] of Object.entries(table)){
			counttime[k] = sumTime(v)
		}
		let maxid = Object.keys(counttime).reduce((a, b) => counttime[a] > counttime[b] ? a : b)
		let timeacc = Array.apply(0, new Array(60)).map((x,i) => 0)
		for(let min in timeacc){
			for(let slot of table[maxid]){
				console.log(slot)
				if(slot[0] <= min && min <= slot[1]){
					timeacc[min] += 1
				}
			}
		}
		console.log(parseInt(maxid)*argMax(timeacc))
	})
}
main()