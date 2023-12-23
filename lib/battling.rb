##############################################################################################################################################################################################################################################################
#####    BATTLE    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


module Battle
    def is_alive
        @health > 0
    end
    def is_slain
        @health < 1
    end
    def weapon_equipped
        @weapon != nil
    end
    def armor_equipped
        @armor != nil
    end
    def weapon_name
        if @weapon != nil
            Rainbow("#{@weapon.targets[0]}").orange
        else Rainbow("bare hands").orange
        end
    end
    def armor_name
        if @armor != nil
            Rainbow("#{@armor.targets[0]}").orange
        else Rainbow("bare skin").orange
        end
    end
    def attack_points
        if weapon_equipped
            total = @weapon.profile[:damage] + @level
            total
        else @level
        end
    end
    def damage_received(magnitude)
        if (magnitude - defense) > 0
            (magnitude - defense)
        else 0
        end
    end
    def defense
        if armor_equipped
            [(@armor.profile[:defense] + @stats_clock[:strength]),4].min
        else 0 + [@stats_clock[:strength],4].min
        end
    end
    def successful_hit
        focus_value = @focus.to_i  # Convert focus to integer as a safeguard

        rand(focus_value..4) > 3
    end
    def degrade_weapon
        if weapon_equipped
            @weapon.damage_item
            @weapon.break_item
        end
    end
    def degrade_armor
        if armor_equipped
            @armor.damage_item
            @armor.break_item
        end
    end
    def display_defense
        if armor_equipped
            print "	   - Your #{armor_name} deflects "
            print Rainbow("#{@armor.profile[:defense]}").green
            print " damage\n"
            print "	     points. Its lifespan wanes.\n\n "
        end
    end
    def animate_damage
        if is_alive
            SoundBoard.hit_enemy
            print Rainbow("	   - You hit it. #{@health} heart").green
            print Rainbow("s").green if @health > 1
            print Rainbow(" remain").green
            print Rainbow("s").green if @health == 1
            print Rainbow(".\n\n").green
        end
    end
    def lose_all_items
        @content.each { |item| item.push_to_player_inventory }
    end
    def animate_death
        if is_slain
            puts Rainbow("	   - You slay the #{targets[0]}. It drops:\n").cyan
            @content.each {|item| puts("	       - 1 #{item.targets[0]}") if item}
            puts "\n"
            puts Rainbow("	   - You stuff the spoils of this").orange
            puts Rainbow("	     victory in your rucksack.\n").orange
            puts Rainbow("	   - The slain flesh catches fire").purple
            puts Rainbow("	     and disappears forever.\n").purple
            lose_all_items
            remove_from_board
        end
    end
    def cooldown_effects
        if @stats_clock[:stunned] > 0
            @stats_clock[:stunned] -= 1
            display_clock("Stunned") if @stats_clock[:stunned] == 1
        end
        if @stats_clock[:cursed] > 0
            @stats_clock[:cursed] -= 1
            display_clock("Cursed") if @stats_clock[:cursed] == 1
        end
        if @stats_clock[:subdued] > 0
            @stats_clock[:subdued] -= 1
            display_clock("Subdued") if @stats_clock[:subdued] == 1
        end
        if @stats_clock[:infected] > 0
            @stats_clock[:infected] -= 1
            display_clock("Infected") if @stats_clock[:poisoned] == 1
        end
    end
end









































