# Multi-Deck Blackjack in Ruby
# https://github.com/em77

Dir[File.expand_path '**/*.rb'].each { |f| require_relative(f) }

# Start game with $100 bankroll
Game.new(100).start
