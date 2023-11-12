##############################################################################################################################################################################################################################################################
#####    PLAYER    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'
require_relative 'battle'

class Player
  include Inventory
  include Navigation
  include Battle
  attr_accessor :action, :target, :state, :sight, :position
  attr_accessor :items, :armor, :weapon, :health, :focus, :defense
  attr_accessor :focus_clock, :block_clock, :curse_clock
  def initialize
    super
    @position = [0,1,2]
    @action = :start
    @target = :start
    @state =  :inert
    @sight =  []
    @items = []
    @armor = nil
    @weapon = nil
    @defense = 0
    @health = 2
    @focus_clock = 0
    @block_clock = 0
    @curse_clock = 0
  end
  def focus
    rand(1..3)
  end
  def defense
    if armor_equipped?
        [(@armor.profile[:defense] + @block_clock),4].min
    else 0 + [block_clock,4].min
    end
  end
  def display_defense
    if armor_equipped?
        print "	   - Your #{armor_name} deflects "
        print Rainbow("#{@armor.profile[:defense]}").green
        print " damage\n"
        print "	     points. Its lifespan wanes.\n\n "
    end
  end
  def damage(magnitude)
    if (magnitude - defense) > 0
        (magnitude - defense)
    else 0
    end
  end
  def gain_health(magnitude)
    SoundBoard.heal_heart
    @health += (magnitude)
  end
  def alive?
    @health > 0
  end
  def clear_sight
    @sight.clear
  end
  def state_inert?
    @state == :inert
  end
  def toggle_state_inert
    @state = :inert
  end
  def toggle_state_engaged
    moves = MOVES[1..15].flatten
    return if moves.none?(@action)
    @state = :engaged
  end
  def display_clock(clock_name)
    puts Rainbow("	   - The magick that affects your").red
    puts Rainbow("	     #{clock_name} grows thin.\n").red
end
def cooldown_effects
    if @focus_clock > 0
      @focus_clock -= 1
      display_clock("focus") if @focus_clock == 1
    end
    if @block_clock > 0
      @block_clock -= 1
      display_clock("defense") if @block_clock == 1
    end
    if @curse_clock > 0
      @curse_clock -= 1
      display_clock("possession") if @curse_clock == 1
    end
end
  def turn_page
    clear_sight
    Board.increment_page(1)
    toggle_state_inert
    cooldown_effects
    reset_input
  end
  def remove_from_inventory(item)
    @items.delete(item)
  end
end
