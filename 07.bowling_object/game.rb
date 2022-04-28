# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(marks)
    # [1,1,1,1,1,1,1,1,1,1]
    @marks = marks.split(',')
  end

  def divide_into_frames
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
    frames.map do |frame|
      Frame.new(frame[0], frame[1], frame[2])
    end
  end

  def build_game
    divide_into_frames.map(&:build_frame)
  end

  def calculate_total_score
    total = 0
    build_game.each_with_index do |frame, index|
      total +=
        if index == 9
          frame.sum
        elsif frame[0] == 10
          calculate_strike(frame, index)
        elsif frame.sum == 10
          calculate_spare(frame, index)
        else
          frame.sum
        end
    end
    total
  end

  def calculate_strike(frame, index)
    if build_game[index + 1][0] == 10 && index + 1 != 9
      frame[0] + build_game[index + 1][0] + build_game[index + 2][0]
    else
      frame[0] + build_game[index + 1][0] + build_game[index + 1][1]
    end
  end

  def calculate_spare(frame, index)
    frame.sum + build_game[index + 1][0]
  end
end

game = Game.new(ARGV[0])
total_score = game.calculate_total_score
puts total_score
