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
       ["gem","jewel","geode","stone","crystal", "shard"]
    end
    def view 
        puts "	   - It's a cherub gem. They tend"
		puts "	     to grow where angels dwell.\n\n" 
        view_profile
        print "\n"
    end
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
        puts "	   - A heavy tusk fragment lays on"
		puts "	     the ground here.\n\n"
    end
end

class Shell < Portable
    def targets
        ["shell"]
    end
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
        puts "	   - A fallen branch leans against"
		puts "	     the tree's gnarled roots.\n\n"
    end
    def burn_effect
        @@items.delete(self)
        @@items.push(Ash.new)
    end
    def animate_combusion
        puts "	   - You hold the branch over the"
        puts "	     fire. It burns quickly.\n\n"
        burn_effect
    end
    def view 
        puts "	   - Made of hardy wood, it builds"
		puts "	     sturdy handles and staves. It" 
        puts "	     is sometimes burned for ashes.\n\n" 
    end
end

class Gland < Portable 
    def targets
        ["gland","ink"]
    end
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
    def targets
        ["salt","seasoning","sodium","cube"]
    end
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

