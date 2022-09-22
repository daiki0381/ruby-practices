# frozen_string_literal: true

require 'optparse'
require_relative 'file_info'
require_relative 'short_format'
require_relative 'long_format'

class LsCommand
  def initialize(option)
    @option = option
  end

  def output
    files = @option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_files = @option['r'] ? files.sort.reverse : files.sort
    file_info_list = sorted_files.map { |file_name| FileInfo.new(file_name) }
    @option['l'] ? LongFormat.new(file_info_list).output : ShortFormat.new(file_info_list).output
  end
end

LsCommand.new(ARGV.getopts('arl')).output
