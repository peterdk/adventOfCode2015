 def groups(input, target)
     valid_combos = []
     first_groups = group(input, target)     
     puts "first groups: #{first_groups.size}"
     first_groups.each_with_index do |g,i|
        puts "first group: #{i}/#{first_groups.size}"
        second_groups = group(input.dup - g, target)        
#       puts "second groups: #{second_groups.size}"
        second_groups.each do |sg|
            
            third_groups = group(input.dup - g - sg, target)
#           puts "first groups: #{third_groups.size}"
            third_groups.each do |tg|
                fourth_groups = group(input.dup - g - sg - tg, target)
                fourth_groups.each do |fg|
                    valid_combos << [g, sg, tg, fg]
                end
            end
        end
     end
    winner = valid_combos.sort_by{|c|c[0].inject(:*)}.first         
    puts "Matching: #{valid_combos.size}"
    puts "QE: #{winner[0].inject(:*)}"
    puts winner.inspect
 end
 
 
 def group(input, target)
     match = false
     size = 1
     while (!match && size <= input.size)
        combinations = input.combination(size)
        matching = combinations.find_all{|c|c.inject(:+) == target}
        if (matching && matching.size > 0)
#           puts size
            return matching
        end
        size += 1
     end
     return []
     
 end
 
 input = File.new("input_24.txt").readlines.map{|l|l.strip.to_i}
 
 target = input.inject(:+) / 4
 groups(input, target)
 