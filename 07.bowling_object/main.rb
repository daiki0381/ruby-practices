# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './game'

shot_object = Shot.new(ARGV[0])
shots = shot_object.store_shots_to_array
frame_object = Frame.new(shots)
frames = frame_object.divide_into_frames
game_object = Game.new(frames)
total_score = game_object.calculate_total_score
puts total_score
