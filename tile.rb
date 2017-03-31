class Tile
  attr_accessor :flag, :bomb, :num, :visible, :neighbors

  def initialize
    @flag = false
    @bomb = false
    @visible = false
    @num = 0
    @neighbors = []
  end

  def reveal
    @visible = true
  end

  def flag_tile
    @flag = @flag ? false : true
  end

  def place_bomb
    @bomb = true
  end
end
