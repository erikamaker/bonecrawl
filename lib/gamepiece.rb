##############################################################################################################################################################################################################################################################
#####    GAMEPIECE    ########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require './board'
require './sound'
require './gamepiece'

class Gamepiece < Board
  attr_accessor :location, :targets, :moveset, :profile
  def initialize
    super
  end
  def display_backdrop
    # Some pieces have unique backdrops.
    # Others may have none and return nil.
  end
  def execute_special_behavior
    # Unique behavior during activation.
    # E.G. Fruit trees can grow new fruit.
  end
  def remove_from_board
    @location = [0]
  end
  def teleport(new_plot)
    @location = new_plot
  end
  def reveal_targets_to_player
    @@player.sight |= targets
  end
  def player_near?
    @location.include?(@@player.position)
  end
  def view
    display_description
    display_profile
    print "\n"
  end
  def display_profile
    return if @profile.nil?
    @profile.each do |key, value|
      length = 25 - (key.to_s.length + value.to_s.length)
      dots = Rainbow(".").purple * length
      space = " " * 13
      value = value.to_s.capitalize
      puts space + "#{key.capitalize} #{dots} #{value}"
    end
  end
  def interpret_action
    Board.actions.each do |action, moves|
      send(action) if moves.include?(@@player.action)
    end
  end
  def activate
    execute_special_behavior
    player_near? ? reveal_targets_to_player : return
    @@player.state_idle? ? display_backdrop : interact
  end
  def wrong_move
    puts "	   - It would be uesless to try."
    puts "	     A page passes in vain.\n\n"
  end
  def interact
    return if targets.none?(@@player.target)
    if moveset.include?(@@player.action)
      interpret_action
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
  attr_accessor  :subtype, :composition, :terrain, :borders, :general, :targets
  def initialize
    super
    @general = ["around","room","area","surroundings"] | subtype
    @borders = [["wall", "walls"],["floor","down", "ground"], ["ceiling","up","canopy"]]
    @terrain = ["terrain","medium","material"] | composition
    @targets = (general + terrain + borders).flatten
  end
  def view
    overview
  end
  def execute_special_behavior
    @@map |= @location
  end
  def interpret_action
    case @@player.target
    when *general
      @@player.toggle_state_idle
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
  def wrong_move
    print "	   - This portable object can be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("taken").cyan + ".\n\n"
  end
  def take
    self.view
    puts Rainbow("	   - You take the #{targets[0]}.\n").orange
    push_to_player_inventory
    SoundBoard.found_item
  end
  def push_to_player_inventory
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
    @state = :"closed shut"
    @needkey = false
  end
  def moveset
    @moveset = MOVES[1] | MOVES[3]
  end
  def toggle_state_open
    @state = :"jammed open"
  end
  def view
  	puts "	   - This #{targets[0]} is #{state}.\n\n"
  end
  def key
    @@player.items.find {|i| i.is_a?(Lockpick) or i.is_a?(Key)}
  end
  def open
    if @state == :"closed shut"
      @needkey ? is_locked : give_content
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
  def wrong_move
    print "	   - This container can only be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("opened").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    COMBUSTIBLES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Burnable < Portable
  def moveset
    MOVES[1..2].flatten + MOVES[9]
  end
  def fuel
      @@player.items.find { |item| item.is_a?(Fuel) }
    end
  def fire_near?
    @@player.sight.include?("fire")
  end
  def burn
    if fire_near?
      unique_burn_screen
      remove_from_board
    elsif @@player.search_inventory(Lighter)
      use_lighter
    else
      puts "	   - There's isn't any fire here.\n\n"
    end
  end
  def use_fuel
      puts "	   - You thumb a little fuel into"
      puts "	     your lighter's fuel canister."
      puts "	     It sparks a warm flame.\n\n"
      @@player.remove_from_inventory(fuel)
  end
  def use_lighter
    if @@player.search_inventory(Fuel)
      use_fuel
      unique_burn_screen
      remove_from_board
    else
      puts "	   - You're out of lighter fuel.\n\n"
    end
  end
  def wrong_move
    print "	   - This burnable object can be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("burned").cyan + ".\n\n"
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
    display_remaining_portions
    @@player.gain_health(heal_amount)
    activate_side_effects
  end
  def animate_ingestion
    puts Rainbow("	   - You eat the #{subtype[0]}, healing").orange
  	print Rainbow("	     #{heal_amount} heart").orange
    print Rainbow("#{heal_amount == 1 ? '.' : 's.'} ").orange
  end
  def remove_portion
    profile[:portions] -= 1
  end
  def display_remaining_portions
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
  def activate_side_effects
    # Reserved for foods or drinks that affect
    # player's stats in some way. See presets.
  end
  def wrong_move
    print "	   - This food item can only be\n"
    print Rainbow("	     viewed").cyan + " or "
    print Rainbow("ingested").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    LIQUID    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Liquid < Edible
  def targets
  	subtype | ["drink","liquid","fluid"]
  end
  def moveset
  	[MOVES[1..2],MOVES[10..11]].flatten
  end
  def drink
    feed
  end
  def animate_ingestion
    puts Rainbow("	   - You drink the #{subtype[0]}, healing").orange
  	print Rainbow("	     #{heal_amount} heart").orange
    print Rainbow("#{heal_amount == 1 ? '.' : 's.'} ").orange
  end
  def wrong_move
    print "	   - This liquid item can only be\n"
    print Rainbow("	     taken").cyan + " or "
    print Rainbow("ingested").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####    FRUIT TREES    ######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class FruitTree < Edible
  def initialize
    super
    @count = 999
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
  def execute_special_behavior
    @fruit.count < 3 && grow_fruit
  end
  def fruit_needs_time_to_grow
    puts "	   - The fruit needs time to grow.\n\n"
    @@player.toggle_state_idle
  end
  def take
    if @fruit.count > 0
      @fruit[0].take
      @fruit.shift
    else
      fruit_needs_time_to_grow
    end
  end
  def feed
    puts "	   - You can't eat fruit that you"
    puts "	     haven't harvested.\n\n"
    take
  end
  def view
    display_description
    display_profile
    print "\n"
    fruit_needs_time_to_grow if @fruit.count < 1
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
  def damage_item
    profile[:lifespan] -= 1
  end
  def break_item
    if profile[:lifespan] == 0
      puts Rainbow("	   - Your #{targets[0]} snaps in two.").red
      puts Rainbow("	     You toss away the pieces.\n").red
      @@player.remove_from_inventory(self)
      @@player.clear_weapon
    end
  end
  def display_backdrop
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
    SoundBoard.equip_item
    self.push_to_player_inventory if @@player.items.none?(self)
    view
    puts Rainbow("	   - You equip the #{targets[0]}.\n").orange
    @@player.weapon = self
  end
  def wrong_move
    print "	   - This weapon can be"
    print Rainbow(" examined").cyan + ",\n"
    print Rainbow("	     taken").cyan + ", or "
    print Rainbow("equipped").cyan + ".\n\n"
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
    @pulled = false
  end
  def execute_special_behavior
    content.activate if @pulled == true
  end
  def toggle_state_pulled
    @pulled = true
  end
  def pull
  	unless @pulled
  	  reveal_secret
      toggle_state_pulled
  	else
      puts "	   - It appears that somebody has\n"
  	  puts "	     already pulled this #{targets[0]}.\n\n"
  	end
  end
  def wrong_move
    print "	   - This pull switch can only be\n"
    print Rainbow("	     examined").cyan + ", or "
    print Rainbow("pulled").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     CHARACTERS     #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Character < Gamepiece
  attr_accessor :regions, :desires, :content, :rewards
  def initialize
    super
    @moveset = (MOVES[1] + MOVES[6] + MOVES[8]).flatten
    @hostile = false
    @passive = false
    @demonic = false
  end
  def targets
    subtype | ["character","person","npc"]
  end
  def focus_level
    rand(@profile[:focus]..2)
  end
  def alive?
    @profile[:hearts] > 0
  end
  def slain?
    @profile[:hearts] < 1
  end
  def material_leverage
    @@player.items.find do |item|
      item.targets == desires.targets
    end
  end
  def display_backdrop
    if @hostile
      puts "	   - A violent #{subtype[0]} stalks you.\n\n"
    else
      docile_backdrop
    end
  end
  def become_hostile
    unless @hostile
      @hostile = true
      @location = @regions
      hostile_script
    end
  end
  def become_passive
    @hostile = false
    @passive = true
  end
  def update_profile
    @profile[:hostile] = @hostile
  end
  def reverse_curse
    @@player.curse_clock > 0 && @@player.curse_clock = 1
  end
  def execute_special_behavior
    update_profile
    if @hostile && alive?
      attack_player
    end
  end
  def activate
    player_near? ? reveal_targets_to_player : return
    @@player.state_idle? ? display_backdrop : interact
    execute_special_behavior
  end
  def talk
    if @hostile
      puts "	   - You cannot reason with it.\n\n"
    else
      conversation
    end
  end
  def conversation
    if @passive
        passive_script
    else business_as_usual
    end
  end
  def business_as_usual
    default_script
    barter if material_leverage
  end
  def barter
    unique_bartering_script
    print Rainbow("	   - Yes / No  ").cyan
    print Rainbow(">>  ").purple
    choice = gets.chomp.downcase.gsub(/[[:punct:]]/, '')
    print "\n"
    bartering_outcome(choice)
  end
  def bartering_outcome(choice)
    if AFFIRMATIONS.include?(choice)
      exchange_gifts
    else
        puts "	   - It doesn't look too thrilled.\n\n"
        become_hostile if rand(1..3) == 3
    end
  end
  def exchange_gifts
    reward_animation
    reward = @rewards.sample
    puts "	   - To help you on your journey,"
    puts "	     you're given 1 #{reward.targets[0]}.\n\n"
    reward.take
    @content = @weapons
    @content.push(@desires)
    @@player.remove_from_inventory(material_leverage)
    become_passive
  end
  def weapon_equipped?
    if @weapons[0]
      @weapons[0]
    else
      "bare hands.\n\n"
    end
  end
  def attack_power
    if @weapons[0]
      @weapons[0].profile[:damage]
    else 1
    end
  end
  def curse_chance
    rand(1..3)
  end
  def curse_duration
    rand(5..10)
  end
  def battle
    @@player.move_to_attack
    retaliate
  end
  def retaliate
    if @@player.focus_level > 2 || @@player.curse_clock > 0
      take_damage
      become_hostile if alive?
      play_death_scene if slain?
    else
      dodge_player_attack
      become_hostile
    end
  end
  def take_damage
    if @@player.curse_clock > 0
        puts Rainbow("	   - The demon's curse is strong.").red
        puts Rainbow("	     You struggle to fight it.\n").red
        violent_possession
        return
    end
    player_successful_hit
  end
  def violent_possession
    def damage_done
        @@player.damage_endured(@@player.attack)
    end
    if rand(1..3) == 3
        puts "	   - Horrified, you watch it turn"
        puts "	     and attack your own body.\n\n"
        damage_player
    else player_successful_hit
    end
  end
  def player_successful_hit
    @profile[:hearts] -= @@player.attack
    if @profile[:hearts] > 0
      SoundBoard.hit_enemy
      print Rainbow("	   - You hit it. #{@profile[:hearts]} heart").green
      print Rainbow("s").green if @profile[:hearts] > 1
      print Rainbow(" remain").green
      print Rainbow("s").green if @profile[:hearts] == 1
      print Rainbow(".\n\n").green
      @@player.damage_weapon
      @@player.display_added_focus
    end
  end
  def dodge_player_attack
    puts Rainbow("	   - The beast dodges your attack.\n").red
  end
  def attack_player
    puts "	   - The #{subtype[0]} strikes to attack"
    print "	     with its "
    print Rainbow("#{weapon_equipped?.targets[0]}.\n\n").purple
    attack_outcome
  end
  def attack_outcome
    if focus_level == 2 or @@player.curse_clock > 0
      damage_player
      curse_player
    else
      puts Rainbow("	   - You narrowly avoid its blow.\n").green
    end
  end
  def damage_player
    def damage_done
      @@player.damage_endured(attack_power)
    end
    @@player.display_added_defense
    puts "	   - The attack costs you a total"
    print "	     of #{Rainbow(damage_done).red} heart point"
    damage_done != 1 ? print("s.\n\n") : print(".\n\n")
    @@player.health -= @@player.damage_endured(attack_power)
    SoundBoard.take_damage
  end
  def curse_player
    if !@demonic || @@player.curse_clock > 0
      return
    elsif curse_chance == 3
      display_curse_message
      @@player.curse_clock += curse_duration
    end
  end
  def display_curse_message
    puts Rainbow("	   - The demon manages to possess").red
    puts Rainbow("	     you for #{curse_duration} pages.\n").red
  end
  def play_death_scene
    if @profile[:hearts] < 1
      puts Rainbow("	   - The demon is slain. It drops:\n").cyan
      list_rewards
      lose_all_items
      puts Rainbow("	   - You stuff the spoils of this").orange
      puts Rainbow("	     victory in your rucksack.\n").orange
      reverse_curse
      remove_from_board
    end
  end
  def list_rewards
    @content.each {|item| puts "	       - 1 #{item.targets[0]}"}
    puts "\n"
  end
  def lose_all_items
    @content.each { |item| item.push_to_player_inventory }
  end
  def wrong_move
    print "	   - This character is capable of\n"
    print Rainbow("	     talking").cyan + ", or "
    print Rainbow("battling").cyan + ".\n\n"
  end
end


##############################################################################################################################################################################################################################################################
#####     ALTAR     ##########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


class Altar < Gamepiece
  attr_accessor :bone
  def initialize
    super
    @bone = bone
    @moveset = MOVES[1] | MOVES[6..7].flatten
    @lock_pick_stock = []
    @silver_ring_stock = []
    @gold_ring_stock = []
    @sneaker_stock = []
    @hoodie_stock = []
    @staff_stock = []
    @tonic_stock = []
    @juice_stock = []
    fill_stock
  end
  def fill_stock
    50.times do
      @lock_pick_stock.push(Lockpick.new)
      @silver_ring_stock.push(SilverRing.new)
      @gold_ring_stock.push(GoldRing.new)
      @sneaker_stock.push(Sneakers.new)
      @hoodie_stock.push(Hoodie.new)
      @staff_stock.push(Staff.new)
      @tonic_stock.push(Tonic.new)
      @juice_stock.push(Juice.new)
    end
  end
  def targets
    ["altar","shrine"]
  end
  def display_backdrop
    puts Rainbow("	   - You stand before a sinister").purple
    puts Rainbow("	     altar cut from black marble.\n").purple
  end
  def talk
    make
  end
  def display_description
    puts Rainbow("	   - It towers up to your chest.").purple
    puts Rainbow("	     Your ears ring a little.\n").purple
    wrong_move
  end
  def make
    print Rainbow("	   - You feel compelled to kneel.\n").red
    if any_materials? == true
        print Rainbow("	     The spirits offer a trade...\n\n").red
        crafting_menu
        print Rainbow("	   - Choose your worldly blessing\n").cyan
        print Rainbow("	     >> ").purple
        choice = gets.chomp.downcase.gsub(/[[:punct:]]/, '').split.last
        start_building(choice)
    else
        print Rainbow("	     You have nothing to offer.\n\n").red
    end
    print "	   - The altar releases you from\n"
    print "	     its grip. You stand up.\n\n"
  end
  def greedy_mortal_message
    print Rainbow("\n	   - Nothing comes from nothing.\n").red
    print Rainbow("	     You lack the materials.\n\n").red
  end
  def not_an_option
    print Rainbow("\n	   - The altar can only grant so\n").red
    print Rainbow("	     much. It can't make that.\n\n").red
  end
  def lock_pick_materials?
    @@player.all_item_types.count(Key) > 1
  end
  def silver_ring_materials?
    @@player.all_item_types.count(Silver) > 1
  end
  def gold_ring_materials?
    @@player.all_item_types.count(Gold) > 1
  end
  def sneaker_materials?
    (@@player.all_item_types & [Rubber,Leather]).size == 2
  end
  def hoodie_materials?
    (@@player.all_item_types & [Silver,Silk]).size == 2
  end
  def staff_materials?
    (@@player.all_item_types & [Branch,Feather]).size == 2
  end
  def tonic_materials?
    (@@player.all_item_types & [Water,PurpleFlower]).size == 2
  end
  def juice_materials?
    (@@player.all_item_types & [Water,RedFlower]).size == 2
  end
  def any_materials?
    materials = [
      lock_pick_materials?,
      staff_materials?,
      tonic_materials?,
      juice_materials?,
      hoodie_materials?,
      sneaker_materials?,
      gold_ring_materials?,
      silver_ring_materials?,
      @@player.search_inventory(@bone)
    ].any?
  end
  def crafting_menu
    if lock_pick_materials?
      print(Rainbow("	     + 1 Lock Pick\n").green)
      print("	        - 2 Keys\n\n")
    end
    if silver_ring_materials?
      print(Rainbow("	     + 1 Silver Ring\n").green)
      print("	        - 2 Silver\n\n")
    end
    if gold_ring_materials?
      print(Rainbow("	     + 1 Gold Ring\n").green)
      print("	        - 2 Gold\n\n")
    end
    if sneaker_materials?
      print(Rainbow("	     + 1 Rubber Sneakers\n").green)
      print("	        - 1 Rubber\n")
      print("	        - 1 Leather\n\n")
    end
    if hoodie_materials?
      print(Rainbow("	     + 1 Spider Silk Hoodie\n").green)
      print("	        - 1 Silk\n")
      print("	        - 1 Silver\n\n")
    end
    if staff_materials?
      print(Rainbow("	     + 1 Magick Staff\n").green)
      print("	        - 1 Branch\n")
      print("	        - 1 Feather\n\n")
    end
    if tonic_materials?
      print(Rainbow("	     + 1 Exorcist Tonic\n").green)
      print("	        - 1 Holy Water\n")
      print("	        - 1 Purple Flower\n\n")
    end
    if juice_materials?
      print(Rainbow("	     + 1 Heart juice\n").green)
      print("	       - 1 Holy Water\n")
      print("	       - 1 Red Flower\n\n")
    end
    if @@player.search_inventory(@bone)
      print Rainbow("	   - You conquered your demon. To\n").pink
      print Rainbow("	     leave this level, simply ask\n").pink
      print Rainbow("	     for ").pink
      print Rainbow("salvation").blue
      print Rainbow(".\n\n").pink
    end
  end
  def build_item(stock, materials)
    print "\n"
    stock[0].take
    stock.shift
    materials.each { |material| delete_material(material) }
  end
  def build_lock_pick
    build_item(@lock_pick_stock, ["key","key"])
  end
  def build_silver_ring
    build_item(@silver_ring_stock, ["silver","silver"])
  end
  def build_gold_ring
    build_item(@gold_ring_stock, ["gold","gold"])
  end
  def build_sneakers
    build_item(@sneaker_stock, ["rubber","leather"])
  end
  def build_hoodie
    build_item(@hoodie_stock, ["silk","silver"])
  end
  def build_staff
    build_item(@staff_stock, ["branch","feather"])
  end
  def build_tonic
    build_item(@tonic_stock, ["water","purple flower"])
  end
  def build_juice
    build_item(@Juice_stock, ["water","red flower"])
  end
  def delete_material(material)
    @@player.items.find { |item| item.targets.include?(material) && @@player.remove_from_inventory(item) }
  end
  def start_building(choice)
    case choice
    when *@lock_pick_stock[0].targets
      lock_pick_materials? ? build_lock_pick : greedy_mortal_message
    when *@silver_ring_stock[0].targets
      silver_ring_materials? ? build_silver_ring : greedy_mortal_message
    when *@gold_ring_stock[0].targets
      gold_ring_materials? ? build_gold_ring : greedy_mortal_message
    when *@sneaker_stock[0].targets
      sneaker_materials? ? build_sneakers : greedy_mortal_message
    when *@hoodie_stock[0].targets
      hoodie_materials? ? build_hoodie : greedy_mortal_message
    when *@staff_stock[0].targets
      staff_materials? ? build_staff : greedy_mortal_message
    when *@tonic_stock[0].targets
      tonic_materials? ? build_tonic : greedy_mortal_message
    when *@Juice_stock[0].targets
      juice_materials? ? build_juice : greedy_mortal_message
    when "salvation", "ascension", "freedom", "transcend"
      level_complete_screen
    else
      not_an_option
    end
  end
  def wrong_move
    print "	   - A sacrificial altar can be\n"
    print Rainbow("	     prayed to" ).cyan + ", or "
    print Rainbow("examined").cyan + ".\n\n"
  end
end