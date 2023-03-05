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
    def backdrop 
        puts "     - A hunk of #{subtype} ore sits on"
        puts "	     the ground at your feet.\n\n"    

    end
end

class Silver < Ore      
    def subtype
       ["silver"]
    end
    def initialize
        @profile = {:deflects => "evil", :strength => 3}
    end
end

class Copper < Ore      
    def subtype
       ["copper"]
    end
    def initialize
        @profile = {:strength => 4}
    end
end

## sterling


############################################################################################################################################################################################################################################################## 
#####    JEWELS     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Jewel < Portable 
    def targets
        subtype | ["gem","jewel","geode","stone","crystal"]
    end
    def view 
        puts "	   - It's a #{subtype[0]}. Jewels like"
		puts "	     this are seldom found before"
        puts "	     Trolls can eat them.\n\n"
        view_profile
        print "\n"
    end
    def backdrop 
        puts "     - A shimmering #{subtype} juts"
        puts "	     out of the cave wall here.\n\n"    
    end
end

class Blue < Jewel      
    def subtype
       ["blue gem"]
    end
    def initialize
        @profile = {:magic => "freeze"}
    end
end

class Pink < Jewel      
    def subtype
       ["pink gem"]
    end
    def initialize
        @profile = {:magic => "disarm"}
    end
end

class Plum < Jewel      
    def subtype
       ["plum gem"]
    end
    def initialize
        @profile = {:magic => "reveal"}
    end
end

class Rose < Jewel      
    def subtype
       ["rose gem"]
    end
    def initialize
        @profile = {:magic => "weaken"}
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
    def backdrop 
        puts "	   - A wad of stinkworm fat sulks"
		puts "	     on the ground at your feet.\n\n"
    end
    def view 
        puts "	   - It smells horrible. It's good"
		puts "	     for refueling tanks, though.\n\n"
    end
end

class Wax < Fuel
    def subtype 
        ["wax","cave wax","cavern wax"]
    end
    def backdrop 
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
    def backdrop 
        puts "	   - A vein of almost-solid resin"
		puts "	     clings to the tree\n\n"
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
    def backdrop 
        puts "	   - The thick hide of a sewer rat"
		puts "	     lays on the ground.\n\n"
    end
    def view 
        puts "	   - It's durable leather. Usually"
		puts "	     used for crafting armor.\n\n"
    end
end

class Silk < Portable 
    def backdrop 
        puts "	   - A tangled mess of spider silk"
		puts "	     webs the corner here.\n\n"
    end
    def view 
        puts "	   - It's remarkably strong spider"
		puts "	     silk. It makes good thread.\n\n" 
    end
end

class Bone < Portable 
    def backdrop 
        puts "	   - A dirty bone fragment lays at"
		puts "	     your feet.\n\n"
    end
    def view 
        puts "	   - It's a brittle base for tools"
		puts "	     and weapons. Just add metal.\n\n" 
    end
end

class Tusk < Portable 
    def backdrop 
        puts "	   - A heavy tusk fragment lays on"
		puts "	     the ground here.\n\n"
    end
    def view 
        puts "	   - It's a durable base for tools"
		puts "	     and weapons. Just add metal.\n\n" 
    end
end

class Shell < Portable
    def backdrop 
        puts "	   - A large spiral shell was shed"
		puts "	     here. The snail's long gone.\n\n"
    end
    def view 
        puts "	   - It's used for crafting arrows,"
		puts "	     or writing with squid ink.\n\n" 
    end
end

class Feather < Portable 
    def backdrop 
        puts "	   - A dark, crooked raven's quill"
		puts "	     lays on the floor here.\n\n"
    end
    def view 
        puts "	   - It's used for crafting arrows,"
		puts "	     or writing with squid ink.\n\n" 
    end
end
  
class Branch < Portable 
    def backdrop 
        puts "	   - A fallen branch leans against"
		puts "	     the tree's gnarled roots.\n\n"
    end
    def view 
        puts "	   - Made of hardy wood, it builds"
		puts "	     sturdy handles and staves.\n\n" 
    end
end

class Gland < Portable 
    def backdrop 
        puts "	   - A dark and spongy squid pouch"
		puts "	     drips ink on the floor here.\n\n"
    end
    def view 
        puts "	   - It's rubbery and fat with ink."
		puts "	     A common brewing ingredient.\n\n" 
    end
end

class Salt < Portable 
    def backdrop 
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

