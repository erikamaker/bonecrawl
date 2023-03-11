############################################################################################################################################################################################################################################################## 
#####    TREES    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Tree < Fixture       
	def targets
	    ["tree","plant"]
	end
    def view 
        description
        toggle_backdrop
    end
end

class CaveTree < Tree 
    def backdrop 
		puts "	   - A gnarled sap tree clings to"
		puts "	     the ceiling with its roots.\n\n"
    end
    def description
        puts "	   - It's a subterranean tree. It"
		puts "	     grows upside down, and leaks"
        puts "	     a dark, bitter sap."
    end
end

class AppleTree < Tree 
    def backdrop 
		puts "	   - A pale blue tree with silken"
		puts "	     bark grows at this plot.\n\n"
    end
    def description
        puts "	   - It's an apple tree. It grows"
		puts "	     uncommonly sweet fruit.\n\n"
    end
end

class WillowTree < Tree 
    def subtype
        ["willow","weaping","magick"]
    end
    def backdrop 
		puts "	   - A massive willow tree mourns"
		puts "	     here, weeping shade with its"
        puts "	     long, dark branches."
    end
    def description
        puts "	   - It's a willow tree. Branches" 
		puts "	     pulled from it have magickal"
		puts "	     properties.\n\n" 
    end
end

class BerryTree < Tree 
    def subtype
        ["berry","blackberry"]
    end
    def backdrop 
		puts "	   - A short and bushy blackberry"
		puts "	     tree grows here.\n\n"
    end
    def description
        puts "	   - It's a berry tree. Its fruit" 
		puts "	     is edible, but doesn't taste"
		puts "	     great on its own.\n\n" 
    end
end

