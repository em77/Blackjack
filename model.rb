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

class Shoe
	extend Deck
	attr_reader :cards

	def initialize(deck_num)
		shuffle_up(deck_num)
	end

	def deal_card(hand)
		hand << cards.delete_at(0)
	end

	def shuffle_up(deck_num)
		@cards = []
		deck_num.times {CARDS.each_index {|index| @cards << CARDS[index].dup} }
		@cards.shuffle!
		# Burning one card at start of shoe
		cards.delete_at(0)
	end
end

class Player
	attr_accessor :bankroll, :player_name

	def initialize(player_name)
		@bankroll = 100.0
		@player_name = player_name
	end
end

class Hand
	attr_accessor :cards, :bet

	def initialize
		@cards = []
		@bet = []
	end

	# Finds first index of 11 in hand. If an 11 is present, hand is "soft" as the 11 can change to 1
	def index_of_11
		cards.index {|c| c[:points] == 11}
	end

	def total
		cards.reduce(0) {|total,c| total + c[:points]}
	end

	def ace_check
		while index_of_11 && (total > 21)
			cards[index_of_11][:points] = 1
		end
	end
end