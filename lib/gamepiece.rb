##############################################################################################################################################################################################################################################################
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Gamepiece < Gameboard
    attr_accessor :minimap, :targets, :moveset, :profile
    def draw_backdrop
        # Not all instances will have their
        # own backdrop. Some are hidden and
        # will return nil.
    end
    def special_properties
        # For example, fruit spawners grow
        # fruit on a schedule. This is for
        # any ad hoc logic a specific piece
        # has. Some may have none at all.
    end
    def reveal_targets
        @@encounters |= targets
    end
    def player_near?
        minimap.include?(@@position)
    end
    def player_idle?
        @@state == :player_idle
    end
    def assemble
        special_properties
        player_near? ? reveal_targets : return
        player_idle? ? draw_backdrop : interact
    end
    def remove_from_board
        @minimap = [0]
        remove_from_inventory
    end
    def remove_from_inventory
        @@inventory.delete(self)
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
    def search_inventory(types)
        types = Array(types)
        @@inventory.find do |item|
            types.any? do |type|
              item.is_a?(type)
            end
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
	def take
        view
        puts Rainbow("	   - You take the #{targets[0]}.\n").orange
        push_to_inventory
    end
    def push_to_inventory
        remove_from_board
        @@inventory.push(self)
	end
end


##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tool < Portable
    def targets
        subtype | ["tool"]
    end
	def draw_backdrop
		puts "	   - A #{targets[0]} lays here.\n\n"
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
        puts Rainbow("	   - You eat the #{subtype[0]}, healing").orange
		print Rainbow("	     #{heal_amount} heart").orange
        if heal_amount == 1
            print Rainbow(". ").orange
        else print Rainbow("s. ").orange
        end
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
            remove_from_board
        end
	end
    def heal_player
        @@player_stats[:heart] += heal_amount
    end
    def heal_amount
        if @@player_stats[:heart] + profile[:hearts] > 4
            (4 - @@player_stats[:heart])
        else
            profile[:hearts]
        end
    end
    def side_effects
        # Reserved for foods or potions
        # that affect player's stats in
        # some way. See presets.
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
        if heal_amount == 1
            print(". ")
        else print("s. ")
        end
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
        @@encounters.none?("fire")
    end
    def out_of_fuel
        puts "	    - You're out of lighter fuel.\n\n"
    end
    def got_fuel?
        if search_inventory(Fuel).nil?
            out_of_fuel
        else use_lighter
        end
    end
    def got_a_light?
        if search_inventory(Lighter).nil?
            puts "	   - There's isn't any fire here.\n\n"
        else
            got_fuel?
        end
    end
    def use_lighter
        puts "	   - You thumb a little fuel into"
        puts "	     your lighter's fuel canister."
        puts "	     It sparks a warm flame.\n\n"
        animate_combustion
        remove_from_board
        search_inventory(Fuel).remove_from_inventory
    end
    def burn
        if no_fire
            got_a_light?
        else
            animate_combustion
            remove_from_board
        end
    end
end


##############################################################################################################################################################################################################################################################
#####    CONTAINERS    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Container < Gamepiece
    attr_accessor :content, :needkey, :state
    def initialize
        @moveset = MOVES[1] | MOVES[3]
        @state = "closed shut"
    end
    def toggle_state_open
        @state = "jammed open"
    end
	def view
		puts "	   - This #{targets[0]} is #{state}.\n\n"
	end
    def key
        tools = ["brass key", "lock pick"]
        @@inventory.find { |item| tools.include?(item.targets[0]) }
    end
    def open
        if @state.eql?("closed shut")
            !needkey ? give_content : is_locked
        else
            puts "	   - This #{targets[0]}'s already open.\n\n"
        end
	end
    def use_key
        key.profile[:lifespan] -= 1
        if key.profile[:lifespan] == 0
            puts Rainbow("	   - Your #{key.targets[0]} snaps in two.").red
            puts Rainbow("	     You toss away the pieces.\n").red
            @@inventory.delete(key)
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
        toggle_state_open
    end
    def give_content
        animate_opening
        content.take
    end
end


##############################################################################################################################################################################################################################################################
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Pullable < Gamepiece
    attr_accessor :content
    def initialize
        @moveset = MOVES[1] | MOVES[5]
        @unpulled = true
    end
    def special_properties
        content.assemble if !@unpulled
    end
    def toggle_state_pulled
        @unpulled = false
    end
    def pull
		if @unpulled
			reveal_secret
            toggle_state_pulled
		else
            puts "	   - It appears that somebody has\n"
			puts "	     already pulled this #{targets[0]}.\n\n"
		end
	end
end


##############################################################################################################################################################################################################################################################
#####     CHARACTERS     #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Character < Gamepiece
    attr_accessor :hostile, :desires, :content, :friends, :subtype
    def initialize
        @moveset = MOVES[1] | MOVES[6..8].flatten
        @hostile = false
        @friends = false
        @desires = desires
    end
    def targets
        subtype | ["character","person","entity","soul"]         # TODO: add individual body parts to SPEECH?
    end
    def demon_is_alive
        @profile[:hearts] > 0
    end
    def demon_is_slain
        @profile[:hearts] < 1
    end
    def become_hostile
        @hostile = true
        hostile_script
    end
    def become_friends
        @hostile = false
        @friends = true
    end
    def player_has_leverage
        @@inventory.find do |item|
            item.targets == desires.targets
        end
    end
    def talk
        if @hostile
            puts "	   - It's in no mood to socialize.\n\n"
        else conversation
        end
    end
    def conversation
        @friends ? unlocked_script : business_as_usual
    end
    def business_as_usual
        default_script
        barter if player_has_leverage
    end
    def barter
        unique_bartering_script
        print Rainbow("	     Yes / No  >>  ").purple
        choice = gets.chomp
        print "\n"
        bartering_outcome(choice)
    end
    def bartering_outcome(choice)
        if choice.eql?("yes")
            exchange_gifts
        else
            become_hostile
        end
    end
    def exchange_gifts
        reward_animation
        reward = @content.sample
        puts Rainbow("	   - To help you on your journey,").orange
        puts Rainbow("	     you're given 1 #{reward.targets[0]}.\n").orange
        reward.take
        @content.push(@desires)
        @desires.remove_from_inventory
        become_friends
    end
    def demon_chance
        rand(@profile[:focus]..2) == 2
    end
    def player_chance
        rand(@@player_stats[:focus]..2) == 2
    end
    def player_hits_demon
        @profile[:hearts] -= 1 # update this to reflect the weapon's value
        print Rainbow("	     You hit it. #{@profile[:hearts]} heart").green
        print Rainbow("s").green if @profile[:hearts] != 1
        print Rainbow(" remain").green
        print Rainbow("s").green if @profile[:hearts] == 1
        print Rainbow(".\n\n").green

    end
    def player_misses_demon
        puts Rainbow("	     The demon dodges your attack.\n").red
    end
    def special_properties
        @profile[:hostile] = @hostile
        if demon_is_alive
            demon_attack
        end
    end
    def assemble
        player_near? ? reveal_targets : return
        player_idle? ? draw_backdrop : interact
        special_properties
    end
    def harm
        # choose_your_weapon
        # player_attack_outcome
        puts Rainbow("	   - You move to strike the demon.").orange
        if player_chance
            player_hits_demon
            become_hostile if demon_is_alive
            demon_death_scene if demon_is_slain
        else player_misses_demon
            become_hostile
        end
    end
    def demon_attack
        if @hostile
            puts Rainbow("	   - The demon strikes to attack").orange
            unique_attack_script
            attack_outcome
        end
    end
    def attack_outcome
        if demon_chance
            total = @@player_stats[:heart] - damage_player(@profile[:attack])
            puts Rainbow("	   - It costs you #{total} heart points.\n").red
        else
            puts Rainbow("	   - You narrowly avoid its blow.\n").green
        end
    end
    def demon_death_scene
        if @profile[:hearts] == 0
            puts Rainbow("	   - The demon is slain. It drops:\n").purple
            list_rewards
            take_everything
            remove_from_board
            puts Rainbow("	   - You stuff the spoils of this").orange
            puts Rainbow("	     victory in your rucksack.\n").orange
        end
    end
    def list_rewards
        @content.each {|item| puts "	       - 1 #{item.targets[0]}"}
        puts "\n"
    end
    def take_everything
        @content.each { |item| item.push_to_inventory }
    end
end


