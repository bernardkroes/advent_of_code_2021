all_fish = File.read('day_6_input.txt').split(",").map(&:to_i)
# all_fish = "3,4,3,1,2".split(",").map(&:to_i)

80.times do |d|
  new_fish_count = all_fish.count { |f| f == 0 }
  all_fish.each_with_index do |f,i|
    f -= 1
    f = 6 if f < 0
    all_fish[i] = f
  end
  all_fish += [8] * new_fish_count
end
puts all_fish.size

# part 2: optimized method
# read input again
all_fish = File.read('day_6_input.txt').split(",").map(&:to_i)
day_counts = []
9.times do |c|
  day_counts << all_fish.count { |f| f == c }
end

256.times do |d|
  day_counts = day_counts.rotate
  day_counts[6] += day_counts[8]

  # or one-line:
  # day_counts.rotate![6] += day_counts[8]
end
puts day_counts.sum
