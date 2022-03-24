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

def option
  ARGV.getopts('l')
end

def dirs
  Dir.glob('*').sort
end

def file_types_and_file_modes
  dirs.map do |dir|
    file_type = File.stat(dir).ftype.gsub(/fifo|characterSpecial|directory|blockSpecial|file|link|socket/, FILE_TYPE)
    file_mode = File.stat(dir).mode.to_s(8).slice(-3, 3).gsub(/[01234567]/, PERMISSION_PATTERN)
    file_type + file_mode
  end
end

def number_of_hard_links
  dirs.map { |dir| File.stat(dir).nlink }
end

def owners
  dirs.map { |dir| Etc.getpwuid(File.stat(dir).uid).name }
end

def groups
  dirs.map { |dir| Etc.getgrgid(File.stat(dir).gid).name }
end

def file_sizes
  dirs.map { |dir| File.stat(dir).size }
end

def final_update_dates
  dirs.map { |dir| File.stat(dir).mtime.strftime('%-m %d %H:%M') }
end

def files
  dirs.map { |dir| File.symlink?(dir) ? "#{dir} -> #{File.readlink(dir)}" : dir }
end

def add_file_details_to_arrs
  [
    file_types_and_file_modes,
    number_of_hard_links,
    owners,
    groups,
    file_sizes,
    final_update_dates,
    files
  ].transpose
end

def collect_file_details(arr)
  {
    file_types_and_file_modes: arr[0],
    number_of_hard_links: arr[1],
    owners: arr[2],
    groups: arr[3],
    file_sizes: arr[4],
    final_update_dates: arr[5],
    files: arr[6]
  }
end

def collect_maximum_number_of_characters
  {
    maximum_number_of_hard_links_in_characters: number_of_hard_links.map { |number_of_hard_link| number_of_hard_link.to_s.size }.max,
    maximum_number_of_characters_for_owners: owners.map { |owner| owner.to_s.size }.max,
    maximum_number_of_characters_for_groups: groups.map { |group| group.to_s.size }.max,
    maximum_file_sizes_in_characters: file_sizes.map { |file_size| file_size.to_s.size }.max,
    maximum_number_of_characters_for_final_update_dates: final_update_dates.map { |final_update_date| final_update_date.to_s.size }.max,
    maximum_number_of_characters_in_files: files.map { |file| file.to_s.size }.max
  }
end

def output_total_number_of_blocks
  total_number_of_blocks = dirs.map.sum { |dir| File.stat(dir).blocks }
  puts "total #{total_number_of_blocks}"
end

def output_file_details(maximum_number_of_characters)
  output_total_number_of_blocks
  add_file_details_to_arrs.each do |arr|
    print "#{collect_file_details(arr)[:file_types_and_file_modes]}  "
    print "#{collect_file_details(arr)[:number_of_hard_links].to_s.rjust(maximum_number_of_characters[:maximum_number_of_hard_links_in_characters])} "
    print "#{collect_file_details(arr)[:owners].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_for_owners])}  "
    print "#{collect_file_details(arr)[:groups].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_for_groups])}  "
    print "#{collect_file_details(arr)[:file_sizes].to_s.rjust(maximum_number_of_characters[:maximum_file_sizes_in_characters])}  "
    print "#{collect_file_details(arr)[:final_update_dates].to_s.rjust(maximum_number_of_characters[:maximum_number_of_characters_for_final_update_dates])} "
    print collect_file_details(arr)[:files].to_s.ljust(maximum_number_of_characters[:maximum_number_of_characters_in_files])
    print "\n"
  end
end

def add_dirs_to_arrs
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

def output_dirs
  maximum_number_of_words = dirs.map(&:size).max
  add_dirs_to_arrs.each do |arr|
    arr.each do |dir|
      print dir.to_s.ljust(maximum_number_of_words + 7)
    end
    puts
  end
end

option['l'] ? output_file_details(collect_maximum_number_of_characters) : output_dirs
