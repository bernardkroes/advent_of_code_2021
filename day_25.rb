class FloorMap
  def initialize(in_lines)
    @the_map = []
    @default_char = "."
    in_lines.each do |line|
      @the_map << line.chomp
    end
    @size_x = @the_map[0].size
    @size_y = @the_map.size
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def char_for(in_x, in_y)
    return @default_char if !on_map?(in_x, in_y)
    @the_map[in_y][in_x]
  end

  def show_info
    puts @size_x
    puts @size_y
  end

  def is_occupied?(x, y)
    check_x, check_y = x, y
    check_y = 0 if y >= @size_y
    check_x = 0 if x >= @size_x
    @the_map[check_y][check_x] != "."
  end

  def set_map(x, y, val)
    the_x, the_y = x, y
    the_y = 0 if y >= @size_y
    the_x = 0 if x >= @size_x
    @the_map[the_y][the_x] = val
  end

  def show_grid
    # puts "\e[H\e[2J" # clear the terminal for more fun
    @size_y.times do |y|
      puts @the_map[y]
    end
  end

  def take_step
    moved_count = 0
    moved_count += move_east
    moved_count += move_south
    moved_count
  end

  def move_east
    moved_count = 0

    @size_y.times do |y|
      @size_x.times do |x|
        if @the_map[y][x] == ">"
          if !is_occupied?(x + 1, y)
            set_map(x + 1, y, "E") # leave a T(emp) E(ast) trail: TE
            set_map(x, y, "T")
            moved_count += 1
          end
        end
      end
    end
    @size_y.times do |y|
      @the_map[y] = @the_map[y].gsub("E",">") # remove the trail
      @the_map[y] = @the_map[y].gsub("T",".")
    end
    moved_count
  end

  def move_south
    moved_count = 0

    @size_y.times do |y|
      @size_x.times do |x|
        if @the_map[y][x] == "v"
          if !is_occupied?(x, y + 1)
            set_map(x, y + 1, "S")  # leave a T(emp) S(outh) trail: TS
            set_map(x, y, "T")
            moved_count += 1
          end
        end
      end
    end
    @size_y.times do |y|
      @the_map[y] = @the_map[y].gsub("S","v") # remove the trail
      @the_map[y] = @the_map[y].gsub("T",".")
    end
    moved_count
  end
end

all_lines = File.read('day_25_input.txt').split("\n")

floormap = FloorMap.new(all_lines)
floormap.show_grid

the_step_count = 0
moved_count = 1
while moved_count > 0
  moved_count = floormap.take_step
  the_step_count += 1
  # floormap.show_grid
end

puts the_step_count

