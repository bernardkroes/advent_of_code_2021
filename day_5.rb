class Grid
  SIZE = 1000

  def initialize(in_filename)
    @map = []
    @lines = []
    File.open(in_filename).each do |line|
      @lines << line.chomp.gsub(" -> ",",").split(',').map(&:to_i)
    end
    SIZE.times do
      @map << [0] * SIZE
    end
  end

  def set_line_counts(do_part2)
    @lines.each do |l|
      x1, y1, x2, y2 = l
      if x1 == x2
        [y1,y2].min.upto([y1,y2].max) { |y| @map[y][x1] += 1 }
      elsif y1 == y2
        [x1,x2].min.upto([x1,x2].max) { |x| @map[y1][x] += 1 }
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
          @map[start_y + i][start_x + i * delta_x] += 1
        end
      end
    end
  end

  def show_map
    SIZE.times do |l|
      puts @map[l].inspect
    end
  end

  def find_score
    two_or_more_count = 0
    SIZE.times do |l|
      two_or_more_count += @map[l].count { |e| e >= 2 }
    end
    two_or_more_count
  end
end

g = Grid.new('day_5_input.txt')
g.set_line_counts(false)
puts g.find_score

g = Grid.new('day_5_input.txt')
g.set_line_counts(true)
puts g.find_score
