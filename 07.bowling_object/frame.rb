# frozen_string_literal: true

STRIKE = 10
SPARE = 10

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def calculate_the_total_of_one_frame
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == STRIKE
  end

  def spare?
    !strike? && [@first_shot.score, @second_shot.score].sum == SPARE
  end

  def first_shot
    @first_shot.score
  end

  def second_shot
    @second_shot.score
  end
end
