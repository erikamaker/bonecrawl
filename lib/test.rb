
##############################################################################################################################################################################################################################################################
#####    DEPENDENCIES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'renderer'
require_relative 'board'
require_relative 'gamepiece'
require_relative 'presets'
require_relative 'player'


##############################################################################################################################################################################################################################################################
#####    GAME START    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


print "\e[8;40;57t"
pl1 = Player.new


##############################################################################################################################################################################################################################################################
#####    LEVEL 1    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


room_1 = Dungeon.new(pl1)
room_1.location = [[0,1,1],[0,1,2],[0,2,1],[0,2,2]]
def room_1.overview
  puts "	   - By the glow of one northeast"
  puts "	     torch, you glance around. A"
  puts "	     crude stone toilet hangs out"
  puts "	     of the southwest corner near"
  puts "	     your cell's only exit.\n\n"
end

lighter = Lighter.new(pl1)
lighter.location = [[0,1,2]]


drain_1 = Toilet.new(pl1)
drain_1.location =  [[0,1,1]]
drain_1.content = Lockpick.new(pl1)


hall_1 = Corridor.new(pl1)
hall_1.location = [[0,2,0],[0,2,-1],[0,2,-2]]
def hall_1.overview
  puts "	   - It's a narrow corridor south"
  puts "	     of your cell. A faint clang"
  puts "	     of metal striking metal can"
  puts "	     be heard to the southeast.\n\n"
end

door_1 = Door.new(pl1)
door_1.location = [[0,2,1]]
door_1.content = hall_1

hook_1 = Hook.new(pl1)
hook_1.location = [[0,2,0]]

hoodie_1 = Hoodie.new(pl1)
hoodie_1.location = [[0,2,0]]
def hoodie_1.draw_backdrop
    puts "	   - A black hoodie hangs from it.\n\n"
end

torch_1 = Torch.new(pl1)
torch_1.location = [[0,2,2]]

room_2 = Dungeon.new(pl1)
room_2.location = [[0,1,-3],[0,2,-3],[0,3,-3],[0,1,-4],[0,2,-4],[0,3,-4],[0,1,-5],[0,2,-5],[0,3,-5]]
def room_2.draw_backdrop
    puts "	   - You're in a homely guardroom."
    puts "	     It's warm, well-lit, and dry.\n\n"
end
def room_2.overview
    puts "	   - It's a cozy supply room where"
    puts "	     goblin guards eat and prepare"
    puts "	     to hunt. A warm fire roars in"
    puts "	     the western wall. A big table"
    puts "	     is set in the center.\n\n"
end

hellion_1 = Hellion.new(pl1)
hellion_1.location = [[0,2,-1]]
def hellion_1.unique_bartering_script
  puts "	   - It asks if it can have yours,"
  print "	     in exchange for a secret.\n\n"
end
hellion_1.territory = hall_1.location | room_2.location


chest_1 = Chest.new(pl1)
chest_1.location = [[0,5,-4]]
chest_1.content = Knife1.new(pl1)


pull_1 = Lever.new(pl1)
pull_1.location = [[0,3,-3]]
pull_1.content = chest_1
def pull_1.reveal_secret
    puts Rainbow("	   - Something heavy crashes east").cyan
    print Rainbow("	     of the warm supply room.").cyan
    print " For\n"
    puts "	     a moment, your ears ring and"
    puts "	     your heart races.\n\n"
    puts "	   - But, if it really had been a"
    puts "	     goblin, you would already be"
    puts "	     hung on that rusty hook back"
    puts "	     outside your cell door.\n\n"
end


door_2 = Door.new(pl1)
door_2.location = [[0,2,-2]]
door_2.content = room_2

grease = Fat.new(pl1)
grease.location = [[0,1,-4]]

table_1 = Table.new(pl1)
table_1.location = [[0,2,-4]]

bread_1 = Bread.new(pl1)
bread_1.location =  [[0,2,-4]]


hall_2 = Corridor.new(pl1)
hall_2.location = [[0,4,-4],[0,5,-4],[0,6,-4]]
def hall_2.overview
    puts "	   - It's a narrow hallway east of"
    puts "	     of the goblin supply chamber."
    puts "	     The clanging grows louder.\n\n"
end

door_3 = Door.new(pl1)
door_3.location = [[0,3,-4]]
door_3.content = hall_2

pick_1 = Lockpick.new(pl1)
pick_1.location = [[0,4,-4]]


tree = AppleTree.new(pl1)
tree.location = [[0,6,-4]]


apples = AppleSpawner.new(pl1)
apples.location = [[0,6,-4]]

fire_1 = Fireplace.new(pl1)
fire_1.location = [[0,1,-4]]





##############################################################################################################################################################################################################################################################
#####    GAME LOOP     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################

levels = [ room_1, drain_1, lighter, door_1, hook_1, hoodie_1, door_2, hellion_1, door_3, tree, apples, torch_1, pull_1, table_1, bread_1, grease, pick_1, fire_1 ]



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