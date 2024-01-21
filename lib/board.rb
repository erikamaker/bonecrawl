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
    def self.load_player
        print "\e[?25h"
        player.action_select
        system("clear")
        player.header
        player.detect_movement
        player.suggest_tutorial
        player.tutorial_screen
        player.stats_screen
        player.load_inventory
    end
    def self.load_loot(items)
        if items.any? { |item| item.location.include?(Board.player.position) }
            Board.player.present_list_of_loot
            items.each { |item| item.activate }
            print "\n"
        end
    end
    def self.run_game(rooms,fixtures,items)
        print "\e[8;40;57t"
        loop do
            Board.load_player
            rooms.each { |room| room.activate}
            fixtures.each { |fixture| fixture.activate }
            player.game_over
            Board.load_loot(items)
            Board.game_end
        end
    end
    def self.game_end
        player.target_does_not_exist
        player.turn_page
        player.page_top
        player.page_bottom
    end
end