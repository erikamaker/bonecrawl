##############################################################################################################################################################################################################################################################
#####    GAMEBOARD    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Gameboard
    def initialize
        @@world_map = []
        @@position= [0,1,2]
        @@inventory = []
        @@encounters = []
        @@page_count = 0
        @@player_stats = {
            :heart => 1,
            :souls => 0,
            :slays => 0,
            :bones => 0,
        }
        @@skill_stats = {
            :arrows => 0,
            :blades => 0,
            :magick => 0,
            :speech => 0
        }
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
        moves = MOVES[1..12].flatten
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
    def detect_direction
        if directions.include?(@@target)
            reposition_player
        else
            no_direction_detected
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
    def print_movement_options
        directions.each_with_index do |direction, index|
            print Rainbow(direction).orange
            print ", " unless index.eql?(directions.size - 1)
            print Rainbow("or ").white if index.eql?(directions.size - 2)
        end
    end
    def no_direction_detected
        print "	   - Move one adjacent tile using\n"
        print "	     "
        print_movement_options
        puts ".\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    INTERFACE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Interface < Gameboard
	def page_top
        print Rainbow("\n---------------------------------------------------------\n").blue.bright
		print Rainbow("[     - ").blue.bright
        print_spirit_meter
        print Rainbow(" -   ╱   - ").blue.bright
		print_hearts_meter
		print Rainbow(" -     ]").blue.bright
		print Rainbow("\n---------------------------------------------------------\n\n\n").blue.bright
    end
    def print_spirit_meter
        print "SPIRIT "
		@@player_stats[:souls] = [@@player_stats[:souls], 4].min
		@@player_stats[:souls].times { print Rainbow("■ ").orange }
		(4 - @@player_stats[:souls]).times { print Rainbow("■ ").cyan }
    end
    def print_hearts_meter
        print "HEARTS "
		@@player_stats[:heart] = [@@player_stats[:heart], 4].min
		if @@player_stats[:heart] > 1
		    @@player_stats[:heart].times { print Rainbow("♥ ").red }
		else
            print Rainbow("♥ ").red.blink
		end
		(4 - @@player_stats[:heart]).times { print Rainbow("♥ ").cyan }
    end
    def that_move_made_no_sense
        MOVES.flatten.none?(@@action) || (@@target.eql?(@@action))
    end
    def player_selected_help_menu
        (MOVES[13] | MOVES[0]).include?(@@target)
    end
	def tutorial
		if that_move_made_no_sense
			return if player_selected_help_menu
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
	def help_menu
		if MOVES[13].include?(@@action)
			puts "	   - Speak your move plainly in a"
			puts "	     few short words, referencing"
			puts "	     just one subject per page.\n\n"
			puts Rainbow("	     Check the area.").blue
			puts Rainbow("	     Talk to the prisoner.").indigo
			puts Rainbow("	     Unlock the door.").maroon
			puts Rainbow("	     Attack the demon.").red
			puts Rainbow("	     View my inventory.").orange
			puts Rainbow("	     Eat some bread.").green
			puts Rainbow("	     Walk south.").cyan
			puts Rainbow("	     Steal the sword.").blue
			puts Rainbow("	     Check my stats.\n").indigo
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
	def page_bottom
		puts "\n\n\n"
        draw_map
        (37 - @@page_count.to_s.length).times { print(" ") }
		print Rainbow("- Pg. #{@@page_count} -\n\n").purple
	end
end