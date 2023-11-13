

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
    def armor_name
        if @armor != nil
            Rainbow("#{@armor.targets[0]}").orange
        else Rainbow("bare skin").orange
        end
    end
    def attack_points
        if weapon_equipped?
            @weapon.profile[:damage]
        else 1
        end
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
    def display_defense
        if armor_equipped?
            print "	   - Your #{armor_name} deflects "
            print Rainbow("#{@armor.profile[:defense]}").green
            print " damage\n"
            print "	     points. Its lifespan wanes.\n\n "
        end
      end
    def cooldown_effects
        def display_clock(clock_name)
            puts Rainbow("	   - The magick that affects your").red
            puts Rainbow("	     #{clock_name} grows thin.\n").red
        end
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









































