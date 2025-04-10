require 'time'

WORDS = %w[
  def
  class
  GetSpanishTransfer
  .run
  .to_h
  initialize
]

def start_rubying
  puts "Starting"
  
  loop do
    # system('cliclick c:1000,1000 t:a kp:delete')
    word = WORDS.sample
    system("cliclick t:#{word}")
    
    # Log activity time
    puts "meow at: #{Time.now}"
    
    # Wait for 20 secondsde
    sleep 7
  end
rescue Interrupt
  puts "\nStopping..."
end

# First install cliclick if not present
unless system('which cliclick > /dev/null 2>&1')
  puts "Installing cliclick..."
  system('brew install cliclick')
end

start_rubying