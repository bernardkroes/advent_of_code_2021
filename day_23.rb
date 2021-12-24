class CaveMap
  def initialize(in_filename)
    @m = []
    File.open(in_filename).each do |line|
      @m << line.chomp
    end
  end

  def show_map
    # puts "\e[H\e[2J" # clear the terminal for more fun
    puts "-" * 10
    @m.each do |line|
      puts line.inspect
    end
  end

  def at(x,y)
    @m[y][x]
  end

  def is_in_hallway?(x,y)
    y == 1
  end

  def steps_for_move(from_x, from_y, dest_x, dest_y)
    if is_in_hallway?(from_x, from_y) || is_in_hallway?(dest_x, dest_y) # manhattan distance
      return (dest_x - from_x).abs + (dest_y - from_y).abs
    end
    # from cave to cave
    (from_y - 1) + (dest_y - 1) + (dest_x - from_x).abs
  end

  def route_clear?(from_x, from_y, dest_x, dest_y)
    return false if at(dest_x, dest_y) != "."

    if !is_in_hallway?(from_x, from_y)
      # up to hallway should be empty
      return false if 1.upto(from_y-1).any? { |y| at(from_x, y) != "." }
    end

    # hallway should be empty
    start_x, end_x = [from_x, dest_x].minmax
    start_x += 1 if from_x < dest_x
    end_x -= 1 if from_x > dest_x
    return false if start_x.upto(end_x).any? { |x| at(x, 1) != "." }

    if !is_in_hallway?(dest_x, dest_y)
      # dest cave should be empty
      return false if 1.upto(dest_y-1).any? { |y| at(dest_x, y) != "." }
    end
    true
  end

  def dest_cave_does_not_contain_wrong_amphipod?(in_dest_cave, letter) # dest_cave does not contain wrong amphipods
    in_dest_cave.all? { |p| [".", letter].include?(at(p[0],p[1])) }
  end

  # the monster
  def all_possible_moves
    moves = [] # [from_x, from_y, dest_x, dest_y, letter, steps]

    # from cave to cave or hallway otherwise
    undone_caves.select { |c| !first_occupied_for(c).nil?}.each do |cave|
      from_x, from_y = first_occupied_for(cave)
      letter = at(from_x, from_y)
      dest_cave = dest_cave_for(letter)
      already_in_cave = dest_cave.any? { |p| p[0] == from_x && p[1] == from_y }
      dest_cave_ok = dest_cave_does_not_contain_wrong_amphipod?(dest_cave, letter)

      should_stay_in_cave = already_in_cave && dest_cave_ok
      added_dest_cave_move = false
      if !should_stay_in_cave
        # to dest_cave?
        if dest_cave_ok
          dest_x, dest_y = last_empty_for(dest_cave)
          if dest_x && route_clear?(from_x, from_y, dest_x, dest_y)
            moves << [from_x, from_y, dest_x, dest_y, letter, steps_for_move(from_x, from_y, dest_x, dest_y)]
            added_dest_cave_move = true
          end
        end
        # to any in hallway?
        if !added_dest_cave_move
          hallway.each do |h|
            dest_x, dest_y = h[0], h[1]
            if route_clear?(from_x, from_y, dest_x, dest_y)
              moves << [from_x, from_y, dest_x, dest_y, letter, steps_for_move(from_x, from_y, dest_x, dest_y)]
            end
          end
        end
      end
    end
    # from hallway to cave
    hallway.select { |h| at(h[0], h[1]) != "." }.each do |h|
      from_x, from_y = h[0], h[1]
      letter = at(from_x, from_y)
      dest_cave = dest_cave_for(letter)

      if dest_cave_does_not_contain_wrong_amphipod?(dest_cave, letter)
        dest_x, dest_y = last_empty_for(dest_cave)
        if dest_x && route_clear?(from_x, from_y, dest_x, dest_y)
          moves << [from_x, from_y, dest_x, dest_y, letter, steps_for_move(from_x, from_y, dest_x, dest_y)]
        end
      end
    end
    moves
  end

  def costs_for_letter(amphipod)
    { "A" => 1, "B" => 10, "C" => 100, "D" => 1000 }[amphipod]
  end

  def costs_for_move(in_move) # [from_x, from_y, dest_x, dest_y, letter, steps]
    in_move[5] * costs_for_letter(in_move[4])
  end

  def do_move(in_move) # [from_x, from_y, dest_x, dest_y, letter, steps]
    from_x, from_y = in_move[0], in_move[1]
    dest_x, dest_y = in_move[2], in_move[3]
    @m[from_y][from_x] = "."
    @m[dest_y][dest_x] = in_move[4]
  end

  def revert_move(in_move) # [from_x, from_y, dest_x, dest_y, letter, steps]
    from_x, from_y = in_move[2], in_move[3]
    dest_x, dest_y = in_move[0], in_move[1]
    @m[from_y][from_x] = "."
    @m[dest_y][dest_x] = in_move[4]
  end

  # functions for now, because why not
  def hallway
    [ [1,1], [2,1], [4,1], [6,1], [8,1], [10,1], [11,1] ]
  end

  def caveA
    [ [3,2], [3,3], [3,4], [3,5] ] #    [ [3,2], [3,3] ]
  end

  def caveB
    [ [5,2], [5,3], [5,4], [5,5] ] #    [ [5,2], [5,3] ]
  end

  def caveC
    [ [7,2], [7,3], [7,4], [7,5] ] #    [ [7,2], [7,3] ]
  end

  def caveD
    [ [9,2], [9,3], [9,4], [9,5] ] #    [ [9,2], [9,3] ]
  end

  def all_caves
    [caveA, caveB, caveC, caveD]
  end

  def last_empty_for(in_cave)
    in_cave.select {|c| at(c[0],c[1]) == "." }.last
  end

  def first_occupied_for(in_cave)
    in_cave.find {|c| at(c[0],c[1]) != "." }
  end

  def undone_caves
    result = []
    result << caveA if caveA.any? { |p| at(p[0],p[1]) != "A" }
    result << caveB if caveB.any? { |p| at(p[0],p[1]) != "B" }
    result << caveC if caveC.any? { |p| at(p[0],p[1]) != "C" }
    result << caveD if caveD.any? { |p| at(p[0],p[1]) != "D" }
    result
  end

  def dest_cave_for(amphipod)
    { "A" => caveA, "B" => caveB, "C" => caveC, "D" => caveD }[amphipod]
  end

  def all_done?
    return false if caveA.any? { |p| at(p[0],p[1]) != "A" }
    return false if caveB.any? { |p| at(p[0],p[1]) != "B" }
    return false if caveC.any? { |p| at(p[0],p[1]) != "C" }
    return false if caveD.any? { |p| at(p[0],p[1]) != "D" }

    true
  end

  def cache_key
    (caveA + caveB + caveC + caveD + hallway).collect { |p| at(p[0], p[1]) }.join
  end
end

# encode all found costs in hash?
CACHED = {}

def min_costs(the_map)
  the_key = the_map.cache_key
  return CACHED[the_key] if CACHED.has_key?(the_key)

  lowest_costs = 1e9
  the_moves = the_map.all_possible_moves

  # check for end moves first
  the_map.all_possible_moves.each do |m|
    the_map.do_move(m)
    if the_map.all_done?
      CACHED[the_key] = the_map.costs_for_move(m)
      return CACHED[the_key]
    end
    the_map.revert_move(m)
  end

  the_map.all_possible_moves.each do |m|
    the_map.do_move(m)
    the_costs = the_map.costs_for_move(m) + min_costs(the_map)
    lowest_costs = the_costs if the_costs < lowest_costs
    the_map.revert_move(m)
  end
  CACHED[the_key] = lowest_costs
  lowest_costs
end

the_map = CaveMap.new('day_23_input.txt')
the_map.show_map

the_min_costs = min_costs(the_map)
puts the_min_costs
