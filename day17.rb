
def part1
containers = File.new("input17.txt").readlines.map{|l|l.strip.to_i}
valid = []
for i in 0..containers.length
    
    valid << containers.combination(i).find_all{|c|c.inject(:+) == 150}
    
end
valid
end

def part2
containers = part1.flatten!(1)
puts part1.group_by{|c|c.length}.sort[1][1].flatten(1).length
end

 puts "day17 part 1"
 output = part1.flatten!(1)
 puts output.inspect
 puts output.size
 puts
puts "day17 part 2"
puts part2
