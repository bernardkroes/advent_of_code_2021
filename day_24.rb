class Alu
  attr_accessor :regs

  def initialize(in_filename)
    @ins = []
    File.open(in_filename).each do |line|
      @ins << line.chomp.split(" ")
    end
    @regs = {}
    reset
  end

  def reset
    @regs["w"] = 0
    @regs["x"] = 0
    @regs["y"] = 0
    @regs["z"] = 0
  end

  def value_for(arg)
    case arg
    when "w"
      value = @regs[arg]
    when "x"
      value = @regs[arg]
    when "y"
      value = @regs[arg]
    when "z"
      value = @regs[arg]
    else
      value = arg.to_i
    end
  end

  def setreg(reg, arg)
    @regs[reg] = value_for(arg)
  end

  def runline(line, inputs)
    case line[0]
    when "inp"
      setreg(line[1], inputs.shift)
    when "add"
      setreg(line[1], value_for(line[1]) + value_for(line[2]))
    when "mul"
      setreg(line[1], value_for(line[1]) * value_for(line[2]))
    when "div"
      setreg(line[1], (value_for(line[1]).to_f / value_for(line[2]).to_f).truncate )
    when "mod"
      setreg(line[1], value_for(line[1]) % value_for(line[2]))
    when "eql"
      setreg(line[1], value_for(line[1]) == value_for(line[2]) ? 1 : 0)
    end
  end

  def runlines(inputs)
    reset
    @ins.each do |ins|
      runline(ins, inputs)
    end
  end
end

the_alu = Alu.new('day_24_input.txt')

if false # part1
  9.downto(2) do |input0|
    input7 = input0 - 1
    4.downto(1) do |input1|
      input4 = input1 + 5
      3.downto(1) do |input2|
        input3 = input2 + 6
        8.downto(1) do |input5|
          input6 = input5 + 1
          9.downto(6) do |input8|
            input9 = input8 - 5
            9.downto(1) do |input10|
              input13 = input10
              9.downto(5) do |input11|
                input12 = input11 - 4
                inputs = [input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13]
                orig_inputs = inputs.clone
                the_alu.runlines(inputs)

                if the_alu.regs["z"] == 0
                  puts the_alu.regs.inspect
                  puts orig_inputs.map(&:to_s).join
                  exit
                end
              end
            end
          end
        end
      end
    end
  end
end

# part 2, revert all the arguments

2.upto(9) do |input0|
  input7 = input0 - 1
  1.upto(4) do |input1|
    input4 = input1 + 5
    1.upto(3) do |input2|
      input3 = input2 + 6
      1.upto(8) do |input5|
        input6 = input5 + 1
        6.upto(9) do |input8|
          input9 = input8 - 5
          1.upto(9) do |input10|
            input13 = input10
            5.upto(9) do |input11|
              input12 = input11 - 4
              inputs = [input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13]
              orig_inputs = inputs.clone
              the_alu.runlines(inputs)

              if the_alu.regs["z"] == 0
                puts the_alu.regs.inspect
                puts orig_inputs.map(&:to_s).join
                exit
              end
            end
          end
        end
      end
    end
  end
end

__END__

Code/input analysis notes:

w = input
x = (((z % 26) + b) != w)   # 0 or 1
z = z / a
z *= (25 * x + 1)           # *= 26 or *= 1
z += (w + c) * x            # 0 or (w + c) 

====================================
if x == 0:
  w = input
  z = z / a                  # shift right in base 26

if x == 1:
  w = input
  z = z / a                  # shift right in base 26
  z *= 26                    # shift left in base 26
  z += (w + c)

====================================
a = 1 or 26
if a == 1 => b >= 10 !!!!
====================================
if a == 1:
  w = input
  x = 1 (!!!)
  z *= 26
  z += (w + c)   => push (w+c) at end (in base 26)

if a == 26:
  if x == 1
    w = input
    z = z / 26   => replace last (base 26) by (w + c)
    z *= 26
    z += (w + c)

  if x == 0
    w = input
    z = z / 26   => pop (in base 26)

====================================
=> how can z decrease???
by dividing it by a(26) (shift right in base 26)

if x == 0: z stays the same
only if c negative and smaller than -w

        a     b      c
 0:     1    12     15          push inputs[0] + 15
 1:     1    14     12          push inputs[1] + 12
 2:     1    11     15          push inputs[2] + 15
 3:    26    -9     12          pop  inputs[2] + 15 => x == 0: ((inputs[2] + 6) != w): inputs[3] == inputs[2] + 6
 4:    26    -7     15          pop  inputs[1] + 12 => x == 0: ((inputs[1] + 5) != w): inputs[4] == inputs[1] + 5
 5:     1    11      2          push inputs[5] +  2
 6:    26    -1     11          pop  inputs[5] +  2 => x == 0: ((inputs[5] + 2 - 1) != w): inputs[6] == inputs[5] + 1
 7:    26   -16     15          pop  push inputs[0] + 15 => x == 0: ((inputs[0] + 15 - 16) != w): inputs[7] == inputs[0] - 1
 8:     1    11     10          push inputs[8] + 10
 9:    26   -15      2          pop  inputs[8] + 10 => x == 0: ((inputs[8] + 10 - 15) != w): inputs[9] == inputs[8] - 5
10:     1    10      0          push inputs[10]
11:     1    12      0          push inputs[11]
12:    26    -4     15          pop  inputs[11] => x == 0: ((inputs[11] - 4) != w): inputs[12] == inputs[11] - 4
13:    26     0     15          pop  inputs[10] => x == 0: ((inputs[10] + 0) != w): inputs[13] == inputs[10]

