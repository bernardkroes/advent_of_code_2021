all_lines = File.read('day_10_input.txt').split("\n")

OPENING_CHARS = "([{<".chars
CLOSING_CHARS = ")]}>".chars

def is_opening_char?(c)
  OPENING_CHARS.include?(c)
end

def is_closing_char?(c)
  CLOSING_CHARS.include?(c)
end

def matching_pair?(opening_char, closing_char)
  OPENING_CHARS.find_index(opening_char) == CLOSING_CHARS.find_index(closing_char)
end

def score_for_char(c)
  [3, 57, 1197, 25137][CLOSING_CHARS.find_index(c)]
end

def score_for_closing_char_matching(c)
  [1, 2, 3, 4][OPENING_CHARS.find_index(c)]
end

part1_score = 0
all_part2_scores = []
all_lines.each_with_index do |line,l|
  the_stack = []
  error_in_line = false
  line.chars.each_with_index do |c, i|
    if is_opening_char?(c)
      the_stack.push(c)
    elsif is_closing_char?(c)
      opening_char = the_stack.pop
      if !matching_pair?(opening_char, c)
        part1_score += score_for_char(c)
        error_in_line = true
        break
      end
    end
  end
  # part 2 scoring
  if !error_in_line
    line_score = 0
    while the_stack.length > 0
      line_score = line_score * 5 + score_for_closing_char_matching(the_stack.pop)
    end
    all_part2_scores << line_score
  end
end
puts part1_score
puts all_part2_scores.sort[all_part2_scores.length/2]
