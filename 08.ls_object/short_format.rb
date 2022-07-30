# frozen_string_literal: true

class ShortFormat
  COL_COUNT = 3

  def initialize(file_info_list)
    @file_info_list = file_info_list
  end

  def output
    file_name_max_length = calculate_file_name_max_length
    build_nested_file_info_list.each do |file_info_list|
      file_info_list.each do |file_info|
        print file_info.file_name.ljust(file_name_max_length + 7)
      end
      puts
    end
  end

  private

  def array_count
    Rational(@file_info_list.size, COL_COUNT).ceil
  end

  def calculate_file_name_max_length
    @file_info_list.map { |file_info| file_info.file_name.size }.max
  end

  def build_nested_file_info_list
    nested_file_info_list = Array.new(array_count) { [] }
    index = 0
    @file_info_list.each do |file_info|
      nested_file_info_list[index] << file_info
      index == array_count - 1 ? index = 0 : index += 1
    end
    nested_file_info_list
  end
end
