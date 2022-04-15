# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
  end

  def calculate_total_score
    total = 0
    @frames.each_with_index do |frame, index|
      total +=
        if index == 9
          frame.sum
        elsif frame[0] == 10
          calculate_strike(index, frame)
        elsif frame.sum == 10
          calculate_spare(index, frame)
        else
          frame.sum
        end
    end
    total
  end

  def calculate_strike(index, frame)
    if @frames[index + 1][0] == 10 && index + 1 != 9
      frame[0] + @frames[index + 1][0] + @frames[index + 2][0]
    else
      frame[0] + @frames[index + 1][0] + @frames[index + 1][1]
    end
  end

  def calculate_spare(index, frame)
    frame.sum + @frames[index + 1][0]
  end
end
