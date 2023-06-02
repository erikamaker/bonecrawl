require_relative 'gamepiece'
require_relative 'inventory'
require_relative 'navigation'


class Player < Board
  include Inventory
  include Navigation
  attr_accessor :items, :health, :state, :target, :action, :sight, :position, :focus
  def initialize
    super
    @action = :start
    @target = :start
    @state = :idle
    @effect = :norm
    @weapon = nil
    @position = [0,1,2]
    @sight = []
    @items = []
    @health = 2
    @spirit = 0
    @defense = 0
    @focus = 1
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
  def remove_from_inventory(item)
    @items.delete(item) { |i| i == item }
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
  def reset_sight
    @sight.clear
  end
  def turn_page
    reset_sight
    increment_page(1)
    toggle_idle
    reset_input
  end
end