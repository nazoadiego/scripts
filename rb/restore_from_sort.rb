# frozen_string_literal: true

require 'fileutils'

def restore_files(directory)
  # Check if the directory exists
  unless Dir.exist?(directory)
    puts 'The directory does not exist.'
    return false
  end

  # Get all subdirectories (file type folders)
  subdirs = Dir.entries(directory).select do |d|
    path = File.join(directory, d)
    File.directory?(path) && !['.', '..'].include?(d)
  end

  subdirs.each do |subdir|
    subdir_path = File.join(directory, subdir)

    # Get all files in the subdirectory
    files = Dir.entries(subdir_path).select { |f| File.file?(File.join(subdir_path, f)) }

    files.each do |file|
      source = File.join(subdir_path, file)
      destination = File.join(directory, file)

      if File.exist?(destination)
        puts "Warning: #{file} already exists in root directory. Skipping..."
        next
      end

      FileUtils.mv(source, destination)
      puts "Moved: #{file} -> root directory"
    end

    # Remove empty directory
    FileUtils.rmdir(subdir_path) if Dir.empty?(subdir_path)
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  puts 'Enter the directory to restore:'
  directory = gets.chomp
  restore_files(directory)
  puts 'Files have been restored to the root directory.'
end
