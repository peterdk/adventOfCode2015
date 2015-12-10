input = File.new("input8.txt").readlines.map{|l|l.strip}
raw_size = input.map{|l|l.length}.inject(:+)
text_size = input.map{|l|eval(l).length}.inject(:+)
puts raw_size - text_size