input = File.new("input8.txt").readlines.map{|l|l.strip}
raw_size = input.map{|l|l.length}.inject(:+)
escaped_size= input.map{|l|l.dump.length}.inject(:+)
puts escaped_size - raw_size