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
        @profile = {:build => "copper", :lifespan => rand(7..13), :damage => 3}
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
        @profile = {:build => "brass", :lifespan => 1}
	end	
    def subtype
        ["brass key","key"]
    end
	def description
		puts "	   - It's brittle and tarnished."
		puts "	     It can be used just once.\n\n"
	end
end

class Lighter < Tool
    def initialize
        @profile = {:build => "copper"}
	end	
    def count_fuel
        @profile[:fuel] = @@items.count { |item| item.is_a?(Fuel) }
    end
    def load_special_properties
        remove_from_board if already_obtained    
        count_fuel
    end
    def subtype
        ["copper lighter", "lighter"]
    end
    def description
		puts "	   - It's handy when there isn't"
        puts "	     any fire. Watch your fuel.\n\n"
	end
end

class Jar < Tool
    def initialize
        @profile = {:build => "glass", :holding => "nothing"}
    end
    def currently_full
        @profile[:holding] != "nothing"
    end
    def moveset
        if currently_full
            [MOVES[1..2],MOVES[15]].flatten
        else MOVES[1..2].flatten
        end
    end
    def subtype
        ["jar", "bottle", "flask"]
    end
    def description
		puts "	   - It's a simple glass jar. It"
        puts "	     currently holds #{profile[:holding]}}"
	end
end

