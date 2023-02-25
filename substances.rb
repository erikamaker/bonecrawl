############################################################################################################################################################################################################################################################## 
#####    SUBSTANCES     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Substance < Burnable
    def targets
		subtype | ["drug","ingredient","narcotic","substance"]
	end	
end


class Crystal < Substance 
    def initialize
		@profile = { :effect => :hyper, :duration => 10 } 
	end
	def subtype
		["crystal", "rock", "shard", "aggressive stimulant", "stimulant", "upper"]
	end	
	def backdrop
		puts "	   - A purple crystal sits here.\n\n"
	end
	def description
		puts "	   - It's an aggressive stimulant."
		puts "	     Its combusted form is vapor.\n\n"
	end
    def burn_screen 
        puts Rainbow("	   - You hold the crystal against").orange
        puts Rainbow("	     the fire, inhaling the vapor.").orange
        puts "	     You feel light as a feather,"
        puts "	     and sharp as a razor.\n\n"
        @@stats[:hyper] = profile[:duration]
    end
end

class Blossom < Substance 
    def initialize
		@profile = { :effect => :fuzzy, :duration => 10 } 
 	end
	def subtype
		["flower","blossom", "bright red flower", "bright red blossom", "red flower","red blossom", "pain -eliever", "plant", "herb"]
	end	
	def backdrop
		puts "	   - A red blossom blooms here.\n\n"
	end
    def description
		puts "	   - It's a powerful pain-reliever\n"
		puts "	     when combusted.\n\n"
	end
    def burn_screen 
        puts Rainbow("	   - You hold the blossom against").orange
        puts Rainbow("	     the fire, inhaling the smoke.").orange
        puts "	     You feel light as a feather,"
        puts "	     and sharp as a razor.\n\n"
        @@stats[:hyper] = profile[:duration]
    end
end
