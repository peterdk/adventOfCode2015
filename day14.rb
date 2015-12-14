class Deer

attr_reader :speed, :duration, :rest, :name

    def initialize(name, speed, duration, rest)
        @name = name
        @speed = speed
        @duration = duration
        @rest = rest
    end

    def to_s
        "#{@name} can fly #{@speed} km/s for #{@duration} seconds, but then must rest for #{@rest} seconds"
    end
    
    def distance(seconds)       
        cycle = @duration + @rest
        cycles = seconds / cycle
        left = seconds % cycle
        left_fly_seconds = [left, @duration].min
        fly_seconds = left_fly_seconds + (cycles * @duration)
        distance = fly_seconds * @speed
    end

end

class Processor

    attr_reader :deers
    
    def initialize
        @deers = []
    end 
    
    def parse(input)
        match = input.match(/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./)
        all, name, speed, duration, rest = match.to_a
        @deers << Deer.new(name, speed.to_i, duration.to_i, rest.to_i)      
    end
    
    def race(seconds)       
        sorted = @deers.sort_by{|d|d.distance(seconds)}.reverse
        sorted.each do |d|
            puts "#{d.name} => #{d.distance(seconds)}"
        end             
    end

end

input = File.new("input14.txt").readlines.map{|l|l.strip}
p = Processor.new
input.each do |l|
    p.parse(l)
end
p.deers.each do |p|
puts p
end
p.race(2503)
