# Multi-Deck Blackjack in Ruby
# https://github.com/em77

module Deck
	CARDS = [
						{:name => "2-h", :points => 2}, {:name => "2-d", :points => 2}, {:name => "2-s", :points => 2}, {:name => "2-c", :points => 2},
						{:name => "3-h", :points => 3}, {:name => "3-d", :points => 3}, {:name => "3-s", :points => 3}, {:name => "3-c", :points => 3},
						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
						{:name => "5-h", :points => 5}, {:name => "5-d", :points => 5}, {:name => "5-s", :points => 5}, {:name => "5-c", :points => 5},
						{:name => "6-h", :points => 6}, {:name => "6-d", :points => 6}, {:name => "6-s", :points => 6}, {:name => "6-c", :points => 6},
						{:name => "7-h", :points => 7}, {:name => "7-d", :points => 7}, {:name => "7-s", :points => 7}, {:name => "7-c", :points => 7},
						{:name => "8-h", :points => 8}, {:name => "8-d", :points => 8}, {:name => "8-s", :points => 8}, {:name => "8-c", :points => 8},
						{:name => "9-h", :points => 9}, {:name => "9-d", :points => 9}, {:name => "9-s", :points => 9}, {:name => "9-c", :points => 9},
						{:name => "10-h", :points => 10}, {:name => "10-d", :points => 10}, {:name => "10-s", :points => 10}, {:name => "10-c", :points => 10},
						{:name => "K-h", :points => 10}, {:name => "K-d", :points => 10}, {:name => "K-s", :points => 10}, {:name => "K-c", :points => 10},
						{:name => "J-h", :points => 10}, {:name => "J-d", :points => 10}, {:name => "J-s", :points => 10}, {:name => "J-c", :points => 10},
						{:name => "Q-h", :points => 10}, {:name => "Q-d", :points => 10}, {:name => "Q-s", :points => 10}, {:name => "Q-c", :points => 10},
						{:name => "A-h", :points => 11}, {:name => "A-d", :points => 11}, {:name => "A-s", :points => 11}, {:name => "A-c", :points => 11}
					]
end


########## For testing splitting
# module Deck
# 	CARDS = [
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4},
# 						{:name => "4-h", :points => 4}, {:name => "4-d", :points => 4}, {:name => "4-s", :points => 4}, {:name => "4-c", :points => 4}
# 					]
# end

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
		deck_num.times {Deck::CARDS.each_index {|index| current_cards << Deck::CARDS[index].dup} }
		current_cards.shuffle!
		# Burning one card at start of shoe
		next_card
	end
end

class Player
	attr_accessor :bankroll, :name, :hands

	def initialize(player_name, bankroll)
		@bankroll = bankroll.to_f
		@name = player_name
		@hands = []
	end

	def enough_in_bankroll?(bet, decision)
		case decision
		when "d","sp"
			if bankroll >= bet
				return true
			else
				return false
			end
		end
		true
	end

	def withdraw_from_bankroll(hand, amount)
		self.bankroll -= amount
	end

	def add_to_bankroll(hand, amount)
		self.bankroll += amount
	end

	def broke?
		bankroll < 5.0
	end

	def there_are_split_hands?
		hands.count > 1
	end
end

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
		cards.index {|card| card[:points] == 11}
	end

	def total
		cards.reduce(0) {|total, card| total + card[:points]}
	end

	def busted?
		total > 21
	end

	# If an 11 is present, hand is "soft" as the 11 can change to 1
	def ace_check
		while index_of_11 && (total > 21)
			cards[index_of_11][:points] = 1
		end
	end
end