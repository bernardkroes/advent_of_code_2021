# all_entries = File.read('day_22_input.txt').split("\n").map(&:to_i)
all_lines = File.read('day_22_input.txt').split("\n")

class Cube
  attr_reader :xmin, :xmax
  attr_reader :ymin, :ymax
  attr_reader :zmin, :zmax
  attr_reader :is_on

  def initialize(xmin, xmax, ymin, ymax, zmin, zmax, on)
    @xmin = xmin
    @xmax = xmax
    @ymin = ymin
    @ymax = ymax
    @zmin = zmin
    @zmax = zmax
    @is_on = on
  end

  def show_info
    puts "#{@is_on ? 'On' : 'Off'} #{@xmin} - #{@xmax}, #{@ymin} - #{@ymax}, #{@zmin} - #{@zmax}"
  end

  def has_overlap_with?(other_cube)
    !((other_cube.xmax < @xmin) || (other_cube.xmin > @xmax) ||
      (other_cube.ymax < @ymin) || (other_cube.ymin > @ymax) ||
      (other_cube.zmax < @zmin) || (other_cube.zmin > @zmax))
  end

  def volume
    dx = @xmax - @xmin + 1
    dy = @ymax - @ymin + 1
    dz = @zmax - @zmin + 1
    dx * dy * dz
  end

  # split this cube into (max) 27 subcubes so that there is no more overlap, leave out the 'middle' one: that will be the other_cube
  def split(other_cube)
    split_cubes = []

    [@xmin..other_cube.xmin-1, [other_cube.xmin, @xmin].max..[other_cube.xmax, @xmax].min, other_cube.xmax+1..@xmax].each_with_index do |xrange, xi|
      [@ymin..other_cube.ymin-1, [other_cube.ymin, @ymin].max..[other_cube.ymax, @ymax].min, other_cube.ymax+1..@ymax].each_with_index do |yrange, yi|
        [@zmin..other_cube.zmin-1, [other_cube.zmin,@zmin].max..[other_cube.zmax, @zmax].min, other_cube.zmax+1..@zmax].each_with_index do |zrange, zi|
          if !(xi == 1 && yi == 1 && zi == 1) &&
            (xrange.end >= xrange.begin) && (yrange.end >= yrange.begin) && (zrange.end >= zrange.begin)
            split_cubes << Cube.new(xrange.begin, xrange.end, yrange.begin, yrange.end, zrange.begin, zrange.end, @is_on)
          end
        end
      end
    end
    split_cubes
  end
end

cubes = []
all_lines.each do |line|
  # on x=-20..34,y=-40..6,z=-44..1
  # off x=26..39,y=40..50,z=-2..11

  if line.start_with?("on")
    s = line.gsub("on ","").split(",")
    v = 1
  else
    s = line.gsub("off ","").split(",")
    v = 0
  end
  x_s = s[0].gsub("x=","").split("..").map(&:to_i)
  y_s = s[1].gsub("y=","").split("..").map(&:to_i)
  z_s = s[2].gsub("z=","").split("..").map(&:to_i)

  cubes << Cube.new(x_s[0], x_s[1], y_s[0], y_s[1], z_s[0], z_s[1], v > 0)
end

# part 1:
# cubes = cubes[0..19]

result_cubes = []
result_cubes << cubes.shift

while cubes.length > 0
  the_cube = cubes.shift

  new_result_cubes = []
  result_cubes.each do |c|
    new_result_cubes = new_result_cubes +( c.has_overlap_with?(the_cube) ? c.split(the_cube) : [c])
  end
  result_cubes = new_result_cubes << the_cube
end

volume = 0
result_cubes.each do |c|
  volume += c.volume if c.is_on
end
puts volume
