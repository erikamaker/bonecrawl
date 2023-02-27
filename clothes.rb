############################################################################################################################################################################################################################################################## 
#####    CLOTHES     #########################################################################################################################################################################################################################################
##############################################################################################################################################################################################################################################################  


class Clothes < Portable 
    def targets
        subtype | ["clothing","clothes","garb","armor"]
    end 
end

class Hoodie < Clothes   # Requires 1 copper ore, and 3 spider spools
    def initialize  
        @targets = ["hoodie","sweater","sweatshirt"]
        @profile = {:defense => 5, :lifespan => 30}
    end
end

class Jeans < Clothes   # Requires 1 copper ore, and 3 spider spools
    def initialize  
        @targets = ["jeans","denim","pants","trousers"]
        @profile = {:defense => 5, :lifespan => 20}
    end
end

class Tee < Clothes     # Requires 2 spider spools
    def initialize  
        @targets = ["tee","shirt","t-shirt"]
        @profile = {:defense => 5, :lifespan => 15}
    end
end

class Sneakers < Clothes    # Requires 2 spider spools, 1 copper ore, and 4 rat leather
    def initialize  
        @targets = ["shoes","sneakers"]
        @profile = {:defense => 5, :lifespan => 50}
    end
end