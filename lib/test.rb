
require_relative 'vocabulary'
require_relative 'renderer'
require_relative 'board'
require_relative 'gamepiece'
require_relative 'presets'
require_relative 'player'


print "\e[8;40;57t"
pl1 = Player.new
pick_1 = Lockpick.new(pl1)
bread = Bread.new(pl1)
flower = RedFlower.new(pl1)
room_1 = Dungeon.new(pl1)
room_1.location = [[-1,0,2],[-1,0,1],[-1,1,1],[-1,1,2]]
def room_1.overview
  puts "	   - By the glow of one northeast"
  puts "	     torch, you glance around. A"
  puts "	     crude stone toilet hangs out"
  puts "	     of the southwest corner near"
  puts "	     your cell's only exit.\n\n"
end

cpu1 = Hellion.new(pl1)
cpu1.location = [[-1,1,2]]
def cpu1.unique_bartering_script
  puts "	   - It asks if it can have yours,"
  print "	     in exchange for a secret.\n\n"
end

hall_1 = Corridor.new(pl1)
hall_1.location = [[-1,1,0],[-1,1,-1],[-1,1,-2]]
def hall_1.overview
  puts "	   - It's a narrow corridor south"
  puts "	     of your cell. A faint clang"
  puts "	     of metal striking metal can"
  puts "	     be heard to the southeast.\n\n"
end


door_1 = Door.new(pl1)
door_1.location = [[-1,1,1]]
door_1.content = hall_1


##############################################################################################################################################################################################################################################################
#####    GAME LOOP     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



levels = [ room_1, door_1, cpu1, pick_1, bread, flower]


loop do
  pl1.action_select
  system("clear")  # Clear the screen
  pl1.header
  pl1.detect_movement
  pl1.tutorial_screen
  pl1.suggest_tutorial
  levels.each { |piece| piece.assemble }
  pl1.load_inventory
  pl1.no_target
  pl1.game_over
  pl1.reset_input
  pl1.page_bottom
  pl1.page_top
  pl1.turn_page
end