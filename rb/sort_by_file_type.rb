# frozen_string_literal: true

require 'fileutils'

# SortByFileType organizes files in a directory by moving them into subdirectories
# based on their file extensions.
class SortByFileType
  # @param directory [String] The path to the directory to organize
  def initialize(directory:)
    @directory = directory
  end

  def run
    return unless directory_exists?

    files_from_directory.each do |file|
      file_extension = file_extension(file)
      next if file_extension.nil?

      folder, create_success = create_folder(file_extension).values_at(:folder, :success)

      move_success = move_to_folder(file, folder) if create_success
      print_progress(move_success)
    end

    true
  end

  private

  def directory_exists?
    return true if Dir.exist?(@directory)

    puts 'The directory does not exist.'
    false
  end

  # TODO: Does it really check if the folder already exists?
  def create_folder(file_extension)
    folder = File.join(@directory, file_extension)
    FileUtils.mkdir_p(folder)

    { folder: folder, success: true }
  end

  def files_from_directory
    Dir.entries(@directory).select { |f| File.file?(File.join(@directory, f)) }
  end

  # No dot!
  def file_extension(file)
    File.extname(file).downcase[1..]
  end

  def move_to_folder(file, folder)
    FileUtils.mv(File.join(@directory, file), File.join(folder, file))
    true
  rescue StandardError => e
    puts "Error moving file #{file}: #{e.message}"
    false
  end

  # TODO: print in green/red
  # TODO: print dots inline, no break line
  def print_progress(success)
    puts success ? '.' : 'x'
  end
end

if __FILE__ == $PROGRAM_NAME
  puts 'Enter the directory to organize:'
  directory = gets.chomp
  SortByFileType.new(directory: directory).run
  puts 'Files have been organized by file type.'
end
