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

frame_object = Frame.new(shots)
frames = frame_object.divide_into_frames

game_object = Game.new(frames)
p game_object.calculate_total_score
