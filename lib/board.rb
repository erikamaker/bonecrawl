##############################################################################################################################################################################################################################################################
#####    BOARD    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'player'

class Board
  include Interface
  def initialize
    @@page = 0
    @@map = []
    @@player = Player.new
  end
  def self.actions
    {
      view: MOVES[1],
      take: MOVES[2],
      open: MOVES[3],
      push: MOVES[4],
      pull: MOVES[5],
      talk: MOVES[6],
      make: MOVES[7],
    battle: MOVES[8],
      burn: MOVES[9],
      feed: MOVES[10],
      gulp: MOVES[11],
      mine: MOVES[12],
      lift: MOVES[13],
     equip: MOVES[14]
    }
  end
  def self.player
    @@player
  end
  def self.world_map
    @@map
  end
  def self.page_count
    @@page
  end
  def self.increment_page(count)
    @@page += count
  end
  def self.decrement_page(count)
    @@page -= count
  end
end