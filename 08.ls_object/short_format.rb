# frozen_string_literal: true

class ShortFormat
  COL_COUNT = 3

  def initialize(file_info_list)
    @file_info_list = file_info_list
  end

  def output
    transposed_file_info_list.each do |file_info_list|
      file_info_list.each do |file_info|
        print file_info.file_name.ljust(file_name_max_length + 7)
      end
      puts
    end
  end

  private

  def file_info_count_per_col
    Rational(@file_info_list.size, COL_COUNT).ceil
  end

  def file_name_max_length
    @file_info_list.map { |file_info| file_info.file_name.size }.max
  end

  def build_nested_file_info_list
    nested_file_info_list = Array.new(COL_COUNT) { [] }
    index = 0
    @file_info_list.each do |file_info|
      nested_file_info_list[index] << file_info
      index += 1 if (nested_file_info_list[index].size % file_info_count_per_col).zero?
    end
    nested_file_info_list
  end

  def transposed_file_info_list
    build_nested_file_info_list.map do |file_info_list|
      file_info_list.values_at(0...file_info_count_per_col)
    end.transpose.map(&:compact)
  end
end
