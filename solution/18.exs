defmodule Solution do
  def get_adjacent({row, col}, limit) do
    for dr <- [-1,0,1], dc <- [-1,0,1] do {row+dr, col+dc} end
    |> Enum.filter(fn {r, c} ->
      {r, c} != {row, col} and r in 0..limit and c in 0..limit
    end)
  end

  def update_map(map, limit) do
    for {pos, elem} <- map, into: %{} do
      get_adjacent(pos, limit)
      |> Enum.map(& Map.get(map,&1))
      |> (& {pos, update_pos(elem, &1)}).()
    end
  end

  def update_pos(".", adjs), do:
    if(Enum.count(adjs, & &1 == "|") >= 3, do: "|", else: ".")
  def update_pos("|", adjs), do:
    if(Enum.count(adjs, & &1 == "#") >= 3, do: "#", else: "|")
  def update_pos("#", adjs), do:
    if("#" in adjs and "|" in adjs, do: "#", else: ".")

  def parse(input) do
    table = for {line, row} <- Enum.with_index(input),
        {elem, col} <- String.graphemes(line) |> Enum.with_index(),
        into: %{}, do: {{row, col}, elem}
    limit = length(input)
    {table, limit}
  end

  @spec part1(input :: [String.t()]) :: integer()
  def part1(input) do
    {table, limit} = parse(input)

    %{"#" => yards, "|" => trees} = Enum.reduce(1..10, table, fn _, acc ->
      update_map(acc, limit)
    end)
    |> Map.values
    |> Enum.frequencies

    yards * trees
  end

  def hash(map, _limit) do
    for {{r,c}, val} <- map do
      case val do  # this works magically
        "." -> (r + c)
        "|" -> (r * 1000 + c)
        "#" -> (r * 100000 + c)
      end
    end
    |> Enum.sum
  end

  @spec part2(input :: [String.t()]) :: integer()
  def part2(input) do
    {table, limit} = parse(input)

    {tabled, from, to} = Stream.iterate(1, & &1+1)
    |> Enum.reduce_while({table, Map.new([{hash(table, limit), 0}])},
      fn i, {acc, history} ->
        accd = update_map(acc, limit)
        key = hash(accd, limit)
        if Map.has_key?(history, key) do
          {:halt, {accd, Map.get(history, key), i}}
        else
          {:cont, {accd, Map.put(history, key, i)}}
        end
      end)

    total = 1_000_000_000
    loop_size = to - from
    remain = rem(total - to, loop_size)

    %{"#" => yards, "|" => trees} = Enum.reduce(1..remain, tabled, fn _, acc ->
      update_map(acc, limit)
    end)
    |> Map.values
    |> Enum.frequencies

    yards * trees
  end
end

initData = "
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
"

testData = %{
  part1: [
    {initData |> String.trim("\n"), 1147}
  ],
  part2: [
    # can't be done as whole test map become open space eventually
    # {initData |> String.trim("\n"), nil}
  ]
}

Utils = Code.require_file("lib/utils.exs") |> hd |> elem(0)
Utils.solve(18, Solution, testData)
