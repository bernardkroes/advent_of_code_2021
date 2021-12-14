all_lines = File.read('day_14_input.txt').split("\n")
the_start = all_lines[0]

rules = {}
all_lines.each do |line|
  if line.include?(" -> ")
    k, v = line.split(" -> ")
    rules[k] = v
  end
end

# part 1
10.times do
  the_new_line = ""
  last_c = ""
  the_start.chars.each_cons(2) do |c|
    the_new_line << c[0]
    the_new_line << rules[c.join]
    last_c = c[1]
  end
  the_new_line << last_c
  the_start = the_new_line
end

the_count = Hash.new(0)
the_start.chars.each do |c|
  the_count[c] += 1
end
puts the_count.values.max - the_count.values.min

#part 2
the_start = all_lines[0]

# initial count
the_count = Hash.new(0)
the_start.chars.each do |c|
  the_count[c] += 1
end

rules_to_apply = Hash.new(0)
the_start.chars.each_cons(2) do |c|
  rules_to_apply[c.join] += 1
end

40.times do
  # apply rules to counts
  next_rules_to_apply = Hash.new(0)

  rules_to_apply.each do |k,v|
    the_new_char = rules[k]
    the_count[the_new_char] += v

    next_rules_to_apply[k.chars[0] + the_new_char] += v
    next_rules_to_apply[the_new_char + k.chars[1]] += v
  end
  rules_to_apply = next_rules_to_apply
end
puts the_count.values.max - the_count.values.min
