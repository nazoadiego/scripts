# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'tmpdir'
require_relative '../scripts/sort_by_file_type'

RSpec.describe SortByFileType do
  let(:test_dir) { Dir.mktmpdir }
  let(:sorter) { SortByFileType.new(directory: test_dir) }

  before(:each) do
    # Create test files
    FileUtils.touch(File.join(test_dir, 'test1.txt'))
    FileUtils.touch(File.join(test_dir, 'test2.pdf'))
    FileUtils.touch(File.join(test_dir, 'test.with.dots.pdf'))
    FileUtils.touch(File.join(test_dir, 'no_extension'))
  end

  after(:each) do
    FileUtils.remove_entry test_dir
  end

  describe '#run' do
    before(:each) do
      sorter.run
    end

    it 'creates folders for each file extension' do
      expect(Dir.exist?(File.join(test_dir, 'txt'))).to be true
      expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be true
    end

    it 'moves files to their respective folders' do
      expect(File.exist?(File.join(test_dir, 'txt', 'test1.txt'))).to be true
      expect(File.exist?(File.join(test_dir, 'pdf', 'test2.pdf'))).to be true
      expect(File.exist?(File.join(test_dir, 'pdf', 'test.with.dots.pdf'))).to be true
    end

    it 'keeps files without extension in the root directory' do
      expect(File.exist?(File.join(test_dir, 'no_extension'))).to be true
    end
  end

  describe '#directory_exists?' do
    it 'returns true when directory exists' do
      expect(sorter.send(:directory_exists?)).to be true
    end

    it 'returns false when directory does not exist' do
      non_existent_sorter = SortByFileType.new(directory: '/non/existent/path')
      expect(non_existent_sorter.send(:directory_exists?)).to be false
    end
  end
end
