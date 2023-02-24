############################################################################################################################################################################################################################################################## 
#####    INGESTIBLES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Apple < Edible 
    def initialize
		@profile = { :hearts => 1, :portions => 4}
	end
	def subtype
		["apple", "fruit"]
	end	
	def backdrop
		puts "	   - A blue apple sits here.\n\n"
	end
	def description 
		puts "	   - Blue apples like these tend"	
        puts "	     to grow underground.\n\n"
	end
end

class Bread < Edible
    def initialize
		@profile = { :hearts => 4, :portions => 6}
	end
	def subtype
		subtype = ["loaf", "bread", "golden bread"]
	end	
	def backdrop
		puts "	   - Some golden bread sits here.\n\n"
	end
	def description 
		puts "	   - It's said that a single bite\n"
        puts "	     can fully heal a grown human.\n\n"
	end
end
