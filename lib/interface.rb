##############################################################################################################################################################################################################################################################
#####    INTERFACE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require 'rainbow'


module Interface
  def prompt_player
    print Rainbow("\n   What next?").cyan.bright
    print Rainbow("  >>  ").purple.bright
  end
  def action_select
    prompt_player
    process_input
    toggle_state_engaged
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
  def header
    print Rainbow("\n---------------------------------------------------------\n").blue.bright
    print Rainbow("[").blue.bright
    print Rainbow("          Bone Crawl  |  Chapter 1  |  2020 ©          ").red
    print Rainbow("]").blue.bright
    print Rainbow("\n---------------------------------------------------------").blue.bright
    print "\n\n\n\n\n"
  end
  def page_top
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
  def toggle_key_icon
    print "KEYS "
    if search_inventory([Key,Lockpick])
      print Rainbow(" ⌐0  ").orange
    else print "     "
    end
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
  def not_a_move?
    MOVES.flatten.none?(@action)
  end
  def target_equal_to_action?
    @target == @action
  end
  def nontraditional_move?
    not_a_move? || target_equal_to_action?
  end
  def tutorial_selected?
    MOVES[15].include?(@target)
  end
  def suggest_tutorial
  	if nontraditional_move?
  	  return if tutorial_selected?
  	  toggle_state_inert
  	  print "	   - A single page passes. Review\n"
  	  print "	     tutorial with command"
      print Rainbow(" help").cyan + ".\n\n"
  	end
  end
  def target_does_not_exist
    return if @target == @action
    return if @state == :inert
    if @sight.none?(@target)
      puts "	   - If it exists, it isn't here."
      puts "	     To view your inventory, open"
      puts "	     your knapsack.\n\n"
    end
  end
  def tutorial_screen
  	if tutorial_selected?
  	  puts "	   - Speak your move plainly in a"
  	  puts "	     few short words, referencing"
  	  puts "	     only one subject per page.\n\n"
  	  puts Rainbow("	     Slay the troll.").red
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
  	puts "\n\n\n"
    draw_map
    draw_page_count
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
      page_bottom
      print Rainbow("\n---------------------------------------------------------\n").red.bright
      print Rainbow("[  DEFENSE           |   HEARTS           |   KEYS      ]").red
      print Rainbow("\n---------------------------------------------------------").red.bright
      puts "\n\n\n\n\n\n"
      exit!
    end
  end
end