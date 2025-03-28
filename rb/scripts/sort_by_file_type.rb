# frozen_string_literal: true

require 'fileutils'
require_relative '../helpers/screen_printer'

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

      ScreenPrinter.print_progress(move_success)
    end

    true
  end

  private

  def directory_exists?
    return true if Dir.exist?(@directory)

    ScreenPrinter.puts_red('The directory does not exist.')
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
    ScreenPrinter.puts_red("Error moving file #{file}: #{e.message}")
    false
  end
end

# This condition prevents the script from running when loaded from a different file.
# For example, the test suite.
# TODO: This might be better in different files. Or as a helper, passing a block.
# Because this would happen with any script with tests.
if __FILE__ == $PROGRAM_NAME
  puts 'Enter the directory to organize:'
  directory = gets.chomp
  puts 'Organizing files...'
  ScreenPrinter.linebreak
  SortByFileType.new(directory: directory).run
  ScreenPrinter.linebreak
  puts "#{ScreenPrinter.colored_text('Done!', ScreenPrinter::GREEN)} Files have been sorted successfully."
end
