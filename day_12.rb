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

  def can_go_to?(in_route, in_dest)
    return false if in_dest == "start"
    return true if !is_small_cave?(in_dest)
    return true if in_route.count { |c| c == in_dest } == 0

    # part 1
    # return false

    # part two conditions:
    # return false if any small cave occurs twice
    small_cave_counts = Hash.new(0)
    in_route.select { |c| is_small_cave?(c) }.each do |cave|
      small_cave_counts[cave] += 1
      return false if small_cave_counts[cave] > 1
    end
    true
  end

  # note that all found routes are collecte in the all_routes param and returned for convenience
  def find_all_routes(all_routes, current_route, destination)
    current_node = current_route[-1]
    if current_node == destination
      all_routes << current_route
      return all_routes
    end

    next_caves = @all_caves[current_node].select { |next_cave| can_go_to?(current_route, next_cave) }
    next_caves.each do |next_cave|
      find_all_routes(all_routes, current_route + [next_cave], destination)
    end
    all_routes
  end
end

the_cave_map = CaveMap.new('day_12_input.txt')
all_routes = the_cave_map.find_all_routes([], ['start'], "end")
puts all_routes.length
