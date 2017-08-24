class Round
  attr_accessor :shoe, :player_hand, :dealer_hand, :decision, :player, :shoe, :play

  def initialize(deck_num, shoe, player)
    @decision = 'h'
    @shoe = shoe
    @player = player
    @play = Play.new(self)
    @player_hand = Hand.new { player }
    @dealer_hand = Hand.new
    2.times { shoe.deal_card(player_hand) }
    2.times { shoe.deal_card(dealer_hand) }
  end

  def there_is_blackjack?
    if (dealer_hand.total == 21) && (player_hand.total == 21)
      player.bankroll += player_hand.bet
      Display.display_final(player_hand, dealer_hand, player.name) { Results.tie }
      return true
    elsif dealer_hand.total == 21
      Display.display_final(player_hand, dealer_hand, player.name) { Results.dealer_has_blackjack(player.name, player_hand.bet) }
      return true
    elsif player_hand.total == 21
      player.add_to_bankroll(player_hand.bet * 2.5)
      player_hand.bet *= 1.5
      Display.display_final(player_hand, dealer_hand, player.name) { Results.player_has_blackjack(player.name, player_hand.bet) }
      return true
    end
    false
  end

  def dealer_play
    shoe.deal_card(dealer_hand) while dealer_hand.total <= 16
  end

  def results
    player.hands.each_with_index do |hand, index|
      if decision == 'sur'
        player.add_to_bankroll(hand.bet)
        Display.display_final(hand, dealer_hand, player.name, index) { Results.surrender(player.name, hand.bet) }
      elsif hand.busted? || ((hand.total < dealer_hand.total) && !dealer_hand.busted?)
        Display.display_final(hand, dealer_hand, player.name, index) { Results.dealer_won(player.name, hand.bet) }
      elsif (hand.total > dealer_hand.total) || (dealer_hand.busted?)
        self.player.bankroll += (hand.bet * 2)
        Display.display_final(hand, dealer_hand, player.name, index) { Results.player_won(player.name, hand.bet) }
      elsif hand.total == dealer_hand.total
        self.player.bankroll += hand.bet
        Display.display_final(hand, dealer_hand, player.name, index) { Results.tie }
      end
    end
  end

  # Returns index of first hand that has not been played
  def index_has_not_been_played(hands)
    hands.index { |hand| hand.has_been_played == false }
  end

  def bet_prompter(player, hand)
    while (hand.bet < 5) || (hand.bet % 0.5 != 0) || (hand.bet >= player.bankroll)
      Prompt.bet_prompt(player, hand)
    end
    player.withdraw_from_bankroll(player_hand.bet)
  end

  def play_loop
    while index_has_not_been_played(player.hands)
      player.hands.each do |hand|
        play.do_play(hand, player.hands.index(hand)) unless hand.has_been_played
      end
    end
  end

  def do_round
    bet_prompter(player, player_hand)
    return if there_is_blackjack?
    play_loop
    dealer_play
    results
  end
end
