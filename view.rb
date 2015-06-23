# Multi-Deck Blackjack in Ruby
# https://github.com/em77

module Prompt

	# Display current bankroll and receives bet choice from user
	def self.bet_prompt(player, hand)
		Display::current_bankroll(player)
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
		gets.chomp
	end

	# Prompts user for decision on whether to play another round
	def self.play_again_prompt
		puts "\nWould you like to play again?\n\n"
		print "Type \"y\" to play again or anything else to exit the game: "
		gets.chomp
	end
end

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
		puts "\nCurrent bankroll: #{Display::money_format(player.bankroll)}"
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

module Message

	def self.greeting(deck_num)
		puts "\nWelcome to #{deck_num}-Deck Blackjack!"
		puts "Blackjack pays 3:2 - Dealer must stand on all 17's"
		puts "Minimum bet: $5\n"
	end

	def self.shuffle_message
		sleep 1
		puts "\nCards are being shuffled..."
		sleep 1
		puts "One card has been burned...\n"
		sleep 1
	end

	# Maybe not necessary?
	def self.maximum_split
		puts "\nYou may only split 3 times to a maximum of 4 hands.\n"
	end

	def self.exit_message
		puts "\nThank you for playing!\n\n"
	end

	def self.broke_message(bankroll)
		Display::current_bankroll(player)
		puts "\nYou don't have enough money left to play at this table."
	end

	def self.not_enough_money
		Display::separator
		puts "You don't have enough money to do that."
		Display::separator
	end
end

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
		puts "\nDealer won. #{name} lost #{Display::money_format(bet)}.\n"
	end

	def self.player_won(name, bet)
		puts "\nDealer lost. #{name} won #{Display::money_format(bet)}.\n"
	end

	def self.tie
		puts "\nIt's a push! Nobody won.\n"
	end

	def self.surrender(name, bet)
		puts "\n#{name} surrendered and #{Display::money_format(bet)} was returned to your bankroll.\n"
	end
end