class Ingredient

    attr_reader :name, :properties
    
    def initialize(name, capacity, durability, flavor, texture, calories)
        @name = name
        @properties = {}
        @properties[:capacity] = capacity
        @properties[:durability] = durability
        @properties[:flavor] = flavor
        @properties[:texture] = texture
        @properties[:calories] = calories
    end

    def value(property)
        @properties[property]
    end
    
    def to_s
        @name
    end
end

class UsedIngredient
    attr_reader :ingredient, :teaspoons
    
    def initialize(ingredient, teaspoons)
        @ingredient = ingredient
        @teaspoons = teaspoons
    end
        
    def score(property)
        @teaspoons * @ingredient.value(property)
    end
    
    def to_s
        "#{@teaspoons} ts of #{@ingredient}"
    end
end

class Cookie
    
    attr_reader :used_ingredients
    
    def initialize(used_ingredients)
        @used_ingredients = used_ingredients
    end
    
    def score
        keys = [:capacity, :durability, :flavor, :texture] #:calories are ignored for now
        scores = []
        keys.each do |k|
            score = @used_ingredients.map{|i|i.score(k)}.inject(:+)         
            score = score < 0 ? 0 : score
            scores << score
        end
        scores.inject(:*)                       
        
    end
    
    def to_s    
        @used_ingredients.map{|u|u.to_s}.join(", ")
    end
    
end

class Processor


    attr_reader :ingredients
    def initialize
        @ingredients = []
    end
    
    def parse (input)
        match = input.match(/(\w+): capacity (-*\d+), durability (-*\d+), flavor (-*\d+), texture (-*\d+), calories (-*\d+)/)
        all, name, capacity, durability, flavor, texture, calories = match.to_a
        @ingredients << Ingredient.new(name, capacity.to_i, durability.to_i, flavor.to_i, texture.to_i, calories.to_i)
        
    end
    
    def highest_score
        #all combinations 100,0,0 : 99,1,0, 98,1,1 98,2,0 98,0,2
        combinations = []
        for i in 0..100
            for j in 0..100
                for k in 0..100
                    for l in 0..100
                        combinations << [i,j,k,l] if (i + j + k + l== 100)
                    end
                end
            end
        end
        
        
        
        
        highscore = 0
        best_cookie = nil
        combinations.each do |c|
            used_ingredients = []
            for i in 0...@ingredients.length
                used_ingredients << UsedIngredient.new(@ingredients[i], c[i])
            end
            cookie = Cookie.new(used_ingredients)
            cookie_score = cookie.score
            if (highscore < cookie_score && cookie.calories == 500)
                highscore = cookie_score
                best_cookie = cookie
            end
        end
        
        puts "Best cookie: #{best_cookie} => #{highscore}"
    end
    
    # def generate_next_round(current)
        # new = []
        # for i in 0..100
        # for j in 0...current.length
            # new << current[j] + [i]
        # end
        # end
        # new
    # end
end

input = "Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8"
lines = input.lines.map{|l|l.strip}
p = Processor.new
lines.each do |l|
    p.parse(l)
end
puts p.ingredients
p.highest_score
