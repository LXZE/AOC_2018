defmodule Utils do
  def getData(date) do
    File.stream!('inputs/#{date}.txt')
    |> Enum.map(&String.trim/1)
  end

  def solveTest(solutionModule, testData) do
    IO.puts("-- Test data -- \n")
    for {input, expect} <- testData[:part1] do
      {execTime, res} = Benchmark.measure(fn ->
        solutionModule.part1(input |> String.split("\n"))
      end)
      if not is_nil(res) do
        IO.puts("Expect: #{expect}")
        IO.puts("Result: #{res}")
        IO.puts("Exec time: #{Benchmark.format(execTime)}")
        IO.puts("Part 1: " <> (res == expect && "Correct" || "Incorrect"))
      else
        IO.puts("Part 1: unsolved")
      end
    end
    IO.puts("")
    for {input, expect} <- testData[:part2] do
      {execTime, res} = Benchmark.measure(fn ->
        solutionModule.part2(input |> String.split("\n"))
      end)
      if not is_nil(res) do
        IO.puts("Expect: #{expect}")
        IO.puts("Result: #{res}")
        IO.puts("Exec time: #{Benchmark.format(execTime)}")
        IO.puts("Part 2: " <> (res == expect && "Correct" || "Incorrect"))
      else IO.puts("Part 2: unsolved") end
    end
    IO.puts("")
  end

  def solveReal(solutionModule, date) do
    IO.puts("-- Actual data -- \n")
    input = getData(date)
    {execTime, res} = Benchmark.measure(fn -> solutionModule.part1(input) end)
    if not is_nil(res) do
      IO.puts("Part 1: #{res}")
      IO.puts("Exec time: #{Benchmark.format(execTime)}")
      IO.puts("")
    end
    {execTime, res} = Benchmark.measure(fn -> solutionModule.part2(input) end)
    if not is_nil(res) do
      IO.puts("Part 2: #{res}")
      IO.puts("Exec time: #{Benchmark.format(execTime)}")
      IO.puts("")
    end
  end

  def solve(date, module, testData) do
    if "--test" in System.argv() do
      solveTest(module, testData)
    else
      solveReal(module, date)
    end
  end
end

defmodule Benchmark do
  def measure(function) do
    function |> :timer.tc
  end

  def prettify(time), do: :erlang.float_to_binary(time, [:compact, decimals: 4])

  def format(time), do: format(time, -6)
  def format(time, unit) when time > 1000, do: format(time / 1000, unit+3)
  def format(time, 0), do: "#{prettify(time)} seconds"
  def format(time, -3), do: "#{prettify(time)} ms"
  def format(time, -6), do: "#{prettify(time)} µs"
end
