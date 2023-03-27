############################################################################################################################################################################################################################################################## 
#####    SUBSTANCES     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Blossom < Burnable
    def targets
        subtype | ["flower","blossom","plant","drug"]
    end
    def animate_combusion
        puts Rainbow("	   - You hold the blossom against").orange
        puts Rainbow("	     the fire, inhaling its smoke.").orange
        burn_effect
    end
    def backdrop
		puts "	   - A #{subtype[1]} blossom blooms here.\n\n"
	end
end


class RedFlower < Blossom 
    def initialize
		@profile = { :effect => :agitation }
	end
    def subtype
		["crimson flower","crimson","red"]
	end	
	def description
		puts "	   - When burned, it's a powerful"
		puts "	     pain reliever and sedative.\n\n"
	end
    def burn_effect 
        puts "	   - A flushed and dreamy feeling"
        puts "	     tickles through your body.\n\n"
        @@stats[:sedation] = 10
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
		puts "	   - It's an aggressive stimulant."
		puts "	     Its combusted form is smoke.\n\n"
	end
    def burn_effect 
        puts "	   - You feel light as a feather,"
        puts "	     and sharp as a razor.\n\n"
        @@stats[:agitation] = 10
    end
end

