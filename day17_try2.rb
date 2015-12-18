	class Container

	attr_reader :size

		def initialize(size)
			@size = size
		end
		
	end

	class Combination

		attr_reader :containers
		
		def initialize(containers)
			@containers = containers
		end
		
		def total_size
			@containers.map{|c|c.size}.inject(:+)
		end
	end

	class Processor

		def initialize()
			@available = File.new("input17.txt").readlines.map{|l|Container.new(l.strip.to_i)}
		end

		def combinations
		combinations = []
			for i in 1..@available.size
				combinations << @available.combination(i).map{|c|Combination.new(c)}.select{|c|c.total_size == 150}
			end
		combinations.flatten(1)
		end
		
		def part1       
			puts combinations.size
		end
		
		def part2
			puts combinations.group_by{|c|c.containers.length}.map{|length, combinations|combinations.length}.first
		end

	end

	p = Processor.new
	#puts p.part1
	puts p.part2