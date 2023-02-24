############################################################################################################################################################################################################################################################## 
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Gamepiece < Gameboard
    attr_accessor :minimap, :targets, :moveset, :profile     
    def backdrop ; end
    def load_special_properties ; end
    def assemble
        load_special_properties
        minimap.none?(@@stand) ? return : @@sight |= targets
        @@state.eql?(:backdrop) ? backdrop : engage_player
    end
    def disassemble
        @@check.push(self)
        @@items.delete(self)
    end
    def view_profile
        @profile.each do |key, value|
            dots = Rainbow(".").purple * (22 - key.to_s.length)
            space = " " * 13
            value.is_a?(String) and value = value.capitalize
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
    def engage_player
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
    def load_special_properties
        condition = @@check.include?(self) && self.is_a?(Portable)
        @minimap = [0] if condition    # SEND IT TO THE VOID, MWAHAHA
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


class Substance < Portable
    def targets
		subtype | ["drug","ingredient","narcotic","substance"]
	end	
    def moveset
        MOVES[1..2].flatten + MOVES[9]
    end
    def view 
        description
        view_profile
        print "\n"
	end	
    def burn 
        if @@sight.none?("fire")
            puts "	    - There's no fire at this plot.\n\n"
        else special_burn_screen
            disassemble
        end
    end
    def special_burn_screen 
        puts "	    - You drop it in the fire. The"
        puts "	     vapor makes you feel #{profile[:effect]}.\n\n"
        @profile[:effect].eql?(:hyper) and @@stats[:hyper] = profile[:pages]
        @profile[:effect].eql?(:fuzzy) and @@stats[:fuzzy] = profile[:pages]
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


############################################################################################################################################################################################################################################################## 
#####    CRACKS & VEINS    ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Crack < Portable
    def targets
        subtype | ["ore vein", "vein", "ore"]
    end
	def backdrop
        print "	   - You've already pulled this\n"
		puts "	   - An ore vein zigzags across"
        puts "	     the wall here.\n\n"
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