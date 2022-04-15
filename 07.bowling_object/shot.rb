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
