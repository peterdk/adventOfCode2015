class Light

	attr_reader :x, :y, :always_on
	def initialize(x,y)
		@x = x
		@y = y
		@on = false
		@always_on = false
	end 
	
	def turn_on(on)
		@on = on
	end
	
	def set_always_on
		@always_on = true
	end
	
	def on
		@always_on ? true : @on
	end
	
	def to_s
		on ? "#" : "."
	end
end

class Grid

	attr_reader :grid, :lights, :size
	
	def initialize(size)
		@grid = []
		@lights = []
		@size = size
		for y in 0...size       
			@grid[y] = []
			for x in 0...size
				l = Light.new(x,y)
				@grid[y][x] = l
				@lights << l
			end
		end
		always_on = [0,size-1].repeated_permutation(2).to_a
		always_on.each {|x,y| @grid[y][x].set_always_on}
	end

	def to_s
		output = []
		@grid.each do |l|
			output << l.map{|l|l.to_s}.join
		end
		output.join("\n")
		
	end 
	
	def neighbours(light)
		x = light.x
		y = light.y
		combinations = [-1,0,1].repeated_permutation(2).to_a
		combinations.delete([0,0])
		values = combinations.map{|x_offset, y_offset| [x+x_offset, y+y_offset]}.find_all{|x,y| x >= 0 && y>=0 &&x <@size && y <@size}              
		
		lights = values.map{|x,y|@grid[y][x]}       
		return lights               
	end 
	
	def lights_on
		@lights.find_all{|l|l.on}.count
	end

	def copy
		copy = Grid.new(@size)
		for y in 0...@size
			for x in 0...@size
				copy.grid[y][x].turn_on(@grid[y][x].on)
				copy.grid[y][x].set_always_on if @grid[y][x].always_on
			end
		end
		copy
	end
end

class Processor

	attr_reader :grid

	
	def parse(lines)
		size = lines.count
		@grid = Grid.new(size)
		lines.each_with_index do |l,y|
			l.strip.chars.each_with_index do |c,x|
				light = @grid.grid[y][x]
				light.turn_on(c =='#')               
			end
		end
	end
	
	def step
		copy = @grid.copy
		copy.lights.each do |l|
			n_on = copy.neighbours(l).find_all{|n|n.on}.count
			target = @grid.grid[l.y][l.x]
			if (l.on)
				target.turn_on(false) if (n_on != 2 && n_on != 3)
			else
				target.turn_on(true) if (n_on == 3)
			end
		end     
	end
end




p = Processor.new
p.parse(File.new("input18.txt").readlines)
100.times do |i|
	puts i
	p.step
end
puts p.grid
puts p.grid.lights_on

#light = g.grid[0][0]
#n = g.neighbours(light).each {|l|l.turn_on(true)}
#puts g.to_s

