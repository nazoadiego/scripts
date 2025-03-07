require 'fileutils'

def organize_files(directory)
  # Check if the directory exists
  unless Dir.exist?(directory)
    puts "The directory does not exist."
    return false
  end

  # Get all files in the directory
  files = Dir.entries(directory).select { |f| File.file?(File.join(directory, f)) }

  files.each do |file|
    # Get the file extension
    ext = File.extname(file).downcase
    next if ext.empty?

    # Create a folder for the file type if it doesn't exist
    folder = File.join(directory, ext[1..]) # Remove the dot from the extension
    FileUtils.mkdir_p(folder)

    # Move the file to the folder
    FileUtils.mv(File.join(directory, file), File.join(folder, file))
  end

  true
end

if __FILE__ == $PROGRAM_NAME
  puts "Enter the directory to organize:"
  directory = gets.chomp
  organize_files(directory)
  puts "Files have been organized by file type."
end