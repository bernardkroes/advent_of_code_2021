class Grid
  def initialize(in_filename)
    @grid = {}
    @lines = []
    File.open(in_filename).each do |line|
      @lines << line.chomp.gsub(" -> ",",").split(',').map(&:to_i)
    end
  end

  def inc_value_at(x,y)
    the_key = "#{x}_#{y}"
    @grid[the_key] = 0 unless @grid.has_key?(the_key)
    @grid[the_key] += 1
  end

  def set_line_counts(do_part2)
    @lines.each do |l|
      x1, y1, x2, y2 = l
      if x1 == x2
        [y1,y2].min.upto([y1,y2].max) { |y| inc_value_at(x1, y) }
      elsif y1 == y2
        [x1,x2].min.upto([x1,x2].max) { |x| inc_value_at(x, y1) }
      elsif do_part2 # part 2 : diagonal lines
        start_y, end_y = y1, y2
        start_x = x1
        delta_x = x2 > x1 ? 1 : -1

        if y1 > y2
          start_y, end_y = y2, y1
          start_x = x2
          delta_x = x1 > x2 ? 1 : -1
        end
        (end_y - start_y + 1).times do |i|
          inc_value_at(start_x + i * delta_x, start_y + i)
        end
      end
    end
  end

  def find_score
    @grid.values.count { |e| e >= 2 }
  end
end

g = Grid.new('day_5_input.txt')
g.set_line_counts(false)
puts g.find_score

g = Grid.new('day_5_input.txt')
g.set_line_counts(true)
puts g.find_score
