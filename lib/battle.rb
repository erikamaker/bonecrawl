

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
end









































