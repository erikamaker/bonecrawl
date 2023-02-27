############################################################################################################################################################################################################################################################## 
#####    ABOUT    ############################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


# Copyright Erika Maker  / 'Bone Crawl' © 2019 (www.bonecrawl.com).
# Desktop demo of rogue-like text adventure engine, and accompanying test level.
# Intended use: game engine for creating game content on PC and mobile platforms. 


############################################################################################################################################################################################################################################################## 
#####    DEPENDENCIES    #####################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


print "\e[8;57;57t"					
require 'rainbow'
require './vocabulary.rb' 
require './gameboard.rb'         
require './gamepiece.rb'
require './fixtures.rb'
require './materials.rb'
require './tools.rb'
require './weapons.rb'
require './ingestibles.rb'
require './substances.rb'
require './containers.rb'
require './pullables.rb'


############################################################################################################################################################################################################################################################## 
#####    GAME START    #######################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


console = Interface.new
player = Gameboard.new
coordinate = Position.new
knapsack = Knapsack.new
stats = StatsCard.new


############################################################################################################################################################################################################################################################## 
#####    LEVEL 1    ##########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


room_1 = Dungeon.new                                          # Starting room. This is the only time a Tiles instance isn't the content of some portal (like a door).
room_1.minimap = [[0,1,1],[0,1,2],[0,2,1],[0,2,2]]            # Give the room a 2D array of coordinates: [[ Z for the elevation, X for east/west, and Y for north/south. ]]
def room_1.overview                                           # Will execute when player "views" the "area", and also displays once when uncovered (e.g. opening a door).
    puts "	   - By the glow of one northeast"                # Convention is to describe un-alterable fixtures, as gameplay can alter other objects (e.g. taking something).
    puts "	     torch, you glance around. A"                 # In the parent class Tiles, invoking this method will reset the Gameboard's play state to :backdrop. 
    puts "	     crude stone toilet hangs out"                # A state of :backdrop means that the object's main display (not interaction text) is displayed, as if it is
    puts "	     of the southwest corner near"                # in the player's backdrop. When this method is evoked, we start at 1.) :interaction (i.e. "look around", 
    puts "	     your cell's only exit.\n\n"                  # causing the left text to display), then we move to 2.) :backdrop within the same page. This lets us see
end                                                           # the backdrop of any standalone object at the player's location in addition to the overview. Test it to see. 

torch_1 = Torch.new                                           # An example of a fixture. Nothing can be done TO it, though presence of "fire" unlocks certain abilities. 
torch_1.minimap = [[0,2,2],[0,2,-1],[0,5,-4]]                 # Since they cannot be removed, we can create a number of them throughout the level in one line like so.  

drain_1 = Toilet.new                                          # An example of a container. They can be opened, or viewed. Test both actions against it to see.  
drain_1.minimap = [[0,1,1]]                                   # Single coordinates are still 2D arrays (parent class checks if the player's current coordinate is WITHIN it). 
drain_1.content = Lockpick.new                                # The container's content must be a Portable instance, since Container's `give_content` method invokes `take`. 

hall_1 = Corridor.new                                         # The first of every other room in the game that is destined to be either a Door, or some other portal's content. 
hall_1.minimap = [[0,2,0],[0,2,-1],[0,2,-2]]                  # Define it just ilke room_1 above. Give it coordinates with double brackets, and provide an overview. There 
def hall_1.overview                                           # are presets like Dungeon and Corridor, but following their format to create new ones is very easy! 
    puts "	   - It's a narrow corridor south"                # Remember, overviews should only include things that won't ever change. This means I've intentionally made
    puts "	     of your cell. A faint clang"                 # a "faint clang" that will always be present in the game for one reason or another. Maybe there's a machine
    puts "	     of metal striking metal can"                 # in another room that's a Fixture instance, or maybe someone is always welding. Totally up to the author. 
    puts "	     be heard to the east.\n\n"
end

door_1 = Door.new                                             # This is the Door instance that will contain hall_1. See below. 
door_1.minimap = [[0,2,1]]                                    # Important note: every gamepiece you make will need its own minimap of coordinates. 
door_1.content = hall_1

hook_1 = Hook.new                                             # Another fixture for world-building. Like Tiles, player can only "view" it. Its backdrop can be found in the
hook_1.minimap = [[0,2,0]]                                    # Fixtures file. Hanging things on a hook is easy (we don't even need to assign any content), just follow below: 

key_1 = Key.new                                               # Our first standalone Portable (Tool < Key). It is able to unlock any latch, but only once. This particular one
key_1.minimap = [[0,2,0]]                                     # redefines the main Key's `backdrop` method. This backdrop, following Hook's above, makes it appear to hang from the hook.
def key_1.backdrop                                            # Stand at the coordinate [[0,2,0]] in-game to see how they appear in order! This also works for other fixtures, like
    puts "	   - A brass key dangles from it.\n\n"            # surfaces (e.g. tables, shelves, etcetera).
end

room_2 = Dungeon.new
room_2.minimap = [[0,1,-3],[0,2,-3],[0,3,-3],[0,1,-4],[0,2,-4],[0,3,-4],[0,1,-5],[0,2,-5],[0,3,-5]]
def room_2.backdrop                                           # You might find that the preset for some rooms (Dungeon, in this case) isn't appropriate for the world you're
    puts "	   - You're in a homely guardroom."               # building, but you still want it to be part of the brick Dungeon type terrain. Redefine the backdrop like this. 
    puts "	     It's warm, well-lit, and dry.\n\n"           # We didn't define the first backdrop for room_1 because, unlike room_2, it uses the preset in Fixtures (see: Tiles).
end
def room_2.overview                                           # Still, the overview should follow normal conventions. Only permanent fixtures. At this point, we can focus on more
    puts "	   - It's a cozy supply room where"               # interesting objects than exits (room_1 had very little interesting features, and it encourages the player to leave).
    puts "	     goblin guards eat and prepare"               # The player, at this point, should feel naturally inclined to search each coordinate, and will find doors there. 
    puts "	     to hunt. A warm fire roars in"
    puts "	     the western wall. A big table"
    puts "	     is set in the center.\n\n"
end

chest_1 = Chest.new                                           # Another container. This one contains a weapon, which is part of the Tool class (a Portable subclass). Like the toilet
chest_1.minimap = [[0,5,-4]]                                  # and lockpick combo above, opening the container will invoke the "take" command on the content. Worth noting: when taking
chest_1.content = Knife1.new                                  # any portable object, a brief profile of info about it will display before alerting the player that they've received it. 

pull_1 = Lever.new                                            # A lever works very much like a container, with one distinction: the content that they contain can be portable objects
pull_1.minimap = [[0,3,-3]]                                   # that appear over great distances (e.g. something falls from above), or an event (e.g. gate or a door opens, revealing new
pull_1.content = chest_1                                      # areas to explore). In this case, the chest that contains the knife above is dropped into existance at [[0,5,-4]].
def pull_1.reveal_secret													
    puts Rainbow("	   - Something heavy crashes east").orange	# The convention is to make the discovery orange. In *ahem* some *ahem* games, a phrase of music might play when secrets
    print Rainbow("	     of the warm supply room.").orange    # are uncovered. The author can decide how that secret is unveiled. I choose to make a vague hint to encourage exploration. 
    print " For\n"			
    puts "	     a moment, your ears ring and"                # And, a little more world-building to help paint the game's story. Here, we're exposing some more information about goblins.  
    puts "	     your heart races.\n\n"                       # We haven't encountered any yet, and it's good to build anticipation before their interaction. Now we know they're violent.
    puts "	   - But, if it really had been a"                # But, anyone who knows anything about goblins knows this. 
    puts "	     goblin, you would already be"
    puts "	     hung on that rusty hook back" 
    puts "	     outside your cell door.\n\n"
end 

door_2 = Door.new                                             # This door feeds hall_1 into room_2, which we have defined as the content below.  
door_2.minimap = [[0,2,-2]]
door_2.content = room_2

table_1 = Table.new                                           # Another fixture. 
table_1.minimap = [[0,2,-4]]

food_1 = Apple.new                                            # This is a subclass of an Ingestible class (subclass of Portable). These can be taken or eaten. 
food_1.minimap = [[0,2,-4]]                                   # The preset backdrop for an Apple instance already makes it seem to sit on the table above. 

hall_2 = Corridor.new                                         # Another hall, this one being the content of door_3 (see below).
hall_2.minimap = [[0,4,-4],[0,5,-4],[0,6,-4]]
def hall_2.overview                                           # Unique `overview` display (redefining the preset to tell a story).
    puts "	   - It's a narrow hallway east of" 
    puts "	     of the goblin supply chamber."
    puts "	     The clanging grows louder.\n\n"
end

door_3 = Door.new                                             # A third door. This one contains hall_2 above. 
door_3.minimap = [[0,3,-4]]
door_3.content = hall_2

pick_1 = Lockpick.new                                         # Random Lockpick (Tool < Portable).
pick_1.minimap = [[0,4,-4]]

drug_1 = Crystal.new                                          # A substance. This is combustible. If a player tries to "burn" it in the presence of a flame,
drug_1.minimap = [[0,2,1]]                                    # like a torch, or a Portable lighter, it will activate a special property that affects stats. 

gem_1 = Pink.new                                              # Not to be confused with a Crystal, a Gem has magickal properties and can be used to make a staff. 
gem_1.minimap = [[0,1,2]]


lighter = Lighter.new
lighter.minimap = [[0,1,2]]

grease = WormFat.new
grease.minimap = [[0,1,1]]

tree = Tree.new
tree.minimap = [[0,1,1]]

level_1 = [ room_1, drain_1, lighter, grease, door_1, hook_1, key_1, door_2, door_3, torch_1, table_1, food_1, pull_1, pick_1, drug_1 ]


############################################################################################################################################################################################################################################################## 
#####    GAME LOOP     #######################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


loop do
    console.turn_page
    console.page_top
    player.action_select
    console.help_menu
    console.tutorial  
    coordinate.navigate     
    level_1.each { |piece| piece.assemble }
    knapsack.assemble
    stats.assemble
    console.no_target		
    console.page_bottom
end

