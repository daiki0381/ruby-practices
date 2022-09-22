# frozen_string_literal: true

class Frame
  def initialize(index, first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
    @index = index
  end

  def calculate_the_total_of_one_frame
    [score_of_first_shot, score_of_second_shot, score_of_third_shot].sum
  end

  def strike?
    score_of_first_shot == 10
  end

  def spare?
    !strike? && [score_of_first_shot, score_of_second_shot].sum == 10
  end

  def final_frame?
    @index == 9
  end

  def score_of_first_shot
    @first_shot.score
  end

  def score_of_second_shot
    @second_shot.score
  end

  private

  def score_of_third_shot
    @third_shot.score
  end
end
