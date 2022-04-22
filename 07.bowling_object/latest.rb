# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark == 'X' ? 10 : @mark.to_i
  end
end

class Frame
  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
    @third_mark = Shot.new(third_mark)
  end

  def store_frame_to_array
    frame_without_nil = [@first_mark.mark, @second_mark.mark, @third_mark.mark]
    frame_without_nil.include?(nil) ? frame_without_nil.compact! : frame_without_nil
    case frame_without_nil.length
    when 1
      [@first_mark.score]
    when 2
      [@first_mark.score, @second_mark.score]
    when 3
      [@first_mark.score, @second_mark.score, @third_mark.score]
    end
  end
end

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def divide_into_frames
    frames = []
    10.times { frames << [] }
    frames_index = 0
    @marks.each do |mark|
      if frames_index == 9
        frames[frames_index] << mark
      elsif mark == 'X'
        frames[frames_index] << mark
        frames_index += 1
      elsif frames[frames_index].length == 2
        frames[frames_index] << mark
        frames_index += 1
      end
    end
    frames
  end

  def store_frames_to_array
    divide_into_frames.map do |frame|
      Frame.new(frame[0], frame[1], frame[2]).store_frame_to_array
    end
  end

  def calculate_total_score
    total = 0
    store_frames_to_array.each_with_index do |frame, index|
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
    if store_frames_to_array[index + 1][0] == 10 && index + 1 != 9
      frame[0] + store_frames_to_array[index + 1][0] + store_frames_to_array[index + 2][0]
    else
      frame[0] + store_frames_to_array[index + 1][0] + store_frames_to_array[index + 1][1]
    end
  end

  def calculate_spare(index, frame)
    frame.sum + store_frames_to_array[index + 1][0]
  end
end


game = Game.new(ARGV[0])
p game.calculate_total_score
