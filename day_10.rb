all_lines = File.read('day_10_input.txt').split("\n")

OPENING_CHARS = "([<{"
CLOSING_CHARS = ")]>}"

def is_opening_char?(c)
  OPENING_CHARS.include?(c)
end

def is_closing_char?(c)
  CLOSING_CHARS.include?(c)
end

def matching_pair?(opening_char, closing_char)
  OPENING_CHARS.chars.find_index(opening_char) == CLOSING_CHARS.chars.find_index(closing_char)
end

def score_for_char(c)
  return 3 if c == ")"
  return 57 if c == "]"
  return 1197 if c == "}"
  return 25137 if c == ">"
end

def score_for_closing_char_matching(c)
  return 1 if c == "("
  return 2 if c == "["
  return 3 if c == "{"
  return 4 if c == "<"
end

total_score = 0
error_lines = []
all_lines.each_with_index do |line,l|
  the_stack = []
  line.chars.each_with_index do |c, i|
    if is_opening_char?(c)
      the_stack << c
    elsif is_closing_char?(c)
      opening_char = the_stack.pop
      if !matching_pair?(opening_char, c)
        total_score += score_for_char(c)
        error_lines << l
        break
      end
    end
  end
end
puts total_score

# part 2
all_scores = []
all_lines.each_with_index do |line,l|
  if !error_lines.include?(l)
    the_stack = []
    line.chars.each_with_index do |c, i|
      if is_opening_char?(c)
        the_stack << c
      elsif is_closing_char?(c)
        the_stack.pop
      end
    end
    # autocomplete
    line_score = 0
    while the_stack.length > 0
      line_score = line_score * 5 + score_for_closing_char_matching(the_stack.pop)
    end
    all_scores << line_score
  end
end
puts all_scores.sort[(all_scores.length - 1)/2]
