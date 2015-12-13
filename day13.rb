


class Person
    
    attr_reader :influences, :name
    
    def initialize(name)
        @influences = {}
        @name = name
    end
    
    def add_influence(source, value)
        @influences[source] = value
    end
    
    def get_influence(person)
        @influences[person]
    end 
    
     def hash
        @name.hash
    end
    
    def eql?(other)
        self == other
    end
    
    def ==(other)
        @name == other.name
    end
    
    def to_s
        @name
    end
end

class TableArrangement
    
    def initialize(persons)
        @persons = persons
    end
    
    def happiness
        value = 0
        count = @persons.count
        for i in 0...count
            left = @persons[(i-1)%count]
            right = @persons[(i+1)%count]
            person = @persons[i]
            value += person.get_influence(left)
            value += person.get_influence(right)            
        end
        value
    end
    
    def to_s
        "#{@persons.map{|p|p.name}.join(", ")} => #{happiness}"
    end
    
end
class Processor
    
    def initialize  
        @persons = {}
        @arrangements = []
    end
    
    def parse(line)
        match = line.match(/(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+)/)
        all, target, modifier, count, source = match.to_a
            
        influence = (modifier == "gain"? count.to_i : 0- count.to_i)
        target_person = get_person(target)
        source_person = get_person(source)
        
        target_person.add_influence(source_person, influence)       
    end
    
    def add_self        
        you = get_person("yourself")
        @persons.values.each do |p|
            p.add_influence(you, 0)
            you.add_influence(p, 0)
        end
    end
    
    def process
        #generate all possible arrangements
        @persons.values.permutation.each do |t| #wow, dat is makkelijk zo!
            @arrangements << TableArrangement.new(t)
        end
        sorted = @arrangements.sort_by{|a|a.happiness}
        puts sorted.last
        
    end
    
    def get_person(name)
        person = @persons[name]
        if (!person)
            person = Person.new(name)
            @persons[name] = person
        end
        person
    end
end

puts "Day 13 part 1"
input = File.new("input13.txt").readlines.map{|l|l.strip}
p = Processor.new
input.each {|l|p.parse(l)}
p.process

puts "Day 13 part 2"
p = Processor.new
input.each {|l|p.parse(l)}
p.add_self
p.process