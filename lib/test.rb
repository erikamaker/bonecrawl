
##############################################################################################################################################################################################################################################################
#####    DEPENDENCIES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'vocabulary'
require_relative 'interface'
require_relative 'board'
require_relative 'sound'
require_relative 'gamepiece'
require_relative 'presets'
require_relative 'player'
# Sets the size of the terminal window.
print "\e[8;40;57t"


##############################################################################################################################################################################################################################################################
#####    LEVEL 1    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


# Adds each gamepiece and its unique qualities to record. Make your pieces tell a story.
# Portable items (loot) will display in list form following all room or fixture backdrop displays.


room_1 = Dungeon.new
room_1.location = [[0,1,1],[0,1,2],[0,2,1],[0,2,2]]
def room_1.overview
  puts "	   - By the glow of one northeast"
  puts "	     torch, you glance around. A"
  puts "	     crude stone toilet hangs out"
  puts "	     of the southwest corner near"
  puts "	     your cell's only exit.\n\n"
end

cane = Cane.new
cane.location = [[0,1,1]]
def cane.display_position
    puts "in the corner."
end

lighter = Lighter.new
lighter.location = [[0,1,1]]
def lighter.display_position
    puts "on the floor."
end

drain_1 = Toilet.new
drain_1.location =  [[0,1,1]]
drain_1.content = Lockpick.new

hall_1 = Corridor.new
hall_1.location = [[0,2,0],[0,2,-1],[0,2,-2]]
def hall_1.overview
  puts "	   - It's a narrow corridor south"
  puts "	     of your cell. A faint clang"
  puts "	     of metal striking metal can"
  puts "	     be heard to the southeast.\n\n"
end

door_1 = Door.new
door_1.location = [[0,2,1]]
door_1.content = hall_1

hook_1 = Hook.new
hook_1.location = [[0,2,0]]

hoodie_1 = Hoodie.new
hoodie_1.location = [[0,2,0]]
def hoodie_1.display_position
    puts "hangs from the hook."
end

room_2 = Dungeon.new
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

hellion_1 = Hellion.new
hellion_1.location = [[0,2,-1]]
hellion_1.regions = hall_1.location | room_2.location
def hellion_1.unique_bartering_script
  puts "	   - It asks if it can have yours,"
  print "	     in exchange for a secret.\n\n"
end
def hellion_1.reward_animation
  puts "	   - The hellion lowers its voice."
  puts "	     It barely whispers a rumor...\n\n"
  puts Rainbow("	   \" There's a third cell lost to").green
  puts Rainbow("	     the ages on this floor. \"\n").green
end
def hellion_1.default_script
  puts "	   - It leers at you, dark pupils"
  puts "	     flexing in its yellow eyes."
  puts "	     It says it lost its lighter.\n\n"
end
def hellion_1.passive_script
  puts "	   - It says this place isn't all"
  puts "	     that it seems. Be vigilant.\n\n"
end

chest_1 = Chest.new
chest_1.location = [[0,5,-4]]
chest_1.content = Knife.new

pull_1 = Lever.new
pull_1.location = [[0,3,-3]]
pull_1.content = chest_1
def pull_1.reveal_secret
  SoundBoard.secret_music
  puts Rainbow("	   - Something heavy crashes east").cyan
  print Rainbow("	     of the warm supply room.").cyan
  print " For\n"
  puts "	     a moment, your ears ring and"
  puts "	     your heart races.\n\n"
end

door_2 = Door.new
door_2.location = [[0,2,-2]]
door_2.content = room_2

table_1 = Table.new
table_1.location = [[0,2,-4]]

bread_1 = Bread.new
bread_1.location =  [[0,2,-4]]

hall_2 = Corridor.new
hall_2.location = [[0,4,-4],[0,5,-4],[0,6,-4]]
def hall_2.overview
  puts "	   - It's a narrow hallway east of"
  puts "	     of the goblin supply chamber."
  puts "	     The clanging grows louder.\n\n"
end

door_3 = Door.new
door_3.location = [[0,3,-4]]
door_3.content = hall_2

pick_1 = Lockpick.new
pick_1.location = [[0,4,-4]]

fire_1 = Fireplace.new
fire_1.location = [[0,1,-4]]

tree = AppleTree.new
tree.location = [[0,6,-4]]

altar = Altar.new
altar.location = [[0,1,2]]
altar.bone = Femur
def altar.level_complete_screen
    print "\e[?25l"
    system("clear")  # Clear the screen
    print "\n\n\n\n\n\n\n\n"
    sleep 2
    print Rainbow("	   - Your vision begins to fade.\n").violet
    print Rainbow("	     You're gently lifted away.\n\n").violet
    sleep 3
    print Rainbow("	   - But as you go, a whisper in\n").violet
    print Rainbow("	     your ear begin to grow.\n\n").violet
    sleep 3
    system("clear")  # Clear the screen
    sleep 3
    print Rainbow("\n\n\n\n\n\n\n\n	   \" You cannot outpace my abyss.\n" ).red.bright
    sleep 3
    print Rainbow("	     See you in Level 2, lamby. \" \n\n\n\n\n\n\n " ).red.bright
    sleep 3
    print Rainbow("\n---------------------------------------------------------").blue.bright
    exit!
end


femur = Femur.new

fat1 = Fat.new
fat1.location = [[0,2,2]]
def fat1.display_position
    puts "sulks on the floor."
end

secret_room = Corridor.new
secret_room.location = [[0,3,2],[0,4,2],[0,5,2]]


torch_1 = Torch.new
torch_1.location = [[0,2,2]]
torch_1.douse_torch
torch_1.content = secret_room
def torch_1.reveal_secret
    SoundBoard.secret_music
    SoundBoard.wall_reveal
    puts Rainbow("	   - The eastern wall rumbles and").cyan
    puts Rainbow("	     recedes to reveal a new path.").cyan
    puts Rainbow("	     Your map has been updated.\n").cyan
    content.activate
end

gold = Gold.new
gold.location = [[0,2,1]]
def gold.display_position
    puts "sits at your feet."
end

flower = RedFlower.new
flower.location = [[0,2,1]]
def flower.display_position
    puts "grows here."
end

juice = Juice.new
juice.location = [[0,2,1]]
def juice.display_position
    puts "sits on the floor."
end

wizard = Wizard.new
wizard.location = [[0,2,2]]
wizard.regions = hall_1.location | room_2.location | room_1.location

def wizard.unique_bartering_script
  puts "	   - He requests your gold. It's"
  print "	     very important he have it.\n\n"
end
def wizard.reward_animation
  puts "	   - The wizard whispers in your"
  print "	     ear, "
  print Rainbow("\'Luck be with you.\'\n\n").green
end
def wizard.default_script
  puts "	   - He says the dungeon stinks."
  puts "	     He's looking for a way out.\n\n"
end
def wizard.passive_script
  puts "	   - He says if you're ever lost,"
  puts "	     to always follow your nose.\n\n"
end

def open_scene
    system("clear")  # Clear the screen
    print "\e[?25l"
    print "\n\n\n\n\n\n\n\n"
    sleep 2
    print Rainbow("	   - You wake up with a headache\n").violet
    print Rainbow("	     on the cold, hard floor.\n\n").violet
    sleep 3
    Board.player.reset_input
    Board.player.page_bottom
    Board.player.page_top
    Board.player.turn_page
end


##############################################################################################################################################################################################################################################################
#####    GAME LOOP     #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


rooms = [ room_1, door_1, door_2, door_3 ]
fixtures = [ torch_1, wizard, altar, drain_1, hook_1, hellion_1, pull_1, table_1, fire_1, tree ]
items = [ cane, juice, flower, gold, lighter, fat1, hoodie_1, bread_1, pick_1 ]

loop do
  print "\e[?25h"
  Board.player.action_select
  system("clear")
  Board.player.header
  Board.player.detect_movement
  Board.player.suggest_tutorial
  Board.player.tutorial_screen
  Board.player.stats_screen

  rooms.each { |room| room.activate}
  fixtures.each { |fixture| fixture.activate }
  if items.any? { |item| item.location.include?(Board.player.position) }
    Board.player.present_list_of_loot
    items.each { |item| item.activate }
    print "\n"
  end

  Board.player.load_inventory
  Board.player.target_does_not_exist
  Board.player.game_over
  Board.player.turn_page
  Board.player.page_top
  Board.player.page_bottom
end




# TODO: apple in bag at end of test run showed zero portions, was edible. investigate. might have been the apple given by hellion or one of 3 apples on tree.

# first took an apple from tree, then took another, then tried to eat what wasn't there, then viewed what wasn't there. ate apple during battle throughout.