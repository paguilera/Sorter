#!/usr/bin/env ruby
require "fileutils"

class Sorter
  def initialize
    @start_dir = Dir.getwd
    @input_dir = File.join(@start_dir, "test-files")
    @output_dir = File.join(@start_dir, "sorted")
    @file_list = Array.new
    @ext_list = Array.new
    @no_ext_list = Array.new
    @hidden_list = Array.new
  end
  
  def make_file_list
  # make a list of all the files in the input directory
    if Dir.exists?(@input_dir)
      Dir.entries(@input_dir).each do |filename|
        @file_list.push(filename) unless filename[/\.\.?/].eql?(filename)
      end
    end
  end
  
  def make_ext_list
  # make a list of the unique extensions
    @file_list.each do |ext|
      temp = ext.split('.')
      if temp.length == 1
        add_no_ext_file(ext)
#        @ext_list.push('no_ext')
#        @no_ext_list.push(ext)
      elsif ext[/^\./]
        add_hidden_file(ext)
#        @ext_list.push('hidden')
#        @hidden_list.push(ext)
      else
        add_normal_file(temp[-1])
#        @ext_list.push(temp[-1])
      end
    end
    @ext_list.uniq!
  end
  
  def add_no_ext_file(ext)
    @ext_list.push('no_ext')
    @no_ext_list.push(ext)
  end
  
  def add_hidden_file(ext)
    @ext_list.push('hidden')
    @hidden_list.push(ext)
  end
  
  def add_normal_file(ext)
    @ext_list.push(ext)
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
      if ext == "no_ext"
        FileUtils.cp(@no_ext_list, File.join(@output_dir, "no_ext"))
      elsif ext == "hidden"
        FileUtils.cp(@hidden_list, File.join(@output_dir, "hidden"))
      else
        files = Dir.glob("*.#{ext}")
        FileUtils.cp(files, File.join(@output_dir, ext))
      end
    end
  end
  
  def run
    make_file_list
    make_ext_list
    make_output_dir
    make_ext_dirs
    copy_files
  end
end

if $0 == __FILE__
  test = Sorter.new
  test.run
end


