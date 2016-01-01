def index(x,y)  
    
    y_value = loop(y,1,1)
    x_value = loop(x,y_value,(y+1)) 
end

def loop(target, start, start_step)
current = start
    for i in (1...target)
        current += (i + (start_step -1))
    end
    current
end


index_of_answer = index(3083,2978)
#index_of_answer = index(6,6)
last_answer = 20151125
index_of_answer.times do |i|
    next if (i == 0)
    puts "#{i}/#{index_of_answer}" if (i% 1000 == 0)
    last_answer = ((last_answer * 252533) %33554393) 
end
puts last_answer
