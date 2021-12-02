all_lines = File.read('day_2_input.txt').split("\n")

hor_pos = depth = 0
all_lines.each do |line|
  cmd, amount_string = line.split(" ")
  amount = amount_string.to_i

  hor_pos += amount if cmd == "forward"
  depth += amount if cmd == "down"
  depth -= amount if cmd == "up"
end
puts hor_pos * depth

hor_pos = depth = aim = 0
all_lines.each do |line|
  cmd, amount_string = line.split(" ")
  amount = amount_string.to_i

  if cmd == "forward"
    hor_pos += amount
    depth += (amount * aim)
  end
  aim += amount if cmd == "down"
  aim -= amount if cmd == "up"
end
puts hor_pos * depth

