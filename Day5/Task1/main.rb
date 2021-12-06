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
    end
    if start.y == fin.y
      (fin.x - start.x).abs.times do |count|
        points.add(Point.new(fin.x - start.x > 0 ? start.x + count : start.x - count, start.y))
      end
    end
    points.add(fin)
    return points
  end
end

class Board
  def initialize
    @items = Array.new(1000) { Array.new(1000) { 0 } }
  end

  def add(line)
    line.all_points.each { |p|
      @items[p.x][p.y] += 1
    }
  end

  def overlaps
    over = 0
    @items.each { |row|
      row.each { |item|
        if item >= 2
          over += 1
        end
      }
    }
    over
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
board = Board.new
File.readlines('../input.txt').each do |line|
  parsed = parse line
  board.add(parsed)
end
puts "Number of overlapping tiles: #{board.overlaps}"


