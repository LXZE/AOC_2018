const fs = require('fs')
const util = require('util');
const readFile = util.promisify(fs.readFile);

let readData = async (fileName) => {
	return await readFile(fileName, 'utf8');
}

Array.prototype.indicesOf = function(x){
	return this.reduce((p,c,i) => c === x ? p.concat(i) : p ,[]);
}

let game = (player_amnt, last_marble) => {
	let turn = 1
	let current_marble = 1
	let players = Array.apply(0, new Array(player_amnt)).map(x => 0)

	let map = [0]
	let idx = 0

	while (current_marble <= last_marble) {
		if(idx == 0 || idx >= map.length-1){
			idx = 1
		}else{
			idx += 2
		}

		if(current_marble % 23 != 0){
			map.splice(idx, 0, current_marble)
		}else{
			idx -= (7+2)
			if(idx < 0){
				idx += map.length
			}
			rm = map.splice(idx, 1)[0]
			players[turn-1] += current_marble + rm
		}

		turn += 1
		if(turn > player_amnt) turn = 1
		current_marble += 1
	}
	return Math.max(...players)
}

let main = async () => {
	let data = []
	let result = await readData('input9.txt')

	let [player_amnt, last_marble] = result.split(' ')
	.filter((item, idx) => { return [0, 6].indexOf(idx) > -1 })
	.map(item => parseInt(item))

	let highscore = game(player_amnt, last_marble)

	console.log(highscore)
}
main()