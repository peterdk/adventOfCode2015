class Item

    attr_reader :type, :name, :cost, :damage, :armor

    def initialize(type, name, cost, damage, armor)
        @name = name
        @cost = cost
        @damage = damage
        @armor = armor
        @type = type
    end
        
    def to_s
        "#{@type}: #{@name}\t#{@cost}\t#{@damage}\t#{@armor}"
    end
end

class Warrior
    
    attr_accessor :items, :hitpoints
    
    def initialize(hitpoints)
        @items = []
        @hitpoints = hitpoints
    end
    
    def add_item(item)
        @items << item
    end
    
    def cost
        @items.map{|i|i.cost}.inject(:+)
    end
    
    def damage
        @items.map{|i|i.damage}.inject(:+)
    end
    
    def armor
        @items.map{|i|i.armor}.inject(:+)
    end
    
    def valid
        weapons = @items.find_all{|i|i.type=="Weapons"}
        armor =  @items.find_all{|i|i.type=="Armor"}
        rings =  @items.find_all{|i|i.type=="Rings"}
        return (weapons.size == 1 && (armor.size == 0 || armor.size == 1) && (rings.size >=0 && rings.size <= 2))
    end
    
    def clone
        w = super
        w.items = [ ]
        @items.each do |i|
            w.items << i
        end
        w
    end
    
end


class Player

    attr_reader :name, :damage, :armor, :cost
    attr_accessor :hitpoints
    
    def initialize(name, hitpoints, damage, armor, cost)
        @name = name
        @hitpoints = hitpoints
        @damage = damage
        @armor = armor
        @cost = cost
    end
    
    def deal_damage(enemy)
        damage = @damage - enemy.armor
        damage = 1 if (damage <= 0)
        enemy.hitpoints -= damage 
    end
    
    def to_s
        "#{@name}: hitpoints #{@hitpoints}, damage #{@damage}, armor #{@armor}, cost #{@cost}"
    end
    
end

class Fight
    
    attr_reader :boss, :player
    
    def initialize(boss, player)
        @boss = boss
        @player = player
    end
    
    def winner
        while (@boss.hitpoints >= 0 && @player.hitpoints >= 0)
            round
        end
        [@boss, @player].find{|p|p.hitpoints > 0}
    end
    
    def round
        @player.deal_damage(@boss)
        if (@boss.hitpoints >= 0)
            @boss.deal_damage(@player)
        end
    end
    
    
end

shop_input = File.new("day21_shop.txt").readlines
@shop = []

type = nil
shop_input.each do |l|
    match = l.match(/([a-zA-Z0-9+ ]+)\s+(\d+)\s+(\d+)\s+(\d+)/)
    if (match)
        all, name, cost, damage, armor = match.to_a
        @shop << Item.new(type, name, cost.to_i,damage.to_i,armor.to_i)
    else
        match = l.match(/(\w+):/)
        if (match)  
            type = match.to_a[1]
        end
    end
end





def create_combinations(items, min, max)
    perms = []
    for i in (min..max)
        perms << items.combination(i).to_a
    end
    perms.flatten!(1)
    
end

def create_warrior_combinations(warriors, items, min, max)
    new_warriors= []
    new_items = create_combinations(items,min,max)
    new_items.each do |ni|
        warriors.each do |w|
            new_w = w.clone
            ni.each do |i|
                new_w.add_item(i)
            end
            new_warriors << new_w
        end
    end
    new_warriors
end
def create_players
    weapons = @shop.find_all{|i|i.type == "Weapons"}
    armor = @shop.find_all{|i|i.type == "Armor"}
    rings = @shop.find_all{|i|i.type == "Rings"}
    
    warriors = [Warrior.new(100)]
    warriors = create_warrior_combinations(warriors, weapons, 1, 1)
    warriors = create_warrior_combinations(warriors, armor, 0, 1)
    warriors = create_warrior_combinations(warriors, rings,0, 2)
    players = []
    puts "Warriors: #{warriors.size}"
    puts "Valid warriors: #{warriors.find_all{|w|w.valid}.size}"    
    warriors.each do |w|
        players << Player.new("player", w.hitpoints, w.damage, w.armor, w.cost)
    end 
    players
    
end
boss = Player.new("boss", 109, 8, 2, 0)

players = create_players
costs = players.find_all{|p|Fight.new(boss.clone, p).winner == p}.sort_by{|p|p.cost}
puts costs[0]

players = create_players
costs = players.find_all{|p|Fight.new(boss.clone, p).winner != p}.sort_by{|p|p.cost}
puts costs.last



    



