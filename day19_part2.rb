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

    attr_reader :name, :atoms, :conversions
	
    def initialize(name)
        @name = name
        @conversions = []		
    end
	
	def add_conversion(atom)
		@conversions << atom
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
		m.add_conversion(a)
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

def stepsToMolecule(molecule)
	input = [[molecule, 0]]
	next_steps = getNextSteps(input)
	while ((next_steps - input).size > 0)
		input = next_steps
		next_steps = getNextSteps(input)
	end
	puts next_steps.find{|m,i|m == "e"}.sort_by{|m,i| i}.inspect
	
	
end

def getNextSteps(molecules)
new_versions = []
	molecules.each do |molecule, count|		
		found_new = false
		@molecules.each do |m|
			i = 0
			indices = []
			molecule.scan(m.name).each do |match|
				index = molecule.index(m.name,i)
				indices << index
				i = index +1
			end
			found_new = true if (indices.length > 0)
				
			indices.each do |start|
				replaced = molecule.dup
				replaced[start...start+m.name.length] = m.conversions.first.name
				new_versions << [replaced, count+1]
			end				
		end
		new_versions << [molecule, count] if (!found_new)
	end	
	new_versions.uniq!
	puts new_versions.count
	new_versions
end

end

p = Processor.new
#input = "HOH"
#p.calibrate(File.new("input19_cal_test.txt").readlines.map{|l|l.strip})
#p.possibilities(input)
 
p.calibrate(File.new("input19_cal.txt").readlines.map{|l|l.strip})
#p.possibilities(File.new("input19.txt").read.strip)
p.stepsToMolecule(File.new("input19.txt").read.strip)
#p.stepsToMolecule(input)