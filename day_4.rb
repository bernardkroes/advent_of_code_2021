SIZE = 5

class Board
  attr_reader :numbers

  def initialize(in_board_numbers)
    @numbers = in_board_numbers
  end

  def all_rows
    the_rows = []
    SIZE.times do |i|
      the_rows << @numbers[i*SIZE..((i+1)*SIZE-1)]
    end
    the_rows
  end

  def all_cols
    the_cols = []
    SIZE.times do |i|
      # for now, just like this:
      the_cols << [@numbers[i],@numbers[i+SIZE],@numbers[i+SIZE*2],@numbers[i+SIZE*3],@numbers[i+SIZE*4]]
    end
    the_cols
  end

  def has_bingo?(in_drawn_numbers)
    all_rows.any? { |r| (r - in_drawn_numbers).size == 0 } || all_cols.any? { |c| (c - in_drawn_numbers).size == 0 }
  end

  # no check for bingo:
  def score(in_drawn_numbers)
    in_drawn_numbers[-1] * (@numbers - in_drawn_numbers).sum
  end
end

all_lines = File.read('day_4_input.txt').split("\n")
draw_numbers = all_lines[0].split(",").map(&:to_i)
all_boards = []

the_board_numbers = []
all_lines[2..-1].each_with_index do |line,i|
  if line.length == 0
    all_boards << Board.new(the_board_numbers)
    the_board_numbers = []
  else
    the_board_numbers += line.gsub(/\s+/," ").split(" ").map(&:to_i)
  end
end

# part 1
the_draw_size = 5
while !all_boards.any?{ |b| b.has_bingo?(draw_numbers.first(the_draw_size)) }
  the_draw_size += 1
end
the_board = all_boards.find { |b| b.has_bingo?(draw_numbers.first(the_draw_size)) }
puts the_board.score(draw_numbers.first(the_draw_size))

# part 2
the_draw_size = 5
draw_counts_for_bingo = [0] * all_boards.size
while !all_boards.all?{ |b| b.has_bingo?(draw_numbers.first(the_draw_size)) }
  all_boards.each_with_index do |b,i|
    if draw_counts_for_bingo[i] == 0 && b.has_bingo?(draw_numbers.first(the_draw_size))
      draw_counts_for_bingo[i] = the_draw_size
    end
  end
  the_draw_size += 1
end
# find last board (still has a zero in draw_counts_for_bingo)
the_index = draw_counts_for_bingo.find_index { |d| d == 0 }
puts all_boards[the_index].score(draw_numbers.first(the_draw_size))
