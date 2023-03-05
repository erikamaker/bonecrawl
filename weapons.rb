############################################################################################################################################################################################################################################################## 
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Weapon < Tool
    def targets
        subtype | ["weapon"]
    end
end

class Knife < Weapon
    def subtype 
        ["knife","dagger","blade"]
    end
end

class Knife1 < Knife 
	def initialize  
        @profile = {:build => "bone", :lifespan => rand(1..6), :damage => 2}
	end
    def description
        puts "	   - It's a weak dagger made from"
		puts "	     spare skeleton parts.\n\n"
    end
end

class Knife2 < Knife 
    def initialize  
        @profile = {:build => "iron", :lifespan => rand(7..13), :damage => 3}
	end
    def description
        puts "	   - It's a sturdy dagger wrought"
		puts "	     from tempered iron.\n\n"
    end
end

class Knife3 < Knife 
    def initialize  
        @profile = {:build => "silver", :lifespan => rand(14..21), :damage => 4}
	end
    def description
        puts "	   - It's a sacred dagger wrought"
		puts "	     from sterling silver.\n\n"
    end
end

