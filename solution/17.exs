defmodule Solution do
  def getRange(str) do
    String.split(str, "..")
    |> Enum.map(&String.to_integer/1)
    |> (fn [from, to] -> Range.new(from, to) end).()
  end
  def parseWall("x=" <> rem) do
    [rawX, rawYrange] = String.split(rem, ", y=")
    x = String.to_integer(rawX)
    getRange(rawYrange)
    |> Enum.map(fn y -> {x, y} end)
  end
  def parseWall("y=" <> rem) do
    [rawY, rawXrange] = String.split(rem, ", x=")
    y = String.to_integer(rawY)
    getRange(rawXrange)
    |> Enum.map(fn x -> {x, y} end)
  end

  def fall({x, y}, fs, {water, trail}, const={wall, maxY}) do
    stream = Stream.iterate(y, & &1+1)
      |> Stream.take_while(fn gy ->
        gy <= maxY and
        not (
          MapSet.member?(wall, {x, gy})
          or MapSet.member?(water, {x, gy})
        )
      end)
      |> Enum.map(&{x, &1})
    lastStream = {lx, ly} = List.last(stream)
    fsd = cond do
      length(stream) <= 1 -> []
      ly >= maxY -> []
      MapSet.member?(wall, {lx, ly+1}) or
      MapSet.member?(water, {lx, ly+1}) -> [{:fill, lastStream}]
      true -> []
    end
    traild = MapSet.union(trail, MapSet.new(stream))
    run(fs ++ fsd, {water, traild}, const)
  end

  def fill(_pos={x, y}, fs, {water, trail}, const={wall, _maxY}) do
    is_fillable? = fn gx ->
      not MapSet.member?(wall, {gx, y}) # not wall
      and ( # under is either wall or water
        MapSet.member?(wall, {gx, y+1})
        or MapSet.member?(water, {gx, y+1})
      )
    end
    left = Stream.iterate(x, & &1-1)
      |> Stream.take_while(is_fillable?)
      |> Enum.map(&{&1, y})

    right = Stream.iterate(x, & &1+1)
      |> Stream.take_while(is_fillable?)
      |> Enum.map(&{&1, y})

    # most left and right
    {mlx, mly} = List.last(left)
    {mrx, mry} = List.last(right)
    isLeftWall? = MapSet.member?(wall, {mlx-1, mly})
    isRightWall? = MapSet.member?(wall, {mrx+1, mry})

    # if both side are in wall = water
    waterd = if isLeftWall? and isRightWall? do
      MapSet.union(water, MapSet.new(left ++ right))
    else water end
    # otherwise it become trail of water
    traild = if isLeftWall? and isRightWall? do trail else
      MapSet.union(trail, MapSet.new(left ++ right))
    end

    fsd = case {isLeftWall?, isRightWall?} do
      {true, true} -> [{:fill, {x, y-1}}] # both wall -> go fill upper
      {_, true} -> [{:fall, {mlx-1, mly}}] # right wall -> fall left
      {true, _} -> [{:fall, {mrx+1, mry}}] # left wall -> fall right
      {_, _} -> [{:fall, {mlx-1, mly}}, {:fall, {mrx+1, mry}}] # both can fall
    end

    run(Enum.uniq(fs ++ fsd), {waterd, traild}, const)
  end

  def run([], state, _const), do: state
  def run([{:fall, p} | fs], state, const), do: fall(p, fs, state, const)
  def run([{:fill, p} | fs], state, const), do: fill(p, fs, state, const)

  def solve(input) do
    wall = Enum.map(input, &parseWall/1)
    |> Enum.concat
    |> MapSet.new
    [minY, maxY] = Enum.min_max_by(wall, &elem(&1, 1))
      |> Tuple.to_list
      |> Enum.map(&elem(&1, 1))

    {
      run([{:fall, {500, 0}}], {MapSet.new(), MapSet.new()}, {wall, maxY}),
      [minY, maxY]
    }
  end

  @spec part1(input :: [String.t()]) :: integer()
  def part1(input) do
    {{water, trail}, [minY, maxY]} = solve(input)
    MapSet.union(water, trail)
      |> MapSet.to_list
      |> Enum.filter(fn {_, y} -> y in minY..maxY end)
      |> length
  end

  @spec part2(input :: [String.t()]) :: integer()
  def part2(input) do
    {{water, _trail}, [minY, maxY]} = solve(input)
    MapSet.to_list(water)
    |> Enum.filter(fn {_, y} -> y in minY..maxY end)
    |> length
  end
end

initData = "
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
"

testData = %{
  part1: [
    {initData |> String.trim("\n"), 57}
  ],
  part2: [
    {initData |> String.trim("\n"), 29}
  ]
}

Utils = Code.require_file("lib/utils.exs") |> hd |> elem(0)
Utils.solve(17, Solution, testData)
