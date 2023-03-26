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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
    def backdrop 
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
        @profile = {:build => "silver", :rune => "none"}    # A caster should be able to give it a rune, with a number of uses. power determined by material. changes the backdrop.
    end
    def backdrop 
        puts "	   - A simple ring of silver sits"
		puts "	     on the dirty ground.\n\n"
    end
end

class GoldRing < Ring  # Requires 1 silver
    def initialize  
        @targets = ["ring","band"]
        @profile = {:build => "gold", :rune => "none"}
    end
    def backdrop 
        puts "	   - A simple golden ring lays on"
		puts "	     the dirty ground.\n\n"
    end
end