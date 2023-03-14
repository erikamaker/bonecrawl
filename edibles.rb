############################################################################################################################################################################################################################################################## 
#####    FOOD    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Bread < Edible
    def initialize
		@profile = { :hearts => 2, :portions => 3 }
	end
    def subtype
       ["loaf", "bread", "golden bread"]
    end
	def backdrop
		puts "	   - Some goblish bread sits here.\n\n"
	end
	def description 
		puts "	   - It's soft and buttery. Cook\n"
        puts "	     it down with fruit or meat.\n\n"
	end
end

class Apple < Edible 
    def initialize
        @profile = { :hearts => 1, :portions => 3 }
    end
    def subtype
        ["apple"]
	end
	def backdrop
		puts "	   - An indigo apple sits here.\n\n"
	end
	def description 
		puts "	   - Blue apples like these tend"	
        puts "	     to grow underground. Goblin"
        puts "	     elders bake them with bread.\n\n"

	end
end

class Berry < Edible 
    def initialize
        @profile = { :hearts => 1, :portions => 1 }
    end
    def subtype
        ["berry","berries","blackberries"]
	end
	def backdrop
		puts "	   - A single blackberry, perhaps"
        puts "	     spilt by mistake, lays here.\n\n"
	end
	def description 
		puts "	   - Berries like this are bitter."	
        puts "	     They don't heal much on their"
        puts "	     own, but cook well with bread.\n\n"
	end
end

class Mushroom < Edible 
    def initialize
        @profile = { :hearts => 4, :portions => 1, :effect => "trance", :duration => 10}
    end
    def subtype
        ["fungi","fungus","mushroom","shroom","toadstool","stool"]
	end
	def backdrop
		puts "	   - A small blue mushroom blooms"
        puts "	     on the wall here.\n\n"
	end
	def description 
		puts "	   - Toadstools like these induce"	
        puts "	     waking dreams when eaten.\n\n"
	end
    def side_effect
        puts "	     The walls begin to breathe."
        puts "	     Colors whirl in your eyes.\n\n" 
        @@stats[:tranced] = profile[:duration]
    end
end

class Jerky < Edible 
    def initialize
        @profile = { :hearts => 2, :portions => 2}
    end
    def subtype
        ["jerky","meat"]
	end
	def backdrop
		puts "	   - A small strip of smoked meat"
        puts "	     lays across the ground here.\n\n"
	end
	def description 
		puts "	   - It's dry and salty. It might"	
        puts "	     cook well with some bread.\n\n"
	end
end


############################################################################################################################################################################################################################################################## 
#####    DRINKS    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Elixer < Drink   # No backdrop, because you'll never see it until it's already obtained. 
    def initialize
		@profile = { :effect => "health", :portions => 3, :hearts => 3 }
	end
    def subtype
       ["elixer", "potion", "medicine"]
    end
	def description 
		puts "	   - It's a hearty health elixer."
        puts "	     One drink fully restores all"
        puts "	     heart points.\n\n"
	end
end

class Anodyne < Drink 
    def initialize
        @profile = { :effect => "tolerance", :duration => 3, :magnitude => 3, :portions => 2 }
    end
    def subtype
        ["anodyne","narcotic","analgesic","pain reliever"]
	end
	def description 
		puts "	   - Made from boiled red blossom"	
        puts "	     petals, it protects its user"
        puts "	     from pain for 3 pages.\n\n"

	end
end

class Water < Drink 
    def initialize
        @profile = { :effect => "blessing", :duration => 3, :magnitude => 3, :portions => 3 }
    end
    def subtype
        ["water","holy water"]
	end
	def description 
		puts "	   - It's water bottled by a rebel"	
        puts "	     cherub. It blesses one's soul"
        puts "	     with luck against all odds.\n\n"
	end
end

class Cure < Drink 
    def initialize
        @profile = { :effect => "exorcism", :portions => 1 }
    end
    def subtype
        ["antidote","cure","exorcism"]
	end
	def description 
		puts "	   - Difficult to concoct, it will"	
        puts "	     exorcise any daemonic curses."
        puts "	     It must be entirely drained.\n"
	end
end

class Brew < Drink 
    def initialize
        @profile = { :effect => "aggression", :duration => 3, :magnitude => 3, :portions => 2 }
    end
    def subtype
        ["brew","daemon brew"]
	end
	def description 
		puts "	   - Caustic and frothy, this will"	
        puts "	     raise one's aggression to its"
        puts "	     brim for 3 pages.\n\n"
	end
end

