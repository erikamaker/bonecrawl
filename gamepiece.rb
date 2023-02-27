############################################################################################################################################################################################################################################################## 
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Gamepiece < Gameboard
    attr_accessor :minimap, :targets, :moveset, :profile     
    def backdrop
        ## Namespaced, as not all instances have
        ## backdrops. Some are hidden from player
    end
    def load_special_properties
        ## Namespaced if an instance doesn't have 
        ## its own special property to load. 
    end
    def visualize_target
        @@sight |= targets
    end
    def player_near?
        minimap.include?(@@stand)
    end
    def player_idle?
        @@state.eql?(:backdrop)
    end
    def assemble
        load_special_properties
        player_near? ? visualize_target : return
        player_idle? ? backdrop : interact
    end
    def disassemble
        @@check.push(self)
        @@items.delete(self)
    end
    def view_profile
        @profile.each do |key, value|
            total = 25 - (key.to_s.length + value.to_s.length) 
            dots = Rainbow(".").purple * total
            space = " " * 13
            value = value.capitalize if not value.is_a?(Integer)
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
    end
    def parse_action
        actions = {
            view: MOVES[1],
            take: MOVES[2],
            open: MOVES[3],
            push: MOVES[4],
            pull: MOVES[5],
            talk: MOVES[6],
            give: MOVES[7],
            harm: MOVES[8],
            burn: MOVES[9],
            heal: MOVES[10],
            mine: MOVES[11]
        }
        actions.each do |action, moves|
            return self.send(action) if moves.include?(@@action)
        end
    end
    def interact
		return if targets.none?(@@target)
        if moveset.include?(@@action)
			parse_action
		else wrong_move
		end
    end
    def wrong_move
        puts "	   - It proves useless to try. A"
        puts "	     page passes in vain.\n\n"
    end	
end


############################################################################################################################################################################################################################################################## 
#####    FIXTURES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Fixture < Gamepiece
    def moveset
        MOVES[1]
    end
end


############################################################################################################################################################################################################################################################## 
#####    PORTABLE     ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Portable < Gamepiece
	def moveset
		MOVES[1..2].flatten 
	end	
    def remove_from_board
        @minimap = [0]
    end
    def load_special_properties
        already_gotten = @@check.include?(self) && self.is_a?(Portable)
        remove_from_board if already_gotten    
    end
	def take 
        view
        puts Rainbow("	   - You steal the #{targets[0]}.\n").orange
        @@check.push(self)
        @@items.push(self)
	end						
end


############################################################################################################################################################################################################################################################## 
#####    TOOLS & WEAPONS    ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Tool < Portable
    def targets
        @targets | ["tool"]
    end
	def backdrop
		puts "	   - A #{targets[0]} lays here.\n\n"   
	end
	def view
        description 
        view_profile 
        print "\n"
    end
end

class Weapon < Tool
    def targets
        @targets | ["weapon"]
    end
end


############################################################################################################################################################################################################################################################## 
#####    INGESTIBLES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Edible < Portable
	def targets
		subtype | ["food","edible"] 
	end		
	def moveset
		MOVES[1..2].flatten | MOVES[10]
	end	
    def view
        description 
        view_profile 
        print "\n"
    end
    def heal
        @@heart += heal_amount
        profile[:portions] -= 1 if profile[:portions] > 0
        puts "	   - You eat the #{subtype[0]}, healing"
		print "	     #{heal_amount} heart"   
        heal_amount.eql?(1) ? print(". ") : print("s. ")
        portions_left
        side_effects
    end
    def heal_amount 
        if @@heart + profile[:hearts] > 4
            (4 - @@heart)
        else profile[:hearts]
        end
    end
    def portions_left
        case profile[:portions]
        when 1
            print "#{profile[:portions]} portion remains.\n\n"
        when * [2,3,4,5,6,7]
            print "#{profile[:portions]} portions remain.\n\n"
        else print "You finish it.\n\n"
            disassemble
        end
	end
    def side_effects
        return if not profile.key?(:effect) 
        puts "	   - You feel... #{profile[:effect]}.\n\n"
    end
end


############################################################################################################################################################################################################################################################## 
#####    COMBUSTIBLES     ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Burnable < Portable
    def moveset
        MOVES[1..2].flatten + MOVES[9]
    end
    def view 
        description
        view_profile
        print "\n"
	end	
    def no_fire
        @@sight.none?("fire")
    end
    def out_of_fuel
        puts "	    - You're out of lighter fuel.\n\n"
    end
    def lighter
        lighter = @@items.find { |i| i.is_a?(Lighter) }
    end
    def fuel
        fuel = @@items.find { |i| i.is_a?(Fuel) }
    end
    def use_lighter
        puts "	   - You thumb a little grease in"
        puts "	     your lighter's fuel canister."
        puts "	     It sparks a warm flame.\n\n"
        burn_screen
        disassemble
        @@items.find { |i| i.is_a?(Fuel) and i.disassemble }
    end
    def other_method
        if lighter == nil
            puts "	   - There's isn't any fire here.\n\n"
        else fuel != nil ? use_lighter : out_of_fuel
        end
    end
    def burn 
        if no_fire
            other_method
        else burn_screen
            disassemble
        end
    end
end	


############################################################################################################################################################################################################################################################## 
#####    CONTAINERS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Container < Gamepiece 
    attr_accessor :content, :needkey
    def moveset
        moveset = MOVES[1] | MOVES[3]
    end
	def view
        state = @@check.none?(self) ? "closed shut" : "wide open"
		puts "	   - This #{targets[0]} is #{state}.\n\n" 
	end
    def key 
        tools = ["brass key", "lock pick"]
        @@items.find { |i| tools.include?(i.targets[0]) }
    end
    def open
        if @@check.none?(self)
            needkey.eql?(false) ? give_content : is_locked
        else puts "	   - It's already open.\n\n"
        end
	end 
    def use_key
        key.profile[:lifespan] -= 1
        if key.profile[:lifespan] == 0
            puts Rainbow("	   - Your #{key.targets[0]} snaps in two.").red
            puts Rainbow("	     You toss away the pieces.\n").red
            @@items.delete(key)
        end
    end
    def is_locked
        if key.nil?
            puts "	   - It won't open. It's locked.\n\n"
        else puts "	   - You twirl a #{key.targets[0]} in the"
            puts "	     #{targets[0]}'s latch. Click.\n\n"
            use_key
            give_content  
        end
	end
    def opening_animation
        puts Rainbow("           - It swings open and reveals a").orange
        puts Rainbow("             hidden #{content.targets[0]}.\n").orange
    end
    def give_content
        opening_animation
        @@action = "take"
        @@target = content.targets[0]
        content.minimap = minimap
        content.assemble
        @@check.push(self)  
    end
end


############################################################################################################################################################################################################################################################## 
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Pullable < Gamepiece	
    attr_accessor :content
	def moveset
		MOVES[1] | MOVES[5]
	end
    def pull
		if @@check.none?(self)		
			@@check.push(self) 
			reveal_secret
		else print "	   - You've already pulled this\n"
			print "	     #{targets[0]} before.\n\n" 							
		end														
	end		
end


