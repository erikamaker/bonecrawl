############################################################################################################################################################################################################################################################## 
#####     PULL SWITCHES     ##################################################################################################################################################################################################################################
############################################################################################################################################################################################################################################################## 


class Lever < Pullable
    def targets 
        ["lever","handle","switch"]
    end
    def load_special_properties
        content.assemble if @@check.include?(self)
    end
	def backdrop													
		puts "	   - An iron lever juts out from"					
		puts "	     the wall where you stand.\n\n"				
	end
	def view
		if @@check.none?(self)									
			puts "	   - This lever isn't pulled yet."			
			puts "	     It could do anything.\n\n"	
		else puts "	   - It's stuck down and locked.\n\n"
		end
	end
end	

class Rope < Pullable
    def targets 
        ["rope","twine","switch"]
    end
    def load_special_properties
        content.assemble if @@check.include?(self)
    end
	def backdrop
        puts "	   - A frayed rope dangles above"															
        puts "	     where you stand. It's huge.\n\n"				
	end
	def view
		if @@check.none?(self)									
		    puts "	   - It's tied to something. You"			
			puts "	     wonder what it could be.\n\n"	
		else print "	   - It's stuck down and locked.\n\n"
		end
	end
end	

