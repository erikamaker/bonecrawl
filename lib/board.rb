require_relative 'vocabulary'

class Board
  include Interface
  attr_accessor :position
  def initialize(player = nil)
    @@page = 0
    @@map = []
  end
  def world_map
    @@map
  end
  def page_count
    @@page
  end
  def actions
    {
      view: MOVES[1],
      take: MOVES[2],
      open: MOVES[3],
      push: MOVES[4],
      pull: MOVES[5],
      talk: MOVES[6],
      give: MOVES[7],
      harm: MOVES[8],
      burn: MOVES[9],
      feed: MOVES[10],
      drink: MOVES[11],
      mine: MOVES[12],
      lift: MOVES[13],
      equip: MOVES[14]
    }
  end
  def remove_from_board
    @position = [0]
  end
  def move_piece(new_plot)
    @position = new_plot
  end
  def increment_page(count)
    @@page += count
  end
  def decrement_page(count)
    @@page -= count
  end
  def print_page
    @@page
  end
end