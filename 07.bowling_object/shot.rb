# frozen_string_literal: true

class Shot
  def initialize(shots)
    @shots = shots
  end

  def store_shots_to_array
    @shots.split(',').map { |shot| shot == 'X' ? 'X' : shot.to_i }
  end
end
