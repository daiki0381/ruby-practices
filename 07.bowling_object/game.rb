# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def calculate_total_score
    total = 0
    frames = build_frames
    frames.each_with_index do |frame, index|
      next_frame = frames[index + 1]
      after_next_frame = frames[index + 2]
      total +=
        if frame.strike? && !frame.final_frame?
          calculate_strike(frame, next_frame, after_next_frame)
        elsif frame.spare? && !frame.final_frame?
          calculate_spare(frame, next_frame)
        else
          frame.calculate_the_total_of_one_frame
        end
    end
    total
  end

  private

  def build_frames
    frames = []
    10.times { frames << [] }
    frames_index = 0
    @marks.each do |mark|
      frames[frames_index] << mark
      if mark == 'X' && frames_index != 9
        frames_index += 1
      elsif frames[frames_index].length == 2 && frames_index != 9
        frames_index += 1
      end
    end
    frames.map.with_index do |frame, index|
      Frame.new(index, Shot.new(frame[0]), Shot.new(frame[1]), Shot.new(frame[2]))
    end
  end

  def calculate_strike(frame, next_frame, after_next_frame)
    if next_frame.strike? && !next_frame.final_frame?
      frame.score_of_first_shot + next_frame.score_of_first_shot + after_next_frame.score_of_first_shot
    else
      frame.score_of_first_shot + next_frame.score_of_first_shot + next_frame.score_of_second_shot
    end
  end

  def calculate_spare(frame, next_frame)
    frame.calculate_the_total_of_one_frame + next_frame.score_of_first_shot
  end
end

game = Game.new(ARGV[0])
puts game.calculate_total_score
