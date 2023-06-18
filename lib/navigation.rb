##############################################################################################################################################################################################################################################################
#####    NAVIGATION    #######################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################


require_relative 'interface'

module Navigation
  def directions
    ["north","south","east","west"]
  end
  def load_directions
    @sight | directions
  end
  def direction
    {
      directions[0] => [0, 1],
      directions[1] => [0,-1],
      directions[2] => [1, 0],
      directions[3] => [-1,0]
    }
  end
  def directed_movement
    @position[1] += direction[@target][0]
    @position[2] += direction[@target][1]
  end
  def activated_barrier
    @position[1] -= direction[@target][0]
    @position[2] -= direction[@target][1]
  end
  def no_direction_detected
    print Rainbow("	   - Move ").cyan
    print "one adjacent tile using\n"
    print Rainbow("	     north").orange + ", "
    print Rainbow("south").orange + ", "
    print Rainbow("east").orange + ", or "
    print Rainbow("west").orange + ".\n\n"
  end
  def detect_direction
    if directions.include?(@target)
      reposition_player
    else
      no_direction_detected
    end
  end
  def detect_movement
    if MOVES[0].include?(@action)
      load_directions
      detect_direction
    end
  end
  def reposition_player
    directed_movement
    if Board.world_map.include?(@position)
      animate_movement
    else
      activated_barrier
      the_way_is_blocked
    end
  end
  def animate_movement
    print "	   - You move #{@target} to "
    print Rainbow(	     "[ #{@position[1]} , #{@position[2]} ]").orange
    print ".\n\n"
  end
  def the_way_is_blocked
    puts "	   - The #{@target}ern way is blocked."
    puts "	     One page passes in vain.\n\n"
  end
end