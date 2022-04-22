# frozen_string_literal: true

require_relative './shot'

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
