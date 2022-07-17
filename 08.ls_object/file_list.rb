# frozen_string_literal: true

class FileList
  COL_COUNT = 3

  def initialize(files)
    @files = files
  end

  def output_file_list
    nested_files = Array.new(COL_COUNT) { [] }
    file_count_per_col = Rational(@files.size, COL_COUNT).ceil
    index = 0
    @files.each do |file|
      nested_files[index] << file.name_and_symbolic_link
      index += 1 if (nested_files[index].size % file_count_per_col).zero?
    end
    transposed_nested_files = nested_files.map do |files|
      files.values_at(0...file_count_per_col)
    end.transpose
    file_name_max_length = @files.map { |file| file.name_and_symbolic_link.size }.max
    transposed_nested_files.each do |files|
      files.each do |file|
        print file.to_s.ljust(file_name_max_length + 7)
      end
      puts
    end
  end
end
