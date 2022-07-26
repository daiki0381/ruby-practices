# frozen_string_literal: true

require 'etc'

class FileInfo
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
    @file_stat = File.stat(file_name)
  end

  def block_count
    @file_stat.blocks
  end

  def type
    @file_stat.ftype
  end

  def mode
    @file_stat.mode
  end

  def hard_link_count
    @file_stat.nlink
  end

  def owner_name
    Etc.getpwuid(@file_stat.uid).name
  end

  def group_name
    Etc.getgrgid(@file_stat.gid).name
  end

  def size
    @file_stat.size
  end

  def final_update_time
    @file_stat.mtime
  end

  def name_and_symbolic_link
    File.symlink?(@file_name) ? "#{@file_name} -> #{File.readlink(@file_name)}" : @file_name
  end
end
