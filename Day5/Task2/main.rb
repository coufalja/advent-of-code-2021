require 'set'

Point = Struct.new(:x, :y)

Line = Struct.new(:start, :fin) do
  def all_points
    @all_points ||= compute_all_points
  end

  def compute_all_points
    points = Set.new
    points.add(start)
    if start.x == fin.x
      (fin.y - start.y).abs.times do |count|
        points.add(Point.new(start.x, fin.y - start.y > 0 ? start.y + count : start.y - count))
      end
    elsif start.y == fin.y
      (fin.x - start.x).abs.times do |count|
        points.add(Point.new(fin.x - start.x > 0 ? start.x + count : start.x - count, start.y))
      end
    else
      (fin.x - start.x).abs.times do |count|
        points.add(Point.new(fin.x - start.x > 0 ? start.x + count : start.x - count, fin.y - start.y > 0 ? start.y + count : start.y - count));
      end
    end
    points.add(fin)
    return points
  end
end

class Board
  def initialize(size)
    @items = Array.new(size) { Array.new(size) { 0 } }
  end

  def add(line)
    line.all_points.each { |p|
      @items[p.x][p.y] += 1
    }
  end

  def overlaps
    @items.flat_map { |e| e }.select { |e| e >= 2 }.count
  end
end

def parse(line)
  points = line.split(" -> ")
  x = points[0].split(",")
  y = points[1].split(",")

  Line.new(
    Point.new(x[0].to_i, x[1].to_i),
    Point.new(y[0].to_i, y[1].to_i)
  )
end

### Main
board = Board.new(1000)
File.readlines('../input.txt').each { |line| board.add(parse line) }
puts "Number of overlapping tiles: #{board.overlaps}"


