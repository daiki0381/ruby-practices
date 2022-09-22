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
    max_lengths = build_max_lengths
    @file_info_list.each do |file_info|
      print "#{type_and_permission(file_info)}  "
      print "#{file_info.hard_link_count.to_s.rjust(max_lengths[:hard_link_count_max_length])} "
      print "#{file_info.owner_name.ljust(max_lengths[:owner_name_max_length])}  "
      print "#{file_info.group_name.ljust(max_lengths[:group_name_max_length])}  "
      print "#{file_info.size.to_s.rjust(max_lengths[:size_max_length])}  "
      print "#{format_time(file_info).rjust(FORMATTED_TIME_LENGTH)} "
      print file_info.name_and_symbolic_link
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

  def build_max_lengths
    max_lengths = {}
    @file_info_list.each do |file_info|
      max_lengths[:hard_link_count_max_length] = [file_info.hard_link_count.to_s.size, max_lengths[:hard_link_count_max_length].to_i].max
      max_lengths[:owner_name_max_length] = [file_info.owner_name.size, max_lengths[:owner_name_max_length].to_i].max
      max_lengths[:group_name_max_length] = [file_info.group_name.size, max_lengths[:group_name_max_length].to_i].max
      max_lengths[:size_max_length] = [file_info.size.to_s.size, max_lengths[:size_max_length].to_i].max
    end
    max_lengths
  end

  def total_block_count
    @file_info_list.map(&:block_count).sum
  end
end
