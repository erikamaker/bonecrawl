############################################################################################################################################################################################################################################################## 
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Knife1 < Weapon 
    def description
        puts "	   - It's a weak dagger made from"
		puts "	     spare skeleton parts.\n\n"
    end
	def initialize  
        @targets = ["knife","dagger","blade"] | ["bone"]
        @profile = {:build => "bone", :lifespan => rand(1..6), :damage => 2}
	end
end

class Knife2 < Weapon 
    def description
        puts "	   - It's a sturdy dagger wrought"
		puts "	     from tempered iron.\n\n"
    end
	def initialize  
        @targets = ["dagger","knife","blade","weapon"] | ["iron"]
        @profile = {:build => "iron", :lifespan => rand(7..13), :damage => 3}
	end
end

class Knife3 < Weapon 
    def description
        puts "	   - It's a sacred dagger wrought"
		puts "	     from sterling silver.\n\n"
    end
	def initialize  
        @targets = ["knife","dagger","blade","weapon"] | ["silver"]
        @profile = {:build => "silver", :lifespan => rand(14..21), :damage => 4}
	end
end

