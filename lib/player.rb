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
    attr_accessor :armor, :weapon, :health, :focus, :defense, :spirit, :level, :upper_hand
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
        @focus = 3
        @upper_hand = false
        @stats_clock = {:stunned => 0, :cursed => 0, :subdued => 0, :infected => 0, :fortified => 80, :stimulated => 0, :envigored => 0}
    end
    def stats
        { :level => @level, :attack => attack_points, :defense => defense, :health => @health, :focus => @focus}
    end
    def attack
        attack_points + @stats_clock[:envigored]
    end
    def defense
        if armor_equipped
            [(@armor.profile[:defense] + @stats_clock[:fortified]),4].min
        else 0 + [@stats_clock[:fortified],4].min
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
    def state_inert
        @state == :inert
    end
    def toggle_state_inert
        @state = :inert
    end
    def state_engaged
        @state == :engaged
    end
    def toggle_state_engaged
        moves = MOVES[1..16].flatten
        return if moves.none?(@action)
        @state = :engaged
    end
    def turn_page
        Board.increment_page(1)
        clear_sight
        @sight.concat(MOVES[15..16].flatten)
        toggle_state_inert
        cooldown_effects
        reset_input
    end
    def remove_from_inventory(item)
        @items.delete(item)
    end
end