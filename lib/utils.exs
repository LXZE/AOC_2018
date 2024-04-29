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
      IO.puts("Expect: #{expect}")
      IO.puts("Result: #{res}")
      IO.puts("Exec time: #{Benchmark.format(execTime)}")
      IO.puts("Part 1: " <> (res == expect && "Correct" || "Incorrect"))
    end
    IO.puts("\n")
    for {input, expect} <- testData[:part2] do
        {execTime, res} = Benchmark.measure(fn ->
          solutionModule.part2(input |> String.split("\n"))
        end)
        IO.puts("Expect: #{expect}")
        IO.puts("Result: #{res}")
        IO.puts("Exec time: #{Benchmark.format(execTime)}")
        IO.puts("Part 2: " <> (res == expect && "Correct" || "Incorrect"))
    end
    IO.puts("\n")
  end

  def solveReal(solutionModule, date) do
    IO.puts("-- Actual data -- \n")
    input = getData(date)
    {execTime, res} = Benchmark.measure(fn -> solutionModule.part1(input) end)
    IO.puts("Part 1: #{res}")
    IO.puts("Exec time: #{Benchmark.format(execTime)}")
    IO.puts("\n")
    {execTime, res} = Benchmark.measure(fn -> solutionModule.part2(input) end)
    IO.puts("Part 2: #{res}")
    IO.puts("Exec time: #{Benchmark.format(execTime)}")
    IO.puts("\n")
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

  def format(time), do: format(time, -6)
  def format(time, unit) when time > 1000, do: format(time / 1000, unit+3)
  def format(time, 0), do: "#{time} seconds"
  def format(time, -3), do: "#{time} ms"
  def format(time, -6), do: "#{time} µs"
end
