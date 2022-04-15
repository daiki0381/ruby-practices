# frozen_string_literal: true

class Frame
  # ①使える形に処理した配列をインスタンス変数に入れる。
  def initialize(shots)
    @shots = shots
  end

  # ②フレームに分割する。
  def divide_into_frames
    frames = []
    10.times { frames << [] }
    frames_index = 0
    @shots.each do |shot|
      if frames_index == 9
        frames[frames_index] << (shot == 'X' ? 10 : shot)
      elsif shot == 'X'
        frames[frames_index] << 10
        frames_index += 1
      else
        frames[frames_index] << shot
        frames_index += 1 if frames[frames_index].length == 2
      end
    end
    frames
  end
end
