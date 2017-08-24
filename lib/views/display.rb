module Display

  def self.separator
    puts "____________________________________________________________\n"
  end

  def self.blackjack_moves
    puts "\nBlackjack moves: \"h\" to hit - \"d\" to double down - \"s\" to stand - \"sp\" to split - \"sur\" to surrender"
    puts "In order to split or double down, you must have at least double your original bet in your bankroll."
  end

  # Takes in number and returns string formatted as dollars and cents (e.g. 10 becomes "$10.50")
  def self.money_format(number)
    "$#{"%.2f" % number}"
  end

  # Displays current bankroll
  def self.current_bankroll(player)
    puts "\nCurrent bankroll: #{Display.money_format(player.bankroll)}"
  end

  # Displays cards of hand and total of hand
  def self.display_hand(hand, name)
    yield if block_given?
    card_names = hand.cards.map{|c| c[:name]}
    puts "\nHand (#{name}): #{card_names.join(', ')}"
    puts "Total (#{name}): #{hand.total}\n"
  end

  # Displays dealer's upcard, which is second card in hand
  def self.display_upcard(hand)
    puts "\nDealer upcard: #{hand.cards[1][:name]}\n"
  end

  # Display hand number
  def self.display_hand_number(hand_index)
    puts "\nHand ##{hand_index + 1}"
    puts "______________"
  end

  # Displays final cards/totals of dealer and player, who won, and how much money was lost or won by player
  def self.display_final(player_hand, dealer_hand, player_name, hand_index=nil)
    display_hand_number(hand_index) if !hand_index.nil?
    display_hand(player_hand, player_name)
    sleep 1
    display_hand(dealer_hand, "Dealer")
    sleep 1
    puts "The holecard was #{dealer_hand.cards[0][:name]}."
    yield if block_given?
    separator
  end
end
