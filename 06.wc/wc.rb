# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  files_data = collect_files_data
  total_of_files_data = collect_total_of_files_data(files_data)
  if files_data.empty?
    output_standard_input(option)
  elsif option['l']
    output_lines(files_data)
    output_total_of_lines(total_of_files_data) if files_data.size != 1
  else
    output_files_data(files_data)
    output_total_of_files_data(total_of_files_data) if files_data.size != 1
  end
end

def collect_files_data
  ARGV.each.map do |file|
    file_contents = File.read(file)
    {
      lines: file_contents.lines.size,
      words: file_contents.split(/\s+/).size,
      bytes: File::Stat.new(file).size,
      file: file
    }
  end
end

def collect_total_of_files_data(files_data)
  {
    total_of_lines: files_data.sum { |file_data| file_data[:lines] },
    total_of_words: files_data.sum { |file_data| file_data[:words] },
    total_of_bytes: files_data.sum { |file_data| file_data[:bytes] }
  }
end

def output_files_data(files_data)
  files_data.each do |file_data|
    puts "#{file_data[:lines].to_s.rjust(8)} #{file_data[:words].to_s.rjust(7)} #{file_data[:bytes].to_s.rjust(7)} #{file_data[:file]}"
  end
end

def output_lines(files_data)
  files_data.each do |file_data|
    puts "#{file_data[:lines].to_s.rjust(8)} #{file_data[:file]}"
  end
end

def output_standard_input(option)
  standard_input = $stdin.read
  if option['l']
    puts standard_input.lines.size.to_s.rjust(8).to_s
  else
    puts "#{standard_input.lines.size.to_s.rjust(8)} #{standard_input.split(/\s+/).size.to_s.rjust(7)} #{standard_input.bytesize.to_s.rjust(7)}"
  end
end

def output_total_of_files_data(total_of_files_data)
  print (total_of_files_data[:total_of_lines]).to_s.rjust(8)
  print (total_of_files_data[:total_of_words]).to_s.rjust(8)
  print (total_of_files_data[:total_of_bytes]).to_s.rjust(8)
  print 'total'.rjust(6)
end

def output_total_of_lines(total_of_files_data)
  puts "#{total_of_files_data[:total_of_lines].to_s.rjust(8)} total"
end

main
