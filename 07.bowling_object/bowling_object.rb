# frozen_string_literal: true

class Shot
  # ①コマンドライン引数をインスタンス変数に入れる。
  def initialize(shots)
    @shots = shots
  end

  # ②使える形に処理して、配列にする。
  def store_shots_to_array
    @shots.split(',').map { |shot| shot == 'X' ? 'X' : shot.to_i }
  end
end

shot_object = Shot.new(ARGV[0])
shots = shot_object.store_shots_to_array

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

frame_object = Frame.new(shots)
frames = frame_object.divide_into_frames

class Game
  # ①フレームに分割した配列をインスタンス変数に入れる。
  def initialize(frames)
    @frames = frames
  end

  # ②合計点を算出する。
  def calculate_total_score
    total = 0
    @frames.each_with_index do |frame, index|
      total +=
        if index == 9
          frame.sum
        elsif frame[0] == 10
          calculate_strike(index, frame)
        elsif frame.sum == 10
          calculate_spare(index, frame)
        else
          frame.sum
        end
    end
    total
  end

  def calculate_strike(index, frame)
    if @frames[index + 1][0] == 10 && index + 1 != 9
      frame[0] + @frames[index + 1][0] + @frames[index + 2][0]
    else
      frame[0] + @frames[index + 1][0] + @frames[index + 1][1]
    end
  end

  def calculate_spare(index, frame)
    frame.sum + @frames[index + 1][0]
  end
end

game_object = Game.new(frames)
p game_object.calculate_total_score
