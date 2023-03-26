############################################################################################################################################################################################################################################################## 
#####    SUBSTANCES     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Substance < Burnable
    def targets
		subtype | ["drug","ingredient","narcotic","substance"]
	end	
    def animate_combusion
        puts Rainbow("	   - You hold the #{subtype[0]} against").orange
        puts Rainbow("	     the fire, inhaling the smoke.").orange
        burn_effect
    end
end


class Crystal < Substance 
    def initialize
		@profile = { :effect => :aggression, :duration => 3 , :magnitude => 2}
	end
	def subtype
		["crystal", "rock", "shard", "stimulant"]
	end	
	def backdrop
		puts "	   - A purple crystal sits here.\n\n"
	end
	def description
		puts "	   - It's an aggressive stimulant."
		puts "	     Its combusted form is vapor.\n\n"
	end
    def burn_effect 
        puts "	     You feel light as a feather,"
        puts "	     and sharp as a razor.\n\n"
        @@stats[:excited] = profile[:duration]
    end
end

class Blossom < Substance 
    def initialize
		@profile = { :effect => :tolerance, :duration => 3, :magnitude => 2} 
 	end
	def subtype
		["blossom","flower"]
	end	
	def backdrop
		puts "	   - A red blossom blooms here.\n\n"
	end
    def description
		puts "	   - It's a powerful pain-reliever\n"
		puts "	     when combusted.\n\n"
	end
    def burn_effect 
        puts "	     You feel warm and fuzzy all"
        puts "	     over. Your eyes droop.\n\n"
        @@stats[:sedated] = profile[:duration]
    end
end

