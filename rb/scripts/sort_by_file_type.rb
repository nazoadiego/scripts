# frozen_string_literal: true

require 'fileutils'
require_relative '../helpers/screen_printer'

class Directory
  attr_reader :path

  def initialize(path:)
    @path = path
  end

  def files
    entries = Dir.entries(path).select { |f| File.file?(File.join(path, f)) }

    entries.map { |file| MyScript::TargetFile.new(file:) }
  end

  def exists?
    Dir.exist?(path)
  end

  # TODO: Does it really check if the folder already exists?
  def create_folder_by_file_extension(file_extension)
    folder = File.join(path, file_extension)
    FileUtils.mkdir_p(folder)

    { folder: folder, success: true }
  end
end

module MyScript
  class TargetFile
    attr_reader :file

    def initialize(file:)
      @file = file
    end

    def to_str
      file.to_str
    end

    def to_s
      file.to_s
    end

    def extension
      File.extname(file).downcase[1..]
    end

    def extension?
      !extension.nil?
    end
  end
end

# SortByFileType organizes files in a directory by moving them into subdirectories
# based on their file extensions.
class SortByFileType
  # @param directory [String] The path to the directory to organize
  def run(path:)
    @directory = Directory.new(path:)

    ScreenPrinter.puts_red('The directory does not exist.') unless @directory.exists?

    @directory.files.each do |file|
      next unless file.extension?

      folder, create_success = @directory.create_folder_by_file_extension(file.extension).values_at(:folder, :success)
      move_success = move_to_folder(file, folder) if create_success

      ScreenPrinter.print_progress(move_success)
    end
  end

  private

  def move_to_folder(file, folder)
    FileUtils.move(File.join(@directory.path, file), File.join(folder, file))
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
  path = gets.chomp
  puts 'Organizing files...'
  ScreenPrinter.linebreak
  SortByFileType.new.run(path:)
  ScreenPrinter.linebreak
  puts "#{ScreenPrinter.colored_text('Done!', ScreenPrinter::GREEN)} Files have been sorted successfully."
end
