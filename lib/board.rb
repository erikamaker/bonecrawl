require_relative 'vocabulary'
require_relative 'player'

class Board
  include Interface
  def initialize
    @@page = 0
    @@map = []
    @@player = Player.new
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
  def self.print_page
    @@page
  end
end