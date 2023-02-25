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
            :attack => 1
            :defense => 0,
            :hyper => 0,
            :fuzzy => 0,
            :weird => 0, 
            :blessed => 0,
            :cursed => 0,
            :arrows => 0,     # experience level / base chance out of 10 to land in battle
            :blades => 0,     # experience level / base chance out of 10 to land in battle
            :magick => 0,     # experience level / base chance out of 10 to land in battle
            :speech => 0      # experience level / base chance out of 10 to land in battle
        }
    end
    def action_select
        print Rainbow("\n  What next?").cyan.bright
        print Rainbow("  >>  ").purple.bright	
        process_input
        play = MOVES[1..12].flatten.include?(@@action)
        play.eql?(true) and @@state = :engage 
        print "\n\n\n\n" 
    end	
    def process_input	
        @@action = gets.chomp.downcase.gsub(/[[:punct:]]/, '')									
        sentence = @@action.split(' ')
        @@action = (MOVES.flatten & (sentence)).join('')
        @@target = (sentence - PARTS).last 
    end	
    def turn_page
        @@sight.clear 
        @@pages += 1 
        @@state = :backdrop    
        @@stats.each_with_index do |(key, value), index|
            next unless (2..5).include?(index)
            @@stats[key] -= 1 if value > 0
        end
    end
end


############################################################################################################################################################################################################################################################## 
#####    MOVEMENT    #########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Position < Gameboard
    def compass 
        ["north","south","east","west"]
    end
    def navigate
        return if MOVES[0].none?(@@action)
        @@sight = @@sight | compass
        if compass.include?(@@target)
            reposition 
        else cartesian_error
        end  
    end	
    def reposition
        coord = {
            compass[0] => [0, 1],
            compass[1] => [0,-1],
            compass[2] => [1, 0],
            compass[3] => [-1,0]
        }
        delta = coord[@@target]
        @@stand[1] += delta[0]
        @@stand[2] += delta[1]
        if @@world.include?(@@stand)
            print "	   - You move #{@@target} to "
            print Rainbow(	     "[ #{@@stand[1]} , #{@@stand[2]} ]").orange	
            print ".\n\n"												
        else puts "	   - The #{@@target}ern way is blocked."
            puts "	     One page passes in vain.\n\n"
            @@stand[1] -= delta[0]
            @@stand[2] -= delta[1]
        end   
    end
    def cartesian_error
        print "	   - Move one adjacent tile using\n"
        print "	     "
        compass.each_with_index do |direction, index|
            print Rainbow(direction).orange
            print ", " unless index.eql?(compass.size - 1)
            print Rainbow("or ").white if index.eql?(compass.size - 2)
        end
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
		@@souls = [@@souls, 4].min
		@@souls.times { print Rainbow("■ ").orange }
		(4 - @@souls).times { print Rainbow("■ ").cyan }
    end
    def print_hearts_meter
        print "HEARTS "
		@@heart = [@@heart, 4].min
		if @@heart > 1
		@@heart.times { print Rainbow("♥ ").red }
		else print Rainbow("♥ ").red.blink
		end
		(4 - @@heart).times { print Rainbow("♥ ").cyan }
    end
	def tutorial
		if MOVES.flatten.none?(@@action) || (@@target.eql?(@@action))
			return if (MOVES[13] | MOVES[0]).include?(@@target)
			@@state = :backdrop		
			@@pages -= 1	
			print "	   - You pause for one page. View\n"
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
			puts Rainbow("	     Look around the room.").red
			puts Rainbow("	     Speak to the wizard.").orange
			puts Rainbow("	     Fight the goblin.").green
			puts Rainbow("	     Take the sword.").blue
			puts Rainbow("	     View my items.").indigo
			puts Rainbow("	     Eat some bread.").maroon
			puts Rainbow("	     Walk south.").red
			puts Rainbow("	     Unlock the door.").orange
			puts Rainbow("	     Check my stats.\n").green											
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
					print Rainbow("■ ").red.blink
				elsif @@world.include?(pos)
					print Rainbow("■ ").green
				else print "⬚ "
				end
			end
			print "\n" if row != bigmap.last
		end	
        (37 - @@pages.to_s.length).times { print(" ") }
		print Rainbow("- Pg. #{@@pages} -\n\n").purple									
	end	
end

