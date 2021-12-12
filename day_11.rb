require 'set'

class OctoMap
  attr_reader :size_x, :size_y

  DELTA_MOVES = [[-1,-1],[ 0,-1],[ 1,-1],
                 [-1, 0],[ 1, 0],
                 [-1, 1],[ 0, 1],[ 1, 1]]

  def initialize(in_filename)
    @octo_map = []
    File.open(in_filename).each do |line|
      @octo_map << line.chomp.chars.map(&:to_i)
    end
    @size_x = @octo_map[0].size
    @size_y = @octo_map.size
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def flash(x, y, did_flash)
    return if did_flash.include?([x,y])

    did_flash.add([x,y])

    DELTA_MOVES.each do |move|
      the_check_x, the_check_y = x + move[0], y + move[1]
      if on_map?(the_check_x, the_check_y) && @octo_map[the_check_y][the_check_x] <= 9
        @octo_map[the_check_y][the_check_x] += 1
        flash(the_check_x, the_check_y, did_flash) if @octo_map[the_check_y][the_check_x] == 10
      end
    end
  end

  def take_step
    # inc all the energy levels:
    @octo_map.each_with_index do |line, i|
      line.each_index { |i| line[i] += 1 }
    end
    # flash!
    did_flash = Set.new
    @size_x.times do |x|
      @size_y.times do |y|
        flash(x,y, did_flash) if @octo_map[y][x] == 10
      end
    end
    # wrap to zero
    @octo_map.each_with_index do |line, i|
      line.each_index { |i| line[i] = 0 if line[i] > 9 }
    end
    did_flash.length
  end

  def show_octomap
    # puts "\e[H\e[2J" # clear the terminal for more fun
    puts "-" * 10
    @octo_map.each do |line|
      puts line.inspect
    end
  end

  def show_flashed_map
    puts "\e[H\e[2J" # clear the terminal for more fun
    @octo_map.each do |line|
      line_string = ""
      line.each do |v|
        if v > 6
          line_string +="\033[0;32m#{v}\033[0m"
        elsif v > 3
          line_string +="\033[0;37m#{v}\033[0m"
        elsif v > 0
          line_string +="\033[0;33m#{v}\033[0m"
        else
          line_string +="\033[1;33m0\033[0m"
        end
      end
      puts line_string
    end
    sleep(1.0/24.0)
  end
end

the_octo_map = OctoMap.new('day_11_input.txt')
total_flash_count = 0
100.times do |s|
  total_flash_count += the_octo_map.take_step
  # the_octo_map.show_flashed_map
end
puts total_flash_count

#part 2
the_octo_map = OctoMap.new('day_11_input.txt')
flash_count = step = 0
while flash_count < 100
  flash_count = the_octo_map.take_step
  step += 1
  the_octo_map.show_flashed_map
end
puts step

