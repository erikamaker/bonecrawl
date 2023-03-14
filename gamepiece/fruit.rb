############################################################################################################################################################################################################################################################## 
#####    FRUIT    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Fruit < Edible
    def targets
        if any_fruit?
            subtype | ["food","edibles","produce","fruit"]
        else 
            [] 
        end
    end
    def load_special_properties
        increment_time
        harvest_cycle
        assign_profile
    end
    def increment_time
        @time += 1 
    end
    def grow_fruit
        if @group.count < 3
            @group.push(@type.new) 
        end
    end
    def assign_profile
        if any_fruit?
            @profile = @group[0].profile
        end
    end
    def remove_from_board
        if last_bite?
            @group.delete(@group[0])
        end
    end
    def any_fruit? 
        @group.count > 0
    end
    def one_left
        @group.count.eql?(1)
    end
    def last_bite?
        @group[0].profile[:portions].eql?(0)
    end
    def none_left?
        @group.count == 0
    end
    def be_patient
        puts "	   - There aren't any left. They"
        puts "	     need time to regrow.\n\n"    
    end
    def view
        if any_fruit?
            description 
            view_profile 
            print "\n"
        else 
            be_patient
        end
    end
    def take
        view
        puts Rainbow("	   - You pluck one from the tree. \n").orange   
        @@items.push(@group[0])
        @group.delete(@group[0])
    end
    def feed
        return if none_left?
        animate_ingestion
        remove_portion
        portions_left
        heal_player
        side_effects
        remove_from_board      
    end
end


############################################################################################################################################################################################################################################################## 
#####    APPLE SPAWNER    ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class AppleSpawner < Fruit 
    def initialize                                                                
        @group = []
        @time = 0
        @type = Apple
    end 
    def harvest_cycle
        if (@time % 30 == 0)
            grow_fruit
        end
    end
    def subtype 
        ["apple","apples"]  
    end
    def backdrop
		if any_fruit?
            print "	   - #{@group.count} indigo " 
            one_left ? print("apple ") : print("apples ")
            one_left ? print("hangs ") : print("hang ") 
            print "off its\n	     twisty branches.\n\n"
        else 
            puts "	   - Its branches bear no fruit.\n\n"
        end	
    end 
    def description  
		puts "	   - Deeply blue and glimmering,"	
        puts "	     they mature every 30 pages.\n\n"
	end    
end

class BerrySpawner < Fruit 
    def initialize                                                                
        @group = []
        @time = 0 
        @type = Berry
    end 
    def harvest_cycle
        if (@time % 40 == 0)
            grow_fruit
        end
    end
    def subtype 
        ["berry","berries"]  
    end
    def backdrop
		if any_fruit?
            print "	   - #{@group.count} little " 
            one_left ? print("berry ") : print("berries ")
            one_left ? print("grows ") : print("grow ") 
            print "on its\n	     thin branches.\n\n"
        else 
            puts "	   - Its branches bear no fruit.\n\n"
        end	
    end 
    def description  
		puts "	   - This dark and bitter fruit"	
        puts "	     matures every 40 pages.\n\n"
	end    
end

