##############################################################################################################################################################################################################################################################
#####    INTERFACE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require 'rainbow'


module Interface
    def header
        print Rainbow("\n---------------------------------------------------------\n").blue.bright
        print Rainbow("[").blue.bright
        print Rainbow("          Bone Crawl  |  Chapter 1  |  2020 ©          ").red
        print Rainbow("]").blue.bright
        print Rainbow("\n---------------------------------------------------------").blue.bright
        print "\n\n\n\n\n"
    end
    def page_top
        puts "\n\n\n"
        draw_map
        draw_page_count
    end
    def game_map
        z = @position[0]
    	x = @position[1]
    	y = @position[2]
        [
    	    [[z, x - 1, y + 1], [z, x, y + 1], [z, x + 1, y + 1]],
    	    [[z, x - 1, y], [z, x, y], [z, x + 1, y]],
    	    [[z, x - 1, y - 1], [z, x, y - 1], [z, x + 1, y - 1]]
    	]
    end
    def map_character(pos)
        return Rainbow("■ ").red.blink if pos == @position
        return Rainbow("■ ").green if Board.world_map.include?(pos)
        "⬚ "
    end
    def draw_map
        game_map.each do |row|
            print "   "
            row.each do |pos|
                print map_character(pos)
            end
            print "\n" unless row == game_map.last
        end
    end
    def draw_page_count
        (37 - Board.page_count.to_s.length).times { print(" ") }
    	print Rainbow("- Pg. #{Board.page_count} -\n\n").purple
    end
    def page_bottom
        print Rainbow("\n---------------------------------------------------------\n").blue.bright
    	print Rainbow("[  ").blue.bright
        print_defense_meter
        print Rainbow("  |   ").blue.bright
    	print_hearts_meter
    	print Rainbow("  |   ").blue.bright
        toggle_key_icon
        print Rainbow("]").blue.bright
    	print Rainbow("\n---------------------------------------------------------\n\n").blue.bright
    end
    def print_defense_meter
        print "DEFENSE "
    	blocks = [defense, 4].min
    	blocks.times { print Rainbow("■ ").orange }
    	(4 - blocks).times { print Rainbow("■ ").cyan }
    end
    def print_hearts_meter
      print "HEARTS "
    	@health = [@health, 4].min
    	if @health > 1
    	    @health.times { print Rainbow("♥ ").red }
    	else
            print Rainbow("♥ ").red.blink
    	end
    	(4 - @health).times { print Rainbow("♥ ").cyan }
    end
    def toggle_key_icon
        print "KEYS "
        if search_inventory([Key,Lockpick])
            print Rainbow(" ⌐0  ").orange
        else print "     "
        end
    end
    def action_select
        print Rainbow("\n   What next?").cyan.bright
        print Rainbow("  >>  ").purple.bright
        process_input
        toggle_state_engaged
        print "\n\n\n\n"
    end
    def process_input
        @action = gets.chomp.downcase
        sentence = @action.scan(/[\w']+/)
        intersection = MOVES.flatten & sentence
        @action = intersection.first
        @target = (sentence - SPEECH).last
    end
    def reset_input
        @action = :reset
        @target = :reset
    end
    def nontraditional_move
        MOVES.flatten.none?(@action) || @target == @action
    end
    def navigation_move
        MOVES[0].include?(@action)
    end
    def menu_move
        MOVES[15..16].flatten.include?(@target)
    end
    def suggest_tutorial
    	if nontraditional_move
            return if navigation_move
            return if menu_move
    	    print "	   - A single page passes. Review\n"
    	    print "	     tutorial with command"
            print Rainbow(" help").cyan + ".\n\n"
    	end
    end
    def tutorial_screen
        return if MOVES[0].include?(@action)
        return if !MOVES[15].include?(@target)
        puts "	   - Speak your move plainly in a"
    	puts "	     few short words, referencing"
    	puts "	     only one subject per page.\n\n"
        puts Rainbow("	     View my stats.").orange
    	puts Rainbow("	     Fight the troll.").red
    	puts Rainbow("	     View my items.").yellow
    	puts Rainbow("	     Eat some bread.").green
    	puts Rainbow("	     Go to the west.").blue
    	puts Rainbow("	     Light the torch.\n").indigo
    	print "	   - Press "
        print Rainbow("return").cyan
    	puts " for the current"
        puts "	     coordinate's list of targets,"
        puts "	     or to quickly pass time.\n\n"
    end
    def stats_screen
        return if !MOVES[16].include?(@target)
        return if navigation_move
        if @level < 10
            title = "desicrated"
        else title = "sanctified"
        end
        puts "	   - You're a #{title} spirit,"
        if title != "santified"
            puts "	     condemned to perditiion.\n\n"
        else puts "	     cleansed for ascension.\n\n"
        end
        stats.each do |key, value|
            length = 25 - (key.to_s.length + value.to_s.length)
            dots = Rainbow(".").purple * length
            space = " " * 13
            value = value.to_s.capitalize
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        print "\n"
    end
    def target_does_not_exist
        return if @target == @action
        return if @state == :inert
        if @sight.none?(@target)
            puts "	   - If it exists, it isn't here."
            print "	     To view your inventory, "
            print Rainbow("open\n").cyan
            print Rainbow("	     your rucksack").cyan + ".\n\n"
        end
    end
    def present_list_of_loot
        cond_1 = inventory_selected
        cond_2 = MOVES[15].include?(@target)
        cond_3 = MOVES[16].include?(@target)

        cond_4 = state_engaged
        cond_5 = [cond_1, cond_2, cond_3, cond_4]
        puts Rainbow("	   - At this coordinate, you find:\n").magenta if cond_5.none?
    end
    def game_over
        if @health < 1
          sleep 2
          puts Rainbow("	   - Hearts expired, you collapse").purple
          print Rainbow("	     where you stand.\n\n").purple
          sleep 2
          puts "	   - A clamor of demons drag your"
          puts "	     spirit to its assigned cell.\n\n"
          sleep 2
          page_top
          print Rainbow("\n---------------------------------------------------------\n").red.bright
          print Rainbow("[  DEFENSE           |   HEARTS           |   KEYS      ]").red
          print Rainbow("\n---------------------------------------------------------").red.bright
          puts "\n\n\n\n\n\n"
          exit!
        end
    end
end