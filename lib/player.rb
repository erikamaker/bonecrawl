##############################################################################################################################################################################################################################################################
#####    PLAYER    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'

class Player
  include Inventory
  include Navigation
  attr_accessor :action, :target, :state, :sight, :position
  attr_accessor :items, :armor, :weapon, :health
  attr_accessor :focus_clock, :block_clock, :curse_clock
  def initialize
    super
    @action = :start
    @target = :start
    @state = :idle
    @sight = []
    @position = [0,1,2]
    @items = []
    @armor = nil
    @weapon = nil
    @health = 2
    @focus_clock = 0
    @block_clock = 0
    @curse_clock = 0
  end
  def reset_input
    @action = :reset
    @target = :reset
  end
  def reset_player_sight
    @sight.clear
  end
  def state_idle?
    @state == :idle
  end
  def toggle_state_idle
    @state = :idle
  end
  def toggle_state_engaged
    moves = MOVES[1..15].flatten
    return if moves.none?(@action)
    @state = :engaged
  end
  def action_select
    prompt_player
    process_input
    toggle_state_engaged
    print "\n\n\n\n"
  end
  def process_input
    @action = gets.chomp.downcase
    sentence = @action.scan(/[\w']+/)
    @action = (MOVES.flatten & (sentence)).join('')
    @target = (sentence - SPEECH).last
  end
  def turn_page
    reset_player_sight
    Board.increment_page(1)
    toggle_state_idle
    effects_cooldown
    reset_input
    print @curse_clock
  end
  def remove_from_inventory(item)
    @items.delete(item)
  end
  def weapon_equipped?
    weapon != nil
  end
  def armor_equipped?
    armor != nil
  end
  def clear_weapon
    @weapon = nil
  end
  def clear_armor
    @armor = nil
  end
  def armor_name
    if armor_equipped?
        Rainbow("#{armor.targets[0]}").purple
    end
  end
  def weapon_name
    if weapon_equipped?
        Rainbow("#{weapon.targets[0]}.").purple
    else Rainbow("bare hands.").purple
    end
  end
  def attack
    if weapon_equipped?
      weapon.profile[:damage]
    else 1
    end
  end
  def defense
    if armor_equipped?
        [(@armor.profile[:defense] + block_clock),4].min
    else 0 + [block_clock,4].min
    end
  end
  def focus_level
    if focus_clock > 0
        3
    else rand(1..4)
    end
  end
  def move_to_attack
    puts "	   - You move to strike the demon"
    print "	     with your #{weapon_name}\n\n"
  end
  def display_added_defense
    if armor_equipped?
        print "	   - Your #{armor_name} absorbs "
        print Rainbow("#{armor.profile[:defense]}").red
        print " damage\n"
        print "	     points. Watch its lifespan.\n\n "
        armor.profile[:lifespan] -= armor.profile[:defense]
    end
    if @block_clock > 1
        puts Rainbow("	   - Your emboldened defense will").orange
        puts Rainbow("	     last #{@block_clock - 1} more pages.\n").orange
    end
  end
  def display_added_focus
    if @focus_clock > 1
        puts Rainbow("	   - Your blessed focus will last").cyan
        puts Rainbow("	     just #{@focus_clock - 1} more pages.\n").cyan
    end
  end
  def lose_health(magnitude)
    total = (magnitude - defense)
    total > 0 ? total : 0
  end
  def gain_health(magnitude)
    SoundBoard.heal_heart
    @health += (magnitude)
  end
  def display_clock(clock_name)
    puts Rainbow("	   - The magick that affects your").red
    puts Rainbow("	     #{clock_name} grows thin.\n").red
  end
  def effects_cooldown
    if @focus_clock > 0
      display_clock("focus") if @focus_clock == 1
      @focus_clock -= 1
    end
    if @block_clock > 0
      display_clock("defense") if @block_clock == 1
      @block_clock -= 1
    end
    if @curse_clock > 0
        display_clock("possession") if @curse_clock == 1
        @curse_clock -= 1
    end
  end
end