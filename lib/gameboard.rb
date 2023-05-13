##############################################################################################################################################################################################################################################################
#####    GAMEBOARD    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Gameboard
    def initialize
        @@world_map = []
        @@position = [0,1,2]
        @@inventory = []
        @@encounters = []
        @@page_count = 0
        @@statistics = {
            :heart => 4,
            :block => 0,
            :focus => 1,
            :souls => 0,
            :slays => 0,
            :bones => 0,
        }
        @@weapons = {
            :weapon => nil,
            :arrows => 0,
            :blades => 0,
            :magick => 0,
            :speech => 0
        }
    end
    def remove_from_board
        @minimap = [0]
        remove_from_inventory
    end
    def remove_from_inventory
        @@inventory.delete(self)
    end
    def search_inventory(types)
        types = Array(types)
        @@inventory.find do |item|
            types.any? do |type|
              item.is_a?(type)
            end
        end
    end
    def damage_player(magnitude)
        block = @@statistics[:block]
        total = magnitude - block
        @@statistics[:heart] -= total
    end
    def player_focus
        rand(@@statistics[:focus]..4)
    end
    def action_select
        prompt_player
        process_input
        toggle_engaged
        print "\n\n\n\n"
    end
    def prompt_player
        print Rainbow("\n   What next?").cyan.bright
        print Rainbow("  >>  ").purple.bright
    end
    def process_input
        @@action = gets.chomp.downcase
        sentence = @@action.scan(/[\w']+/)
        @@action = (MOVES.flatten & (sentence)).join('')
        @@target = (sentence - SPEECH).last
    end
    def reset_input
        @@action = :reset
        @@target = :reset
    end
    def toggle_idle
        @@state = :player_idle
    end
    def toggle_engaged
        moves = MOVES[1..15].flatten
        return if moves.none?(@@action)
        @@state = :player_engaged
    end
    def reset_sightline
        @@encounters.clear
    end
    def increment_page(count)
        @@page_count += count
    end
    def decrement_page(count)
        @@page_count -= count
    end
    def turn_page
        reset_sightline
        increment_page(1)
        toggle_idle
        reset_input
    end
end




##############################################################################################################################################################################################################################################################
#####    MOVEMENT    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



class Inventory < Gameboard
    def synonyms
        ["rucksack","knapsack","backpack","bag","pack","items","inventory","stuff","things"]
    end
    def load_synonyms
        @@encounters | synonyms
    end
    def opening_or_viewing
        (MOVES[1] | MOVES[3]).include?(@@action)
    end
    def target_isnt_inventory
        synonyms.none?(@@target)
    end
    def detect_usage
        return if target_isnt_inventory
        if opening_or_viewing
            load_synonyms
            open_inventory
            toggle_engaged
        end
    end
    def open_inventory
        print Rainbow("	   - You reach into your rucksack.\n\n").red
        if @@inventory.empty?
			print "	   - It's empty.\n\n"
            print Rainbow("           - You close your rucksack shut.\n\n").red
		else
            show_contents
            manage_inventory
		end
        reset_input
    end
    def show_contents
        @@inventory.group_by { |item| item.targets[0] }.each do |item, total|
            dots = (24 - item.length)
            item_copy = item
            print "	     #{item_copy.split.each{|word| word.capitalize!}.join(' ')}"
            dots.times do
                print Rainbow(".").purple
            end
            puts " #{total.count}"
        end
    end
    def manage_inventory
        print Rainbow("\n\n	   - What next?").cyan
        print Rainbow("  >>  ").purple
        process_input
        item = @@inventory.find { |item| item.targets.include?(@@target) }
        puts "\n\n"
        bag_action(item)
    end
    def bag_action(item)
        if MOVES[1..15].flatten.none?(@@action)  # TO DO : make this more exclusive (the help keyword shouldn't work, for instance)
            puts Rainbow("           - You tie your rucksack shut.\n").red
        elsif item.nil?
            puts Rainbow("           - You don't have that.\n").red
        elsif MOVES[2].include?(@@action)
            puts Rainbow("           - You already have it.\n").red
        else
            item.interact
            puts Rainbow("           - You tie your rucksack shut.\n").red
        end
    end
end


##############################################################################################################################################################################################################################################################
#####    STATISTICS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Statistics < Gameboard
    def synonyms
        ["hell pass","pass","card","id","identification","stats","statistics"]
    end
    def load_synonyms
        @@encounters | synonyms
    end
    def opening_or_viewing
        (MOVES[1] | MOVES[3]).include?(@@action)
    end
    def target_isnt_stats
        synonyms.none?(@@target)
    end
    def detect_usage
        return if target_isnt_stats
        if opening_or_viewing
            load_synonyms
            display_stats
            display_skill
            reset_input
        end
    end
    def display_stats
        puts Rainbow("	          - Prisoner Stats -\n").green
        @@statistics.each do |key, value|
            dots = Rainbow(".").purple * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n\n"
    end
    def display_skill
        puts Rainbow("	          - Skill Progress -\n").orange
        @@weapons.each do |key, value|
            dots = Rainbow(".").red * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n"
    end
end



##############################################################################################################################################################################################################################################################
#####    MOVEMENT    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Position < Gameboard
    def directions
        ["north","south","east","west"]
    end
    def load_directions
        @@encounters | directions
    end
    def direction
        {
            directions[0] => [0, 1],
            directions[1] => [0,-1],
            directions[2] => [1, 0],
            directions[3] => [-1,0]
        }
    end
    def directed_movement
        @@position[1] += direction[@@target][0]
        @@position[2] += direction[@@target][1]
    end
    def activated_barrier
        @@position[1] -= direction[@@target][0]
        @@position[2] -= direction[@@target][1]
    end
    def no_direction_detected
        print Rainbow("	   - Move ").cyan
        print "one adjacent tile using\n"
        print Rainbow("	     north").orange + ", "
        print Rainbow("south").orange + ", "
        print Rainbow("east").orange + ", or "
        print Rainbow("west").orange + ".\n\n"
    end
    def detect_direction
        if directions.include?(@@target)
            reposition_player
        else
            no_direction_detected           # FIX THIS
        end
    end
    def detect_movement
        if MOVES[0].include?(@@action)
            load_directions
            detect_direction
        end
    end
    def reposition_player
        directed_movement
        if @@world_map.include?(@@position)
            animate_movement
        else
            activated_barrier
            the_way_is_blocked
        end
    end
    def animate_movement
        print "	   - You move #{@@target} to "
        print Rainbow(	     "[ #{@@position[1]} , #{@@position[2]} ]").orange
        print ".\n\n"
    end
    def the_way_is_blocked
        puts "	   - The #{@@target}ern way is blocked."
        puts "	     One page passes in vain.\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    INTERFACE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Interface < Gameboard
    def header
        print Rainbow("\n---------------------------------------------------------\n").blue.bright
        print Rainbow("[").blue.bright
        print Rainbow("         - BONE CRAWL / ERIKA MAKER / 2019 © -         ").violet
        print Rainbow("]").blue.bright
        print Rainbow("\n---------------------------------------------------------").blue.bright
        print "\n\n\n\n\n"
    end
	def page_top
        print Rainbow("\n---------------------------------------------------------\n").blue.bright
		print Rainbow("[   ").blue.bright
        print_spirit_meter
        print Rainbow("  |   ").blue.bright
		print_hearts_meter
		print Rainbow("  |   ").blue.bright
        toggle_key_icon
        print Rainbow("]").blue.bright
		print Rainbow("\n---------------------------------------------------------\n\n").blue.bright
    end
    def toggle_key_icon
        print "KEYS "

        if search_inventory([Key,Lockpick])
            print Rainbow(" ⌐0  ").orange
        else print "     "
        end
    end
    def print_spirit_meter
        print "SPIRIT "
		@@statistics[:souls] = [@@statistics[:souls], 4].min
		@@statistics[:souls].times { print Rainbow("■ ").orange }
		(4 - @@statistics[:souls]).times { print Rainbow("■ ").cyan }
    end
    def print_hearts_meter
        print "HEARTS "
		@@statistics[:heart] = [@@statistics[:heart], 4].min
		if @@statistics[:heart] > 1
		    @@statistics[:heart].times { print Rainbow("♥ ").red }
		else
            print Rainbow("♥ ").red.blink
		end
		(4 - @@statistics[:heart]).times { print Rainbow("♥ ").cyan }
    end
    def not_a_move
        MOVES.flatten.none?(@@action)
    end
    def input_stutter
        (@@target.eql?(@@action))
    end
    def nontraditional_move
        not_a_move || input_stutter
    end
    def tutorial_selected
        MOVES[13].include?(@@target)
    end
	def suggest_tutorial
		if nontraditional_move
			return if tutorial_selected
			toggle_idle
			print "	   - A page passes in vain. View\n"
			print "	     tutorial with command"
            print Rainbow(" help").cyan + ".\n\n"
		end
	end
    def no_target
        return if @@target.eql?(@@action)
        return if @@state.eql?(:player_idle)
        if @@encounters.none?(@@target)
            puts "	   - If it exists, it isn't here."
            puts "	     To view your inventory, open"
            puts "	     your knapsack.\n\n"
        end
    end
	def tutorial_screen
		if tutorial_selected
			puts "	   - Speak your move plainly in a"
			puts "	     few short words, referencing"
			puts "	     only one subject per page.\n\n"
			puts Rainbow("	     Slay the troll.").red
			puts Rainbow("	     View my items.").yellow
			puts Rainbow("	     Eat some bread.").green
			puts Rainbow("	     Go west of here.").blue
			puts Rainbow("	     Read my journal.\n").indigo
			print "	   - Press "
            print Rainbow("return").cyan
			puts " for the current"
            puts "	     coordinate's list of targets,"
            puts "	     or to quickly pass time.\n\n"
		end
    end
    def bigmap
        z = @@position[0]
		x = @@position[1]
		y = @@position[2]
        [
		    [[z, x - 1, y + 1], [z, x, y + 1], [z, x + 1, y + 1]],
		    [[z, x - 1, y], [z, x, y], [z, x + 1, y]],
		    [[z, x - 1, y - 1], [z, x, y - 1], [z, x + 1, y - 1]]
		]
    end
    def draw_map
        bigmap.each do |row|
			print "   "
			row.each do |pos|
				if pos.eql?(@@position)
					print Rainbow("■ ").red.blink
				elsif @@world_map.include?(pos)
					print Rainbow("■ ").green
			    else
                    print "⬚ "
				end
			end
			print "\n" if row != bigmap.last
		end
    end
    def draw_page_count
        (37 - @@page_count.to_s.length).times { print(" ") }
		print Rainbow("- Pg. #{@@page_count} -\n\n").purple
    end
	def page_bottom
		puts "\n\n\n"
        draw_map
        draw_page_count
	end
    def game_over
        if @@statistics[:heart] < 1
            sleep 2
            puts Rainbow("	   - Hearts expired, you collapse").purple
            print Rainbow("	     where you stand.\n\n").purple
            sleep 2
            puts "	   - A clamor of demons drag your"
            puts "	     soul to its assigned cell.\n\n"
            sleep 2
            page_bottom
            print Rainbow("\n---------------------------------------------------------\n").red.bright
            print Rainbow("[   SPIRIT X X X X   |   HEARTS X X X X   |   KEYS      ]").red
            print Rainbow("\n---------------------------------------------------------").red.bright
            puts "\n\n\n\n\n\n"
            exit!
        end
    end
end