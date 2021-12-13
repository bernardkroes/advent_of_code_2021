class DotMap
  attr_reader :all_dots

  def initialize(in_filename)
    @all_dots = {}
    File.open(in_filename).each do |line|
      if line.strip().length > 0 && !line.start_with?("fold")
        the_x, the_y = line.chomp.split(",")
        @all_dots[[the_x.to_i, the_y.to_i]] = true
      end
    end
  end

  def fold_along_y(fold_y)
    new_dots = {}
    @all_dots.keys.each do |k|
      the_x, the_y = k[0], k[1]
      if the_y > fold_y
        new_y = fold_y - (the_y - fold_y)
        @all_dots[[the_x, new_y]] = true
        @all_dots.delete(k)
      end
    end
  end

  def fold_along_x(fold_x)
    new_dots = {}
    @all_dots.keys.each do |k|
      the_x, the_y = k[0], k[1]
      if the_x > fold_x
        new_x = fold_x - (the_x - fold_x)
        @all_dots[[new_x, the_y]] = true
        @all_dots.delete(k)
      end
    end
  end

  def max_xy
    max_x = 0
    max_y = 0
    @all_dots.each do |k,v|
      max_x = k[0] if k[0] > max_x
      max_y = k[1] if k[1] > max_y
    end
    return max_x, max_y
  end

  def show_info
    puts @all_dots.count
  end

  def display_map
    max_x, max_y = max_xy
    0.upto(max_y) do |y|
      the_line = ""
      0.upto(max_x) do |x|
        the_line << (@all_dots.has_key?([x,y]) ? "#" : ".")
      end
      puts the_line
    end
  end
end

the_dot_map = DotMap.new('day_13_input.txt')
the_dot_map.show_info

all_lines = File.read('day_13_input.txt').split("\n")
all_lines.each do |line|
  if line.start_with?("fold along x=")
    the_x = line.gsub("fold along x=","").to_i
    the_dot_map.fold_along_x(the_x)
    the_dot_map.show_info
  elsif line.start_with?("fold along y=")
    the_y = line.gsub("fold along y=","").to_i
    the_dot_map.fold_along_y(the_y)
    the_dot_map.show_info
  end
end
the_dot_map.display_map
