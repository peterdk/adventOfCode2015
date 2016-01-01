def smallest_possible(weights, num_groups)
  return weights if num_groups == 1
  target = weights.reduce(:+) / num_groups

  (1..(weights.size - num_groups)).lazy.map do |grp_size|
    weights.combination(grp_size).reduce([]) do |m, combo|
      next m unless combo.reduce(:+) == target &&
                    smallest_possible(weights - combo, num_groups - 1)
      m.concat([combo])
    end
  end.find{|x| !x.empty?}
end

weights = File.new("input_24.txt").readlines.map{|l|l.strip.to_i}
output = smallest_possible(weights, 3)
puts output.inspect
puts "my algo: #{output.sort_by{|x|x.reduce(:*)}.first.inject(:*)}"
puts "other algo: #{output.map{|x| x.reduce(:*)}.min}"