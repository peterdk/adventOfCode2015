input = File.new("input12.txt").read

puts input.scan(/(-{0,1}\d+)/).flatten.map{|s|s.to_i}.inject(:+)
