# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def divide_into_marks
    frames = []
    10.times { frames << [] }
    frames_index = 0
    @marks.each do |mark|
      if frames_index == 9
        frames[frames_index] << (mark == 'X' ? 'X' : mark)
      elsif mark == 'X'
        frames[frames_index] << 'X'
        frames_index += 1
      else
        frames[frames_index] << mark
        frames_index += 1 if frames[frames_index].length == 2
      end
    end
    frames
  end

  def build_frames
    divide_into_marks.map do |mark|
      Frame.new(Shot.new(mark[0]), Shot.new(mark[1]), Shot.new(mark[2]))
    end
  end

  def calculate_total_score
    total = 0
    build_frames.each_with_index do |frame, index|
      total +=
        if index == 9
          frame.calculate_the_total_of_one_frame
        elsif frame.strike?
          calculate_strike(frame, index)
        elsif frame.spare?
          calculate_spare(frame, index)
        else
          frame.calculate_the_total_of_one_frame
        end
    end
    total
  end

  def calculate_strike(frame, index)
    if build_frames[index + 1].first_shot == 10 && index + 1 != 9
      frame.first_shot + build_frames[index + 1].first_shot + build_frames[index + 2].first_shot
    else
      frame.first_shot + build_frames[index + 1].first_shot + build_frames[index + 1].second_shot
    end
  end

  def calculate_spare(frame, index)
    frame.calculate_the_total_of_one_frame + build_frames[index + 1].first_shot
  end
end

game = Game.new(ARGV[0])
p game.calculate_total_score
