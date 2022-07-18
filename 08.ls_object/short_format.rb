# frozen_string_literal: true

class ShortFormat
  COL_COUNT = 3

  def initialize(file_info_list)
    @file_info_list = file_info_list
  end

  def output
    nested_file_info_list = Array.new(COL_COUNT) { [] }
    file_info_count_per_col = Rational(@file_info_list.size, COL_COUNT).ceil
    index = 0
    @file_info_list.each do |file_info|
      nested_file_info_list[index] << file_info.name_and_symbolic_link
      index += 1 if (nested_file_info_list[index].size % file_info_count_per_col).zero?
    end
    transposed_nested_file_info_list = nested_file_info_list.map do |file_info_list|
      file_info_list.values_at(0...file_info_count_per_col)
    end.transpose
    file_name_max_length = @file_info_list.map { |file_info| file_info.name_and_symbolic_link.size }.max
    transposed_nested_file_info_list.each do |file_info_list|
      file_info_list.each do |file_info|
        print file_info.to_s.ljust(file_name_max_length + 7)
      end
      puts
    end
  end
end
