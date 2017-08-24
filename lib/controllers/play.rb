class Play
  DECISIONS = {
    'h'   => 'hit_decision',
    's'   => 'stand_decision',
    'd'   => 'double_down_decision',
    'sp'  => 'split_decision',
    'sur' => 'surrender_decision'
  }.freeze

  attr_accessor :round, :choices

  def initialize(round)
    @round = round
    @choices = []
  end

  def do_play(current_player_hand, hand_index)
    while !current_player_hand.has_been_played && (current_player_hand.total <= 20)
      play(current_player_hand, hand_index)
    end
  end

  def play(current_player_hand, hand_index)
      Display.display_upcard(round.dealer_hand)
      Display.display_hand(current_player_hand, round.player.name) { Display.display_hand_number(hand_index) }
      get_choices(current_player_hand)
      get_decision
      make_decision(current_player_hand)
  end

  def get_decision
    Display.blackjack_moves
    decision_made = nil
    until choices.include? decision_made
      decision_made = Prompt.decision_prompt(choices)
    end
    self.round.decision = decision_made
  end

  def make_decision(current_player_hand)
    send(DECISIONS[round.decision], current_player_hand)
  end

  def hit_decision(current_player_hand)
    round.shoe.deal_card(current_player_hand)
    current_player_hand.has_been_played = true if current_player_hand.total >= 21
  end

  def stand_decision(current_player_hand)
    current_player_hand.has_been_played = true
  end

  def double_down_decision(current_player_hand)
    doubler_splitter_decision_maker(choices, round.decision, current_player_hand) { double_down(current_player_hand) }
    current_player_hand.has_been_played = true if choices.include? 'd'
  end

  def surrender_decision(current_player_hand)
    surrender(current_player_hand)
    current_player_hand.has_been_played = true
  end

  def split_decision(current_player_hand)
    doubler_splitter_decision_maker(choices, round.decision, current_player_hand) { do_split(current_player_hand) }
  end

  def doubler_splitter_decision_maker(available_choices, choice, current_player_hand)
    if round.player.enough_in_bankroll?(current_player_hand.bet, round.decision)
      round.player.withdraw_from_bankroll(current_player_hand.bet)
      yield
    else
      Message.not_enough_money
      choices_fixer(choice)
      get_decision
      make_decision(current_player_hand)
    end
  end

  def double_down(current_player_hand)
    current_player_hand.bet *= 2
    round.shoe.deal_card(current_player_hand)
  end

  def surrender(current_player_hand)
    current_player_hand.bet /= 2
  end

  def split_hand(shoe, original_hand, new_hand)
    new_hand.cards << original_hand.cards.delete_at(0)
    shoe.deal_card(original_hand)
    shoe.deal_card(new_hand)
    new_hand.bet = original_hand.bet
  end

  def do_split(current_player_hand)
    new_hand = Hand.new { round.player }
    split_hand(round.shoe, current_player_hand, new_hand)
  end

  def choices_fixer(remove_choice)
    choices.delete(remove_choice)
  end

  def get_choices(current_player_hand)
    if first_two_not_splittable?(current_player_hand)
      self.choices = %w[h d s sur]
    elsif not_first_two_not_splittable_or_final_split_opportunity?(current_player_hand)
      self.choices = %w[h d s]
    elsif first_two_splittable?(current_player_hand)
      self.choices = %w[h d s sp sur]
    elsif not_first_two_and_splittable?(current_player_hand)
      self.choices = %w[h d s sp]
    else
      self.choices = %w[h s]
    end
  end

  def first_two_not_splittable?(hand)
    hand.cards.count == 2 && (hand.cards[0][:points] != hand.cards[1][:points]) && !round.player.there_are_split_hands?
  end

  def not_first_two_not_splittable_or_final_split_opportunity?(hand)
    ((hand.cards.count == 2) && (round.player.there_are_split_hands?)) && ((hand.cards[0][:points] != hand.cards[1][:points]) || (round.player.hands.count == 4))
  end

  def first_two_splittable?(hand)
    ((hand.cards[0][:points] == hand.cards[1][:points])) && (hand.cards.count == 2) && !round.player.there_are_split_hands?
  end

  def not_first_two_and_splittable?(hand)
    ((hand.cards[0][:points] == hand.cards[1][:points])) && (hand.cards.count == 2) && round.player.there_are_split_hands? && (round.player.hands.count <= 3)
  end
end
