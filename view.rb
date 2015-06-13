# Multi-Deck Blackjack in Ruby
# https://github.com/em77

module Prompt

	# Display current bankroll and receives bet choice from user
	def self.bet_prompt(player, hand)
		while (hand.bet < 5) || (hand.bet % 0.5 != 0) || (hand.bet >= player.bankroll)
			Display::current_bankroll(player)
			puts "\nMinimum bet is $5 and smallest chip size is 50¢"
			print "\nEnter your bet amount: "
			hand.bet = gets.to_f
		end
	end

	# Displays general blackjack moves and the ones available to the user, then prompts for input. Returns decision.
	def self.decision_prompt(choices)
		decision = nil
		puts "\nBlackjack moves: \"h\" to hit - \"d\" to double down - \"s\" to stand - \"sp\" to split - \"sur\" to surrender"
		puts "In order to split or double down, you must have at least double your original bet in your bankroll."
		until choices.include? decision
			print "\nChoose one of the following moves (#{choices.join(', ')}): "
			decision = gets.chomp
		end
		decision
	end

	# Prompt for deck choice and returns decision.
	def self.deck_num_prompt
		decision = 0
		choices = [2,4,6,8]
		puts "Welcome to Blackjack!"
		puts "\nHow many decks would you like to play with?"
		until choices.include? decision
			print "Enter (#{choices.join(', ')}): "
			decision = gets.chomp.to_i
		end
		decision
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

	# Displays current bankroll
	def self.current_bankroll(player)
		puts "\nCurrent bankroll: $#{"%.2f" % player.bankroll}"
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

	# Displays final cards/totals of dealer and player, who won, and how much money was lost or won by player
	def self.display_final(player_hand, dealer_hand, hand_index, player_name)
		puts "\nHand ##{hand_index + 1}"
		puts "______________"
		display_hand(player_hand, player_name)
		sleep 1
		display_hand(dealer_hand, "Dealer")
		sleep 1
		puts "The holecard was #{dealer_hand.cards[0][:name]}."
		yield if block_given?
		puts "____________________________________________________________\n"
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
		puts "____________________________________________________________"
		puts "\nYou don't have enough money to do that."
		puts "____________________________________________________________"
	end
end

module Results

	def self.player_has_blackjack(player)
		puts "\n#{player.name} has blackjack!\n"
	end

	def self.dealer_has_blackjack
		puts "\nDealer has blackjack!\n"
	end

	def self.dealer_won(name, bet)
		puts "\nDealer won. #{name} lost $#{"%.2f" % bet}.\n"
	end

	def self.player_won(name, bet)
		puts "\nDealer lost. #{name} won $#{"%.2f" % bet}.\n"
	end

	def self.tie
		puts "\nIt's a push! Nobody won.\n"
	end

	def self.surrender(name, bet)
		puts "\n#{name} surrendered and $#{"%.2f" % bet} was returned to your bankroll.\n"
	end
end