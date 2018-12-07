defmodule AOC_3_1 do

	def start() do
		read()
		|> Stream.each(fn elm ->
			loop(elm)
		end)
		|> Enum.map(fn elm ->

		end)

	end

	def read() do
		File.stream!("test3.txt")
		|> Enum.map(&String.trim/1)
		|> Enum.map(&String.split/1)
		|> Enum.map(fn elm ->
			[Enum.at(elm, 2), Enum.at(elm, 3)]
		end)
	end

	def loop(data) do
		[start | size] = data
		# [conv1(start), conv2(size)]
	end

	def conv1(dp), do: String.split(dp, ",") |> Enum.map(&String.to_integer/1)
	def conv2(sz), do: String.split(sz, "x") |> Enum.map(&String.to_integer/1)

	def mapgen() do
		List.duplicate(".", 10)
		|> List.duplicate(10)
	end

	def claim(map, x, y) do
		case get(map, x, y) do
			"." -> set(map, x, y, "+")
			"+" -> set(map, x, y, "X")
		end
	end

	def set(map, x, y, val) do
		List.replace_at(map, x,
			List.replace_at(Enum.at(map, x), y, val)
		)
	end

	def get(map, x, y) do
		map |> Enum.at(x) |> Enum.at(y)
	end

end


IO.inspect(AOC_3_1.start)
# IO.inspect(AOC_3_1.mapgen)
