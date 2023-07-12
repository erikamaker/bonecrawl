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
  def self.level
    @@level
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
  def self.secret_music
    fork do
      exec('aplay ./sounds/secret.wav > /dev/null 2>&1')
    end
  end
  def self.found_item
    fork do
        exec('aplay ./sounds/found_item.wav > /dev/null 2>&1')
      end
    end
end


# TODO: make sure items delete the same when they're burned.