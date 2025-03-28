# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'tmpdir'
require_relative '../restore_from_sort'

RSpec.describe 'RestoreFromSort' do
  let(:test_dir) { Dir.mktmpdir }

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

  describe '#restore_files' do
    context 'with non-conflicting files' do
      it 'moves files from type folders to root directory' do
        restore_files(test_dir)
        expect(File.exist?(File.join(test_dir, 'test1.pdf'))).to be true
        expect(File.exist?(File.join(test_dir, 'document.with.dots.pdf'))).to be true
        expect(File.exist?(File.join(test_dir, 'notes.txt'))).to be true
      end

      it 'removes empty type folders after moving files' do
        restore_files(test_dir)
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be false
        expect(Dir.exist?(File.join(test_dir, 'txt'))).to be false
      end
    end

    context 'with conflicting files' do
      before(:each) do
        # Create conflict scenario
        FileUtils.touch(File.join(test_dir, 'conflict.pdf'))
        FileUtils.touch(File.join(test_dir, 'pdf', 'conflict.pdf'))
      end

      it 'handles name conflicts by skipping existing files' do
        restore_files(test_dir)
        expect(File.exist?(File.join(test_dir, 'conflict.pdf'))).to be true
        expect(File.exist?(File.join(test_dir, 'pdf', 'conflict.pdf'))).to be true
      end

      it 'keeps folders with skipped files' do
        restore_files(test_dir)
        expect(Dir.exist?(File.join(test_dir, 'pdf'))).to be true
      end
    end

    it 'returns true when successful' do
      expect(restore_files(test_dir)).to be true
    end
  end
end
