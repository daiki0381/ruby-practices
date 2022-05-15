# frozen_string_literal: true

STRIKE = 10
SPARE = 10

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def first_shot
    @first_shot.score
  end

  def second_shot
    @second_shot.score
  end

  def calculate_the_total_of_one_frame
    [first_shot, second_shot, third_shot].sum
  end

  def strike?
    first_shot == STRIKE
  end

  def spare?
    !strike? && [first_shot, second_shot].sum == SPARE
  end

  private

  def third_shot
    @third_shot.score
  end
end
