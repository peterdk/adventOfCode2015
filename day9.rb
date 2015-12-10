
class Location

	attr_reader :name
	attr_reader :distances
	
	def initialize(name)
		@name = name
		@distances = {}
	end
	
	def distance_to(location)
		@distances[location]
	end
	
	def set_distance_to(location, distance)
		@distances[location] = distance
	end
	
	def hash
		@name.hash
	end
	
	def eql?(other)
		self == other
	end
	
	def ==(other)
		@name == other.name
	end
	
	def to_s
		@name
	end
	
end


class Route
	
	attr_accessor :visited
	
	def initialize		
		@visited = []
	end
	
	def not_visited(location)
		!@visited.include?(location)
	end
	
	def visit(location)
		@visited << location
		return self
	end
	
	def distance
		total = 0
		for i in 0...@visited.length - 1
			total += @visited[i].distance_to(@visited[i+1])
		end
		total
	end
	
	def to_s
		@visited.map{|l|l.name}.join(" => ") + " = #{distance}" 
	end
	
	def copy
		route = Route.new
		route.visited = @visited.dup
		route
	end
end

class Processor

	
	attr_reader :locations
	
	def initialize
		@locations = {}
	end
	
	def get_location(name)
		location = @locations[name]
		if (!location)
			location = Location.new(name)
			@locations[name] = location
		end
		location
	end

	def process(input)
		input.each do |line|
			match = line.match(/(\w+) to (\w+) = (\d+)/)			
			all, start, finish, distance = match.to_a
			start_location = get_location(start)
			end_location = get_location(finish)
			
			start_location.set_distance_to(end_location, distance.to_i)
			end_location.set_distance_to(start_location, distance.to_i)

		end

		routes
	end
	
	def routes
		#setup
		routes = []
		@locations.values.each do |loc|
			r = Route.new
			routes << r.visit(loc)					
		end
	
		new_routes = routes
		final_routes = routes
		while (new_routes.length != 0)
			final_routes = new_routes
			new_routes = perform_visits(final_routes)
		end
		
		final_routes.sort_by{|r|r.distance}.reverse.each do |r|
			puts r
		end
	end
	
	def perform_visits(input_routes)
		new_routes = []
		input_routes.each do |r|			
			r.visited.last.distances.keys.each do |available_loc|
				if (r.not_visited(available_loc))			
					new_routes << r.copy.visit(available_loc)
				end
			end
		end
		#puts "routes:#{input_routes.size} -> new routes:#{new_routes.size}"
		
		new_routes
		
		
	end
end

input = File.new("input9.txt").readlines.map{|l|l.strip}
p = Processor.new
p.process(input)






