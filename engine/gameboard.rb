############################################################################################################################################################################################################################################################## 
#####    GAMEBOARD    ########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Gameboard
    def initialize
        @@world = [] 
        @@check = []
        @@stand = [0,1,2]
        @@items = []
        @@sight = []
        @@heart = 1
        @@souls = 1
        @@pages = 0
        @@stats = {
            :offense => 1,
            :defense => 0, 
            :excited => 0,
            :sedated => 0,
            :tranced => 0, 
            :blessed => 0,
            :acursed => 0,
        }

        @@skill = {
            :arrows => 0,     
            :blades => 0,     
            :magick => 0,     
            :speech => 0      
        }
    end
    def action_select
        prompt_player
        process_input
        toggle_interact
        print "\n\n\n\n" 
    end	
    def prompt_player
        print Rainbow("\n  What next?").cyan.bright
        print Rainbow("  >>  ").purple.bright	
    end
    def process_input	
        @@action = gets.chomp.downcase.gsub(/[[:punct:]]/, '')									
        sentence = @@action.split(' ')
        @@action = (MOVES.flatten & (sentence)).join('')
        @@target = (sentence - PARTS).last 
    end	
    def reset_input
        @@action = :reset
        @@target = :reset
    end
    def toggle_interact 
        moves = MOVES[1..12].flatten 
        if moves.include?(@@action)
            @@state = :interact
        end
    end
    def toggle_backdrop
        @@state = :backdrop
    end
    def reset_sightline
        @@sight.clear
    end
    def increment_page(count)
        @@pages += count
    end
    def decrement_stats
        @@stats.each_with_index do |(key, value), index|
            next unless (2..5).include?(index)
            @@stats[key] -= 1 if value > 0
        end
    end
    def turn_page
        reset_sightline
        increment_page(1)
        toggle_backdrop  
        decrement_stats
    end
end


############################################################################################################################################################################################################################################################## 
#####    MOVEMENT    #########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Position < Gameboard
    def compass 
        ["north","south","east","west"]
    end
    def load_compass
        @@sight | compass
    end
    def direction
        {
            compass[0] => [0, 1],
            compass[1] => [0,-1],
            compass[2] => [1, 0],
            compass[3] => [-1,0]
        }
    end 
    def directed_movement
        @@stand[1] += direction[@@target][0]
        @@stand[2] += direction[@@target][1] 
    end
    def activated_barrier
        @@stand[1] -= direction[@@target][0]
        @@stand[2] -= direction[@@target][1]
    end
    def detect_direction
        if compass.include?(@@target)
            reposition 
        else 
            cartesian_error
        end  
    end
    def detect_movement
        if MOVES[0].include?(@@action)
            load_compass
            detect_direction
        end
    end
    def reposition
        directed_movement
        if @@world.include?(@@stand)
            accepted_movement
        else 
            redirect_movement
        end
    end
    def accepted_movement
        print "	   - You move #{@@target} to "
        print Rainbow(	     "[ #{@@stand[1]} , #{@@stand[2]} ]").orange	
        print ".\n\n"	
    end
    def redirect_movement
        puts "	   - The #{@@target}ern way is blocked."
        puts "	     One page passes in vain.\n\n"
        activated_barrier
    end
    def print_options
        compass.each_with_index do |direction, index|
            print Rainbow(direction).orange
            print ", " unless index.eql?(compass.size - 1)
            print Rainbow("or ").white if index.eql?(compass.size - 2)
        end
    end
    def cartesian_error
        print "	   - Move one adjacent tile using\n"
        print "	     "
        print_options
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
        print Rainbow(" -   ???   - ").blue.bright
		print_hearts_meter
		print Rainbow(" -     ]").blue.bright 		
		print Rainbow("\n---------------------------------------------------------\n\n\n").blue.bright
    end
    def print_spirit_meter
        print "SPIRIT "
		@@souls = [@@souls, 4].min
		@@souls.times { print Rainbow("??? ").orange }
		(4 - @@souls).times { print Rainbow("??? ").cyan }
    end
    def print_hearts_meter
        print "HEARTS "
		@@heart = [@@heart, 4].min
		if @@heart > 1
		@@heart.times { print Rainbow("??? ").red }
		else 
            print Rainbow("??? ").red.blink
		end
		(4 - @@heart).times { print Rainbow("??? ").cyan }
    end
	def tutorial
		if MOVES.flatten.none?(@@action) || (@@target.eql?(@@action))
			return if (MOVES[13] | MOVES[0]).include?(@@target)
			@@state = :backdrop	
			print "	   - A page passes in vain. View\n"
			print "	     tutorial with command" 
            print Rainbow(" help").cyan + ".\n\n"
		end
	end
    def no_target
        return if @@target.eql?(@@action)
        return if @@state.eql?(:backdrop)
        return if @@sight.include?(@@target)
        puts "	   - If it exists, it isn't here."
        puts "	     To view your inventory, open"
        puts "	     your knapsack.\n\n"
    end
	def help_menu
		if MOVES[13].include?(@@action)																																
			@@pages -= 1																	
			puts "	   - Speak your move plainly in a"  													
			puts "	     few short words, referencing"														
			puts "	     just one subject per page.\n\n"
			puts Rainbow("	     Check the area.").blue
			puts Rainbow("	     Talk to the wizard.").indigo
			puts Rainbow("	     Unlock the door.").maroon
			puts Rainbow("	     Take the sword.").red
			puts Rainbow("	     View my inventory.").orange
			puts Rainbow("	     Eat some bread.").green
			puts Rainbow("	     Walk south.").cyan
			puts Rainbow("	     Unlock the door.").blue
			puts Rainbow("	     Check my stats.\n").indigo											
			puts "	   - Pause to view your current"
			print "	     position by pressing " 
			print Rainbow("return").cyan + ".\n\n"
		end
    end
	def page_bottom	
		puts "\n\n\n"
        z = @@stand[0]																				
		x = @@stand[1]																				
		y = @@stand[2]	
		bigmap = [
			[[z, x - 1, y + 1], [z, x, y + 1], [z, x + 1, y + 1]],
			[[z, x - 1, y], [z, x, y], [z, x + 1, y]],
			[[z, x - 1, y - 1], [z, x, y - 1], [z, x + 1, y - 1]]
		  ]
		bigmap.each do |row|
			print "   "
			row.each do |pos|
				if pos.eql?(@@stand)
					print Rainbow("??? ").red.blink
				elsif @@world.include?(pos)
					print Rainbow("??? ").green
				else 
                    print "??? "
				end
			end
			print "\n" if row != bigmap.last
		end	
        (37 - @@pages.to_s.length).times { print(" ") }
		print Rainbow("- Pg. #{@@pages} -\n\n").purple									
	end	
end

