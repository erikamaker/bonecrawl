require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'


class Player
  include Inventory
  include Navigation
  attr_accessor :items, :health, :state, :target, :action, :sight, :position, :focus, :weapon, :armor
  def initialize
    super
    @action = :start
    @target = :start
    @state = :idle
    @effect = :norm
    @weapon = nil
    @armor = nil
    @position = [0,1,2]
    @sight = []
    @items = []
    @health = 2
    @spirit = 0
    @defense = 0
    @focus = 1
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
  def reset_input
    @action = :reset
    @target = :reset
  end
  def player_idle?
    @state == :idle
  end
  def toggle_idle
    @state = :idle
  end
  def toggle_engaged
    moves = MOVES[1..15].flatten
    return if moves.none?(@action)
    @state = :engaged
  end
  def lose_health(magnitude)
    @health -= (magnitude - @defense)
  end
  def gain_health(magnitude)
    @health += (magnitude)
  end
  def player_accuracy
    rand(@focus..4)
  end
  def weapon_equipped?
    weapon != nil
  end
  def reset_sight
    @sight.clear
  end
  def turn_page
    reset_sight
    Board.increment_page(1)
    toggle_idle
    reset_input
  end
end