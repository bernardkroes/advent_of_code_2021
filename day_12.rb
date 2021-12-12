class CaveMap
  def initialize(in_filename)
    @all_caves = Hash.new { |h, k| h[k] = [] }
    File.open(in_filename).each do |line|
      the_from_cave, the_dest_cave = line.chomp.split("-")

      @all_caves[the_from_cave] << the_dest_cave
      @all_caves[the_dest_cave] << the_from_cave
    end
  end

  def is_small_cave?(in_cave)
    in_cave.downcase == in_cave
  end

  def can_go_to_part1?(in_route, in_dest)
    if is_small_cave?(in_dest) && in_route.include?(in_dest)
      return false
    end
    true
  end

  def can_go_to?(in_route, in_dest)
    return false if in_dest == "start"

    if is_small_cave?(in_dest)
      # count all small caves in the route:
      small_cave_counts = Hash.new(0)
      in_route.each do |cave|
        small_cave_counts[cave] += 1 if is_small_cave?(cave)
      end
      if small_cave_counts[in_dest] > 0 && small_cave_counts.any? { |k,v| v == 2 }
        return false
      end
    end
    true
  end

  def find_all_routes(all_routes, current_route)
    current_node = current_route[-1]
    candidate_caves = @all_caves[current_node]

    candidate_caves.each do |dest|
      if can_go_to?(current_route, dest)
        if dest == 'end'
          all_routes << (current_route + [dest])
        else
          find_all_routes(all_routes, current_route + [dest])
        end
      end
    end
    all_routes
  end
end

the_cave_map = CaveMap.new('day_12_input.txt')
all_routes = the_cave_map.find_all_routes([], ['start'])
puts all_routes.length
