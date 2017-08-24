module Message

  def self.greeting(deck_num)
    puts "\nWelcome to #{deck_num}-Deck Blackjack!"
    puts "Blackjack pays 3:2 - Dealer must stand on all 17's"
    puts "Minimum bet: $5\n"
  end

  def self.shuffle_message
    sleep 1
    puts "\nCards are being shuffled..."
    sleep 1
    puts "One card has been burned...\n"
    sleep 1
  end

  # Maybe not necessary?
  def self.maximum_split
    puts "\nYou may only split 3 times to a maximum of 4 hands.\n"
  end

  def self.exit_message
    puts "\nThank you for playing!\n\n"
  end

  def self.broke_message(bankroll)
    Display.current_bankroll(player)
    puts "\nYou don't have enough money left to play at this table."
  end

  def self.not_enough_money
    Display.separator
    puts "You don't have enough money to do that."
    Display.separator
  end
end
