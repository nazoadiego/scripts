# frozen_string_literal: true

require 'fileutils'
require_relative '../helpers/screen_printer'

# SortByFileType organizes files in a directory by moving them into subdirectories
# based on their file extensions.
class RestoreFilesFromSort
  # @param directory [String] The path to the directory to organize
  def initialize(directory:)
    @directory = directory
  end

  def run
    return false unless directory_exists?

    subdirectories.each do |subdirectory|
      subdirectory_path = File.join(@directory, subdirectory)
      files = files_from_directory(subdirectory_path)

      files.each do |file|
        success, message = move_to_root(origin_path: subdirectory_path, file: file).values_at(:success, :message)

        if success
          ScreenPrinter.print_progress(success)
          puts message
        end

        ScreenPrinter.puts_red("Error moving file #{file}: #{message}") unless success
        next unless success
      end

      remove_directory(subdirectory_path)
    end

    true
  end

  private

  def directory_exists?
    return true if Dir.exist?(@directory)

    ScreenPrinter.puts_red('The directory does not exist.')
    false
  end

  def remove_directory(directory_path)
    return { success: false, path: nil } unless Dir.empty?(directory_path)

    FileUtils.rmdir(directory_path)
    { success: true, path: directory_path }
  end

  def subdirectories
    Dir.entries(@directory).select do |folder|
      path = File.join(@directory, folder)
      File.directory?(path) && !['.', '..'].include?(folder)
    end
  end

  def files_from_directory(directory_path)
    Dir.entries(directory_path).select { |f| File.file?(File.join(directory_path, f)) }
  end

  def move_to_root(origin_path:, file:)
    origin = File.join(origin_path, file)
    destination = File.join(@directory, file)

    if File.exist?(destination)
      return {
        success: false,
        file: file,
        message: "File #{origin} already exists in #{destination} directory."
      }
    end

    FileUtils.mv(origin, destination)
    { success: true, file: file, message: "Moved: #{file} -> root directory" }
  rescue StandardError => e
    { success: false, file: file, message: "Error moving file #{file}: #{e.message}" }
  end
end

# This condition prevents the script from running when loaded from a different file.
# For example, the test suite.
# TODO: This might be better in different files. Or as a helper, passing a block.
# Because this would happen with any script with tests.
if __FILE__ == $PROGRAM_NAME
  puts 'Enter the directory to restore:'
  directory = gets.chomp
  puts 'Organizing files...'
  ScreenPrinter.linebreak
  RestoreFilesFromSort.new(directory: directory).run
  ScreenPrinter.linebreak
  puts "#{ScreenPrinter.colored_text('Done!', ScreenPrinter::GREEN)} Files have been restored successfully."
end
