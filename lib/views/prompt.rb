module Prompt
  # Display current bankroll and receives bet choice from user
  def self.bet_prompt(player, hand)
    Display.current_bankroll(player)
    puts "\nMinimum bet is $5 and smallest chip size is 50¢"
    print "\nEnter your bet amount: "
    hand.bet = gets.to_f
  end

  # Prompts user for decision. Returns input.
  def self.decision_prompt(choices)
    print "\nChoose one of the following moves (#{choices.join(', ')}): "
    gets.chomp
  end

  # Prompt for deck choice and returns input.
  def self.deck_num_prompt(choices)
    puts "\nHow many decks would you like to play with?"
    print "Enter (#{choices.join(', ')}): "
    gets.chomp.to_i
  end

  # Prompts user for name and returns their input
  def self.name_prompt
    print "\nPlease enter your first name: "
    gets.chomp.downcase.capitalize
  end

  # Prompts user for decision on whether to play another round
  def self.play_again_prompt
    puts "\nWould you like to play again?\n\n"
    print "Type \"y\" to play again or anything else to exit the game: "
    gets.chomp
  end
end
