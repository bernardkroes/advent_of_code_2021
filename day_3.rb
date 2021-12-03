# all_entries = File.read('day_3_input.txt').split("\n").map(&:to_i)
all_lines = File.read('day_3_input.txt').split("\n")
the_line_length = all_lines[0].length

gamma = epsilon = ""
the_line_length.times do |i|
  zero_count = all_lines.count { |l| l[i] == "0" }
  one_count = all_lines.count { |l| l[i] == "1" }
  if zero_count > one_count
    gamma += "0"
    epsilon += "1"
  else 
    gamma += "1"
    epsilon += "0"
  end
end
puts gamma.to_i(2) * epsilon.to_i(2)

oxygen = co2 = ""
all_lines2 = all_lines.clone # make a copy for co2
the_line_length.times do |i| # just loop over all the bits even if we are done earlier, should not be a problem
  zero_count = all_lines.count { |l| l[i] == "0" }
  one_count = all_lines.count { |l| l[i] == "1" }

  all_lines = all_lines.delete_if { |l| l[i] == (one_count >= zero_count ? "0" : "1") }
  oxygen = all_lines[0] if all_lines.size == 1
end

the_line_length.times do |i| # just loop over all the bits even if we are done earlier, should not be a problem
  zero_count = all_lines2.count { |l| l[i] == "0" }
  one_count = all_lines2.count { |l| l[i] == "1" }

  all_lines2 = all_lines2.delete_if { |l| l[i] == (zero_count > one_count ? "0" : "1") }
  co2 = all_lines2[0] if all_lines2.size == 1
end
puts oxygen.to_i(2) * co2.to_i(2)

