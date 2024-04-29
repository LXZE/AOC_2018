defmodule Aoc5_2 do
	def main(data) do
		alpha = for n <- ?a..?z, do: << n >>
		alpha
		|> Stream.map(fn x -> removechar(data,x) end)
		|> Stream.map(fn p -> start(p) end)
		|> Enum.min()
	end

	def start(line) do
		res = cut(line)
		case stillcontain?(res) do
			true -> start(res)
			false -> String.length(res)
		end
	end

	def removechar(data, char) do
		String.split(data, [char, String.upcase(char)])
		|> Enum.join("")
	end

	def stillcontain?(line) do
		line
		|> String.graphemes
		|> Enum.chunk_every(2,1,:discard)
		|> Stream.map(fn x -> opposite?(Enum.at(x, 0), Enum.at(x, 1)) end)
		|> Enum.any?(fn x ->
			x == true
		end)
	end

	def opposite?(a,b) do
		case a do
			nil ->
				false
			_ ->
				a != b and (String.downcase(a) == b or a == String.downcase(b))
		end
	end

	def cut(line) do
		line
		|> String.graphemes
		|> Enum.reduce(fn elem, acc ->
			ls = String.at(acc, -1)
			if opposite?(ls, elem) do
				String.slice(acc, 0..-2)
			else
				acc <> elem
			end
		end)
	end
end

data = File.stream!("input5.txt")
|> Enum.map(&String.trim/1)
|> hd

IO.inspect Aoc5_2.main(data)
