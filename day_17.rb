# target area: x=241..273, y=-97..-63 => hard code it

def next_path_elem_for(pos_x, pos_y, vel_x, vel_y)
  [pos_x + vel_x, pos_y + vel_y, vel_x + (0 <=> vel_x), vel_y - 1] # spaceship operator to determine sign(x): -1/0/1
end

target_x_min, target_x_max = 241, 273
target_y_min, target_y_max = -97, -63

max_y = 0
num_hits = 0

# use some reasonable starting values and bounds
target_x_max.downto(Math.sqrt(target_x_min)) do |start_vel_x|
  (-1 * target_y_min).downto(target_y_min) do |start_vel_y|
    pos_x, pos_y = 0, 0

    the_path = []
    the_path_elem = [pos_x, pos_y, start_vel_x, start_vel_y]
    the_path << the_path_elem
    loop do
      the_path_elem = next_path_elem_for(the_path_elem[0], the_path_elem[1], the_path_elem[2], the_path_elem[3])
      the_path << the_path_elem

      should_break = false
      x, y = the_path_elem[0], the_path_elem[1]
      if x >= target_x_min && x <= target_x_max && y >= target_y_min && y <= target_y_max
        path_max_y = the_path.collect { |e| e[1] }.max
        max_y = path_max_y if path_max_y > max_y
        num_hits += 1
        should_break = true
      end

      should_break = true if the_path_elem[1] < target_y_min
      should_break = true if the_path_elem[0] > target_x_max
      if the_path_elem[2] == 0 # vel_x
        should_break = true if (the_path_elem[0] < target_x_min) # > target_x_max and y < target_y_min already dealt with
      end
      break if should_break
    end
  end
end

puts max_y
puts num_hits
