defmodule Solution do
  def parse([ip_cmd | rem]) do
    ip = String.split(ip_cmd, " ") |> List.last |> String.to_integer
    cmds = Enum.map(rem, fn line ->
      String.split(line, " ") |> Enum.with_index
        |> Enum.map(fn
          {term, 0} -> term
          {term, _} -> String.to_integer(term)
        end)
    end)
    {ip, cmds}
  end

  def increase_ip(register, ip) do
    List.update_at(register, ip, & &1+1)
  end

  def get_register(val, register), do: Enum.at(register, val)

  def exec(["seti", a, _, c], register), do: List.replace_at(register, c, a)
  def exec(["setr", a, _, c], register), do: List.replace_at(register, c, get_register(a, register))
  def exec(["addi", a, b, c], register), do: List.replace_at(register, c, get_register(a, register) + b)
  def exec(["addr", a, b, c], register), do: List.replace_at(register, c, get_register(a, register) + get_register(b, register))
  def exec(["muli", a, b, c], register), do: List.replace_at(register, c, get_register(a, register) * b)
  def exec(["mulr", a, b, c], register), do: List.replace_at(register, c, get_register(a, register) * get_register(b, register))

  def exec(["eqrr", a, b, c], register), do: List.replace_at(register, c, if(get_register(a, register) == get_register(b, register), do: 1, else: 0))
  def exec(["gtrr", a, b, c], register), do: List.replace_at(register, c, if(get_register(a, register) > get_register(b, register), do: 1, else: 0))

  @spec part1(input :: [String.t()]) :: integer()
  def part1(input) do
    register = List.duplicate(0, 6)
    {ip, cmds} = parse(input)
    limit = length(cmds)
    Stream.repeatedly(fn->0 end) |> Enum.reduce_while(register, fn _, reg ->
      case Enum.at(reg, ip) do
        ipval when ipval >= limit -> {:halt, hd(reg)}
        ipval -> {:cont, Enum.at(cmds, ipval) |> exec(reg) |> increase_ip(ip)}
      end
    end)
  end

  @spec part2(input :: [String.t()]) :: integer()
  def part2(input) do
    register = List.duplicate(0, 6)
      |> List.replace_at(0, 1) # specified in task
    {ip, cmds} = parse(input)
    target_number = Stream.repeatedly(fn->0 end) |> Enum.reduce_while(register, fn _, reg ->
      # :timer.sleep(500)
      case Enum.at(reg, ip) do
        ipval when ipval == 1 -> {:halt, reg} # ip == 1 means got actual target number
        ipval ->
          cmd =  Enum.at(cmds, ipval)
          {:cont, cmd |> exec(reg) |> increase_ip(ip) }
      end
    end) |> Enum.max

    # find sum of all divisors of the number
    Enum.filter(1..target_number, &Integer.mod(target_number, &1) == 0)
    |> Enum.sum
  end
end

initData = "
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
"

testData = %{
  part1: [
    {initData |> String.trim("\n"), 7}
  ],
  part2: [
    # {initData |> String.trim("\n"), nil}
  ]
}

day = __ENV__.file |> Path.basename(".exs") |> String.to_integer
Utils = Code.require_file("lib/utils.exs") |> hd |> elem(0)
Utils.solve(day, Solution, testData)
