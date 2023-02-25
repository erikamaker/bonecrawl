############################################################################################################################################################################################################################################################## 
#####    TILES    ############################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Tiles < Fixture	
	attr_accessor  :subtype, :built_of, :terrain, :borders, :general, :targets
	def initialize
		@general = ["around","room","area","surroundings"] | subtype
		@general = general
		@borders = [["wall", "walls"],["floor","down", "ground"], ["ceiling","up","canopy"]]
		@terrain = ["terrain","medium","material"] | built_of
		@targets = (general + terrain + borders).flatten
	end
    def view
        overview
    end
    def load_special_properties
        @@world |= minimap 
        @@sight.include?("vein") and moveset | MOVES[12]
    end
	def parse_action 
		case @@target
		when *general
            @@state = :backdrop
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
#####    BRICKS    ###########################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 

	
class Bricks < Tiles												
	def built_of
		["brick","bricks","block","blocks"]
	end
	def view_type														 								 																					
		puts "	   - The weathered bricks look to"		 																															 	
		puts "	     to be cut from solid rock.\n\n"	
	end
	def view_wall		
		puts "	   - The walls are built of bricks"																			 
		puts "	     cobbled haphazardly together.\n\n"		
	end
	def view_down																																												
		puts "	   - The cobbled floor is stained"																			
		puts "	     with either soot or dirt.\n\n"	
	end
	def view_above																																																				
		puts "	   - The cobbled ceiling is burnt"																			
		puts "	     black with torch smoke.\n\n"	
	end		
end


class Dungeon < Bricks
	def subtype 
		subtype = ["jail","dungeon","cell"] 
	end
	def backdrop
		puts "	   - You're in a cold prison cell."        ## A preset, feel free to change in the main runner file. 
		puts "	     It's dark and mostly empty.\n\n"
	end
end


class Corridor < Bricks
	def subtype 
		subtype = ["tunnel","corridor","hall"] 
	end
	def backdrop
		puts "	   - You're in a cramped corridor"        ## Another preset. These are always suggestions for the main
		puts "	     made of dark cobbled bricks.\n\n"           ## screen player views when idle in the environment. 
	end
end


############################################################################################################################################################################################################################################################## 
#####    ROCKS    ############################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class WarmRocks < Tiles												
	def built_of
		built_of = ["rock","rocks","geodes","earth","stone","stones"]
	end
	def view_type	
		puts "	   - The cavern walls radiate with"																																			 	
		puts "	     a pale green light somehow.\n\n"	
	end
	def view_wall																							 																																														
		puts "	   - The cave walls are smooth and"																			 
		puts "	     glimmer. They feel warm. \n\n"		
	end
	def view_down																																										
		puts "	   - The cave floor's been eroded"																			
		puts "	     smooth by the passing eons.\n\n"	
	end
	def view_above																																																				
		puts "	   - The cavern ceiling looms low"																			
		puts "	     above your head.\n\n"	
	end		
end


class WarmCave < WarmRocks
	def subtype
		subtype = ["cavern","cave","underground"]
	end
	def backdrop
		puts "	   - You're in an ancient cavern."
		puts "	     It's pleasantly warm.\n\n"
	end
end


class Grotto < WarmCave
	def subtype 
		subtype = ["cave","cavern","spring","pool","sauna","grotto"]
	end
	def backdrop
		puts "	   - You're in a gleaming grotto"
		puts "	     with a simmering spring.\n\n"
	end
end


############################################################################################################################################################################################################################################################## 
#####    FIRE SOURCES    #####################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Fire < Fixture
	def initialize
		@targets = ["fire","light","flame","flames"] | subtype
	end
end

class Torch < Fire
	def subtype
		["torch", "iron torch", "black torch", "metal torch"]
	end	
	def backdrop	
		puts "	   - A black torch is bolted into"
		puts "	     the wall. Its flame smolders.\n\n"
	end
	def view
		puts "	   - The red fire dances, casting"
		puts "	     wild shadows on the walls.\n\n"
	end
end

class Fireplace < Fire
	def subtype
		["fireplace", "grate", "coals", "coal", "hearth"]
	end	
	def backdrop
		puts "	   - Hot coals smolder in an iron"
		puts "	     grate built into of the wall.\n\n"
	end
	def view
		puts "	   - You warm your hands and toes"
		puts "	     at the fire. It's nice.\n\n"
        @@heart = 4
    end
end


############################################################################################################################################################################################################################################################## 
#####    HOOK    #############################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Hook < Fixture
    def initialize
        @targets = ["hook","rusty hook","metal hook"]
    end
    def backdrop
        puts "	   - A rusty hook juts out of the"
        puts "	     masonry where you stand.\n\n" 
    end
    def view
        puts "	   - It looks sinister. Intuition"
        puts "	     tells you the goblins use it"
        puts "	     to hang more than just coats"
        puts "	     and keys.\n\n"
        @@state = :backdrop
    end
end


############################################################################################################################################################################################################################################################## 
#####    SURFACES    #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Surface < Fixture
	def initialize
		@targets = ["surface"] | subtype
	end
    def view
        subtype_view
        @@state = :backdrop
    end
end

class Table < Surface
	def subtype
		["table","stone table","tabletop"]
	end	
	def backdrop
		puts "	   - You stand before a humungous"
		puts "	     table made of solid rock.\n\n"
	end
	def subtype_view
		puts "	   - Its rocky top rises to meet"
		puts "	     you at your neck.\n\n"
	end
end

class Shelf < Surface
	def subtype
		["shelf","wooden shelf"]
	end	
	def backdrop
		puts "	   - You stand at a wooden shelf."
		puts "	     It's just within your reach.\n\n"
	end
	def subtype_view
        puts "	   - The wood is gnarled and old."
		puts "	     It's scarred by many years.\n\n"
	end
end

class Slab < Surface
	def subtype
		["grave","grave slab","gravestone","headstone"]
	end	
	def backdrop
		puts "	   - You stand near a gravestone"
		puts "	     sticking out of the ground.\n\n"
	end
	def subtype_view
		puts "	   - It's made of crumbling rock."
		puts "	     The inscription has eroded.\n\n"
	end
end


