data = File.stream!("input2.txt")
|> Enum.map(&String.trim/1) |> Enum.map(&String.to_charlist/1)
|> Enum.map(&Enum.sort/1) |> Enum.map(&to_string/1)
|> Enum.map(fn str ->
	[
		String.match?(str, ~r/([a-z])\1\1/),
		String.replace(str, ~r/([a-z])\1\1/, "")
		|> String.match?(~r/([a-z])\1/)
	]
end)

th = data \
|> Enum.count(&(Enum.at(&1, 0)) == true)
tw = data \
|> Enum.count(&(Enum.at(&1, 1)) == true)

IO.inspect tw*th
