##############################################################################################################################################################################################################################################################
#####    PRESETS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'gamepiece'


##############################################################################################################################################################################################################################################################
#####    BRICKS    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Bricks < Tiles
  def built_of
  	["brick","bricks","block","blocks"]
  end
  def view_type
  	puts "	   - The weathered bricks look to"
  	puts "	     to be cut from solid rock.\n\n"
  end
  def view_wall
  	puts "	   - The walls are built of bricks"
  	puts "	     cobbled haphazardly together.\n\n"
  end
  def view_down
  	puts "	   - The cobbled floor is stained"
  	puts "	     with either soot or dirt.\n\n"
  end
  def view_above
  	puts "	   - The cobbled ceiling is burnt"
  	puts "	     black with torch smoke.\n\n"
  end
end

class Dungeon < Bricks
  def subtype
  	subtype = ["jail","dungeon","cell"]
  end
  def draw_backdrop
  	puts "	   - You're in a cold prison cell."
  	puts "	     It's dark and mostly empty.\n\n"
  end
end

class Corridor < Bricks
  def subtype
  	subtype = ["tunnel","corridor","hall"]
  end
  def draw_backdrop
  	puts "	   - You're in a cramped corridor"
  	puts "	     made of dark cobbled bricks.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    ROCKS    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class WarmRocks < Tiles
  def built_of
  	built_of = ["rock","rocks","geodes","earth","stone","stones"]
  end
  def view_type
  	puts "	   - The cavern walls radiate with"
  	puts "	     a pale green light somehow.\n\n"
  end
  def view_wall
  	puts "	   - The cave walls are smooth and"
  	puts "	     glimmer. They feel warm. \n\n"
  end
  def view_down
  	puts "	   - The cave floor's been eroded"
  	puts "	     smooth by the passing eons.\n\n"
  end
  def view_above
  	puts "	   - The cavern ceiling looms low"
  	puts "	     above your head.\n\n"
  end
end

class WarmCave < WarmRocks
  def subtype
  	subtype = ["cavern","cave","underground"]
  end
  def draw_backdrop
  	puts "	   - You're in an ancient cavern."
  	puts "	     It's pleasantly warm.\n\n"
  end
end

class Grotto < WarmCave
  def subtype
  	subtype = ["cave","cavern","spring","pool","sauna","grotto"]
  end
  def draw_backdrop
  	puts "	   - You're in a gleaming grotto"
  	puts "	     with a simmering spring.\n\n"
  end
  def view_above
  	puts "	   - The ceiling seems to yawn a"
  	puts "	     good 30 feet above you.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    FIRE SOURCES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Fire < Fixture
  def initialize
    super
  	@targets = subtype | ["fire","light","flame","flames"]
  end
end

class Torch < Fire
  def subtype
  	["torch", "iron torch", "black torch", "metal torch"]
  end
  def draw_backdrop
  	puts "	   - A black torch is bolted into"
  	puts "	     the wall. Its flame dances.\n\n"
  end
  def view
  	puts "	   - The red fire dances, casting"
  	puts "	     wild shadows on the walls.\n\n"
  end
end

class Fireplace < Fire
  def subtype
  	["fireplace", "grate", "coals", "coal", "hearth"]
  end
  def draw_backdrop
  	puts "	   - Hot coals smolder in an iron"
  	puts "	     grate built into of the wall.\n\n"
  end
  def view
  	puts "	   - The coals glow and crackle.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    HOOK    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hook < Fixture
  def initialize
    super
    @targets = ["hook","rusty hook","metal hook"]
  end
  def draw_backdrop
    puts "	   - A rusty hook juts out of the"
    puts "	     masonry where you stand.\n\n"
  end
  def view
    puts "	   - It looks sinister. Intuition"
    puts "	     tells you the goblins use it"
    puts "	     to hang more than just coats"
    puts "	     and keys.\n\n"
    @@player.toggle_idle
  end
end


##############################################################################################################################################################################################################################################################
#####    SURFACES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Surface < Fixture
  def initialize
    super
  	@targets = subtype | ["surface"]
  end
  def view
    subtype_view
    @@player.toggle_idle
  end
end

class Table < Surface
  def subtype
  	["table","stone table","tabletop"]
  end
  def draw_backdrop
  	puts "	   - You stand before a humungous"
  	puts "	     table cut from solid rock.\n\n"
  end
  def subtype_view
  	puts "	   - Its rocky top rises to meet"
  	puts "	     you at your neck.\n\n"
  end
end

class Shelf < Surface
  def subtype
  	["shelf","wooden shelf"]
  end
  def draw_backdrop
  	puts "	   - You stand at a wooden shelf."
  	puts "	     It's just within your reach.\n\n"
  end
  def subtype_view
    puts "	   - The wood is gnarly and blue."
  	puts "	     It's covered in scars.\n\n"
  end
end

class Grave < Surface
  def subtype
  	["grave","slab","gravestone","headstone"]
  end
  def draw_backdrop
  	puts "	   - You stand a square headstone"
  	puts "	     sticking out of the ground.\n\n"
  end
  def display_inscription
    puts "	     The inscription has eroded.\n\n"
  end
  def subtype_view
  	puts "	   - It's made of crumbling rock."
    display_inscription
  end
end


##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Lockpick < Weapon
  def initialize
    super
    @profile = {:build => "copper", :lifespan => rand(2..4), :damage => 2}
  end
  def subtype
    ["lock pick", "metal lock pick", "metal pick", "pick", "tool"]
  end
  def description
  	puts "	   - Maybe it belonged to another"
  	print "	     prisoner? It's quite sharp.\n\n"
  end
end

class Pickaxe < Weapon
  def initialize
    super
    @profile = {:build => "copper", :lifespan => rand(7..13), :damage => 3}
  end
  def subtype
    ["pickaxe","iron pickaxe"]
  end
  def description
    puts "	   - Trolls mine for precious ore"
  	puts "	     under the dungeon with these.\n\n"
  end
end

class Key < Tool
  def initialize
    super
    @profile = {:build => "brass", :lifespan => 1}
  end
  def subtype
    ["brass key", "key"]
  end
  def description
  	puts "	   - It's brittle and tarnished."
  	puts "	     It can be used just once.\n\n"
  end
end

class Lighter < Tool
  def initialize
    super
    @profile = {:build => "silver"}
  end
  def subtype
    ["silver lighter", "lighter"]
  end
  def description
  	puts "	   - It's indiscriminately fueled"
    puts "	     by grease, wax, or sap.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Knife < Weapon
  def initialize
    super
    @profile = { :build => "bone", :lifespan => rand(5..10), :damage => 2 }
  end
  def subtype
    ["knife","dagger"]
  end
  def description
    puts "	   - It's a weak dagger made from"
  	puts "	     scrapped skeleton parts.\n\n"
  end
end

class Cleaver < Weapon
  def initialize
    super
    @profile = { :build => "iron", :lifespan => rand(10..15), :damage => 3 }
  end
  def subtype
    ["cleaver", "axe","blade"]
  end
  def description
    puts "	   - It's a butcher's cleaver. It"
  	puts "	     feels heavy in your hand.\n\n"
  end
end

class Sword < Weapon
  def initialize
    super
    @profile = { :build => "silver", :lifespan => rand(15..25), :damage => 4 }
  end
  def subtype
    ["sword"]
  end
  def description
    puts "	   - It's a sturdy skeleton sword"
  	puts "	     infused with sacred silver.\n\n"
  end
end

class Staff < Weapon
  def initialize
    super
    @profile = { :build => "wood", :lifespan => rand(15..25), :damage => 4 }
  end
  def subtype
    ["staff"]
  end
  def description
    puts "	   - It's a magick staff. It can"
    puts "	     blind enemies in battle.\n\n"
  end
end

##############################################################################################################################################################################################################################################################
#####    FOOD    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Bread < Edible
  def initialize
    super
  	@profile = { :hearts => 2, :portions => 3 }
  end
  def subtype
    ["bread"]
  end
  def draw_backdrop
  	puts "	   - Some goblin bread sits here.\n\n"
  end
  def description
  	puts "	   - It's stale and burnt.\n\n"
  end
end

class Apple < Edible
  def initialize
    super
    @profile = { :hearts => 1, :portions => 3 }
  end
  def subtype
    ["apple"]
  end
  def draw_backdrop
  	puts "	   - An indigo apple sits here.\n\n"
  end
  def description
  	puts "	   - Blue apples like these tend"
    puts "	     to grow underground.\n\n"
  end
end

class Plum < Edible
  def initialize
    super
    @profile = { :hearts => 1, :portions => 4 }
  end
  def subtype
    ["plum"]
  end
  def draw_backdrop
    puts "	   - A big black plum sits here.\n\n"
  end
  def description
    puts "	   - Plums like these work well"
    puts "	     in elixers. They're edible.\n\n"
  end
end

class Mushroom < Edible
  def initialize
    super
    @profile = { :hearts => 4, :portions => 1, :effect => :entranced, :duration => 10 }
  end
  def subtype
    ["fungi","fungus","mushroom","shroom","toadstool","stool"]
  end
  def draw_backdrop
    puts "	   - A small blue mushroom blooms"
    puts "	     on the wall here.\n\n"
  end
  def description
    puts "	   - Toadstools like these induce"
    puts "	     waking dreams when eaten.\n\n"
  end
  def side_effect
    puts "	     The walls begin to breathe."
    puts "	     Colors whirl in your eyes.\n\n"
  end
end

class Flesh < Edible
  def initialize
    super
    @profile = { :hearts => 2, :portions => 2 }
  end
  def subtype
    ["jerky","meat"]
  end
  def draw_backdrop
    puts "	   - A small strip of smoked meat"
    puts "	     lays across the ground here.\n\n"
  end
  def description
    puts "	   - It's dry and salty. It might"
    puts "	     cook well with some bread.\n\n"
  end
end

class Salt < Portable
  def targets
    ["salt","seasoning","sodium","cube"]
  end
  def draw_backdrop
    puts "	   - A pink cube of salt as big as"
    puts "	     your fist sits here.\n\n"
  end
  def view
    puts "	   - Cook it alongside ingredients"
    puts "	     to increase healing potential.\n\n"
  end
  def wrong_move
    puts "	   - It wouldn't taste right on its"
    puts "	     own. You decide against it.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT TREES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class AppleTree < FruitTree
  def initialize
    super
    @profile = Apple.new.profile
  end
  def targets
    ["tree","apple","apples","fruit"]
  end
  def draw_backdrop
    puts "	   - An apple tree stands here. It"
    print "	     bears #{@fruit.count} apple"
    @fruit.count == 1 ? print(".\n\n") : print("s.\n\n")
  end
  def description
    puts "	   - This tree produces uncommonly"
    puts "	     sweet fruit with a blue hue.\n\n"
  end
  def fill_stock
    @count.times do
      @stock.push(Apple.new)
    end
  end
end

class PlumTree < FruitTree
  def initialize
    super
    @profile = Plum.new.profile
  end
  def targets
    ["tree","apple","apples","fruit"]
  end
  def draw_backdrop
    puts "	   - A plum tree stands here. It"
    print "	     bears #{@fruit.count} plum"
    @fruit.count == 1 ? print(".\n\n") : print("s.\n\n")
  end
  def description
    puts "	   - This tree produces delicious"
    puts "	     plums that are good in brews.\n\n"
  end
  def fill_stock
    @count.times do
      @stock.push(Plum.new)
    end
  end
end


##############################################################################################################################################################################################################################################################
#####    DRINKS    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Elixer < Drink
  def initialize
    super
  	@profile = { :effect => :health, :portions => 3, :hearts => 3 }
  end
  def subtype
    ["elixer", "potion", "medicine"]
  end
  def description
  	puts "	   - It's a luck elixer brewed by"
    puts "	     cherbus. It doubles focus.\n\n"
  end
  def side_effects
    @@player.focus = 4
    @@player.focus_timer += 20

  end
end

class Water < Drink
  def initialize
    super
    @profile = { :effect => :blessing, :duration => 3, :magnitude => 3, :portions => 3 }
  end
  def subtype
    ["water","holy water"]
  end
  def description
  	puts "	   - It's water bottled by a rebel"
    puts "	     cherub. It increases luck.\n\n"
  end
end

class Tonic < Drink
  def initialize
    super
    @profile = { :effect => :exorcism, :portions => 1 }
  end
  def subtype
    ["antidote","cure","exorcism"]
  end
  def description
  	puts "	   - Made from rebel cherub spring"
    puts "	     water, it cures demon hexes."
  end
end


##############################################################################################################################################################################################################################################################
#####    SUBSTANCES     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Blossom < Burnable
  def targets
    subtype | ["flower","blossom","plant","drug"]
  end
  def animate_combustion
    puts "	   - You hold the blossom against"
    puts "	     the fire, inhaling its smoke."
    burn_effect
    print "\n"
  end
  def draw_backdrop
  	puts "	   - A #{subtype[1]} flower blooms here.\n\n"
  end
end

class RedFlower < Blossom
  def initialize
    super
  	@profile = { :effect => :sedation, :defense => 2 , :attack => -1}
  end
  def subtype
  	["blood flower","crimson","red flower","red"]
  end
  def description
  	puts "	   - When burned, it's a powerful"
  	puts "	     pain reliever and sedative.\n\n"
  end
  def burn_effect
    puts Rainbow("	     A flushed and dreamy feeling").orange
    print Rainbow("	     tickles through your body.\n\n").orange
    view_profile
  end
end

class PurpleFlower < Blossom
  def initialize
    super
  	@profile = { :effect => :agitation, :defense => 2 , :attack => 2}
  end
  def subtype
  	["purple flower","purple","violet","indigo"]
  end
  def description
  	puts Rainbow("	   - It's an aggressive stimulant.")
  	puts Rainbow("	     Its combusted form is smoke.\n\n")
  end
  def burn_effect
    puts "	     You feel light as a feather,"
    puts "	     and sharp as a razor.\n\n"
    @agitation = 10
  end
end


##############################################################################################################################################################################################################################################################
#####    SILVER     ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Ore  < Portable
    def targets
      subtype | ["ore","ingot"]
    end
    def view
        puts "	   - It's worthless, but is often"
        puts "	     used in crafting weapons.\n\n"
      end
end

class Silver < Ore
    def subtype
      ["silver"]
    end
    def draw_backdrop
      puts "	   - A hunk of raw silver lays on"
      puts "	     the ground at your feet.\n\n"
    end
end

class Gold < Ore
    def subtype
      ["gold"]
    end
    def draw_backdrop
      puts "	   - A chunk of raw gold lays on"
      puts "	     the ground at your feet.\n\n"
    end
end



##############################################################################################################################################################################################################################################################
#####    FUEL     ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Fuel  < Portable
  def targets
    subtype | ["fuel","wax","fat","grease","oil"]
  end
end

class Fat < Fuel
  def subtype
    ["worm fat","stinkworm fat", "fat"]
  end
  def draw_backdrop
    puts "	   - A wad of stinkworm fat sulks"
  	puts "	     on the ground at your feet.\n\n"
  end
  def view
    puts "	   - It smells putrid. It's good"
  	puts "	     for refueling tanks, though.\n\n"
  end
end

class Wax < Fuel
  def subtype
    ["wax","cave wax","cavern wax"]
  end
  def draw_backdrop
    puts "	   - A wad of orange wax grows out"
  	puts "	     of the cave wall here.\n\n"
  end
  def view
    puts "	   - It's cave wax. Most commonly,"
  	puts "	     it's used to refuel tanks.\n\n"
  end
end

class Sap < Fuel
  def subtype
    ["sap","tree sap", "resin"]
  end
  def draw_backdrop
    puts "	   - A drop of nearly-solid resin"
  	puts "	     hangs thick from the tree.\n\n"
  end
  def view
    puts "	   - It's a rich amber color, but"
  	puts "	     inedible. Makes good fuel.\n\n"
  end
end



##############################################################################################################################################################################################################################################################
#####    CLOTHING MATERIAL     ###############################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Leather < Portable
  def targets
    ["leather","hide","skin"]
  end
  def draw_backdrop
    puts "	   - The thick hide of a sewer rat"
  	puts "	     lays on the ground.\n\n"
  end
  def view
    puts "	   - It's durable leather. Usually"
  	puts "	     it's used for crafting armor.\n\n"
  end
end

class Silk < Portable
  def targets
    ["silk","thread","web","webbing","webs"]
  end
  def draw_backdrop
    puts "	   - A tangled mess of spider silk"
  	puts "	     webs the corner here.\n\n"
  end
  def view
    puts "	   - It's remarkably strong, and is"
  	puts "	     commonly used as thread.\n\n"
  end
end

class Rubber < Portable
  def targets
    ["rubber","silicone"]
  end
  def draw_backdrop
    puts "	   - A durable chunk of raw rubber"
    puts "	     sulks on the ground here.\n\n"
  end
  def view
    puts "	   - You wonder where it came from,"
    puts "	     and what you can make with it.\n\n"
  end
end

class Bone < Portable
  def targets
    ["bone","fragment","scrap"]
  end
  def draw_backdrop
    puts "	   - A dirty bone fragment lays at"
  	puts "	     your feet.\n\n"
  end
  def view
    puts "	   - It's a brittle base for tools"
  	puts "	     and weapons. Just add metal.\n\n"
  end
end

class Tusk < Bone
  def targets
    ["tusk","horn"]
  end
  def draw_backdrop
    puts "	   - A heavy tusk fragment lays on"
  	puts "	     the ground here.\n\n"
  end
end

class Shell < Portable
  def targets
    ["shell"]
  end
  def draw_backdrop
    puts "	   - A large spiral shell was shed"
  	puts "	     here. The snail's long gone.\n\n"
  end
  def view
    puts "	   - It is often crushed for brews"
  	puts "	     or elixers.\n\n"
  end
end

class Feather < Portable
  def targets
    ["feather","quill"]
  end
  def draw_backdrop
    puts "	   - A dark, crooked raven's quill"
  	puts "	     lays on the floor here.\n\n"
  end
  def view
    puts "	   - It's used for crafting arrows,"
  	puts "	     or writing with squid ink.\n\n"
  end
end

class Ash < Portable
  def targets
    ["ash","ashes","charcoal","soot"]
  end
  def draw_backdrop
    puts "	   - A small pile of ashes sits on"
  	puts "	     the ground here.\n\n"
  end
  def view
    puts "	   - It's the soot leftover from a"
  	puts "	     small woodfire. Brew with it.\n\n"
  end
end

class Branch < Burnable
  def targets
    ["branch","stick","skin"]
  end
  def draw_backdrop
    puts "	   - A fallen branch leans against"
  	puts "	     the tree's gnarled roots.\n\n"
  end
  def burn_effect
    puts "	   - You put the resulting ash in"
    puts "	     your rucksack.\n\n"
    @@inventory.delete(self)
    @@inventory.push(Ash.new)
  end
  def animate_combustion
    puts "	   - You hold the branch over the"
    puts "	     fire. It burns quickly.\n\n"
    burn_effect
  end
  def view
    puts "	   - Made of hardy wood, it builds"
  	puts "	     sturdy bases for tools. It is"
    puts "	     sometimes burned for ashes.\n\n"
  end
end

class Gland < Portable
  def targets
    ["gland","ink"]
  end
  def draw_backdrop
    puts "	   - A dark and spongy squid pouch"
  	puts "	     drips ink on the floor here.\n\n"
  end
  def view
    puts "	   - It's rubbery and fat with ink."
  	puts "	     A common brewing ingredient.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    PLAYER'S BONES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



class Femur < Bone
    def targets
      ["bone","femur"]
    end
    def draw_backdrop
        puts "	   - A thick, white femur lays at"
        puts "	     your feet on the ground.\n\n"
    end
    def view
      puts "	   - It's your femur. Bring it to"
      puts "	     this level's altar to ascend.\n\n"
    end
  end


##############################################################################################################################################################################################################################################################
#####    CLOTHES     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Clothes < Tool
  def targets
    subtype | ["clothing","clothes","garb","armor"]
  end
  def equip
    self.push_to_inventory if @@player.items.none?(self)
    view
    puts Rainbow("	   - You equip the #{targets[0]}.\n").orange
    @@player.armor = self
  end
end

class Hoodie < Clothes   # Requires 1 copper ore, and 3 spider spools
  def initialize
    super
    @profile = {:defense => 2, :lifespan => 30}
  end
  def subtype
    ["hoodie","sweater","sweatshirt"]
  end
  def draw_backdrop
    puts "	   - A dark hoodie lays in a pile"
  	puts "	     on the ground here.\n\n"
  end
  def description
  	puts "	   - It's a hooded sweatshirt. It"
  	puts "	     was sewn with spider's silk.\n\n"
  end
end

class Sneakers < Clothes    # Requires 2 spider spools, 1 copper ore, and 4 rat leather
  def initialize
    super
    @profile = {:defense => 5, :lifespan => 50}
  end
  def subtype
    ["shoes","sneakers"]
  end
  def draw_backdrop
    puts "	   - A pair of hide sneakers sits"
  	puts "	     untied on the ground.\n\n"
  end
  def description
  	puts "	   - They're cobbled from leather."
  	puts "	     Useful for dangerous terrain.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    JEWELRY     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Jewelry < Portable
  def targets
    subtype | ["jewelry"]
  end
end

class Ring < Jewelry
  def subtype
    ["ring","band"]
  end
  def description
  	puts "	   - It fits. It doesn't do much,"
  	puts "	     but it sure is pretty.\n\n"
  end
end

class SilverRing < Ring  # Requires 1 silver
  def initialize
    @targets = ["ring","band"]

    @profile = {:build => "silver", :rune => "none"}
  end
  def draw_backdrop
    puts "	   - A simple ring of silver sits"
  	puts "	     on the dirty ground.\n\n"
  end
end

class GoldRing < Ring  # Requires 1 silver
  def initialize
    @targets = ["ring","band"]
    @profile = {:build => "gold", :rune => "none"}
  end
  def draw_backdrop
    puts "	   - A simple golden ring lays on"
  	puts "	     the dirty ground.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    CONTAINERS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Toilet < Container
  def needkey
  	false
  end
  def targets
    ["drain","toilet","bowl","lid"]
  end
  def draw_backdrop
  	puts "	   - A dirty lidded toilet sticks"
  	puts "	     out of the wall here.\n\n"
  end
end

class Chest < Container
  def needkey
    true
  end
  def targets
    ["chest","strongbox","lootbox","box"]
  end
  def draw_backdrop
  	puts "	   - A wooden chest rests against"
  	puts "	     the dungeon wall.\n\n"
  end
end

class Urn < Container
  def needkey
    false
  end
  def targets
    ["urn","jar","bottle","remains"]
  end
  def draw_backdrop
  	puts "	   - An ornate clay urn sits here.\n\n"
  end
end

class Barrel < Container
  def needkey
    false
  end
  def targets
    ["barrel","keg","drum","vat"]
  end
  def draw_backdrop
  	puts "	   - A wooden barrel sits against"
  	puts "	     the wall here.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    DOORS    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Door < Container
  def needkey
    true
  end
  def special_properties
    if state == "jammed open"
      content.activate
    end
  end
  def give_content
    puts Rainbow("           - A new path is revealed. Your").cyan
    puts Rainbow("             map has been updated.\n ").cyan
    content.activate
    content.overview
    toggle_state_open
  end
  def targets
  	["door","exit"]
  end
  def draw_backdrop
  	puts "	   - You stand near the threshold"
  	puts "	     of a heavy iron door.\n\n"
  end
  def wrong_move
    print "	   - This iron door can only be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("opened").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Lever < Pullable
  def targets
    ["lever","handle","switch"]
  end
  def draw_backdrop
  	puts "	   - An iron lever juts out from"
  	puts "	     the wall where you stand.\n\n"
  end
  def view
  	if @unpulled
  	  puts "	   - This lever isn't pulled yet."
  	  puts "	     It could do anything.\n\n"
  	else
      puts "	   - It's stuck down and locked.\n\n"
  	end
  end
end

class Rope < Pullable
  def targets
    ["rope","twine","switch"]
  end
  def draw_backdrop
    puts "	   - A frayed rope dangles above"
    puts "	     where you stand. It's huge.\n\n"
  end
  def view
  	if @state == "unpulled"
  	  puts "	   - It feels tied to something.\n\n"
  	else
      print "	   - It won't move any further.\n\n"
  	end
  end
end


##############################################################################################################################################################################################################################################################
#####    CHARACTERS     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hellion < Character
  def initialize
    super
    @weapons = [Cleaver.new]
    @rewards = [Apple.new]
    @content = @weapons | @rewards
    @desires = Lighter.new
    @profile = {:hearts => 10, :focus => 1}
  end
  def subtype
    ["hellion","goat","monster","enemy","demon","daemon"]
  end
  def docile_backdrop
    puts "	   - A dark hellion stands on two\n"
    puts "	     cloven hooves. It stinks.\n\n"
  end
  def hostile_script
    puts "	   - Its black pupils quiver with"
    puts "	     rage. It looks rabid.\n\n"
  end
  def description
    puts "	   - It's a hellion. This goatish"
    puts "	     demon has a quick temper.\n\n"
  end
end