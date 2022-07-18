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

  def initialize(files)
    @files = files
  end

  def output_file_info_list
    puts "total #{total_block_count}"
    nested_file_data_list.each do |file_data_list|
      print "#{file_data_list[:type_and_permission]}  "
      print "#{file_data_list[:hard_link_count].to_s.rjust(file_data_list[:hard_link_count_max_length])} "
      print "#{file_data_list[:owner_name].to_s.ljust(file_data_list[:owner_name_max_length])}  "
      print "#{file_data_list[:group_name].to_s.ljust(file_data_list[:group_name_max_length])}  "
      print "#{file_data_list[:size].to_s.rjust(file_data_list[:size_max_length])}  "
      print "#{file_data_list[:formatted_time].to_s.rjust(file_data_list[:formatted_time_max_length])} "
      print file_data_list[:name_and_symbolic_link].to_s.ljust(file_data_list[:name_and_symbolic_link_max_length])
      print "\n"
    end
  end

  private

  def type_and_permission(file)
    type = file.type.gsub(/fifo|characterSpecial|directory|blockSpecial|file|link|socket/, TYPE)
    permission = file.mode.to_s(8).slice(-3, 3).gsub(/[01234567]/, PERMISSION)
    type + permission
  end

  def formatted_time(file)
    file.final_update_time.strftime('%-m %d %H:%M')
  end

  def hard_link_count_max_length
    @files.map { |file| file.hard_link_count.to_s.size }.max
  end

  def owner_name_max_length
    @files.map { |file| file.owner_name.size }.max
  end

  def group_name_max_length
    @files.map { |file| file.group_name.size }.max
  end

  def size_max_length
    @files.map { |file| file.size.to_s.size }.max
  end

  def formatted_time_max_length
    @files.map { |file| formatted_time(file).size }.max
  end

  def name_and_symbolic_link_max_length
    @files.map { |file| file.name_and_symbolic_link.size }.max
  end

  def total_block_count
    @files.map(&:block_count).sum
  end

  def nested_file_data_list
    @files.map do |file|
      {
        type_and_permission: type_and_permission(file),
        hard_link_count: file.hard_link_count,
        owner_name: file.owner_name,
        group_name: file.group_name,
        size: file.size,
        formatted_time: formatted_time(file),
        name_and_symbolic_link: file.name_and_symbolic_link,
        hard_link_count_max_length: hard_link_count_max_length,
        owner_name_max_length: owner_name_max_length,
        group_name_max_length: group_name_max_length,
        size_max_length: size_max_length,
        formatted_time_max_length: formatted_time_max_length,
        name_and_symbolic_link_max_length: name_and_symbolic_link_max_length
      }
    end
  end
end
