require_relative 'board'
require_relative 'tile'

class MineSweeper

  def initialize
    @board = Board.new
  end

  def play
    until over?
      @board.render
      pos = get_pos
      move = place_what
      if move == 'g'
        @board.open_tile(pos)
        return player_lose if @board.bomb?(pos)
      else
        @board[pos].flag_tile
      end
    end
    player_won
  end

  def get_pos
    puts "where do you want to check?(0,0)"
    gets.chomp.split(",").map(&:to_i)
  end

  def place_what
    puts "what do you want to do?(g/f)"
    gets.chomp
  end

  def player_lose
    open_everything
    puts "YOU LOSEEEEEE!!!"
  end

  def player_won
    open_everything
    puts "YOU WIN!"
  end

  def open_everything
    @board.grid.each do |row|
      row.each do |tile|
        tile.reveal
      end
    end
    @board.render
  end

  def over?
    hidden = 0
    @board.grid.each do |row|
      row.each do |tile|
        hidden += 1 unless tile.visible
      end
    end
    p hidden

    hidden == 2 ? true : false
  end

end

if __FILE__ == $0
  test = MineSweeper.new
  test.play
end
