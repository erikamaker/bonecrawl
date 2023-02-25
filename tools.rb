############################################################################################################################################################################################################################################################## 
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Pickaxe1 < Tool 
    def description
        puts "	   - Trolls mine for precious ore"
		puts "	     under the dungeon with these.\n\n"
    end
	def initialize  
        @targets = ["pickaxe","iron pickaxe"]
        @profile = {:build => "iron", :lifespan => rand(7..13), :damage => 3}
	end
end

class Lockpick < Tool      
    def initialize
        @targets = ["lock pick", "metal lock pick", "metal pick", "pick", "tool"]
        @profile = {:build => "iron", :lifespan => rand(2..4), :damage => 1}
    end
	def description
		puts "	   - Maybe it belonged to another"
		print "	     prisoner like you?\n\n"
	end
end

class Key < Tool
	def initialize
        @targets = ["brass key", "skeleton key", "key"]
        @profile = {:build => "brass", :lifespan => 1}
	end	
	def description
		puts "	   - It's brittle and tarnished."
		puts "	     It can be used only once.\n\n"
	end
end

class Lighter < Tool
    def initialize
        @targets = ["brass lighter", "lighter"]
        @profile = {:build => "brass"}
	end	
    def description
		puts "	   - It's handy when there isn't"
        puts "	     any fire near, but requires"
        puts "	     fuel to work.\n\n"
	end
end
