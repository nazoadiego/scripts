# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../scripts/sort_by_file_type'

RSpec.describe SortByFileType do
  let(:test_dir) { Dir.mktmpdir }
  let(:sorter) { described_class.new(directory: test_dir) }

  before do
    # Create test files
    FileUtils.touch(File.join(test_dir, 'test1.txt'))
    FileUtils.touch(File.join(test_dir, 'test2.pdf'))
    FileUtils.touch(File.join(test_dir, 'test.with.dots.pdf'))
    FileUtils.touch(File.join(test_dir, 'no_extension'))
  end

  after do
    FileUtils.remove_entry test_dir
  end

  describe '#run' do
    before do
      sorter.run
    end

    context 'when creating folders' do
      it 'creates a folder for txt files' do
        expect(Dir.exist?(File.join(test_dir, 'txt'))).to be true
      end

      it 'creates a folder for pdf files' do
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be true
      end
    end

    context 'when moving files' do
      it 'moves the txt file' do
        expect(File.exist?(File.join(test_dir, 'txt', 'test1.txt'))).to be true
      end

      it 'moves the pdf file' do
        expect(File.exist?(File.join(test_dir, 'pdf', 'test2.pdf'))).to be true
      end

      it 'moves a file with dots on its name' do
        expect(File.exist?(File.join(test_dir, 'pdf', 'test.with.dots.pdf'))).to be true
      end

      it 'keeps files without extension in the root directory' do
        expect(File.exist?(File.join(test_dir, 'no_extension'))).to be true
      end
    end
  end

  describe '#directory_exists?' do
    it 'returns true when directory exists' do
      expect(sorter.send(:directory_exists?)).to be true
    end

    it 'returns false when directory does not exist' do
      non_existent_sorter = described_class.new(directory: '/non/existent/path')
      expect(non_existent_sorter.send(:directory_exists?)).to be false
    end
  end
end
