require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'mini_exiftool'
end

require 'mini_exiftool'
require 'fileutils'

PHOTO_EXTENSIONS = %w[.jpg .jpeg .png].freeze
patterns = PHOTO_EXTENSIONS.map { |extension| "*#{extension}" }.join(',')
Dir.chdir 'photos'
photos = Dir.glob("{#{patterns}}")

photos.each do |photo|
  exif = MiniExiftool.new(photo)
  date_taken = exif.date_time_original
  # For video, create_date can be used instead
  # date_taken = exif.create_date

  next unless date_taken

  year_month    = date_taken.strftime('%Y/%m')
  new_directory = "organized_photos/#{year_month}"

  FileUtils.mkdir_p(new_directory)

  new_filename = date_taken.strftime('%Y-%m-%d_%H-%M-%S.jpg')
  new_filepath = File.join(new_directory, new_filename)

  FileUtils.cp(photo, new_filepath)
end
