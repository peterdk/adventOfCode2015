
DEBUG = false
class Item
	
	attr_reader :name, :cost, :damage, :armor, :healing, :recharge, :effect
	def initialize(name, cost, damage, armor, healing, recharge, effect)
		@name = name
		@cost = cost
		@damage = damage
		@armor = armor
		@effect = effect
		@healing = healing
		@recharge = recharge
	end
	def to_s
		@name
	end
end

class Spell

	attr_reader :item
	attr_accessor :timer
	
	def initialize(item)
		@item = item
		@timer = item.effect
	end
	
	
end

class Player

	attr_accessor :name, :hit_points, :armor, :mana, :spells, :damage, :planned_spells, :spent_mana
	
	def initialize(name, hit_points, armor, mana, damage, planned_spells)
		@name = name
		@hit_points = hit_points
		@armor = armor
		@mana = mana
		@spells = []
		@damage = damage
		@planned_spells = planned_spells
		@spent_mana = 0
	end	
	
	def deal_damage(enemy)
		damage = @damage
		#@spells.each do |s|
		#	damage += s.item.damage
		#end
		enemy_armor = 0
		enemy.spells.each do |s|
			enemy_armor += s.item.armor
		end
		damage -= enemy_armor
		damage = 1 if damage < 1		
		enemy.hit_points -= damage
	end
	
	def cast_spell(enemy, item)	
		spell =  Spell.new(item)
		
		
		@mana -= item.cost	
		@spent_mana += item.cost
		if (@mana <= 0)
			@hit_points = -1
		end
		if (!spell.timer)
			spells_action(enemy, [spell])
		else
			@spells << spell
		end
		
	end
		
	def cast_next_spell(enemy)	
		cast_spell(enemy, @planned_spells.shift)
	end

	def spells_action(enemy, spells)
		damage = 0
		spells.each do |s|
			if (s.item.healing)
				@hit_points += s.item.healing
			end
			if (s.item.recharge)
				@mana += s.item.recharge
			end
			if (s.item.damage)
				damage += s.item.damage
			end
		end		
		enemy.hit_points -= damage
	end
	
	def spells_round(enemy)	
		spells_action(enemy, @spells)
		@spells.dup.each do |s|
			if (!s.timer)
				@spells.delete(s)
			else
				s.timer -= 1
				if (s.timer == 0)
					@spells.delete(s)
				end
			end
		end		
	end
	
	def to_s
		@name
	end
end

class Battle
	
	def initialize(boss, player)
		@boss = boss
		@player = player
	end
	
	def winner
		while (@boss.hit_points > 0 && @player.hit_points > 0 )
			round
		end
		[@boss,@player].find{|p|p.hit_points > 0}
	end
	
	def round		
		if (@player.hit_points > 0)
			if (DEBUG)
				puts "-- Player turn --"
				puts "- Player has #{@player.hit_points} hit points, #{@player.mana} mana"
				puts "- Boss has #{@boss.hit_points} hit points"
			end
			@player.spells_round(@boss)	
			@player.cast_next_spell(@boss)					
		end
		puts if DEBUG
		if (@boss.hit_points > 0)
			if (DEBUG)
				puts "-- Boss turn --"
				puts "- Player has #{@player.hit_points} hit points, #{@player.mana} mana"
				puts "- Boss has #{@boss.hit_points} hit points"
			end
			@player.spells_round(@boss)
			if (@boss.hit_points > 0)
				@boss.deal_damage(@player)
			end
		end
		puts if DEBUG
		
	end
end
#def initialize(name, cost, damage, armor, healing, recharge, effect)
spells = {}
spells[:Missile] = Item.new("Magic Missile", 53, 4, 0,0,0,nil)
spells[:Drain] = Item.new("Drain", 73,2,0,2,0,nil)
spells[:Shield] = Item.new("Shield", 113,0,7,0,0,6)
spells[:Poison] = Item.new("Poision", 173,3,0,0,0,6)
spells[:Recharge] = Item.new("Recharge", 229,0,0,0,101,5)
 
#def initialize(name, hit_points, armor, mana, damage, planned_spells)
boss = Player.new("boss", 14, 0, 0,8,nil)
player = Player.new("player",10,0, 250, 0,[spells[:Recharge], spells[:Shield],spells[:Drain], spells[:Poison], spells[:Missile]])

battle = Battle.new(boss, player)
puts "Winner: #{battle.winner}"

players = []
lowest = nil
spells.values.repeated_permutation(9).each do |p|	

	valid= true
	p.each_with_index do |s,i|
		if (s.effect)
			if (p[(i+1)..(i + ((s.effect - 1)/2))].include?(s))
			valid = false
			break
			end
		end
	end
	next if !valid
#907 <-> 1040 is valid
	#puts p.join(",")
#end
	boss = Player.new("boss",55,0,0,8,nil)
	player = Player.new("player",50,0,500,0,p)
	battle = Battle.new(boss, player)
	begin
	winner = battle.winner
	rescue
	next
	end
	
	if (battle.winner == player)
		if (lowest == nil || lowest.spent_mana > player.spent_mana)
			lowest = player
		end			
	end
end
if (lowest)
puts "Lowest mana spent by a winner: #{lowest.spent_mana}"
else
puts "No winner found in all permutations..."
end