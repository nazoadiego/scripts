require 'spec_helper'
require 'fileutils'
require 'tmpdir'
require_relative '../sort_by_file_type'

RSpec.describe 'SortByFileType' do
  let(:test_dir) { Dir.mktmpdir }
  
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

  describe '#organize_files' do
    before(:each) do
      organize_files(test_dir)
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
end