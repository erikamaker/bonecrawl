############################################################################################################################################################################################################################################################## 
#####    SUBSTANCES     ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  

class Crystal < Substance 
    def initialize
		@profile = { :effect => :hyper, :pages => 10 } 
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
end

class Blossom < Substance 
    def initialize
		@profile = { :effect => :fuzzy, :pages => 10 } 
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
end
