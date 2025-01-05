defmodule Solution do

  def get_next(char, {r, c}) do
    case char do
      "N" -> {r-1,c}
      "E" -> {r,c+1}
      "W" -> {r,c-1}
      "S" -> {r+1,c}
    end
  end

  def traverse(_, [], _, state), do: state
  def traverse(loc, ["(" | input], pos, state), do: traverse(loc, input, [loc | pos], state)
  def traverse(_, [")" | input], [latest_pos | pos], state), do: traverse(latest_pos, input, pos, state)
  def traverse(_, ["|" | input], pos, state), do: traverse(hd(pos), input, pos, state)
  def traverse(loc, [char | input], pos, state) do
    new_loc = get_next(char, loc)
    new_dist = Map.get(state, loc) + 1
    new_state = Map.update(state, new_loc, new_dist, fn prev_dist ->
      min(prev_dist, new_dist)
    end)
    traverse(new_loc, input, pos, new_state)
  end

  @spec part1(input :: [String.t()]) :: number()
  def part1([input]) do
    input = String.slice(input, 1..-2//1) |> String.graphemes
    traverse({0, 0}, input, [], %{{0, 0} => 0})
    |> Map.values |> Enum.max
  end

  @spec part2(input :: [String.t()]) :: number()
  def part2([input]) do
    input = String.slice(input, 1..-2//1) |> String.graphemes
    traverse({0, 0}, input, [], %{{0, 0} => 0})
    |> Map.values |> Enum.count(fn val -> val >= 1000 end)
  end
end

initData1 = "^WNE$"
initData2 = "^ENWWW(NEEE|SSE(EE|N))$"
initData3 = "^ENNWSWWSSSEEN(WNSE|)EE(SWEN|)NNN$"
initData4 = "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
initData5 = "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"

testData = %{
  part1: [
    {initData1, 3},
    {initData2, 10},
    {initData3, 18},
    {initData4, 23},
    {initData5, 31}
  ],
  part2: [
  ]
}

day = __ENV__.file |> Path.basename(".exs") |> String.to_integer
Utils = Code.require_file("lib/utils.exs") |> hd |> elem(0)
Utils.solve(day, Solution, testData)
