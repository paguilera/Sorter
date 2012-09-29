#!/usr/bin/env ruby
require "fileutils"

class Sorter
  def initialize
    @start_dir = Dir.getwd
    @input_dir = File.join(@start_dir, "test-files")
    @output_dir = File.join(@start_dir, "sorted")
  end

  def make_file_list
  # make a list of all the files in the input directory
    Dir.chdir(@input_dir)
    @file_list = Dir.glob("*")
  end
  
  def make_ext_list
  # make a list of the unique extensions
    @ext_list = Array.new
    @file_list.each do |ext|
      temp = ext.split('.')
      @ext_list.push(temp[-1])
    end
    @ext_list.uniq!
  end

  def make_output_dir
  # make the desired output directory if it doesn't already exist
    if !Dir.exist?(@output_dir)
      Dir.mkdir(@output_dir)
    end
    Dir.chdir(@output_dir)
  end

  def make_ext_dirs
  # now make the directories for the various extensions
  # check if they exist first
    @ext_list.each do |ext|
      if !Dir.exist?(ext)
        Dir.mkdir(ext)
      end
    end
  end
  
  def copy_files
  # finally, copy the files from the input directory to the correct output directory
    Dir.chdir(@input_dir)
    @ext_list.each do |ext|
      files = Dir.glob("*.#{ext}")
      FileUtils.cp(files, File.join(@output_dir, ext))
    end
  end
end

if $0 == __FILE__
  test = Sorter.new
  test.make_file_list
  test.make_ext_list
  test.make_output_dir
  test.make_ext_dirs
  test.copy_files
end


