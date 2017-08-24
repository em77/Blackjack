class Shoe
  attr_accessor :current_cards

  def initialize(deck_num)
    @current_cards = []
    shuffle_up(deck_num)
  end

  def next_card
    current_cards.delete_at(0)
  end

  def deal_card(hand)
    hand.cards << next_card
    hand.ace_check
  end

  def shuffle_up(deck_num)
    current_cards.clear
    deck_num.times { Deck::CARDS.each_index {|index| current_cards << Deck::CARDS[index].dup } }
    current_cards.shuffle!
    next_card # Burning one card at start of shoe
  end
end
