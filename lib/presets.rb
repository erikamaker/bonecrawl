##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Pickaxe1 < Tool
	def initialize
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

class Lockpick < Tool
    def initialize
        @profile = {:build => "copper", :lifespan => rand(2..4), :damage => 1}
    end
    def subtype
        ["lock pick", "metal lock pick", "metal pick", "pick", "tool"]
    end
	def description
		puts "	   - Maybe it belonged to another"
		print "	     prisoner like you?\n\n"
	end
end

class Key < Tool
	def initialize
        @profile = {:build => "brass", :lifespan => 1}
	end
    def subtype
        ["brass key","key"]
    end
	def description
		puts "	   - It's brittle and tarnished."
		puts "	     It can be used just once.\n\n"
	end
end

class Lighter < Tool
    def initialize
        @profile = {:build => "silver", :damage => 1}
	end
    def subtype
        ["silver lighter", "lighter"]
    end
    def description
		puts "	   - It's handy when there isn't"
        puts "	     any fire. It burns most all"
        puts "	     types of oil, fat, or wax.\n\n"
	end
end

class Jar < Tool
    def initialize
        @profile = {:build => "glass"}
        @holding = []
    end
    def currently_full
        !@holding.empty?
    end
    def moveset
        if currently_full
            [MOVES[1..2],MOVES[15]].flatten
        else MOVES[1..2].flatten
        end
    end
    def subtype
        ["jar", "bottle", "flask"]
    end
    def description
	    puts "	   - It's a simple glass jar. It"
        print "	     currently holds "
        @holding ? "#{@holding[0]}" : "nothing"
	end
end



##############################################################################################################################################################################################################################################################
#####    PLAYER ASSETS    ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Identification < Portable
    def targets
        ["hell pass","pass","card","id","identification"]
    end
    def display_stats
        puts Rainbow("	          - Prisoner Stats -\n").green
        @@player_stats.each do |key, value|
            dots = Rainbow(".").purple * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n\n"
    end
    def display_skill
        puts Rainbow("	          - Skill Progress -\n").orange
        @@skill_stats.each do |key, value|
            dots = Rainbow(".").red * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n"
    end
    def view
        display_stats
        display_skill
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

class Inventory < Container
    def view ; open end
    def targets
        ["knapsack","ruck sack","backpack","sack","bag","pack","items","inventory","stuff","things"]
    end
    def minimap
        [@@position]
    end
    def open
        print Rainbow("	   - You reach into your rucksack.\n\n").red
        if @@inventory.empty?
			print "	   - It's empty.\n\n"
            print Rainbow("           - You close your rucksack shut.\n\n").red
		else
            show_contents
            manage_inventory
            reset_input
		end
    end
    def show_contents
        @@inventory.group_by { |item| item.targets[0] }.each do |item, total|
            dots = (24 - item.length)
            item_copy = item
            print "	     #{item_copy.split.each{|word| word.capitalize!}.join(' ')}"
            dots.times do
                print Rainbow(".").purple
            end
            puts " #{total.count}"
        end
    end
    def manage_inventory
        print Rainbow("\n\n	   - What next?").cyan
        print Rainbow("  >>  ").purple
        process_input
        item = @@inventory.find { |item| item.targets.include?(@@target) }
        puts "\n\n"
        bag_action(item)
    end
    def bag_action(item)
        if MOVES[1..11].flatten.none?(@@action)
            puts Rainbow("           - You close your #{targets[0]} shut.\n").red
        elsif item.nil?
            puts Rainbow("           - You don't have that.\n").red
        elsif MOVES[2].include?(@@action)
            puts Rainbow("           - You already have it.\n").red
        else
            item.interact
            puts Rainbow("           - You close your #{targets[0]} shut.\n").red
        end
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
        if state.eql?("jammed open")
            content.assemble
        end
    end
    def give_content
        puts Rainbow("           - A new path is revealed. Your").orange
        puts Rainbow("             map has been updated.\n ").orange
        content.assemble
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
		if @state.eql?("unpulled")
		    puts "	   - It feels tied to something.\n\n"
		else
            print "	   - It won't move any further.\n\n"
		end
	end
end


##############################################################################################################################################################################################################################################################
#####    FOOD    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Bread < Edible
    def initialize
		@profile = { :hearts => 2, :portions => 3 }
	end
    def subtype
       ["loaf", "bread", "golden bread"]
    end
	def draw_backdrop
		puts "	   - Some goblish bread sits here.\n\n"
	end
	def description
		puts "	   - It's soft and buttery. Cook\n"
        puts "	     it down with fruit or meat.\n\n"
	end
end

class Apple < Edible
    def initialize
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

class Berry < Edible
    def initialize
        @profile = { :hearts => 1, :portions => 1 }
    end
    def subtype
        ["berry","berries","blackberries"]
	end
	def draw_backdrop
		puts "	   - A single blackberry, perhaps"
        puts "	     spilt by mistake, lays here.\n\n"
	end
	def description
		puts "	   - Berries like this are bitter."
        puts "	     They don't heal much on their"
        puts "	     own, but cook well with bread.\n\n"
	end
end

class Mushroom < Edible
    def initialize
        @profile = { :hearts => 4, :portions => 1, :effect => "trance", :duration => 10}
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
        @@player_stats[:Ascension] = profile[:duration]
    end
end

class Jerky < Edible
    def initialize
        @profile = { :hearts => 2, :portions => 2}
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


##############################################################################################################################################################################################################################################################
#####    DRINKS    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Elixer < Drink   # No backdrop, because you'll never see it until it's already obtained.
    def initialize
		@profile = { :effect => "health", :portions => 3, :hearts => 3 }
	end
    def subtype
       ["elixer", "potion", "medicine"]
    end
	def description
		puts "	   - It's a hearty health elixer."
        puts "	     One drink fully restores all"
        puts "	     heart points.\n\n"
	end
end

class Anodyne < Drink
    def initialize
        @profile = { :effect => :sedation, :duration => 10, :defense => +2, :portions => 3 }
    end
    def subtype
        ["anodyne","narcotic","analgesic","pain reliever"]
	end
	def description
		puts "	   - Made from boiled red blossom"
        puts "	     petals, it protects its user"
        puts "	     from pain for 10 pages.\n\n"

	end
end

class Water < Drink
    def initialize
        @profile = { :effect => "blessing", :duration => 3, :magnitude => 3, :portions => 3 }
    end
    def subtype
        ["water","holy water"]
	end
	def description
		puts "	   - It's water bottled by a rebel"
        puts "	     cherub. It blesses one's soul"
        puts "	     with luck against all odds.\n\n"
	end
end

class Cure < Drink
    def initialize
        @profile = { :effect => "exorcism", :portions => 1 }
    end
    def subtype
        ["antidote","cure","exorcism"]
	end
	def description
		puts "	   - Difficult to concoct, it will"
        puts "	     exorcise demonic curses. It's"
        puts "	     a painful draught to swallow.\n\n"
	end
end

class Brew < Drink
    def initialize
        @profile = { :effect => "aggression", :duration => 3, :magnitude => 3, :portions => 2 }
    end
    def subtype
        ["brew","daemon brew"]
	end
	def description
		puts "	   - Caustic and frothy, this will"
        puts "	     raise one's aggression to its"
        puts "	     brim for 3 pages.\n\n"
	end
end


##############################################################################################################################################################################################################################################################
#####    TILES    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tiles < Fixture
	attr_accessor  :subtype, :built_of, :terrain, :borders, :general, :targets
	def initialize
		@general = ["around","room","area","surroundings"] | subtype
		@borders = [["wall", "walls"],["floor","down", "ground"], ["ceiling","up","canopy"]]
		@terrain = ["terrain","medium","material"] | built_of
		@targets = (general + terrain + borders).flatten
	end
    def view
        overview
    end
    def special_properties
        @@world_map |= minimap
        @@encounters.include?("vein") and moveset | MOVES[12]
    end
	def parse_action
		case @@target
		when *general
            toggle_idle
			overview
		when *terrain
			view_type
		when *borders[0]
			view_wall
		when *borders[1]
			view_down
		when *borders[2]
			view_above
		end
	end
end


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
		@targets = subtype | ["fire","light","flame","flames"]
	end
end

class Torch < Fire
	def subtype
		["torch", "iron torch", "black torch", "metal torch"]
	end
	def draw_backdrop
		puts "	   - A black torch is bolted into"
		puts "	     the wall. Its flame smolders.\n\n"
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
    def heal_amount
        4
    end
	def view
		puts "	   - You warm your hands and toes"
		puts "	     at the fire. It heals you.\n\n"
        heal_player
    end
end


##############################################################################################################################################################################################################################################################
#####    HOOK    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Hook < Fixture
    def initialize
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
        toggle_idle
    end
end


##############################################################################################################################################################################################################################################################
#####    SURFACES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Surface < Fixture
	def initialize
		@targets = subtype | ["surface"]
	end
    def view
        subtype_view
        toggle_idle
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

class Slab < Surface
	def subtype
		["grave","grave slab","gravestone","headstone"]
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
#####    TREES    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tree < Fixture
	def targets
	    ["tree","plant"]
	end
    def view
        description
        toggle_idle
    end
end

class SapTree < Tree
    def draw_backdrop
		puts "	   - A gnarled sap tree clings to"
		puts "	     the ceiling with its roots.\n\n"
    end
    def description
        puts "	   - It's a subterranean tree. It"
		puts "	     grows upside down, and leaks"
        puts "	     a dark, bitter sap."
    end
end

class AppleTree < Tree
    def draw_backdrop
		puts "	   - A pale blue tree with silken"
		puts "	     bark grows at this plot.\n\n"
    end
    def description
        puts "	   - It's an apple tree. It grows"
		puts "	     uncommonly sweet fruit.\n\n"
    end
end

class WillowTree < Tree
    def subtype
        ["willow","weaping","magick"]
    end
    def draw_backdrop
		puts "	   - A massive willow tree mourns"
		puts "	     here, weeping shade with its"
        puts "	     long, dark branches."
    end
    def description
        puts "	   - It's a willow tree. Branches"
		puts "	     pulled from it have magickal"
		puts "	     properties.\n\n"
    end
end

class BerryTree < Tree
    def subtype
        ["berry","blackberry"]
    end
    def draw_backdrop
		puts "	   - A short and bushy blackberry"
		puts "	     tree grows here.\n\n"
    end
    def description
        puts "	   - It's a berry tree. Its fruit"
		puts "	     is edible, but doesn't taste"
		puts "	     great on its own.\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class GrowingFruit < Edible
    def targets
        if any_fruit?
            subtype | ["food","edibles","produce","fruit"]
        else
            []
        end
    end
    def feed
        take
    end
    def special_properties
        harvest_cycle
        assign_profile
    end
    def grow_fruit
        if @group.count < 3
            @group.push(@type.new)
        end
    end
    def assign_profile
        if any_fruit?
            @profile = @group[0].profile
        end
    end
    def any_fruit?
        (@group.count) > 0 and (@group[0].profile[:portions] > 0)
    end
    def one_left
        @group.count == 1
    end
    def last_bite?
        if @group.count.eql?(1)
            @group[0].profile[:portions] == 0
        end
    end
    def none_left?
        @group.count == 0
    end
    def be_patient
        puts "	   - There aren't any left. They"
        puts "	     need time to regrow.\n\n"
    end
    def view
        if any_fruit?
            description
            view_profile
            print "\n"
        else
            be_patient
        end
    end
    def take
        view
        puts Rainbow("	   - You pluck one from the tree").orange
        puts Rainbow("	     to eat later.\n").orange
        @@inventory.push(@group[0])
        @group.delete(@group[0])
    end
end


##############################################################################################################################################################################################################################################################
#####    APPLE SPAWNER    ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class AppleSpawner < GrowingFruit
    def initialize
        @group = []
        @type = Apple
    end
    def harvest_cycle
        if @@page_count % 30 == 0
            grow_fruit
        end
    end
    def subtype
        ["apple","apples"]
    end
    def draw_backdrop
		if any_fruit?
            print "	   - #{@group.count} indigo "
            one_left ? print("apple ") : print("apples ")
            one_left ? print("hangs ") : print("hang ")
            print "off its\n	     twisty branches.\n\n"
        else
            puts "	   - Its branches bear no fruit.\n\n"
        end
    end
    def description
		puts "	   - Deeply blue and glimmering,"
        puts "	     they mature every 30 pages.\n\n"
	end
end

class BerrySpawner < GrowingFruit
    def initialize
        @group = []
        @type = Berry
    end
    def harvest_cycle
        if (@@page_count % 40 == 0)
            grow_fruit
        end
    end
    def subtype
        ["berry","berries"]
    end
    def draw_backdrop
		if any_fruit?
            print "	   - #{@group.count} little "
            one_left ? print("berry ") : print("berries ")
            one_left ? print("grows ") : print("grow ")
            print "on its\n	     thin branches.\n\n"
        else
            puts "	   - Its branches bear no fruit.\n\n"
        end
    end
    def description
		puts "	   - This dark and bitter fruit"
        puts "	     matures every 40 pages.\n\n"
	end
end


##############################################################################################################################################################################################################################################################
#####    ORE     #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Ore < Portable
    def targets
        subtype | ["metal","ore"]
    end
    def view
        puts "	   - Raw #{subtype[0]} like this dwells"
        puts "       in Troll tunnels underground.\n\n"
        view_profile
        print "\n"
    end
    def draw_backdrop
        puts "     - A hunk of #{subtype} ore sits on"
        puts "	     the ground at your feet.\n\n"
    end
end

class Silver < Ore
    def subtype
       ["silver"]
    end
end

class Copper < Ore
    def subtype
       ["copper"]
    end
end

class Brass < Ore
    def subtype
       ["brass"]
    end
end


##############################################################################################################################################################################################################################################################
#####    JEWELS     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Jewel < Portable
    def targets
       ["gem","jewel","geode","stone","crystal","rock","shard"]
    end
    def view
        puts "	   - It's a cherub rock. It grows"
		puts "	     where fallen angels dwell.\n\n"
        view_profile
        print "\n"
    end
    def draw_backdrop
        puts "	   - A milky white jewel juts out"
        puts "	     of the cavern wall.\n\n"
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

class Bone < Portable
    def targets
        ["bone","fragment","skin"]
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
		puts "	     small woodfire. Antidotes for"
        puts "	     curses can be brewed with it.\n\n"
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
		@profile = { :effect => :sedation, :defense => 2 , :attack => -1, :duration => '10 pages'}
	end
    def subtype
		["blood flower","crimson","red"]
	end
	def description
		puts "	   - When burned, it's a powerful"
		puts "	     pain reliever and sedative.\n\n"
	end
    def burn_effect
        puts Rainbow("	     A flushed and dreamy feeling").orange
        print Rainbow("	     tickles through your body.\n\n").orange
        @@player_stats[:sedation] = 10
        view_profile
    end
end

class PurpleFlower < Blossom
    def initialize
		@profile = { :effect => :agitation }
	end
    def subtype
		["purple flower","purple","violet","indigo"]
	end
    def description
		puts Rainbow("	   - It's an aggressive stimulant.").orange
		puts Rainbow("	     Its combusted form is smoke.\n\n").orange
	end
    def burn_effect
        puts "	     You feel light as a feather,"
        puts "	     and sharp as a razor.\n\n"
        @@player_stats[:agitation] = 10
    end
end


##############################################################################################################################################################################################################################################################
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Weapon < Tool
    def targets
        subtype | ["weapon"]
    end
end

class Knife < Weapon
    def subtype
        ["knife","dagger","blade"]
    end
end

class Knife1 < Knife
	def initialize
        @profile = {:build => "bone", :lifespan => rand(1..6), :damage => 2}
	end
    def description
        puts "	   - It's a weak dagger made from"
		puts "	     spare skeleton parts.\n\n"
    end
end

class Knife2 < Knife
    def initialize
        @profile = {:build => "copper", :lifespan => rand(7..13), :damage => 3}
	end
    def description
        puts "	   - It's a sturdy dagger wrought"
		puts "	     from honed copper.\n\n"
    end
end

class Knife3 < Knife
    def initialize
        @profile = {:build => "silver", :lifespan => rand(14..21), :damage => 4}
	end
    def description
        puts "	   - It's a sacred dagger wrought"
		puts "	     from sterling silver.\n\n"
    end
end


##############################################################################################################################################################################################################################################################
#####    CLOTHES     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Clothes < Portable
    def targets
        subtype | ["clothing","clothes","garb","armor"]
    end
end

class Hoodie < Clothes   # Requires 1 copper ore, and 3 spider spools
    def initialize
        @targets = ["hoodie","sweater","sweatshirt"]
        @profile = {:defense => 5, :lifespan => 30}
    end
    def draw_backdrop
        puts "	   - A dark hoodie lays in a pile"
		puts "	     on the ground here.\n\n"
    end
    def description
		puts "	   - It's a hooded sweatshirt. It"
		puts "	     was sewn with spider's silk."
        puts "	     The zipper is copper.\n\n"
	end
end

class Jeans < Clothes   # Requires 1 copper ore, and 3 spider spools
    def initialize
        @targets = ["jeans","denim","pants","trousers"]
        @profile = {:defense => 5, :lifespan => 20}
    end
    def draw_backdrop
        puts "	   - A pair of denim jeans lay on"
		puts "	     the ground here.\n\n"
    end
    def description
		puts "	   - Spider silk is so strong, it"
		puts "	     makes a solid pair of denim."
        puts "	     The clasp is copper.\n\n"
	end
end

class Tee < Clothes     # Requires 2 spider spools
    def initialize
        @targets = ["tee","shirt","t-shirt"]
        @profile = {:defense => 5, :lifespan => 15}
    end
    def draw_backdrop
        puts "	   - A t-shirt lays on the ground"
		puts "	     where you stand.\n\n"
    end
    def description
		puts "	   - It was sewn with spider silk."
		puts "	     It's a strong base layer. \n\n"
	end
end

class Sneakers < Clothes    # Requires 2 spider spools, 1 copper ore, and 4 rat leather
    def initialize
        @targets = ["shoes","sneakers"]
        @profile = {:defense => 5, :lifespan => 50}
    end
    def draw_backdrop
        puts "	   - A pair of hide sneakers sits"
		puts "	     untied on the ground.\n\n"
    end
    def description
		puts "	   - Cobbled from rat leather and"
		puts "	     laced with spider silk, they"
        puts "	     are most helpful in crossing"
        puts "	     dangerous terrain.\n\n"
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
		puts "	     but it sure is pretty."
	end
end

class SilverRing < Ring  # Requires 1 silver
    def initialize
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
#####    CHARACTERS     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################



class Hellion < Character
    def initialize
        super
        @desires = Lighter.new
        @profile = {:attack => 2, :defense => 2, :hearts => 4, :focus => 1, :hostile => @hostile}
    end
    def subtype
        ["hellion","goat","monster","enemy","demon","daemon"]
    end
    def draw_backdrop
        puts "	   - A dark hellion stands on two\n"
        puts "	     cloven hooves. It stinks.\n\n"
    end
    def hostile_script
        puts "	   - Its black pupils quiver with"
        puts "	     rage. It looks rabid.\n\n"
    end
    def unique_attack_script
        puts Rainbow("	     with a butcher's cleaver.\n").orange
    end
    def description
        puts "	   - It's a hellion. Goat-like in"
        puts "	     its appearance, these demons"
        puts "	     were the bastard children of"
        puts "	     cherubs and trolls.\n\n"
    end
    def reward_animation
        puts "	   - The hellion lowers its voice."
        puts "	     It barely whispers a rumor...\n\n"
        puts Rainbow("	     There's a third cell lost to").green
        puts Rainbow("	     the ages on this floor.\n").green
    end
    def default_script
        puts "	   - It leers at you, dark pupils"
        puts "	     flexing in its yellow eyes."
        puts "	     It says it lost its lighter.\n\n"
    end
    def unlocked_script
        puts "	   - It says this place isn't all"
        puts "	     that it seems. Be vigilant.\n\n"
    end
end
