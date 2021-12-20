require 'matrix'

class Scanner
  attr_reader :beacons, :id
  attr_reader :x_o, :y_o, :z_o
  attr_reader :mat
  attr_reader :fixated

  def initialize(in_id)
    @id = in_id
    @beacons = []
    @x_o = 0
    @y_o = 0
    @z_o = 0
    @mat = Matrix[ [1,0,0], [0,1,0], [0,0,1]]

    @fixated = false
  end

  def distance_matrix
    return @all_distances if defined?(@all_distances)

    @all_distances = []
    @beacons.each do |b1|
      row = []
      @beacons.each do |b2|
        the_dist = (b2[0] - b1[0]) * (b2[0] - b1[0]) + (b2[1] - b1[1]) * (b2[1] - b1[1]) + (b2[2] - b1[2]) * (b2[2] - b1[2])
        row << the_dist
      end
      @all_distances << row
    end
    @all_distances
  end

  def beacon_count
    @beacons.length
  end

  def fixate(transl, mat)
    return if @fixated

    puts "Fixating scanner #{@id} at: #{transl[0]} #{transl[1]} #{transl[2]}"
    @x_o = transl[0]
    @y_o = transl[1]
    @z_o = transl[2]

    @mat = mat
    @fixated = true
  end

  def get_beacons
    return @fixated_beacons if defined?(@fixated_beacons)

    @fixated_beacons = @beacons.map do |pos|
      the_mat = @mat * Vector.elements(pos).to_matrix
      [@x_o + the_mat.row(0)[0], @y_o + the_mat.row(1)[0], @z_o + the_mat.row(2)[0]]
    end
    @fixated_beacons
  end

  def beacons_transformed(transl, mat)
    @beacons.map do |pos|
      the_mat = mat * Vector.elements(pos).to_matrix
      [transl[0] + the_mat.row(0)[0], transl[1] + the_mat.row(1)[0], transl[2] + the_mat.row(2)[0]]
    end
  end

  def show_info
    puts @id
  end
end

def all_transformation_matrices
  all_mats = [[1,0,0], [0,1,0], [0,0,1], [-1,0,0], [0,-1,0], [0,0,-1]].permutation(3)
  all_mats = all_mats.to_a.delete_if { |a| (a[0][0] + a[1][0] + a[2][0] == 0) || (a[0][1] + a[1][1] + a[2][1] == 0) || (a[0][2] + a[1][2] + a[2][2] == 0) }
  all_mats = all_mats.to_a.delete_if { |a| Matrix.rows(a).determinant < 0 }

  all_mats = all_mats.to_a.collect { |a| Matrix.rows(a) }
  all_mats
end

all_lines = File.read('day_19_input.txt').split("\n")

scanner_id = -1
scanners = []
scanner = nil
all_lines.each do |line|
  if line.start_with?("--- scanner ")
    scanner_id = line.gsub(/[^0-9]/,"")
    scanner = Scanner.new(scanner_id)
    scanners << scanner
  elsif line.strip.length > 0
    scanner.beacons << line.split(",").map(&:to_i)
  end
end

matches = {}
scanners.each do |scanner|
  scanners.each do |cand|
    if scanner.id != cand.id
      if (scanner.distance_matrix.flatten & cand.distance_matrix.flatten).length >= 66 # 12 distance-pairs should match: (12 * 11)/2 = 66
        if matches.has_key?(scanner.id)
          matches[scanner.id] << cand.id
        else
          matches[scanner.id] = [cand.id]
        end
      end
    end
  end
end

# fix all the positions and orientations
scanners[0].fixate([0, 0, 0], Matrix[ [1,0,0], [0,1,0], [0,0,1]])
scanners_tried = []
all_transforms = all_transformation_matrices

while scanners.count { |sc| !sc.fixated } > 0
  scanners.select { |sc| sc.fixated && !scanners_tried.include?(sc.id) }.each do |scanner|
    scanners.select { |sc| !sc.fixated && matches[scanner.id].include?(sc.id) }.each do |cand|
      was_fixated = false

      scanner.beacon_count.times do |fpi|
        cand.beacon_count.times do |spi|
          fp = scanner.get_beacons[fpi]

          all_transforms.each_with_index do |mat|
            sp = cand.beacons_transformed([0, 0, 0], mat)[spi]
            dp = [fp[0] - sp[0], fp[1] - sp[1], fp[2] - sp[2]]

            overlap_count = (scanner.get_beacons & cand.beacons_transformed(dp, mat)).length
            if overlap_count > 11
              cand.fixate(dp, mat)
              was_fixated = true
              break
            end
          end
          break if was_fixated
        end
        break if was_fixated
      end
    end
    scanners_tried << scanner.id
  end
end

# part 1
all_positions = []
scanners.each do |sc|
  all_positions = all_positions + sc.get_beacons
end
puts all_positions.uniq.count

# part 2
max_dist = 0
scanners.each do |first|
  scanners.each do |second|
    the_dist = (first.x_o - second.x_o).abs + (first.y_o - second.y_o).abs + (first.z_o - second.z_o).abs
    max_dist = the_dist if the_dist > max_dist
  end
end
puts max_dist
