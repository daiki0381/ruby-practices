# frozen_string_literal: true

class LongFormat
  TYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  FORMATTED_TIME_LENGTH = 10

  def initialize(file_info_list)
    @file_info_list = file_info_list
  end

  def output
    puts "total #{total_block_count}"
    build_file_data_list.each do |file_data_list|
      print "#{file_data_list[:type_and_permission]}  "
      print "#{file_data_list[:hard_link_count].to_s.rjust(file_data_list[:hard_link_count_max_length])} "
      print "#{file_data_list[:owner_name].to_s.ljust(file_data_list[:owner_name_max_length])}  "
      print "#{file_data_list[:group_name].to_s.ljust(file_data_list[:group_name_max_length])}  "
      print "#{file_data_list[:size].to_s.rjust(file_data_list[:size_max_length])}  "
      print "#{file_data_list[:formatted_time].to_s.rjust(FORMATTED_TIME_LENGTH)} "
      print file_data_list[:name_and_symbolic_link].to_s
      print "\n"
    end
  end

  private

  def type_and_permission(file_info)
    type = file_info.type.gsub(/fifo|characterSpecial|directory|blockSpecial|file|link|socket/, TYPE)
    permission = file_info.mode.to_s(8).slice(-3, 3).gsub(/[01234567]/, PERMISSION)
    type + permission
  end

  def format_time(file_info)
    file_info.final_update_time.strftime('%-m %d %H:%M')
  end

  def nested_max_length_list
    @nested_max_length_list ||= @file_info_list.map do |file_info|
      [
        file_info.hard_link_count.to_s.size,
        file_info.owner_name.size,
        file_info.group_name.size,
        file_info.size.to_s.size
      ]
    end.transpose
  end

  def max_length_list
    @max_length_list ||= nested_max_length_list.map(&:max)
  end

  def total_block_count
    @file_info_list.map(&:block_count).sum
  end

  def build_file_data_list
    @file_info_list.map do |file_info|
      {
        type_and_permission: type_and_permission(file_info),
        hard_link_count: file_info.hard_link_count,
        owner_name: file_info.owner_name,
        group_name: file_info.group_name,
        size: file_info.size,
        formatted_time: format_time(file_info),
        name_and_symbolic_link: file_info.name_and_symbolic_link,
        hard_link_count_max_length: max_length_list[0],
        owner_name_max_length: max_length_list[1],
        group_name_max_length: max_length_list[2],
        size_max_length: max_length_list[3]
      }
    end
  end
end
