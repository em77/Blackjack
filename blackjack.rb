# Double-Deck Blackjack in Ruby
# https://github.com/em77

require_relative 'deck'
require_relative 'methods'

class Float
	def dec_drop
		to_i == self ? to_i : self
	end
end

continue = "y"
@decision = "h"
@base_bet = 0
@ace_count = 0
@bankroll = 100.0
@holecard = {}
@upcard = {}
@cards = []
@player_hand = []
@dealer_hand = []

@split_hands = []
@split_status = false
@split_bets = []
@split_counter = 0
@split_hand1 = []
@split_hand2 = []
@split_hand3 = []
@split_hand4 = []
@split_bet1 = 0.0
@split_bet2 = 0.0
@split_bet3 = 0.0
@split_bet4 = 0.0
@split_hand_counter = 0

greeting

@deck.each_index { |index| @cards[index] = @deck[index].dup }
@deck.each_index { |index| @cards << @deck[index].dup }
@cards.shuffle!

while continue == "y"
	@ace_count = 0
	card_shuffle

	puts "\nCurrent bankroll: $#{@bankroll.dec_drop}"
	print "\nEnter your bet amount: "
	@base_bet = gets.to_f
	@current_bet = @base_bet
	print "\n"
	while (@base_bet < 5) || (@base_bet % 0.5 != 0)
		puts "\nMinimum bet is $5 and smallest chip size is 50¢"
		print "\nEnter your bet amount: "
		@base_bet = gets.to_f
		@current_bet = @base_bet
	end
	@dealer_hand = []
	@player_hand = []
	@dealer_hand << (@holecard = @cards.delete_at(0))
	@dealer_hand << (@upcard = @cards.delete_at(0))
	@player_hand << (@cards.delete_at(0))
	@player_hand << @cards.delete_at(0)

	@playercard = {}
	@dealercard = {}
	double_ace_actions(@player_hand)
	double_ace_actions(@dealer_hand)

	@dealer_total = @dealer_hand.reduce(0) {|total,c| total + c[:points]}
	@player_total = @player_hand.reduce(0) {|total,c| total + c[:points]}

	if (@dealer_total == 21) && (@player_total == 21)
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nIt's a push!"
		puts "The holecard was #{@holecard[:name]}"
	elsif @dealer_total == 21
		sleep 1
		card_names_p = @player_hand.map{|c| c[:name]}
		card_names_d = @dealer_hand.map{|c| c[:name]}
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		puts "\nDealer has blackjack!"
		puts "The holecard was #{@holecard[:name]}"
		puts "You lost $#{@base_bet.dec_drop}"
		@bankroll = @bankroll - @base_bet
	elsif (@player_total == 21)
		sleep 1
		card_names_p = @player_hand.map{|c| c[:name]}
		card_names_d = @dealer_hand.map{|c| c[:name]}
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		puts "\nPlayer has blackjack!"
		puts "The holecard was #{@holecard[:name]}"
		puts "You won $#{(@base_bet*1.5).dec_drop}!"
		@bankroll = @bankroll + (@base_bet*1.5)
	else
		@decision = "h"
		play(@player_hand)
		if @split_status != true
			dealer_play
			result
		end
	end

#This part handles the play flow and game results when splitting is involved
	if (@split_status == true)
		if @split_counter == 2
			@decision = "sp"
			split_actions(@split_hand1)
			@split_hand_counter = 1
			@split_bet1 = @base_bet
			until @decision != "sp"
				play(@split_hand1)
			end

			@decision = "sp"
			split_actions(@split_hand2)
			@split_hand_counter = 2
			@split_bet2 = @base_bet
			until @decision != "sp"
				play(@split_hand2)
			end
			@split_hands << @split_hand1 << @split_hand2
			@split_bets << @split_bet1 << @split_bet2
		end
		if @split_counter >= 3
			@decision = "sp"
			split_actions(@split_hand3)
			@split_bet3 = @base_bet
			@split_hand_counter = 3
			until @decision != "sp"
				play(@split_hand3)
			end
			@split_hands << @split_hand3
			@split_bets << @split_bet3
		end
		if @split_counter == 4
			@decision = "sp"
			split_actions(@split_hand4)
			@split_bet4 = @base_bet
			@split_hand_counter = 4
			until @decision != "sp"
				play(@split_hand4)
			end
			@split_hands << @split_hand4
			@split_bets << @split_bet4
		end

		dealer_play

		@split_hands.each_with_index { |hand,index|
			print "\n"
			print 'Hand #'
			print index + 1
			puts ' results:'
			result(@split_bets[index], @split_hands[index])
		}

		@split_hands = []
	 	@split_status = false
		@split_bets = []
		@split_counter = 0
		@split_hand_counter = 0
		@split_hand1 = []
		@split_hand2 = []
		@split_hand3 = []
		@split_hand4 = []
		@split_bet1 = 0
		@split_bet2 = 0
		@split_bet3 = 0
		@split_bet4 = 0
	end

	sleep 1

	if @bankroll <= 0.0
		puts "\nYou've lost your entire bankroll!"
		break
	elsif @bankroll < 5.0
		puts "\nYou don't have enough money left to play at this table."
		break
	end
	if @split_status == false
		puts "\nWould you like to play again?\n\n"
		print "Type \"y\" to play again or anything else to exit the game: "
		continue = gets.chomp
		print "\n"
	end
end

puts "\nThank you for playing!\n\n"