# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def build_frame
    frame_without_nil = [@first_shot.mark, @second_shot.mark, @third_shot.mark]
    frame_without_nil.include?(nil) ? frame_without_nil.compact! : frame_without_nil
    case frame_without_nil.length
    when 1
      [@first_shot.score]
    when 2
      [@first_shot.score, @second_shot.score]
    when 3
      [@first_shot.score, @second_shot.score, @third_shot.score]
    end
  end
end
