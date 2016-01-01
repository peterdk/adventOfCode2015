 input = File.new("input_24.txt").readlines.map{|l|l.strip.to_i}
 
 valid_combinations = [] 
 target = input.inject(:+) / 3
 smallest_first_group = input.size
 input.permutation(input.size).each do |p|
    #first group can be 1 until size - 2    
    for first_group_size in 1...(p.length - 2)                              
        puts "first group size: #{first_group_size}"    
        break if valid_combinations.size > 0
        next if first_group_size > smallest_first_group
        next if (p[0...first_group_size].inject(:+) != target)
        
        for second_group_size in 1...(p.length - first_group_size - 1)
            #generate
            groups = []
            data = p.dup
            groups[0] = data.shift(first_group_size)
            groups[1] = data.shift(second_group_size)
            groups[2] = data
            
            #validate
            sums = groups.map{|g|g.inject(:+)}
            if (sums[0] == sums[1] && sums[0] == sums[2])
                if (groups[0].length <= smallest_first_group)
                    smallest_first_group = groups[0].length             
                    valid_combinations << groups
                    puts valid_combinations.size            
                end
            end
        end
    end
 end
 
 valid_combinations.uniq!
 puts "Unique combinations: #{valid_combinations.size}"
 smallest_combinations = valid_combinations.find_all{|c|c[0].size == smallest_first_group}
 winner = smallest_combinations.sort_by{|c|c[0].inject(:*)}.first
 puts winner.inspect
 puts "QE: #{winner[0].inject(:*)}"