############################################################################################################################################################################################################################################################## 
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Tool < Portable
    def targets
        subtype | ["tool"]
    end
	def backdrop
		puts "	   - A #{targets[0]} lays here.\n\n"   
	end
end

class Pickaxe1 < Tool 
	def initialize  
        @profile = {:build => "iron", :lifespan => rand(7..13), :damage => 3}
	end
    def subtype
        ["pickaxe","iron pickaxe"]
    end
    def description
        puts "	   - Trolls mine for precious ore"
		puts "	     under the dungeon with these.\n\n"
    end
end

class Lockpick < Tool      
    def initialize
        @profile = {:build => "copper", :lifespan => rand(2..4), :damage => 1}
    end
    def subtype 
        ["lock pick", "metal lock pick", "metal pick", "pick", "tool"]
    end
	def description
		puts "	   - Maybe it belonged to another"
		print "	     prisoner like you?\n\n"
	end
end

class Key < Tool
	def initialize
        @profile = {:build => "copper", :lifespan => 1}
	end	
    def subtype
        ["brass key", "skeleton key", "key"]
    end
	def description
		puts "	   - It's brittle and tarnished."
		puts "	     It can be used only once.\n\n"
	end
end

class Lighter < Tool
    def initialize
        @profile = {:build => "brass"}
	end	
    def count_fuel
        @profile[:fuel] = @@items.count { |item| item.is_a?(Fuel) }
    end
    def load_special_properties
        remove_from_board if already_gotten    
        count_fuel
    end
    def subtype
        ["copper lighter", "lighter"]
    end
    def description
		puts "	   - It's handy when there isn't"
        puts "	     any fire. Watch its fuel.\n\n"
	end
end

class Jar < Tool
    def initialize
        @profile = {:build => "glass", => :holding => "nothing", => :rune => "none"}
    end
    def subtype
        ["jar", "bottle", "flask"]
    end
    def description
		puts "	   - It's a simple glass jar. It"
        puts "	     can carry elixers, spirits,"
        puts "	     and most fluids.\n\n"
	end
end