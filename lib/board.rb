##############################################################################################################################################################################################################################################################
#####    BOARD    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'player'
require_relative 'battling'


class Board
  include Interface
  include Battle
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
    attack: MOVES[7],
    craft: MOVES[8],
      burn: MOVES[9],
      eat: MOVES[10],
      drink: MOVES[11],
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