##############################################################################################################################################################################################################################################################
#####    DEPENDENCIES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require 'rainbow'
require './vocabulary.rb'
require './gameboard.rb'
require './gamepiece.rb'
require './presets.rb'


##############################################################################################################################################################################################################################################################
#####    GAME START    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


print "\e[8;40;57t"
console = Interface.new
player = Gameboard.new
location = Position.new
rucksack = Inventory.new
stats = Identification.new


##############################################################################################################################################################################################################################################################
#####    LEVEL 1    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


cpu1 = Hellion.new
cpu1.minimap = [[0,1,2]]
def cpu1.unique_bartering_script
    puts "	   - It asks if it can have yours,"
    print "	     in exchange for a secret.\n\n"
end


room_1 = Dungeon.new
room_1.minimap = [[0,1,1],[0,1,2],[0,2,1],[0,2,2]]
def room_1.overview
    puts "	   - By the glow of one northeast"
    puts "	     torch, you glance around. A"
    puts "	     crude stone toilet hangs out"
    puts "	     of the southwest corner near"
    puts "	     your cell's only exit.\n\n"
end


torch_1 = Torch.new
torch_1.minimap = [[0,2,2],[0,2,-1],[0,5,-4]]


drain_1 = Toilet.new
drain_1.minimap = [[0,1,1]]
drain_1.content = Lockpick.new


hall_1 = Corridor.new
hall_1.minimap = [[0,2,0],[0,2,-1],[0,2,-2]]
def hall_1.overview
    puts "	   - It's a narrow corridor south"
    puts "	     of your cell. A faint clang"
    puts "	     of metal striking metal can"
    puts "	     be heard to the southeast.\n\n"
end


door_1 = Door.new
door_1.minimap = [[0,2,1]]
door_1.content = hall_1


hook_1 = Hook.new
hook_1.minimap = [[0,2,0]]


key_1 = Key.new
key_1.minimap = [[0,2,0]]
def key_1.draw_backdrop
    puts "	   - A brass key dangles from it.\n\n"
end


room_2 = Dungeon.new
room_2.minimap = [[0,1,-3],[0,2,-3],[0,3,-3],[0,1,-4],[0,2,-4],[0,3,-4],[0,1,-5],[0,2,-5],[0,3,-5]]
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


chest_1 = Chest.new
chest_1.minimap = [[0,5,-4]]
chest_1.content = Knife3.new


pull_1 = Lever.new
pull_1.minimap = [[0,3,-3]]
pull_1.content = chest_1
def pull_1.reveal_secret
    puts Rainbow("	   - Something heavy crashes east").orange
    print Rainbow("	     of the warm supply room.").orange
    print " For\n"
    puts "	     a moment, your ears ring and"
    puts "	     your heart races.\n\n"
    puts "	   - But, if it really had been a"
    puts "	     goblin, you would already be"
    puts "	     hung on that rusty hook back"
    puts "	     outside your cell door.\n\n"
end


door_2 = Door.new
door_2.minimap = [[0,2,-2]]
door_2.content = room_2


table_1 = Table.new
table_1.minimap = [[0,2,-4]]


food_1 = Apple.new
food_1.minimap = [[0,2,-4]]


hall_2 = Corridor.new
hall_2.minimap = [[0,4,-4],[0,5,-4],[0,6,-4]]
def hall_2.overview
    puts "	   - It's a narrow hallway east of"
    puts "	     of the goblin supply chamber."
    puts "	     The clanging grows louder.\n\n"
end


door_3 = Door.new
door_3.minimap = [[0,3,-4]]
door_3.content = hall_2


pick_1 = Lockpick.new
pick_1.minimap = [[0,4,-4]]


drug_1 = RedFlower.new
drug_1.minimap = [[0,2,1]]


lighter = Lighter.new
lighter.minimap = [[0,1,2]]


grease = Fat.new
grease.minimap = [[0,1,2]]


tree = AppleTree.new
tree.minimap = [[0,6,-4]]


apples = AppleSpawner.new
apples.minimap = [[0,6,-4]]


levels = [ room_1, drain_1, lighter, grease, door_1, hook_1, key_1, door_2, cpu1, door_3, tree, apples, torch_1, pull_1, table_1, food_1, pick_1, drug_1 ]


##############################################################################################################################################################################################################################################################
#####    GAME LOOP     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



loop do



    player.action_select
    system("clear")  # Clear the screen
    print Rainbow("\n---------------------------------------------------------\n").blue.bright
    print Rainbow("[").blue.bright
    print Rainbow("         - BONE CRAWL / ERIKA MAKER / 2019 © -         ").violet
    print Rainbow("]").blue.bright
    print Rainbow("\n---------------------------------------------------------").blue.bright
    print "\n\n\n\n\n"
    console.tutorial_screen
    console.suggest_tutorial
    location.detect_movement
    levels.each { |piece| piece.assemble }
    rucksack.assemble
    console.no_target
    console.game_over
    console.page_bottom

    console.page_top

   # console.page_bottom
    console.turn_page


  end


