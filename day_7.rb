crab_positions = File.read('day_7_input.txt').split(",").map(&:to_i)
# crab_positions = = 16,1,2,0,4,2,7,1,2,14

min_fuel = -1
0.upto(crab_positions.max) do |pos|
  total_fuel = 0
  crab_positions.each do |crab_pos|
    # total_fuel += (crab_pos - pos).abs        # part 1

    # part 2
    # total_fuel += (0..(crab_pos - pos).abs).sum # originally used this

#    or use the triangle formula for a little speedup:
    the_dist = (crab_pos - pos).abs
    total_fuel += the_dist * (the_dist + 1) / 2
  end
  if total_fuel < min_fuel || min_fuel == -1
    min_fuel = total_fuel
  end
end
puts min_fuel

