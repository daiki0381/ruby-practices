# コマンドライン引数の取得
score = ARGV[0]
# 1投毎に分割
scores = score.split(",")
# 数字に変換
shots = []
scores.each {|s| s == "X" ? shots << "X" : shots << s.to_i}
# 最大のフレーム数
max_frame = 10
# フレーム
frames = []
max_frame.times {frames.push([])}
# フレームのインデックス番号
frames_index = 0
# shotsのインデックス番号
shots_index = 0
# 投球数
count = 0
# フレーム毎に分割
shots.each do |shot|
  # 最終フレームの場合
  if frames_index == 9
    shot == "X" ? frames[frames_index] << 10 : frames[frames_index] << shot
  # 最終フレームではない場合
  else
    # ストライクを取った場合
    if shot == "X"
      frames[frames_index] << 10
      frames_index += 1
    # 2投した場合
    else
      count += 1
      if count % 2 == 0
        frames[frames_index] << shots[shots_index - 1] << shot
        frames_index += 1
      end
    end
  end
  # shotsのインデックス番号+1
  shots_index += 1
end
# 合計
total = 0
# 合計を算出
frames.each_with_index do |frame, index|
  # 最終フレームの場合
  if index == 9
    total += frame.sum
  # 最終フレームではない場合
  else
    # ストライクの場合
    if frame[0] == 10
      # 次がストライクではない場合
      if frames[index+1][0] != 10
        total += frame[0] + frames[index+1][0] + frames[index+1][1]
      # 次もストライク&次が最終フレーム
      elsif frames[index+1][0] == 10 && index + 1 == 9
        total += frame[0] + frames[index+1][0] + frames[index+1][1]
      # 次もストライク&次が最終フレームではない場合
      elsif frames[index+1][0] == 10 && index + 1 != 9
        total += frame[0] + frames[index+1][0] + frames[index+2][0]
      end
    # スペアの場合
    elsif frame.sum == 10
      total += frame.sum + frames[index+1][0]
    # ストライクでもスペアでもない場合
    else
      total += frame.sum
    end
  end
end
# 合計を出力
puts total
