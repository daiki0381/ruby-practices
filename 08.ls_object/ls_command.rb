# frozen_string_literal: true

require 'optparse'
require_relative 'file_info'
require_relative 'short_format'
require_relative 'long_format'

class LsCommand
  def initialize(option)
    @option = option
  end

  def output_ls_command
    sorted_files = @option['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    reversed_files = @option['r'] ? sorted_files.reverse : sorted_files
    file_info_data_list = reversed_files.map { |file_name| FileInfo.new(file_name) }
    @option['l'] ? LongFormat.new(file_info_data_list).output_file_info_list : ShortFormat.new(file_info_data_list).output_file_list
  end
end

LsCommand.new(ARGV.getopts('arl')).output_ls_command
