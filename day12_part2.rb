require 'json'
input = File.new("input12.txt").read
data  = JSON.parse(input)
@to_delete = []
@all_numbers = []

def numbers(json)
        if (json.class == Array)
            json.each {|j|numbers(j)}
        elsif (json.class == Hash)
            json.keys.each do |key|
                numbers(key)
                numbers(json[key])
            end
        elsif (json.class == Fixnum)
            @all_numbers << json
        end
end

def clean(json, parent)
    if (json.class == Array)
        json.each {|j|clean(j,json)}
    elsif (json.class == Hash)
        json.keys.each do |key|
            clean(key, json)
            clean(json[key],json)
        end 
    elsif (json.class == String)
        parent.clear if (json == "red" && parent.class != Array)
    end
end

puts input.scan(/(-{0,1}\d+)/).flatten.map{|s|s.to_i}.inject(:+)
numbers(data)
puts @all_numbers.inject(:+)

@all_numbers = []
clean(data, [])
numbers(data)
puts @all_numbers.inject(:+)
