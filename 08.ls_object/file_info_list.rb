# frozen_string_literal: true

class FileInfoList
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

  def initialize(dir)
    @dir = dir
  end

  def type_and_permission(file)
    type = file.type.gsub(/fifo|characterSpecial|directory|blockSpecial|file|link|socket/, TYPE)
    permission = file.mode.to_s(8).slice(-3, 3).gsub(/[01234567]/, PERMISSION)
    type + permission
  end

  def formatted_time(file)
    file.final_update_time.strftime('%-m %d %H:%M')
  end

  def array_containing_file_details
    [
      @dir.map { |file| type_and_permission(file) },
      @dir.map(&:hard_link_count),
      @dir.map(&:owner_name),
      @dir.map(&:group_name),
      @dir.map(&:size),
      @dir.map { |file| formatted_time(file) },
      @dir.map(&:name_and_symbolic_link)
    ].transpose
  end

  def array_containing_maximum_number_of_words
    [
      @dir.map { |file| file.hard_link_count.to_s.size }.max,
      @dir.map { |file| file.owner_name.size }.max,
      @dir.map { |file| file.group_name.size }.max,
      @dir.map { |file| file.size.to_s.size }.max,
      @dir.map { |file| formatted_time(file).size }.max,
      @dir.map { |file| file.name_and_symbolic_link.size }.max
    ]
  end

  def total_block_count
    @dir.map(&:block_count).sum
  end

  def output_file_details_list
    puts "total #{total_block_count}"
    array_containing_file_details.each do |file_details|
      print "#{file_details[0]}  "
      print "#{file_details[1].to_s.rjust(array_containing_maximum_number_of_words[0])} "
      print "#{file_details[2].to_s.ljust(array_containing_maximum_number_of_words[1])}  "
      print "#{file_details[3].to_s.ljust(array_containing_maximum_number_of_words[2])}  "
      print "#{file_details[4].to_s.rjust(array_containing_maximum_number_of_words[3])}  "
      print "#{file_details[5].to_s.rjust(array_containing_maximum_number_of_words[4])} "
      print file_details[6].to_s.ljust(array_containing_maximum_number_of_words[5])
      print "\n"
    end
  end
end
