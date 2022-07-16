# frozen_string_literal: true

require 'optparse'
require_relative 'file_info'
require_relative 'file_list'
require_relative 'file_info_list'

class LsCommand
  def initialize(option)
    @option = option
  end

  def output_ls_command
    dir = @option['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    dir = @option['r'] ? dir.reverse.map { |file| FileInfo.new(file) } : dir.map { |file| FileInfo.new(file) }
    @option['l'] ? FileInfoList.new(dir).output_file_details_list : FileList.new(dir).output_file_list
  end
end

LsCommand.new(ARGV.getopts('arl')).output_ls_command
