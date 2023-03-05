############################################################################################################################################################################################################################################################## 
#####    CONTAINERS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Toilet < Container
	def needkey
		false
	end
	def targets
        ["drain","toilet","bowl","toilet bowl", "toilet lid", "drain","lid","latch"]
    end
    def backdrop
		puts "	   - A dirty lidded toilet sticks"
		puts "	     out of the wall here.\n\n"
	end
end

class Chest < Container
    def needkey
        true
    end
    def targets
        ["chest","strongbox","chest","treasure chest","lootbox","box","lock","latch"]
    end
    def backdrop
		puts "	   - A wooden chest sits against"
		puts "	     the dungeon wall.\n\n"
	end
end

class Urns < Container
    def needkey
        false
    end
    def targets
        ["urn","jar","bottle","emains"]
    end
    def backdrop
		puts "	   - A ceramic urn sits here.\n\n"    
	end
end

class Barrel < Container
    def needkey
        false
    end
    def targets
        ["barrel","keg","drum","vat"]
    end
    def backdrop
		puts "	   - A wooden barrel sits against"   
		puts "	     the wall here.\n\n"
	end
end


############################################################################################################################################################################################################################################################## 
#####    DOORS    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Door < Container
    def needkey
        true
    end
    def load_special_properties
        content.assemble if @@check.include?(self)
    end
    def give_content
        puts Rainbow("           - A new path is revealed. Your").orange
        puts Rainbow("             map has been updated.\n ").orange
        content.assemble  
        content.overview
        @@check.push(self)
    end
	def targets										
		["door","exit","iron door","latch"]
	end
	def backdrop
		puts "	   - You stand near the threshold"
		puts "	     of a heavy iron door.\n\n"
	end
end


############################################################################################################################################################################################################################################################## 
#####   INVENTORY    #########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Inventory < Container 
    def view ; open end
    def targets
        ["knapsack","rucksack","backpack","sack","bag","items","inventory","stuff","things","collection"]
    end
    def minimap
        [@@stand]
    end
    def moveset
        MOVES[1] | MOVES[3]
    end
    def open
        print Rainbow("	   - You reach into your #{targets[0]}.\n\n").red
        targets.include?("bag") ? @content = @@items : @content = []
        if @content.empty?  
			print "	   - It's empty.\n\n"
            print Rainbow("           - You close your #{targets[0]} shut.\n\n").red 
		else show_contents
            manage_inventory
            @@action = :reset
            @@target = :reset
		end
    end
    def show_contents
        @content.group_by { |i| i.targets[0] }.each do |item, total|    
            dots = (24 - item.length)
            print "	     #{item.capitalize} "
            dots.times do
                print Rainbow(".").purple
            end
            puts " #{total.count}" 
        end
    end
    def manage_inventory
        moves = MOVES[1..11].flatten
        print Rainbow("\n\n	   - What next?").cyan
        print Rainbow("  >>  ").purple
        process_input
        item = content.find { |i| i.targets.include?(@@target) }
        puts "\n\n"
        if moves.none?(@@action)
            puts Rainbow("           - You close your #{targets[0]} shut.\n").red            
        elsif item.nil?
            puts Rainbow("           - You don't have that.\n").red
        elsif MOVES[2].include?(@@action) and targets.include?("bag")
            puts Rainbow("           - You already have it.\n").red
        else item.interact
            puts Rainbow("           - You close your #{targets[0]} shut.\n").red     
        end
    end 
end


############################################################################################################################################################################################################################################################## 
#####    PLAYER ASSETS    ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class StatsCard < Container
    def view ; open end
    def targets
        ["stats","info","player","self","myself","information","stackup","level"]
    end
    def minimap
        [@@stand]
    end
    def display_stats
        puts Rainbow("	          - Prisoner Stats -\n").green          
        @@stats.each do |key, value|
            dots = Rainbow(".").purple * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n\n"
    end
    def display_skill
        puts Rainbow("	          - Skill Progress -\n").orange          
        @@skill.each do |key, value|
            dots = Rainbow(".").red * (24 - key.to_s.length)
            space = " " * 13
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
        puts "\n"
    end
    def open 
        display_stats
        display_skill
    end
end

