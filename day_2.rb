all_lines = File.read('day_2_input.txt').split("\n")

hor_pos = depth = 0
all_lines.each do |line|
  cmd, amt_string = line.split(" ")
  amt = amt_string.to_i

  hor_pos += amt if cmd == "forward"
  depth += amt if cmd == "down"
  depth -= amt if cmd == "up"
end
puts hor_pos * depth

hor_pos = depth = aim = 0
all_lines.each do |line|
  cmd, amt_string = line.split(" ")
  amt = amt_string.to_i

  if cmd == "forward"
    hor_pos += amt
    depth += (amt * aim)
  end
  aim += amt if cmd == "down"
  aim -= amt if cmd == "up"
end
puts hor_pos * depth

