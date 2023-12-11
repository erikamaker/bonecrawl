##############################################################################################################################################################################################################################################################
#####    PLAYER    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'inventory'
require_relative 'navigation'
require_relative 'board'
require_relative 'battling'


class Player
    include Inventory
    include Navigation
    include Battle
    attr_accessor :action, :target, :state, :sight, :position, :items
    attr_accessor :armor, :weapon, :health, :focus, :defense, :spirit, :level
    attr_accessor :stats_clock
    def initialize
        super
        @level = 1
        @position = [0,1,2]
        @action = :start
        @target = :start
        @state =  :inert
        @sight =  []
        @items = []
        @armor = nil
        @weapon = nil
        @health = 4
        @stats_clock = {:stunned => 0, :cursed => 0, :subdued => 0, :infected => 0, :strength => 80, :aggression => 0, :intelligence => 0}
    end
    def defense
        if armor_equipped
            [(@armor.profile[:defense] + @stats_clock[:strength]),4].min
        else 0 + [@stats_clock[:strength],4].min
        end
    end
    def focus
        rand(1..3)
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
    def state_inert
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
    def turn_page
        Board.increment_page(1)
        clear_sight
        toggle_state_inert
        cooldown_effects
        reset_input
    end
    def remove_from_inventory(item)
        @items.delete(item)
    end
end