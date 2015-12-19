class Atom
    
    attr_reader :name, :conversions
    def initialize(name)
        @name = name
        @conversions = []
    end
    
    def add_conversion(conversion)
        @conversions << conversion
    end
    
    def to_s
        output = []
        @conversions.each do |c|
            output << "#{@name} => #{c}"
        end
        output.join("\n")
    end
end

class Molecule

    attr_reader :name, :atoms
    
    def initialize(name)
        @name = name
        
    end
    
    def parse(available_atoms)
        @atoms =[]
        index = 0
        items = name.split(/(?=[A-Z0-9])/)
        
        puts items.inspect
        @atoms = []
        #items.map{|a|available_atoms.find{|at|at.name == a} : Atom.new(a[1])}
        items.each do |i|
            at = available_atoms.find{|at|at.name == i}
            if (!at)
                at = Atom.new(i)
            end
            @atoms << at
        end
        puts @name.length
        puts @atoms.map{|a|a.name}.join.length
        puts @atoms.map{|a|a.name}.uniq.join("\n")
        puts [@name, @atoms.map{|a|a.name}.join].uniq.count
        #same lengths and 1 uniq, so input gets scanned properly
    end
    
    def possibilities
        puts name
        puts 
        output = []
        for i in 0...@atoms.length                  
            @atoms[i].conversions.each do|c|                                
                result = @atoms.dup 
                result[i] = c
                output << result
            end
        end             
        puts output.map{|c|c.map{|d|d.name}.join}.uniq.count
    end
    
    # def combine(input, index)
        # result = []               
        # input.each do |atoms|
            # atoms[index].conversions.each do |m|
                # version = atoms.dup
                # version[index] = m
                # result << version
            # end
        # end
        # result
    # end
    
    def to_s
        @name
    end
    
end

class Processor

def initialize
    @atoms = []
    @molecules = []
end

def calibrate(lines)    
    lines.each do |l|
        match = l.match(/(\w+) => (\w+)/)
        all, source, target = match.to_a
        a = get_atom(source)
        m = get_molecule(target)
        a.add_conversion(m)     
    end
    puts @atoms.map{|a|a.to_s}.join("\n")
end

def get_atom(name)
    result = @atoms.find{|a|a.name == name}
    if (!result)
        result = Atom.new(name)
        @atoms << result
    end
    result  
end

def get_molecule(name)
    result = @molecules.find{|m|m.name == name}
    if (!result)
        result = Molecule.new(name)
        @molecules << result
    end
    result
end

def possibilities(molecule)
        m = Molecule.new(molecule)
        m.parse(@atoms) 
        m.possibilities
end

end

p = Processor.new
input = "HOHOHO"
#p.calibrate(File.new("input19_cal_test.txt").readlines.map{|l|l.strip})
#p.possibilities(input)
 
p.calibrate(File.new("input19_cal.txt").readlines.map{|l|l.strip})
p.possibilities(File.new("input19.txt").read.strip)
