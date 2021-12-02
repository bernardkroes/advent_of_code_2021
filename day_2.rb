all_lines = File.read('day_2_input.txt').split("\n")

hor_pos = depth = 0
all_lines.each do |line|
  cmd, count_string = line.split(" ")
  count = count_string.to_i

  hor_pos += count if cmd == "forward"
  depth += count if cmd == "down"
  depth -= count if cmd == "up"
end
puts hor_pos * depth

hor_pos = depth = aim = 0
all_lines.each do |line|
  cmd, count_string = line.split(" ")
  count = count_string.to_i

  if cmd == "forward"
    hor_pos += count
    depth += (count * aim)
  end
  aim += count if cmd == "down"
  aim -= count if cmd == "up"
end
puts hor_pos * depth

