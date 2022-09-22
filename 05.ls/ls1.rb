# frozen_string_literal: true

# !/usr/bin/env ruby
require 'optparse'
require 'etc'

NUMBER_OF_COLUMNS = 3

FILE_TYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSION_PATTERN = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

option = ARGV.getopts('l')
dirs = Dir.glob('*').sort
stats = dirs.map { |dir| File.stat(dir) }

def file_types_and_file_modes(stats)
  stats.map do |stat|
    file_type = stat.ftype.gsub(/fifo|characterSpecial|directory|blockSpecial|file|link|socket/, FILE_TYPE)
    file_mode = stat.mode.to_s(8).slice(-3, 3).gsub(/[01234567]/, PERMISSION_PATTERN)
    file_type + file_mode
  end
end

def number_of_hard_links(stats)
  stats.map(&:nlink)
end

def owners(stats)
  stats.map { |stat| Etc.getpwuid(stat.uid).name }
end

def groups(stats)
  stats.map { |stat| Etc.getgrgid(stat.gid).name }
end

def file_sizes(stats)
  stats.map(&:size)
end

def final_update_dates(stats)
  stats.map { |stat| stat.mtime.strftime('%-m %d %H:%M') }
end

def files(dirs)
  dirs.map { |dir| File.symlink?(dir) ? "#{dir} -> #{File.readlink(dir)}" : dir }
end

def add_values_to_arrs(dirs, stats)
  [
    file_types_and_file_modes(stats),
    number_of_hard_links(stats),
    owners(stats),
    groups(stats),
    file_sizes(stats),
    final_update_dates(stats),
    files(dirs)
  ].transpose
end

def add_file_details_to_hashes(dirs, stats)
  key = %i[
    file_types_and_file_modes
    number_of_hard_links
    owners
    groups
    file_sizes
    final_update_dates
    files
  ]
  add_values_to_arrs(dirs, stats).map do |value|
    arr_containing_key_and_value = key.zip(value)
    Hash[arr_containing_key_and_value]
  end
end

def collect_maximum_number_of_characters(dirs, stats)
  {
    maximum_number_of_hard_links_in_characters: number_of_hard_links(stats).map { |number_of_hard_link| number_of_hard_link.to_s.size }.max,
    maximum_number_of_characters_for_owners: owners(stats).map { |owner| owner.to_s.size }.max,
    maximum_number_of_characters_for_groups: groups(stats).map { |group| group.to_s.size }.max,
    maximum_file_sizes_in_characters: file_sizes(stats).map { |file_size| file_size.to_s.size }.max,
    maximum_number_of_characters_for_final_update_dates: final_update_dates(stats).map { |final_update_date| final_update_date.to_s.size }.max,
    maximum_number_of_characters_in_files: files(dirs).map { |file| file.to_s.size }.max
  }
end

def output_total_number_of_blocks(dirs)
  total_number_of_blocks = dirs.map.sum { |dir| File.stat(dir).blocks }
  puts "total #{total_number_of_blocks}"
end

def output_file_details(dirs, stats, maximum_number_of_characters)
  output_total_number_of_blocks(dirs)
  add_file_details_to_hashes(dirs, stats).each do |file_detail|
    print "#{file_detail[:file_types_and_file_modes]}  "
    print "#{file_detail[:number_of_hard_links].to_s.rjust(maximum_number_of_characters[:maximum_number_of_hard_links_in_characters])} "
    print "#{file_detail[:owners].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_for_owners])}  "
    print "#{file_detail[:groups].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_for_groups])}  "
    print "#{file_detail[:file_sizes].to_s.rjust(maximum_number_of_characters[:maximum_file_sizes_in_characters])}  "
    print "#{file_detail[:final_update_dates].to_s.rjust(maximum_number_of_characters[:maximum_number_of_characters_for_final_update_dates])} "
    print file_detail[:files].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_in_files])
    print "\n"
  end
end

def add_dirs_to_arrs(dirs)
  arrs_containing_dirs = Array.new(NUMBER_OF_COLUMNS) { [] }
  number_of_elements_per_column = Rational(dirs.size, NUMBER_OF_COLUMNS).ceil
  index = 0
  dirs.each do |dir|
    arrs_containing_dirs[index] << dir
    index += 1 if (arrs_containing_dirs[index].size % number_of_elements_per_column).zero?
  end
  unity_number_of_arr_elements = arrs_containing_dirs.map { |arr| arr.values_at(0...number_of_elements_per_column) }
  unity_number_of_arr_elements.transpose
end

def output_dirs(dirs)
  maximum_number_of_words = dirs.map(&:size).max
  add_dirs_to_arrs(dirs).each do |arr|
    arr.each do |dir|
      print dir.to_s.ljust(maximum_number_of_words + 7)
    end
    puts
  end
end

option['l'] ? output_file_details(dirs, stats, collect_maximum_number_of_characters(dirs, stats)) : output_dirs(dirs)
