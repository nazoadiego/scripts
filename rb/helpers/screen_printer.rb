# frozen_string_literal: true

# TODO: Add tests
# TODO: asci animations, a cat loader. With a message.
# Module for handling console output formatting
module ScreenPrinter
  module_function

  GREEN = "\e[32m"
  RED = "\e[31m"
  RESET = "\e[0m"

  # Print progress indicators inline with color
  # @param success [Boolean] Whether the operation was successful
  # note: print does not add a line break, puts does.
  def print_progress(success)
    if success
      print_green('.')
    else
      print_red('x')
    end
    $stdout.flush
  end

  def colored_text(text, color)
    "#{color}#{text}#{RESET}"
  end

  def print_green(message)
    print colored_text(message, GREEN)
  end

  def puts_green(message)
    puts colored_text(message, GREEN)
  end

  def print_red(message)
    print colored_text(message, RED)
  end

  def puts_red(message)
    puts colored_text(message, RED)
  end

  def linebreak
    puts # yeah, empty puts produces a line break
  end
end
