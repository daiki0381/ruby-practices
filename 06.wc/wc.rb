# frozen_string_literal: true

def main
  files_data = collect_files_data
  output_files_data(files_data)
  total_of_files_data = collect_total_of_files_data(files_data)
  output_total_of_files_data(total_of_files_data)
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

def output_total_of_files_data(total_of_files_data)
  print (total_of_files_data[:total_of_lines]).to_s.rjust(8)
  print (total_of_files_data[:total_of_words]).to_s.rjust(8)
  print (total_of_files_data[:total_of_bytes]).to_s.rjust(8)
  print 'total'.rjust(6)
end

main
