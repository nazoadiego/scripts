# frozen_string_literal: true

require 'benchmark'

# Benchmarker module for performance and memory consumption
module Benchmarker
  module_function

  def report(title = 'Your method', &block)
    Benchmark.bm do |benchmark|
      benchmark.report(title, &block)
    end
  end

  def memory_usage
    memory_before = `ps -o rss= -p #{Process.pid}`.to_i
    yield
    memory_after = `ps -o rss= -p #{Process.pid}`.to_i

    memory_in_mb = ((memory_after - memory_before) / 1024.0).round(2)
    puts "Memory: #{memory_in_mb} MB"
  end

  def realtime(&)
    time = Benchmark.realtime(&)

    puts "Time: #{time.round(2)}"
  end
end
