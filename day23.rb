class Instruction

    attr_reader :instruction, :register, :offset
    
    def initialize(instruction, register, offset)
            @instruction = instruction
            @register = register
            @offset = offset
            
    end
    
    def next
        case instruction
            when "hlf"
                @register.value = @register.value/2
            when "tpl"
                @register.value *= 3
            when "inc"
                @register.value += 1
            when "jmp"
                return @offset
            when "jie"
                if @register.value % 2 == 0
                    return @offset 
                end
            when "jio"
                if @register.value == 1
                    return @offset 
                end
        end
    return 1
    end
end

class Register

    attr_accessor :value
    attr_reader :name
    
    def initialize(name, value)
        @name = name
        @value = value
    end
    
    def to_s
        "#{@name} => #{@value}"
    end
    
    
end
class Program
    
    attr_reader :instructions, :registers
    
    def initialize(instructions, registers)
        @instructions = instructions
        @registers = registers
    end
    
    def run
        current_instruction = @instructions[0]
        while (current_instruction != nil)
            index = @instructions.index(current_instruction)
            current_instruction = @instructions[index + current_instruction.next]
        end     
    end
        
end

class Processor

    def initialize
        @registers = {"a"=> Register.new("a",0), "b" => Register.new("b",0)}        
        @instructions = []
    end
    
    def parse(lines)
        lines.each do |l|
            i = l.match(/^(\w+)/)
            i = i[1] if (i)
            r = l.match(/ (\w)/)
            r = r[1].strip if (r)
            j = l.match(/([+\-0-9]+)/)
            j = j[1].to_i if (j)
            instruction = Instruction.new(i,@registers[r], j)
            @instructions << instruction
        end
    end
    
    def part1
        p = Program.new(@instructions, @registers)
        p.run
        puts "Day 23 part 1: #{@registers["b"]}"        
    end
    
    def part2
        p = Program.new(@instructions, @registers)
        @registers["a"].value += 1
        p.run
        puts "Day 23 part 2: #{@registers["b"]}"        
    end
end

lines = File.new("day23_input.txt").readlines.map{|l|l.strip}
p = Processor.new
p.parse(lines)
p.part1

p = Processor.new
p.parse(lines)
p.part2

