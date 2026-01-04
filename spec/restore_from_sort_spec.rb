# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../scripts/restore_from_sort'

RSpec.describe 'RestoreFromSort' do
  let(:test_dir) { Dir.mktmpdir }
  let(:restore_files) { RestoreFilesFromSort.new(directory: test_dir) }

  before do
    # Create test directory structure
    FileUtils.mkdir_p(File.join(test_dir, 'pdf'))
    FileUtils.mkdir_p(File.join(test_dir, 'txt'))

    # Create test files in their respective folders
    FileUtils.touch(File.join(test_dir, 'pdf', 'test1.pdf'))
    FileUtils.touch(File.join(test_dir, 'pdf', 'document.with.dots.pdf'))
    FileUtils.touch(File.join(test_dir, 'txt', 'notes.txt'))
  end

  after do
    FileUtils.remove_entry test_dir
  end

  describe '#run' do
    context 'with non-conflicting files' do
      before do
        restore_files.run
      end

      it 'moves a pdf file to the root level' do
        expect(File.exist?(File.join(test_dir, 'test1.pdf'))).to be(true)
      end

      it 'moves a file with dots on its name to the root level' do
        expect(File.exist?(File.join(test_dir, 'document.with.dots.pdf'))).to be(true)
      end

      it 'moves a txt file to the root level' do
        expect(File.exist?(File.join(test_dir, 'notes.txt'))).to be(true)
      end

      it 'removes empty type folder pdf' do
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be(false)
      end

      it 'removes empty type folder txt' do
        expect(Dir.exist?(File.join(test_dir, 'txt'))).to be(false)
      end
    end

    context 'with conflicting files' do
      before do
        restore_files.run

        # Create test directory structure
        FileUtils.mkdir_p(File.join(test_dir, 'pdf'))
        FileUtils.mkdir_p(File.join(test_dir, 'txt'))

        # Create conflict scenario
        FileUtils.touch(File.join(test_dir, 'conflict.pdf'))
        FileUtils.touch(File.join(test_dir, 'pdf', 'conflict.pdf'))
      end

      it 'keeps the file at the root level' do
        expect(File.exist?(File.join(test_dir, 'conflict.pdf'))).to be(true)
      end

      it 'keeps the file in the extension folder' do
        expect(File.exist?(File.join(test_dir, 'pdf', 'conflict.pdf'))).to be(true)
      end

      it 'keeps folders with skipped files' do
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be(true)
      end
    end

    it 'returns true when successful' do
      expect(restore_files.run).to be(true)
    end
  end
end
