all_lines = File.read('day_8_input.txt').split("\n")

the_count = 0
all_lines.each do |line|
  inputs, outputs = line.split(" | ")
  outputs.split(" ").each do |o|
    the_count += 1 if [2,3,4,7].include?(o.length)
  end
end
puts the_count

# part 2 some more reasoning
# all_lines = 'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce'.split("\n")

tot_val = 0
all_lines.each do |line|
  inputs, outputs = line.split(" | ")
  sorted_inputs = []
  sorted_outputs = []
  values = [-1] * 10

  sorted_inputs = inputs.split(" ").map(&:chars).map(&:sort).map(&:join)
  sorted_outputs = outputs.split(" ").map(&:chars).map(&:sort).map(&:join)

  # start reasoning
  sorted_inputs.each_with_index do |k,i|
    # by length 2,4,3,7 => 1, 4, 7, 8
    values[i] = 4 if k.length == 4
    values[i] = 7 if k.length == 3
    values[i] = 8 if k.length == 7
    values[i] = 1 if k.length == 2

    if k.length == 2 # dive in: we can use the '1' leds to find the 3 and 6 by looking at the number of differing leds, same for 3 (-> 9) and 6 (-> 5)
      sorted_inputs.each_with_index do |other_k,j|
        # subtracting 1 from 3 (for 5-led numbers) leaves 3 leds on
        if other_k.length == 5 && (other_k.chars - k.chars).length == 3
          values[j] = 3
          sorted_inputs.each_with_index do |k3,jj| # subtracting 3 from 9 (for 6-led numbers only) leaves 1 led on
            values[jj] = 9 if k3.length == 6 && (k3.chars - other_k.chars).length == 1
          end
        elsif other_k.length == 6 && (other_k.chars - k.chars).length == 5 # subtracting 1 from 6 (for 6-led numbers only) leaves 5 leds on
          values[j] = 6
          sorted_inputs.each_with_index do |k3,jj| # subtracting 5 from 6 (for 6-led numbers only) leaves 1 led on
            values[jj] = 5 if k3.length == 5 && (other_k.chars - k3.chars).length == 1
          end
        end
      end
    end
  end
  # only remaining with 6-leds on -> 0
  # only remaining with 5-leds on -> 2
  values.each_with_index do |v,i|
    if v == -1
      values[i] = 0 if sorted_inputs[i].length == 6
      values[i] = 2 if sorted_inputs[i].length == 5
    end
  end

  line_val = 0
  sorted_outputs.each do |out|
    line_val *= 10
    line_val += values[sorted_inputs.find_index { |i| i == out }]
  end
  tot_val += line_val
end
puts tot_val
