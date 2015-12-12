

class Password

    attr_reader :password
    def initialize(password)
        @password = password
    end
    
    def next_password
        valid = false
        password = @password
        while (!valid)
            password = increment(password)
            valid = valid(password)
        end
        @password = password
    end
    
    def valid(password)
        (has_increasing_straight(password) && has_no_invalid_chars(password) && has_two_non_overlapping_pairs(password))
    end
    
    def has_no_invalid_chars(password)
        password.match(/[iol]/) == nil
    end
    
    def has_two_non_overlapping_pairs(password)
        chars = password.chars
        double_start_indexes = []
        for i in (0..(chars.count - 2))
            if (chars[i] == chars[i+1])
                double_start_indexes << i
            end
        end
        #puts double_start_indexes
        valid_count = 0
        if (double_start_indexes.count >= 2)
            for i in (1..(double_start_indexes.count - 1))
                if (double_start_indexes[i] - double_start_indexes[i-1] >= 2)
                    valid_count += 1
                end
            end
        end
        valid_count >= 1
    end
    
    
    
    def has_increasing_straight(password)
        values = password.chars.map{|c|c.ord}
        valid = false
        for i in 0..(values.length - 3)
            first,second,third  = values[i..(i+2)]
            valid = ((third - second == 1)&&(second-first == 1))
            break if (valid)
        end
        valid
    end
    
    
    def increment(password)
        start = 'a'.ord
        finish = 'z'.ord        
        invalid = ['i','o','l'].map{|c|c.ord}
        values = password.chars.map{|c|c.ord}
        overflow = true
        index = (values.length) - 1
        while (overflow && index >= 0)
            new_value = values[index] + 1
            if (new_value > finish)
                new_value = start
                overflow = true             
            else
                overflow = false
            end
            values[index] = new_value           
            index -= 1
        end
        for i in 0..(values.length - 1)
            if (invalid.include?(values[i]))
                for j in (i+1)..(values.length - 1)
                    values[j] = start
                end
                values[i] += 1
            end
        end
        values.map{|v|v.chr}.join               
    end
    
end

# p = Password.new("hijklmmn")
# puts p.password
# puts p.valid(p.password)

# p = Password.new("abbceffg")
# puts p.password
# puts p.valid(p.password)

# p = Password.new("abbcegjk")
# puts p.password
# puts p.valid(p.password)

# p = Password.new("abcdffaa")
# puts p.password
# puts p.valid(p.password)
# puts p.has_increasing_straight(p.password) 
# puts p.has_no_invalid_chars(p.password) 
# puts p.has_two_non_overlapping_pairs(p.password)
                            
# p = Password.new("ghijklmn")                          
# puts p.password
# puts p.next_password
# puts p.has_increasing_straight(p.password) 
# puts p.has_no_invalid_chars(p.password) 
# puts p.has_two_non_overlapping_pairs(p.password)

p = Password.new("cqjxjnds")
puts "day 11 part 1"
puts p.password
puts p.next_password
puts
puts "day 11 part 2"
puts p.next_password

