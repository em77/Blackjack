class Hand
  attr_accessor :cards, :bet, :has_been_played

  def initialize
    @cards = []
    @bet = 0.0
    @has_been_played = false
    (yield.hands << self) if block_given?
  end

  # Finds first index of 11 in hand
  def index_of_11
    cards.index { |card| card[:points] == 11 }
  end

  def total
    cards.reduce(0) { |total, card| total + card[:points] }
  end

  def busted?
    total > 21
  end

  # If an 11 is present, hand is "soft" as the 11 can change to 1
  def ace_check
    cards[index_of_11][:points] = 1 if index_of_11 && (total > 21)
  end
end
