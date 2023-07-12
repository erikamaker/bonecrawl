##############################################################################################################################################################################################################################################################
#####    PLAYER    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'

class Player
  include Inventory
  include Navigation
  attr_accessor :items, :health, :state, :target, :action, :sight, :position, :focus, :weapon, :armor, :effect, :focus_timer
  def initialize
    super
    @action = :start
    @target = :start
    @state = :idle
    @effect = nil
    @weapon = nil
    @armor = nil
    @position = [0,1,2]
    @sight = []
    @items = []
    @health = 2
    @spirit = 0
    @defense = 0
    @focus = 1
    @focus_timer = 0
  end
  def actions
    {
      view: MOVES[1],
      take: MOVES[2],
      open: MOVES[3],
      push: MOVES[4],
      pull: MOVES[5],
      talk: MOVES[6],
     craft: MOVES[7],
    battle: MOVES[8],
      burn: MOVES[9],
      feed: MOVES[10],
     drink: MOVES[11],
      mine: MOVES[12],
      lift: MOVES[13],
     equip: MOVES[14]
    }
  end
  def action_select
    prompt_player
    process_input
    toggle_engaged
    print "\n\n\n\n"
  end
  def process_input
    @action = gets.chomp.downcase
    sentence = @action.scan(/[\w']+/)
    @action = (MOVES.flatten & (sentence)).join('')
    @target = (sentence - SPEECH).last
  end
  def teleport(location)
    @@position = location
  end
  def remove_from_inventory(item)
    @items.delete(item)
  end
  def reset_input
    @action = :reset
    @target = :reset
  end
  def player_idle?
    @state == :idle
  end
  def toggle_player_state_idle
    @state = :idle
  end
  def toggle_engaged
    moves = MOVES[1..15].flatten
    return if moves.none?(@action)
    @state = :engaged
  end
  def damage_weapon
    if weapon_equipped?
      weapon.profile[:lifespan] -= 1
      weapon.break_item
    end
  end
  def damage_power
    if weapon_equipped?
      weapon.profile[:damage]
    else 1
    end
  end
  def move_to_attack
    puts "	   - You move to strike the demon"
    print "	     with your "
    if weapon_equipped?
      print(Rainbow("#{weapon.targets[0]}.\n\n").purple)
    else print(Rainbow("bare hands.\n\n").purple)
    end
end
  def armor_name
    armor.targets[0]
  end
  def block_points
    armor.profile[:defense]
  end
  def defense_power
    if armor
      puts Rainbow("	     Your #{armor_name} absorbs #{block_points}.").cyan
      armor.profile[:lifespan] -= armor.profile[:defense]
    end
    print "\n"
  end
  def lose_health(magnitude)
    @health -= (magnitude - @defense)
  end
  def gain_health(magnitude)
    SoundBoard.heal_heart
    @health += (magnitude)
  end
  def accuracy_level
    rand(@focus..4)
  end
  def clear_weapon
    @weapon = nil
  end
  def clear_armor
    @armor = nil
  end
  def weapon_equipped?
    weapon != nil
  end
  def reset_player_sight
    @sight.clear
  end
  def focus_cooldown
    if @focus_timer == 1
        puts Rainbow("	   - Your increased focus begins").purple
        puts Rainbow("	     to run thin.\n\n").purple
    end
    if @focus_timer > 0
        @focus_timer -= 1
    end
    if @focus_timer == 0
        @focus = 0
    end
  end
  def effects_cooldown
    return if @focus_timer == 0
    focus_cooldown
  end
  def turn_page
    reset_player_sight
    Board.increment_page(1)
    toggle_player_state_idle
    effects_cooldown
    reset_input
  end
end