all_lines = File.read('day_2_input.txt').split("\n")

hor_pos = depth = 0
all_lines.each do |line|
  cmd, count_string = line.split(" ")
  count = count_string.to_i
  if cmd == "forward"
    hor_pos += count
  elsif cmd == "down"
    depth += count
  elsif cmd == "up"
    depth -= count
  end
end
puts hor_pos * depth

hor_pos = depth = aim = 0
all_lines.each do |line|
  cmd, count_string = line.split(" ")
  count = count_string.to_i
  if cmd == "forward"
    hor_pos += count
    depth += (count * aim)
  elsif cmd == "down"
    aim += count
  elsif cmd == "up"
    aim -= count
  end
end
puts hor_pos * depth

