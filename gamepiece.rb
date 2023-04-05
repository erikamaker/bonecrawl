##############################################################################################################################################################################################################################################################
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Gamepiece < Gameboard
    attr_accessor :minimap, :targets, :moveset, :profile
    def backdrop
        # Not all instances will have their
        # own backdrop. Some are hidden and
        # will return nil.
    end
    def load_special_properties
        # For example, fruit sources grow
        # with passage of time. Other pieces
        # may have other ad hoc properties.
        # Some may have none at all.
    end
    def reveal_targets
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
        player_near? ? reveal_targets : return
        player_idle? ? backdrop : interact
    end
    def already_obtained
        @@check.include?(self)
    end
    def remove_from_board
        @minimap = [0] # The Void. Piece still exists, but can no longer be interacted with.
    end
    def disassemble
        @@check.push(self)
        @@items.delete(self)
    end
    def view
        description
        view_profile
        print "\n"
    end
    def view_profile
        return if @profile == nil
        @profile.each do |key, value|
            total = 25 - (key.to_s.length + value.to_s.length)
            dots = Rainbow(".").purple * total
            space = " " * 13
            value = value.to_s.capitalize
            puts space + "#{key.capitalize} #{dots} #{value}"
        end
    end
    def actions
        {
            view: MOVES[1],
            take: MOVES[2],
            open: MOVES[3],
            push: MOVES[4],
            pull: MOVES[5],
            talk: MOVES[6],
            give: MOVES[7],
            harm: MOVES[8],
            burn: MOVES[9],
            feed: MOVES[10],
            mine: MOVES[11]
        }
    end
    def parse_action
        actions.each do |action, moves|
            self.send(action) if moves.include?(@@action)
        end
    end
    def interact
		return if targets.none?(@@target)
        if moveset.include?(@@action)
			parse_action
		else
            wrong_move
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
        remove_from_board if already_obtained
    end
	def take
        view
        puts Rainbow("	   - You take the #{targets[0]}.\n").orange
        @@check.push(self)
        @@items.push(self)
	end
end


##############################################################################################################################################################################################################################################################
#####    EDIBLE    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Edible < Portable
	def targets
		subtype | ["food","edible","nourishment","nutrients","nutrient"]
	end
	def moveset
		MOVES[1..2].flatten | MOVES[10]
	end
    def feed
        animate_ingestion
        remove_portion
        portions_left
        heal_player
        side_effects
    end
    def animate_ingestion
        puts "	   - You eat the #{subtype[0]}, healing"
		print "	     #{heal_amount} heart"
        heal_amount.eql?(1) ? print(". ") : print("s. ")
    end
    def remove_portion
        profile[:portions] -= 1
    end
    def portions_left
        case profile[:portions]
        when 1
            print "#{profile[:portions]} portion left.\n\n"
        when * [2..7]
            print "#{profile[:portions]} portions left.\n\n"
        else
            print "You finish it.\n\n"
            disassemble
        end
	end
    def heal_player
        @@heart += heal_amount
    end
    def heal_amount
        if @@heart + profile[:hearts] > 4
            (4 - @@heart)
        else
            profile[:hearts]
        end
    end
    def side_effects
        return if not profile.key?(:effect)
        display_side_effect
    end
end


##############################################################################################################################################################################################################################################################
#####    INGESTIBLES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Drink < Edible
	def targets
		subtype | ["drink"]
	end
	def moveset
		[MOVES[1..2],MOVES[10],MOVES[15]].flatten
	end
    def animate_ingestion
        puts "	   - You drink the #{subtype[0]}, healing"
		print "	     #{heal_amount} heart"
        heal_amount.eql?(1) ? print(". ") : print("s. ")
    end
end


##############################################################################################################################################################################################################################################################
#####    COMBUSTIBLES     ####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Burnable < Portable
    def moveset
        MOVES[1..2].flatten + MOVES[9]
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
    def got_a_light?
        if lighter == nil
            puts "	   - There's isn't any fire here.\n\n"
        else
            fuel != nil ? use_lighter : out_of_fuel
        end
    end
    def use_lighter
        puts "	   - You thumb a little fuel into"
        puts "	     your lighter's fuel canister."
        puts "	     It sparks a warm flame.\n\n"
        animate_combusion
        disassemble
        @@items.find { |i| i.is_a?(Fuel) and i.disassemble }
    end
    def burn
        if no_fire
            got_a_light?
        else
            animate_combusion
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
        else
            puts "	   - It's already open.\n\n"
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
        else
            puts "	   - You twirl a #{key.targets[0]} in the"
            puts "	     #{targets[0]}'s latch. Click.\n\n"
            use_key
            give_content
        end
	end
    def animate_opening
        puts Rainbow("           - It swings open and reveals a").orange
        puts Rainbow("             hidden #{content.targets[0]}.\n").orange
    end
    def give_content
        animate_opening
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
			disassemble
			reveal_secret
		else
            puts "	   - It appears that somebody has\n"
			puts "	     already pulled this #{targets[0]}\n\n"
		end
	end
end


