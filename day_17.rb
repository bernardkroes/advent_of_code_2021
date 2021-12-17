# target area: x=241..273, y=-97..-63 => hard code it

def in_target_area?(x,y)
  x >= 241 && x <= 273 && y >= -97 && y <= -63
end

def next_path_elem_for(pos_x, pos_y, vel_x, vel_y)
  [pos_x + vel_x, pos_y + vel_y, vel_x + (0 <=> vel_x), vel_y - 1] # spaceship operator to determine sign(x): -1/0/1
end

# use some reasonalbe starting values and bounds
max_y = 0
num_hits = 0

274.downto(1) do |start_vel_x|      # 241 for part 1
  273.downto(-273) do |start_vel_y| # downto 1 for part 1
    pos_x, pos_y = 0, 0

    the_path = []
    the_path_elem = [pos_x, pos_y, start_vel_x, start_vel_y]
    the_path << the_path_elem
    loop do
      the_path_elem = next_path_elem_for(the_path_elem[0], the_path_elem[1], the_path_elem[2], the_path_elem[3])
      the_path << the_path_elem

      should_break = false
      if in_target_area?(the_path_elem[0], the_path_elem[1])
        path_max_y = the_path.collect { |e| e[1] }.max
        max_y = path_max_y if path_max_y > max_y
        num_hits += 1
        should_break = true
      end

      should_break = true if the_path_elem[1] < -97
      should_break = true if the_path_elem[0] > 273
      if the_path_elem[2] == 0 # vel_x
        should_break = true if (the_path_elem[0] < 241) # > 273 and y < -97 already dealt with
      end
      break if should_break
    end
  end
end

puts max_y
puts num_hits
