##############################################################################################################################################################################################################################################################
#####    BATTLE    ###########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


module Battle
    def weapon_damage
        weapon_damage = weapon_equipped ?
        Rainbow("-1 Use").magenta :
        Rainbow("N/A").magenta
    end
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
            capitalized_target = @weapon.targets[0].split.map(&:capitalize).join(' ')
            Rainbow(capitalized_target).orange
        else
            Rainbow("Bare Hands").orange
        end
    end

    def armor_name
        if @armor != nil
            capitalized_target = @armor.targets[0].split.map(&:capitalize).join(' ')
            Rainbow(capitalized_target).orange
        else
            Rainbow("Bare Skin").orange
        end
    end

    def armor_points
        Rainbow("#{@armor.profile[:defense]}").green
    end
    def type_bonus
        @upper_hand == true ? rand(2..3) : 0
    end
    def attack_points
        if weapon_equipped
            @weapon.profile[:damage] +
            type_bonus +
            @level +
            @stats_clock[:envigored]
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
            [(@armor.profile[:defense] + @stats_clock[:fortified]),4].min
        else 0 + [@stats_clock[:fortified],4].min
        end
    end
    def successful_hit
        focus_value = @focus.to_i
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
            print Rainbow("	   - Your #{armor_name} ").cyan
            print Rainbow("deflects #{armor_points} ").cyan
            print Rainbow("damage\n	     points. Its lifespan wanes.\n\n").cyan
        end
    end
    def lose_all_items
        @content.each { |item| item.push_to_player_inventory }
    end
    def animate_death
        if is_slain
            puts Rainbow("	   - You slay the #{targets[0]}, earning:\n").cyan
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
        elsif @stats_clock[:cursed] > 0
            @stats_clock[:cursed] -= 1
        elsif @stats_clock[:subdued] > 0
            @stats_clock[:subdued] -= 1
        elsif @stats_clock[:infected] > 0
            @stats_clock[:infected] -= 1
        elsif @stats_clock[:fortified] > 0
            @stats_clock[:fortified] -= 1
        elsif @stats_clock[:stimulated] > 0
            @stats_clock[:stimulated] -= 1
        elsif @stats_clock[:envigored] > 0
            @stats_clock[:envigored] -= 1
        end
    end
end
