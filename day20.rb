input = "34000000"


def presents(house)
presents = 0
(1..house).each do |i|
	if (house % i) == 0
		presents += (i * 10)
	end	
end
presents

end

def presents_faster(max_presents)
	houses = []
	(1..(max_presents/10)).each do |e|
		puts e if e%1000 == 0
		(e..(max_presents/10)).step(e).each do |h|
			value = houses[h]
			if (!value)
				houses[h] = 0
			end
			houses[h] += e * 10
		end
	end
	houses.index{|h|h != nil && h >= max_presents}
end

def presents_faster_part2(max_presents)
houses = []
	(1..(max_presents/11)).each do |e|
		puts e if e%1000 == 0
		count = 0
		(e..(max_presents/11)).step(e).each do |h|
			count+=1
			break if count > 50
			value = houses[h]
			if (!value)
				houses[h] = 0
			end
			houses[h] += e * 11
		end
	end
	houses.index{|h|h != nil && h >= max_presents}
end
(1..9).each do |h|
puts "House #{h} got #{presents(h)} presents."
end

#puts presents_faster_part2(input.to_i)
puts presents_faster_part2(input.to_i)




