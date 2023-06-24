##############################################################################################################################################################################################################################################################
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require './board'

class Gamepiece < Board
  attr_accessor :location, :targets, :moveset, :profile, :player
  def initialize
    super
  end
  def draw_backdrop
    # Namespaced for hidden gamepieces.
  end
  def special_properties
    # Unique behavior at activation.
  end
  def remove_from_board
    @location = [0]
  end
  def teleport(new_plot)
    @location = new_plot
  end
  def reveal_targets
    @@player.sight |= targets
  end
  def player_near?
    @location.include?(@@player.position)
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
  def parse_action
    @@player.actions.each do |action, moves|
      send(action) if moves.include?(@@player.action)
    end
  end
  def activate
    special_properties
    player_near?  ? reveal_targets : return
    @@player.player_idle?  ? draw_backdrop : interact
  end
  def interact
    return if targets.none?(@@player.target)
    if moveset.include?(@@player.action)
      parse_action
    else
      wrong_move
    end
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
#####    TILES    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tiles < Fixture
  attr_accessor  :subtype, :built_of, :terrain, :borders, :general, :targets
  def initialize
    super
    @general = ["around","room","area","surroundings"] | subtype
    @borders = [["wall", "walls"],["floor","down", "ground"], ["ceiling","up","canopy"]]
    @terrain = ["terrain","medium","material"] | built_of
    @targets = (general + terrain + borders).flatten
  end
  def view
    overview
  end
  def special_properties
    @@map |= @location
  end
  def parse_action
    case @@player.target
    when *general
      @@player.toggle_idle
      overview
    when *terrain
      view_type
    when *borders[0]
      view_wall
    when *borders[1]
      view_down
    when *borders[2]
      view_above
    end
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
    @@player.items.push(self)
  end
end


##############################################################################################################################################################################################################################################################
#####     CONTAINERS     #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Container < Gamepiece
  attr_accessor :content, :needkey, :state
  def initialize
    super
    @state = "closed shut"
  end
  def moveset
    @moveset = MOVES[1] | MOVES[3]
  end
  def toggle_state_open
    @state = "jammed open"
  end
  def view
  	puts "	   - This #{targets[0]} is #{state}.\n\n"
  end
  def key
    @@player.items.find {|i| i.is_a?(Lockpick) or i.is_a?(Key)}
  end
  def open
    if @state == "closed shut"
      !needkey ? give_content : is_locked
    else
      puts "	   - This #{targets[0]}'s already open.\n\n"
    end
  end
  def use_key
    key.profile[:lifespan] -= 1
    key.break_item
  end
  def is_locked
    if key.nil?
      puts "	   - It won't open. It's locked.\n\n"
    else
      puts "	   - You twirl a #{key.targets[0]} in the"
      print "	     #{targets[0]}'s latch. "
      print Rainbow("Click.\n\n").orange
      use_key
      give_content
    end
  end
  def animate_opening
    puts Rainbow("           - It swings open and reveals a").cyan
    puts Rainbow("             hidden #{content.targets[0]}.\n").cyan
    toggle_state_open
  end
  def give_content
    animate_opening
    content.take
  end
end


##############################################################################################################################################################################################################################################################
#####    COMBUSTIBLES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Burnable < Portable
  def moveset
    MOVES[1..2].flatten + MOVES[9]
  end
  def fire_near?
    @@player.sight.none?("fire")
  end
  def out_of_fuel
    puts "	    - You're out of lighter fuel.\n\n"
  end
  def got_fuel?
    if @@player.search_inventory(Fuel).nil?
      out_of_fuel
    else
      use_lighter
    end
  end
  def got_a_light?
    if @@player.search_inventory(Lighter).nil?
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
    fuel = @@player.search_inventory(Fuel)
    @@player.remove_from_inventory(fuel)
  end
  def burn
    if fire_near?
      got_a_light?
    else
      animate_combustion
      remove_from_board
    end
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
    @@player.gain_health(heal_amount)
    side_effects
  end
  def animate_ingestion
    puts Rainbow("	   - You eat the #{subtype[0]}, healing").orange
  	print Rainbow("	     #{heal_amount} heart").orange
    if heal_amount == 1
      print Rainbow(". ").orange
    else
      print Rainbow("s. ").orange
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
      @@player.remove_from_inventory(self)
    end
  end
  def heal_amount
    if @@player.health + profile[:hearts] > 4
      (4 - @@player.health)
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
#####    DRINK    ############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Drink < Edible
  def targets
  	subtype | ["drink"]
  end
  def moveset
  	[MOVES[1..2],MOVES[10..11]].flatten
  end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT TREES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class FruitTree < Edible
    def initialize
      super
      @count = 666
      @stock = []
      @fruit = []
      fill_stock
    end
    def grow_fruit
      if @@page % 30 == 0
        @fruit.push(@stock[0])
        @stock.shift
      end
    end
    def special_properties
      @fruit.count < 3 && grow_fruit
    end
    def be_patient
      puts "	   - The fruit needs time to grow.\n\n"
      @@player.toggle_idle
    end
    def take
      if @fruit.count > 0
        @fruit[0].take
        @fruit.shift
      else
        be_patient
      end
    end
    def feed
      puts "	   - You can't eat fruit that you"
      puts "	     haven't yet harvested.\n\n"
      take
    end
    def view
      description
      view_profile
      print "\n"
      be_patient if @fruit.count < 1
    end
  end


##############################################################################################################################################################################################################################################################
#####    TOOLS     ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Tool < Portable
  def moveset
  	MOVES[1..2].flatten | MOVES[14]
  end
  def targets
    subtype | ["tool"]
  end
  def equip
    puts "	   - This item will automatically"
    puts "	     apply in its time of need.\n\n"
  end
  def break_item
    if profile[:lifespan] == 0
      puts Rainbow("	   - Your #{targets[0]} snaps in two.").red
      puts Rainbow("	     You toss away the pieces.\n").red
      @@player.remove_from_inventory(self)
      @@player.clear_weapon
    end
  end
  def draw_backdrop
  	puts "	   - A #{targets[0]} lays here.\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    WEAPONS    ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Weapon < Tool
  def targets
    subtype | ["weapon"]
  end
  def equip
    self.push_to_inventory if @@player.items.none?(self)
    view
    puts Rainbow("	   - You equip the #{targets[0]}.\n").orange
    @@player.weapon = self
  end
end


##############################################################################################################################################################################################################################################################
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Pullable < Gamepiece
  attr_accessor :content
  def initialize
    super
    @moveset = MOVES[1] | MOVES[5]
    @unpulled = true
  end
  def special_properties
    content.activate if !@unpulled
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
  attr_accessor :hostile, :desires, :content, :friends, :subtype, :territory
  def initialize
    super
    @moveset = MOVES[1] | MOVES[6..8].flatten
    @hostile = false
    @friends = false
    @territory = territory
    @desires = desires
  end
  def targets
    subtype | ["character","person"]
  end
  def demon_is_alive
    @profile[:hearts] > 0
  end
  def demon_is_slain
    @profile[:hearts] < 1
  end
  def draw_backdrop
    if @hostile
      puts "	   - A violent #{subtype[0]} stalks you.\n\n"
    else
      docile_backdrop
    end
  end
  def become_hostile
    if !@hostile
      @hostile = true
      hostile_script
      @location = @territory
    end
  end
  def become_friends
    @hostile = false
    @friends = true
  end
  def player_has_leverage
    @@player.items.find do |item|
      item.targets == desires.targets
    end
  end
  def talk
    if @hostile
      puts "	   - You cannot reason with it.\n\n"
    else
        conversation
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
    print Rainbow("	   - Yes / No  ").cyan
    print Rainbow(">>  ").purple
    choice = gets.chomp
    print "\n"
    bartering_outcome(choice)
  end
  def bartering_outcome(choice)
    if ["yes","yeah","sure","yep","aye"].include?(choice)
      exchange_gifts
    else
      become_hostile
    end
  end
  def exchange_gifts
    reward_animation
    reward = @rewards.sample
    puts "	   - To help you on your journey,"
    puts "	     you're given 1 #{reward.targets[0]}.\n\n"
    reward.take
    @rewards.delete(reward)
    @content.push(@desires)
    @@player.remove_from_inventory(player_has_leverage)
    become_friends
  end
  def demon_chance
    rand(@profile[:focus]..2) == 2
  end
  def damage_player_weapon
    if @@player.weapon_equipped?
      @@player.weapon.profile[:lifespan] -= 1
      @@player.weapon.break_item
    end
  end
  def player_damage
    if @@player.weapon_equipped?
      @@player.weapon.profile[:damage]
    else 1
    end
  end
  def player_hits_demon
    @profile[:hearts] -= player_damage
    if @profile[:hearts] > 0
      print Rainbow("	   - You hit it. #{@profile[:hearts]} heart").green
      print Rainbow("s").green if @profile[:hearts] > 1
      print Rainbow(" remain").green
      print Rainbow("s").green if @profile[:hearts] == 1
      print Rainbow(".\n\n").green
      damage_player_weapon
    end
  end
  def player_misses_demon
    puts Rainbow("	   - The demon dodges your attack.\n").red
  end
  def special_properties
    @profile[:hostile] = @hostile
    if demon_is_alive
      demon_attack
    end
  end
  def activate
    player_near? ? reveal_targets : return
    @@player.player_idle? ? draw_backdrop : interact
    special_properties
  end
  def player_attack_result
    if @@player.accuracy_level > 2
      player_hits_demon
      become_hostile if demon_is_alive
      demon_death_scene if demon_is_slain
    else player_misses_demon
      become_hostile
    end
  end
  def harm
    puts "	   - You move to strike the demon"
    print "	     with your "
    if @@player.weapon_equipped?
      print(Rainbow("#{@@player.weapon.targets[0]}.\n\n").purple)
    else print(Rainbow("bare hands.\n\n").purple)
    end
    player_attack_result
  end
  def demon_attack
    if @hostile
      puts "	   - The #{subtype[0]} strikes to attack"
      print "	     with its "
      print Rainbow("#{demon_weapon_equipped?.targets[0]}.\n\n").purple
      attack_outcome
    end
  end
  def demon_weapon_equipped?
    if @weapons[0]
      @weapons[0]
    else
      "bare hands.\n\n"
    end
  end
  def demon_damage
    if @weapons[0]
      @weapons[0].profile[:damage]
    else
      1
    end
  end
  def player_defense
    if @@player.armor
      puts Rainbow("	     Your #{@@player.armor.targets[0]} absorbs #{@@player.armor.profile[:defense]}.").cyan
      @@player.armor.profile[:lifespan] -= @@player.armor.profile[:defense]
    end
    print "\n"
  end
  def attack_outcome
    if demon_chance
      total = @@player.health - @@player.lose_health(demon_damage)
      print Rainbow("	   - It costs you #{total} heart point").red
      total > 1 ? print(Rainbow("s.\n").red) : print(Rainbow(".\n").red)
      player_defense
    else
      puts Rainbow("	   - You narrowly avoid its blow.\n").green
    end
  end
  def demon_death_scene
    if @profile[:hearts] < 1
      puts Rainbow("	   - The demon is slain. It drops:\n").cyan
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




##############################################################################################################################################################################################################################################################
#####     ALTAR     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Altar < Gamepiece
    attr_accessor :desires, :gate
    def initialize
      super
      @moveset = MOVES[1] | MOVES[6..7].flatten
      @desires = desires
    end
    def talk
        view
    end
    def targets
      ["altar","shrine"]
    end
    def draw_backdrop
        puts "	   - You stand before a sinister"
        puts "	     altar cut from black marble.\n\n"
    end
    def crafting_menu
        case
        when @@player.all_item_types.count(Key) > 1
          print Rainbow("	   - A single lockpick.\n").orange
        when (@@player.all_item_types & [Silver, Gem]).size == 2
          print("	   - Silver Ring.")
        when (@@player.all_item_types & [Gold, Gem]).size == 2
          print("	   - Golden Ring.")
        when (@@player.all_item_types & [Rubber, Leather, Silk]).size == 3
          print("	   - Durable Sneakers.")
        when (@@player.all_item_types & [Silver, Leather, Silk]).size == 3
          print("	   - Durable Hoodie.")
        when (@@player.all_item_types & [Branch, Feather, Gem]).size == 3
          print("	   - Magick Staff.")
        when (@@player.all_item_types & [Water, Ash, PurpleFlower]).size == 3
          print("	   - Demon Tonic.")
        when (@@player.all_item_types & [Water, Apple, RedFlower]).size == 3
          print("	   - Health Elixir.")
        else
          print Rainbow("	     nothing. wretched beggar. \"\n").red
        end
    end
    def craft_new_inventory
        print Rainbow("	   \" What does the sinner want?\n").red
        print Rainbow("	     Speak the thing you seek. \"\n").red
        print Rainbow("\n	   - Choose / Options").cyan

        print Rainbow("  >>  ").purple

        choice = gets.chomp.downcase
        if ["help","assist","menu","options"].include?(choice)
            print Rainbow("\n	   \" You own materials to make:\n\n").red
            crafting_menu
        else
           # start_building
        end
    end
    def pray_to_ascend
        if @@player.search_inventory(@desires.class)
            puts "	   - The altar accepts the #{@desires.targets[0]}.\n"
        else
            puts "	   - The altar requires a #{@desires.targets[0]}.\n"
        end
    end
    def perform_transaction
        choice = gets.chomp.downcase
        print "\n"
        if ["pray","sacrifice"].include?(choice)
            pray_to_ascend
        elsif ["craft","build","make"].include?(choice)
            craft_new_inventory
        end
        print "\n"
        puts "	   - The altar releases you from"
        puts "	     its grip. You stand up.\n\n"

    end
    def view
        puts "	   - You feel compelled to kneel.\n"
        puts "	     Will you pray, or craft?\n"
        print Rainbow("\n	   - Pray / Craft").cyan
        print Rainbow("  >>  ").purple
        perform_transaction
    end
end


