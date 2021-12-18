def add_sf(num1, num2)
  "["+num1 +"," + num2 + "]"
end

def reduce_sf(num_sf)
  # explode
  bracket_count = 0
  num_sf.length.times do |p|
    bracket_count += 1 if num_sf[p] == "["
    bracket_count -= 1 if num_sf[p] == "]"
    return reduce_sf(explode_sf(num_sf, p)) if bracket_count == 5
  end
  # split
  num_sf.length.times do |p|
    if num_sf[p] >='0' && num_sf[p] <= '9'
      the_val = num_sf[p..].to_i
      return reduce_sf(split_sf(num_sf, p)) if the_val > 9
    end
  end
  num_sf
end

def explode_sf(num_sf, pos)
  # determine the numbers: left_num and right_num
  left_num = num_sf[pos..-1].sub(/\A[^0-9]*/,"").to_i # remove everything non-numeric
  right_num = num_sf[pos..-1].sub(/\A.*?\,/,"").to_i  # remove everything upto and including first , (non greedy)

  # determine the initial left and right part that we need to replace into and keep
  left_part = num_sf[0..(pos-1)]
  right_part = num_sf[(pos+2)..].sub(/\A.*?\]/,"")  # remove everything upto and including first ] (non greedy)

  # replace the first num to the left, I bet there is a regexp one-liner thingy
  left_replace_pos = -1
  left_part.length.times do |p|
    left_replace_pos = p if left_part[p] =~ /\d/
  end
  if left_replace_pos > -1
    while left_replace_pos > 0 && left_part[left_replace_pos - 1] =~ /\d/
      left_replace_pos -= 1
    end
    the_cur_num = left_part[left_replace_pos..].to_i
    the_new_num = the_cur_num + left_num
    left_part = left_part[0..(left_replace_pos-1)] + the_new_num.to_s + left_part[(left_replace_pos+the_cur_num.to_s.length)..]
  end

  # replace the first num to the right, I bet there is a regexp one-liner thingy
  right_replace_pos = -1
  right_part.length.times do |p|
    if right_part[p] =~ /\d/
      right_replace_pos = p
      break
    end
  end
  if right_replace_pos > -1
    the_cur_num = right_part[right_replace_pos..].to_i
    the_new_num = the_cur_num + right_num
    right_part = right_part[0..(right_replace_pos-1)] + the_new_num.to_s + right_part[(right_replace_pos+the_cur_num.to_s.length)..]
  end

  left_part +"0" + right_part
end

def split_sf(num_sf, pos)
  split_num = num_sf[pos..].to_i
  left_num = (split_num / 2.0).floor
  right_num = (split_num / 2.0).ceil
  num_sf[0..(pos-1)] + "[#{left_num},#{right_num}]" + num_sf[(pos + split_num.to_s.length)..]
end

def magnitude_for_string(in_num_sf)
  the_num_sf = in_num_sf
  m = the_num_sf.match(/\[(\d+)\,(\d+)\]/)
  while m
    magnitude = m[1].to_i * 3 + 2* m[2].to_i
    the_num_sf = the_num_sf.sub(/\[(\d+)\,(\d+)\]/, magnitude.to_s)
    m = the_num_sf.match(/\[(\d+)\,(\d+)\]/)
  end
  the_num_sf.to_i
end

all_lines = File.read('day_18_input.txt').split("\n")

the_sum_sf = all_lines[0]
all_lines[1..-1].each do |line|
  the_sum_sf = add_sf(the_sum_sf, line)
  the_sum_sf = reduce_sf(the_sum_sf)
end
puts magnitude_for_string(the_sum_sf)

# part 2
max_magnitude = 0
all_lines.length.times do |first|
  all_lines.length.times do |second|
    if first != second
      the_sum_sf = add_sf(all_lines[first], all_lines[second])
      the_sum_sf = reduce_sf(the_sum_sf)
      the_magnitude = magnitude_for_string(the_sum_sf)
      max_magnitude = the_magnitude if the_magnitude > max_magnitude
    end
  end
end
puts max_magnitude


