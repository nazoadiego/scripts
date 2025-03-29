# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require_relative '../scripts/restore_from_sort'

RSpec.describe 'RestoreFromSort' do
  let(:test_dir) { Dir.mktmpdir }
  let(:restore_files) { RestoreFilesFromSort.new(directory: test_dir) }

  before(:each) do
    # Create test directory structure
    FileUtils.mkdir_p(File.join(test_dir, 'pdf'))
    FileUtils.mkdir_p(File.join(test_dir, 'txt'))

    # Create test files in their respective folders
    FileUtils.touch(File.join(test_dir, 'pdf', 'test1.pdf'))
    FileUtils.touch(File.join(test_dir, 'pdf', 'document.with.dots.pdf'))
    FileUtils.touch(File.join(test_dir, 'txt', 'notes.txt'))
  end

  after(:each) do
    FileUtils.remove_entry test_dir
  end

  describe '#run' do
    context 'with non-conflicting files' do
      before(:each) do
        restore_files.run
      end

      it 'moves files from type folders to root directory' do
        expect(File.exist?(File.join(test_dir, 'test1.pdf'))).to be(true)
        expect(File.exist?(File.join(test_dir, 'document.with.dots.pdf'))).to be(true)
        expect(File.exist?(File.join(test_dir, 'notes.txt'))).to be(true)
      end

      it 'removes empty type folders after moving files' do
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be false
        expect(Dir.exist?(File.join(test_dir, 'txt'))).to be false
      end
    end

    context 'with conflicting files' do
      before(:each) do
        restore_files.run
      end

      before(:each) do
        # Create test directory structure
        FileUtils.mkdir_p(File.join(test_dir, 'pdf'))
        FileUtils.mkdir_p(File.join(test_dir, 'txt'))

        # Create conflict scenario
        FileUtils.touch(File.join(test_dir, 'conflict.pdf'))
        FileUtils.touch(File.join(test_dir, 'pdf', 'conflict.pdf'))
      end

      it 'handles name conflicts by skipping existing files' do
        expect(File.exist?(File.join(test_dir, 'conflict.pdf'))).to be(true)
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
