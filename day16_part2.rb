class Aunt
    
    
    attr_reader :number, :properties
    def initialize(number, properties)
        @number = number
        @properties = properties    
    end
    
    def score(to_match)
        score = 0
        to_match.keys.each do |k|
            if (@properties[k])
                if (k == "cats"||k=="trees")
                    score += 1 if @properties[k] > to_match[k]
                elsif (k == "pomeranians"|| k=="goldfish")
                    score += 1 if @properties[k] < to_match[k]
                else                
                    score += 1 if @properties[k] == to_match[k]
                end
            end
        end
        score
    end
end


class Processor

    def initialize
        @aunts = []
    end

    def parse(line)
        #Sue 1: cars: 9, akitas: 3, goldfish: 0
        match = line.match(/Sue (\d+):(.+)/)
        all, number, properties = match.to_a
        props = properties.split(",").map{|p|p.strip.match(/(\w+): (\d+)/)}.map{|m|{m[1] => m[2].to_i}}.reduce(Hash.new, :merge)
        @aunts << Aunt.new(number.to_i, props)
    end
    
    def find(props_string)
        properties = {}
        props_string.lines.map{|l|l.strip}.map{|l|l.split(":")}.each{|a|properties[a[0]] = a[1].to_i}
        aunt = @aunts.sort_by{|a|a.score(properties)}.reverse.first
        puts "aunt #{aunt.number} => score: #{aunt.score(properties)}"
    end

end

p = Processor.new
input=File.new("input16.txt").readlines.map{|l|l.strip}
input.each do |l|
    p.parse(l)
end

to_match = "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"
 p.find(to_match)

