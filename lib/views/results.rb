module Results

  def self.player_has_blackjack(name, bet)
    puts "\n#{name} has blackjack!\n"
    player_won(name, bet)
  end

  def self.dealer_has_blackjack(name, bet)
    puts "\nDealer has blackjack!\n"
    dealer_won(name, bet)
  end

  def self.dealer_won(name, bet)
    puts "\nDealer won. #{name} lost #{Display.money_format(bet)}.\n"
  end

  def self.player_won(name, bet)
    puts "\nDealer lost. #{name} won #{Display.money_format(bet)}.\n"
  end

  def self.tie
    puts "\nIt's a push! Nobody won.\n"
  end

  def self.surrender(name, bet)
    puts "\n#{name} surrendered and #{Display.money_format(bet)} was returned to your bankroll.\n"
  end
end
