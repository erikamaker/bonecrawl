

module Battle
    def weapon_equipped?
        @weapon != nil
    end
    def armor_equipped?
        @armor != nil
    end
    def weapon_name
        if @weapon != nil
            Rainbow("#{@weapon.targets[0]}").orange
        else Rainbow("bare hands").orange
        end
    end
    def attack_points
        if weapon_equipped?
            weapon.profile[:damage]
        else 1
        end
    end
    def defense_points
        if armor_equipped?
            [(@armor.profile[:defense] + @block_clock),4].min
        else 0 + [block_clock,4].min
        end
    end
    def battle
        player_turn
        enemy_turn
    end
    def degrade_weapon
        if weapon_equipped?
            @weapon.damage_item
            @weapon.break_item
        end
    end
    def degrade_armor
        if armor_equipped?
            @armor.damage_item
            @armor.break_item
        end
    end
    def player_turn
        if rand(@@player.focus..4) > 2
            puts "	   - You move to strike with your"
            puts @@player.weapon_name
            puts ".\n\n"
            @@player.degrade_weapon
            @profile[:health] -= @@player.attack_points
            demon_animate_damage
            play_death_scene if slain
        else puts Rainbow("	   - The #{targets[0]} dodges your attack.\n\n").red
            ## CHANCE OF DEMON PARRY
        end
    end
    def enemy_turn
        become_hostile if alive?
        if rand(@profile[:focus]..4) > 3
            puts "	   - The #{targets[0]} lunges to attack"
            print "	     with its "
            puts @weapon_name
            puts ".\n\n"
            @@player.lose_health(attack_power)
            @@player.degrade_armor
        else puts Rainbow("	   - You narrowly avoid its blow.\n").green
            ## CHANCE OF PARRY
        end
    end
    def demon_animate_damage
        if alive?
            SoundBoard.hit_enemy
            print Rainbow("	   - #{@profile[:hearts]} heart").green
            print Rainbow("s").green if @profile[:hearts] > 1
            print Rainbow(" remain").green
            print Rainbow("s").green if @profile[:hearts] == 1
            print Rainbow(".\n\n").green
        end
        if slain
            puts Rainbow("	   - The #{targets[0]} perishes. It drops:\n").cyan
            @content.each {|item| puts "	       - 1 #{item.targets[0]}"}
            puts "\n"
            puts Rainbow("	   - You stuff the spoils of this").orange
            puts Rainbow("	     victory in your rucksack.\n").orange
            lose_all_items
            remove_from_board
        end
    end
    def player_animate_damage
        if @@player.alive?
            damage_done = @@player.lose_health(self.attack_points)
            if @@player.armor_equipped?
                print "	   - Your #{@@player.armor_name} deflects "
                print Rainbow("#{@@player.armor.profile[:defense]}").green
                print " damage\n"
                print "	     points. Its lifespan wanes.\n\n "
            end
            puts "	   - The damage costs you a total"
            print "	     of #{Rainbow(damage_done).red} heart point"
            damage_done != 1 ? print("s.\n\n") : print(".\n\n")
            SoundBoard.take_damage
        end
    end
    def display_clock(clock_name)
        puts Rainbow("	   - The magick that affects your").red
        puts Rainbow("	     #{clock_name} grows thin.\n").red
    end
    def cooldown_effects
        if @focus_clock > 0
          @focus_clock -= 1
          display_clock("focus") if @focus_clock == 1
        end
        if @block_clock > 0
          @block_clock -= 1
          display_clock("defense") if @block_clock == 1
        end
        if @curse_clock > 0
          @curse_clock -= 1
          display_clock("possession") if @curse_clock == 1
        end
    end
end









































