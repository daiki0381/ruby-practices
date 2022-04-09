# frozen_string_literal: true

# file = ARGV[0]
# file_contents = File.read(file)
# puts "#{file_contents.lines.size.to_s.rjust(8)} #{file_contents.split(/\s+/).size.to_s.rjust(7)} #{File::Stat.new(file).size.to_s.rjust(7)} #{file}"

total_of_lines = 0
total_of_words = 0
total_of_bytes = 0

ARGV.each do |file|
  file_contents = File.read(file)
  puts "#{file_contents.lines.size.to_s.rjust(8)} #{file_contents.split(/\s+/).size.to_s.rjust(7)} #{File::Stat.new(file).size.to_s.rjust(7)} #{file}"
  total_of_lines += file_contents.lines.size
  total_of_words += file_contents.split(/\s+/).size
  total_of_bytes += File::Stat.new(file).size
end
puts "#{total_of_lines.to_s.rjust(8)} #{total_of_words.to_s.rjust(7)} #{total_of_bytes.to_s.rjust(7)} total"
