defmodule Octopuses do
  def inc(idx, m), do: Enum.reduce(idx, m, fn {i,j},mt -> put_in(mt[i][j],mt[i][j]+1) end)
  def zero(idx, m), do: Enum.reduce(idx, m, fn {i,j},mt -> put_in(mt[i][j],0) end)
  def scan(idx, m), do: Enum.filter(idx, fn {i,j} -> m[i][j] == 10 end)
  def neigh(i, j), do: [ {i-1,j-1},{i,j-1},{i+1,j-1},{i-1,j},{i+1,j},{i-1,j+1},{i,j+1},{i+1,j+1} ]
  def bound(l, h, w), do: Enum.filter(l, fn {i,j} -> i >= 0 and j >=0 and i < h and j < w end)
  def nb(i,j,h,w), do: bound(neigh(i,j), h, w)

  def flash([], map, _h, _w), do: map
  def flash([{i,j} | t], map, h, w) do
    next = nb(i,j,h,w) |> Enum.filter(fn {i, j} -> map[i][j] < 10 end)
    map = inc(next, map)
    f = scan(next, map)
    flash(f ++ t, map, h, w)
  end

  def step(_p, max, max, res), do: res
  def step({ h, w, idx, map }, cnt, max, res) do
    map = inc(idx, map)
    flashing = scan(idx, map)
    map = flash(flashing, map, h, w)
    flashed = scan(idx, map)
    map = zero(flashed, map)
    fc = length(flashed)
    if fc == h*w, do: cnt + 1, else: step({ h, w, idx, map }, cnt + 1, max, res + fc)
  end
end

defmodule InputFile do
  def mapmap(l), do: for({v, k} <- Stream.with_index(l), into: %{}, do: {k, v})

  def load() do
    file = File.open!("..\\input.txt", [:read, :utf8])
    input = IO.read(file, :all) |> String.split("\n")

    lol = Enum.map(input, fn l -> String.graphemes(l) |> Enum.map(&String.to_integer/1) end)
    { h, w } = { length(lol), length(hd(lol)) }
    idx = for i <- 0..(h - 1), j <- 0..(w - 1), into: [], do: {i,j}
    { h, w, idx, Enum.map(lol, &mapmap/1) |> mapmap() }
  end
end


IO.puts "Result: #{InputFile.load() |> Octopuses.step(0, 10000000, 0)}"
