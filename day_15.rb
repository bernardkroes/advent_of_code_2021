class ChitonMap
  DELTA_MOVES = [[ 1, 0], [ 0, 1], [-1, 0], [ 0,-1]]

  def initialize(in_filename)
    @the_map = []
    File.open(in_filename).each do |line|
      @the_map << line.chomp.chars.map(&:to_i)
    end
    @size_x = @the_map[0].size
    @size_y = @the_map.size
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def key_for(x,y)
    "#{x}_#{y}"
  end

  def enlarge(in_times)
    new_map = []
    (in_times * @size_y).times do |tile_y|
      new_map << [0] * (in_times * @size_x)
    end

    in_times.times do |tile_y|
      in_times.times do |tile_x|
        @size_y.times do |walk_y|
          @size_x.times do |walk_x|
            target_x = tile_x * @size_x + walk_x
            target_y = tile_y * @size_y + walk_y
            new_val = @the_map[walk_y][walk_x] + tile_x + tile_y
            new_val -= 9 while new_val > 9
            new_map[target_y][target_x] = new_val
          end
        end
      end
    end
    @size_x = @size_x * in_times
    @size_y = @size_y * in_times
    @the_map = new_map
  end

  def find_safest
    target_x, target_y = @size_x - 1, @size_y - 1
    dist_map = []
    min_remaining_dist = {}
    visited = {}
    @size_y.times do |y|
      dist_map << [1e9] * @size_x
    end
    dist_map[0][0] = 0
    visited[key_for(0,0)] = true
    x, y = 0, 0

    finished = false
    while !finished
      DELTA_MOVES.each do |move|
        walk_x, walk_y = x + move[0], y + move[1]
        if on_map?(walk_x, walk_y) && !visited.has_key?(key_for(walk_x, walk_y))
          if dist_map[y][x] + @the_map[walk_y][walk_x] < dist_map[walk_y][walk_x]
            dist_map[walk_y][walk_x] = dist_map[y][x] + @the_map[walk_y][walk_x]
            min_remaining_dist[key_for(walk_x, walk_y)] = dist_map[y][x] + @the_map[walk_y][walk_x]
          end
        end
      end
      visited[key_for(x,y)] = true
      min_remaining_dist.delete(key_for(x, y))

      the_key_value_pair = min_remaining_dist.sort_by {|k, v| v}[0]
      x, y = the_key_value_pair[0].split("_").map(&:to_i)
      finished = (x == target_x) && (y == target_y)
    end
    dist_map[target_y][target_x]
  end

  def show_info
    puts @size_x
    puts @size_y
  end

  def show_map
    @size_y.times do |y|
      line = ""
      @size_x.times do |x|
        line += @the_map[y][x].to_s
      end
      puts line
    end
  end
end

# part 1
the_map = ChitonMap.new('day_15_input.txt')
puts the_map.find_safest

# part 2 enlarge map
the_map.enlarge(5)
puts the_map.find_safest

