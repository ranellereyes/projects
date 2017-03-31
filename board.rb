require_relative 'tile'
require "byebug"

class Board
  NUM_BOMBS = 10

  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) { Tile.new } }
    set_neighbors
    set_bombs
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def set_bombs
    10.times do |i|
      pos = nil
      until bomb?(pos) == false
        x = (0..8).to_a.sample
        y = (0..8).to_a.sample
        pos = [x, y]
      end

      self[pos].place_bomb
      neighbor_bomb_count(pos)
    end
  end

  def neighbor_bomb_count(pos)
    self[pos].neighbors.each do |nei_pos|
      self[nei_pos].num += 1
    end
  end

  def set_neighbors

    @grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        adjacents = (-1..1).to_a.repeated_permutation(2).to_a - [[0, 0]]
        tile.neighbors = adjacents.map do |pair|
          [pair[0] + x, pair[1] + y]
        end.select { |pair| within_bounds?(pair) }
      end
    end
  end

  def within_bounds?(pos)
    pos.all? { |ele| (0..8).to_a.include?(ele) }
  end

  def bomb?(pos)
    return nil if pos.nil?
    self[pos].bomb
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    @grid.each_with_index do |row, i|
      rendered_row = row.map do |tile|
        if tile.visible
          tile.bomb ? 'B' : tile.num
        else
          tile.flag ? 'F' : "_"
        end
      end
      puts "#{i} #{rendered_row.join(" ").chomp}"
    end
    nil
  end

  def open_tile(pos)
    self[pos].reveal
    neighbors = self[pos].neighbors
    neighbors.each do |pos|
      open_tile(pos) if self[pos].num == 0 && !self[pos].visible && !bomb?(pos)
    end
  end

end

if __FILE__ == $0
  test = Board.new
  test.render
end
