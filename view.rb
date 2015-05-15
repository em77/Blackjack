class Float
	def dec_drop
		to_i == self ? to_i : self
	end
end

class Prompt

	# Display current bankroll and receives bet choice from user
	def bet_prompt(player, hand)
		while (hand.bet < 5) || (hand.bet % 0.5 != 0) || (hand.bet > player.bankroll)
			puts "\nCurrent bankroll: $#{player.bankroll.dec_drop}"
			puts "\nMinimum bet is $5 and smallest chip size is 50¢"
			print "\nEnter your bet amount: "
			hand.bet = gets.to_f
		end
	end

	# Displays general blackjack moves and the ones available to the user, then prompts for input. Returns decision.
	def decision_prompt(choices)
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
	def deck_num_prompt
		decision = 0
		choices = [2,4,6,8]
		puts "Welcome to Blackjack!"
		puts "\nHow many decks would you like to play with?"
		until choices.include? decision
			print "Enter (#{choices.join(', ')}): "
			gets.chomp
		end
		decision
	end
end

class Display
	# Displays cards of hand and total of hand
	def display_hand(hand, name)
		card_names = hand.map{|c| c[:name]}
		puts "\n#{name}'s hand: #{card_names.join(', ')}"
		puts "#{name}'s total: #{hand.total}\n"
	end

	# Displays dealer's upcard, which is second card in hand
	def display_upcard(hand)
		puts "\nDealer upcard: #{hand[1][:name]}\n"
	end

	# Displays final cards/totals of dealer and player, who won, and how much money was lost or won by player
	def display_final(player_hand, dealer_hand, result)
		display_hand(player_hand, player_hand.player_name)
		sleep 1
		display_hand(dealer_hand, "Dealer")
		sleep 1
		puts "The holecard was #{dealer_hand[0][:name]}."
		puts result
	end
end

class Message
	def greeting(deck_num)
		puts "\nWelcome to #{deck_num}-Deck Blackjack!"
		puts "Blackjack pays 3:2 - Dealer must stand on all 17's"
		puts "Minimum bet: $5\n\n"
		sleep 1
		puts "Cards are being shuffled..."
		sleep 1
		puts "One card has been burned...\n"
		sleep 1
	end

	def exit_message
		puts "\nThank you for playing!\n\n"
	end

	def broke_message(player)
		puts "\nCurrent bankroll: $#{player.bankroll.dec_drop}"
		puts "\nYou don't have enough money left to play at this table."
	end

	def play_again_message
		puts "\nWould you like to play again?\n\n"
		print "Type \"y\" to play again or anything else to exit the game: "
		gets.chomp
	end
end