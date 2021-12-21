# Player 1 starting position: 6
# Player 2 starting position: 4

p1 = 6 - 1
p2 = 4 - 1

s1 = 0
s2 = 0

next_dice_score = 1

step = 0
num_throws = 0
while s1 < 1000 && s2 < 1000
  dice_total = next_dice_score + (next_dice_score + 1) + (next_dice_score + 2)
  if step % 2 == 0
    p1 = (p1 + dice_total) % 10
    s1 += (p1 + 1)
  else
    p2 = (p2 + dice_total) % 10
    s2 += (p2 + 1)
  end
  step += 1
  next_dice_score += 3
  num_throws += 3
end
puts num_throws * [s1, s2].min

# part 2
CACHED = {}
def count_wins(pos1, pos2, score1, score2)
  return [1,0] if score1 >= 21
  return [0,1] if score2 >= 21

  cache_key = "#{pos1}_#{pos2}_#{score1}_#{score2}"
  return CACHED[cache_key] if CACHED.has_key?(cache_key)

  sub_win_counts = [0,0]
  [1,2,3].each do |r1|
    [1,2,3].each do |r2|
      [1,2,3].each do |r3|
        new_pos1 = (pos1 + r1 + r2 + r3) % 10
        new_s1 = score1 + new_pos1 + 1

        sub_w1, sub_w2 = count_wins(pos2, new_pos1, score2, new_s1)
        sub_win_counts[0] += sub_w2
        sub_win_counts[1] += sub_w1
      end
    end
  end
  CACHED[cache_key] = sub_win_counts
  return sub_win_counts
end

puts count_wins(5,3,0,0).max
