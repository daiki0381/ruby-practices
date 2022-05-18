# frozen_string_literal: true

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score_of_first_shot
    @first_shot.score
  end

  def score_of_second_shot
    @second_shot.score
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

  def final_frame?(index)
    index == 9
  end

  def next_frame_strike?(next_frame)
    next_frame.score_of_first_shot == 10
  end

  def next_frame_except_final_frame?(index)
    index + 1 != 9
  end

  private

  def score_of_third_shot
    @third_shot.score
  end
end
