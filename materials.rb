############################################################################################################################################################################################################################################################## 
#####    ORE     #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Ore < Portable 
    def targets
        subtype | ["ore","metal","raw ore","raw metal"]
    end
    def view 
        puts "	   - Raw silver ore like this is"
		puts "	     rare. Veins of it can still"
        puts "	     be found below the dungeon,"
        puts "	     where the Trolls live.\n\n"
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


############################################################################################################################################################################################################################################################## 
#####    GEMS     ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Jewel < Portable 
    def targets
        subtype | ["gem","jewel","geode","stone","crystal"]
    end
    def view 
        puts "	   - It's a #{subtype[0]}. Jewels like"
		puts "	     this are rarely found before"
        puts "	     Trolls can eat them.\n\n"
        view_profile
        print "\n"
    end
    def backdrop 
        puts "     - A shimmering #{subtype} is set"
        puts "	     on the floor here.\n\n"    
    end
end

class Blue < Jewel      
    def subtype
       ["blue gem"]
    end
    def initialize
        @profile = {:magic => "cold"}
    end
end

class Pink < Jewel      
    def subtype
       ["pink gem"]
    end
    def initialize
        @profile = {:magic => "warm"}
    end
end


############################################################################################################################################################################################################################################################## 
#####    FUEL     ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Fuel  < Portable 
    def targets
        ["fuel","grease","fat","oil","wax"]
    end
end

class WormFat < Fuel
    def backdrop 
        puts "	   - A wad of stinkworm fat sulks"
		puts "	     on the ground at your feet.\n\n"
    end
    def view 
        puts "	   - It's stinkworm grease. Useful"
		puts "	     for refilling fuel tanks.\n\n"
    end
end

class TrollFat < Fuel
    def backdrop 
        puts "	   - A wad of waxy Troll fat sulks"
		puts "	     on the ground at your feet.\n\n"
    end
    def view 
        puts "	   - It's Troll fat. It's good for"
		puts "	     refilling fuel tanks.\n\n"
    end
end

class CaveWax < Fuel
    def backdrop 
        puts "	   - A wad of orange wax grows out"
		puts "	     of the cave wall here.\n\n"
    end
    def view 
        puts "	   - It's cave wax. It's good for"
		puts "	     refilling fuel tanks.\n\n"
    end
end


