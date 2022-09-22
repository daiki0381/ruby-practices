# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map { |s| s == 'X' ? 'X' : s.to_i }

frames = []
10.times { frames << [] }

frames_index = 0
shots.each do |shot|
  if frames_index == 9
    frames[frames_index] << (shot == 'X' ? 10 : shot)
  elsif shot == 'X'
    frames[frames_index] << 10
    frames_index += 1
  else
    frames[frames_index] << shot
    frames_index += 1 if frames[frames_index].length == 2
  end
end

total = 0
frames.each_with_index do |frame, index|
  total +=
    if index == 9
      frame.sum
    elsif frame[0] == 10
      if frames[index + 1][0] == 10 && index + 1 != 9
        frame[0] + frames[index + 1][0] + frames[index + 2][0]
      else
        frame[0] + frames[index + 1][0] + frames[index + 1][1]
      end
    elsif frame.sum == 10
      frame.sum + frames[index + 1][0]
    else
      frame.sum
    end
end

puts total
