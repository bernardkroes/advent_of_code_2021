all_entries = File.read('day_1_input.txt').split("\n").map(&:to_i)

inc_count = 0
look_ahead = 1
all_entries[0..(-1-look_ahead)].each_with_index { |e,i| inc_count += 1 if all_entries[i+look_ahead] > e }
puts inc_count

# no need to sum because the sliding windows are overlapping, we can igonre the overlap, and just need to compare the element with the element that is ahead (1 or 3 steps)
inc_count = 0
look_ahead = 3
all_entries[0..(-1-look_ahead)].each_with_index { |e,i| inc_count += 1 if all_entries[i+look_ahead] > e }
puts inc_count
