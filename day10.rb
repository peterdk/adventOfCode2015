
class Sayer

    attr_reader :current
    
    def initialize(initial)
        @current = initial
    end
    
    def say
        values = @current.chars.map{|c|c.to_i}
        groups = []
        current = values[0]
        start = 0
        for i in 1..values.length
                if (values[i] != current)
                    groups << [current] * (i-start)
                    current = values[i]
                    start = i
                end
        end
        @current = groups.map{|s|"#{s.count}#{s[0]}"}.join      
    end
end

s = Sayer.new("1113122113");
40.times {|i|s.say}
puts "day 10 part 1: #{s.current.length}"
10.times {|i|s.say}
puts "day 10 part 2: #{s.current.length}"






