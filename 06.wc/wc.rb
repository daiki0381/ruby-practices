# frozen_string_literal: true

file = ARGV[0]
file_contents = File.read(file)
puts "#{file_contents.lines.size.to_s.rjust(8)} #{file_contents.split(/\s+/).size.to_s.rjust(7)} #{File::Stat.new(file).size.to_s.rjust(7)} #{file}"
