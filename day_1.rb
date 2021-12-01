all_entries = File.read('day_1_input.txt').split("\n").map(&:to_i)

inc_count = 0
all_entries[1..-1].each_with_index do |e,i|
  if e > all_entries[i]
    inc_count += 1
  end
end

puts inc_count

inc_count = 0
all_entries[0..-4].each_with_index do |e,i|
  if all_entries[i+3] > e
    inc_count += 1
  end
end
puts inc_count
