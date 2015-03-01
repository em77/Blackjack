# Double-Deck Blackjack in Ruby
# https://github.com/em77

class Float
	def dec_drop
		to_i == self ? to_i : self
	end
end

continue = "y"
bet = 0
bankroll = 100.0
holecard = 0
upcard = 0
playercard1 = 0
playercard2 = 0
player_ace_count = 0
dealer_ace_count = 0
deck = [2,2,2,2,
				3,3,3,3,
				4,4,4,4,
				5,5,5,5,
				6,6,6,6,
				7,7,7,7,
				8,8,8,8,
				9,9,9,9,
				10,10,10,10,  # 10s
				10,10,10,10,  # Jacks
				10,10,10,10,  # Queens
				10,10,10,10,  # Kings
				11,11,11,11]
cards = (deck * 2).shuffle
player_hand = []
dealer_hand = []

puts "\nWelcome to Double-Deck Blackjack!"
puts "Minimum Bet: $5\n\n"
sleep 1
puts "We are just beginning a new deck."
sleep 1
cards.delete_at(cards.count-1)
puts "One card burned...\n"
sleep 1

while continue == "y"
	decision = "h"
	round_counter = 0
	player_ace_count = 0
	dealer_ace_count = 0
	if cards.count <= 11
		cards = (deck * 2)
		cards = cards.shuffle
		sleep 2
		puts "\nCards are being shuffled...\n"
		cards.delete_at(cards.count-1)
		puts "One card burned...\n"
		sleep 1
	end

	puts "\nCurrent bankroll: $#{bankroll.dec_drop}"
	print "\nEnter your bet amount: "
	bet = gets.to_f
	print "\n"
	while (bet < 5) || (bet % 0.5 != 0)
		puts "\nMinimum bet is $5 and smallest chip size is 50¢"
		print "\nEnter your bet amount: "
		bet = gets.to_f
		print "\n"
	end

	dealer_hand = []
	player_hand = []
	dealer_hand << (holecard = cards.delete_at(cards.count - 1))
	dealer_hand << (upcard = cards.delete_at(cards.count - 1))
	player_hand << (playercard1 = cards.delete_at(cards.count - 1))
	player_hand << (playercard2 = cards.delete_at(cards.count - 1))
	playercard = 0
	dealercard = 0
	dealer_total = dealer_hand.inject(:+)
	player_total = player_hand.inject(:+)

	if (playercard1 && playercard2) == 11
		player_ace_count = player_ace_count + 1
		playercard1 = 1
	elsif (playercard1 || playercard2) == 11
		player_ace_count = player_ace_count + 1
	end

	if dealer_total == 21
		sleep 1
		puts "\nDealer has blackjack! The holecard was #{holecard}."
		puts "You lost $#{bet.dec_drop}"
		bankroll = bankroll - bet
	elsif player_total == 21
		sleep 1
		puts "\nPlayer has blackjack! The holecard was #{holecard}."
		puts "You won $#{(bet*2).dec_drop}!"
		bankroll = bankroll + (bet*2)
	else
		while player_total <= 20
			if decision == "h"
				sleep 1
				puts "\nDealer upcard: #{upcard}"
				sleep 1
				if player_hand.include?(11)
					puts "Player hand: Soft #{player_total}"
					sleep 1
				else
					puts "Player hand: #{player_total}"
					sleep 1
				end
				if round_counter == 0
					print "\nType \"h\" to hit, \"d\" to double down, \"s\" to stand and \"sur\" to surrender: "
				else
					print "\nType \"h\" to hit and \"s\" to stand: "
				end
				decision = gets.chomp
				while (["h", "d", "s", "sur"].include? decision) == false
					print "\nThat is not a valid choice. Enter \"h,\" \"d,\" \"s\" or \"sur\": "
					decision = gets.chomp
				end
				while (decision == "d") && (bankroll < (bet*2))
					puts "\nYou don't have enough money to double down."
					print "\nPlease enter \"h,\" \"s\" or \"sur\": "
					decision = gets.chomp
				end
				if (decision == "h") || ((decision == "d") && (round_counter == 0))
					playercard = cards.delete_at(cards.count - 1)
					if (playercard == 11)
						player_ace_count = player_ace_count + 1
						if (player_ace_count == 1) && ((playercard + player_total) > 21)
							playercard = 1
							player_ace_count = player_ace_count - 1
						elsif player_ace_count >= 2
							playercard = 1
							player_ace_count = player_ace_count - 1
						end
					end
					if ((player_total + playercard) > 21) && (player_hand.include?(11))
						player_hand[player_hand.index(11)] = 1
						if player_hand.include?(11)
							puts "\n\nerror with player\n\n"
						end
					end
					player_hand << playercard
					player_total = player_hand.inject(:+)
					if decision == "d"
						bet = bet*2
					end
					round_counter = round_counter + 1
				end
			else
				break
			end
		end
		if decision == "sur"
			puts "\nYou surrendered and #{bet/2} was returned to your bankroll."
			puts "The holecard was #{holecard}"
			bankroll = bankroll - (bet/2)
		elsif player_total > 21
			sleep 1
			puts "\nPlayer busted with #{player_total}"
			puts "You lost $#{bet.dec_drop}"
			bankroll = bankroll - bet
		else
			while dealer_total <= 16
				dealercard = cards.delete_at(cards.count - 1)
				if (dealercard == 11)
					dealer_ace_count = dealer_ace_count + 1
					if (dealer_ace_count == 1) && ((dealercard + dealer_total) > 21)
						dealercard = 1
						dealer_ace_count = dealer_ace_count - 1
					elsif dealer_ace_count >= 2
						dealercard = 1
						dealer_ace_count = dealer_ace_count - 1
					end
				end
				dealer_total = dealer_hand.inject(:+)
				if ((dealer_total + dealercard) > 21) && (dealer_hand.include?(11))
					dealer_hand[dealer_hand.index(11)] = 1
					if dealer_hand.include?(11)
						puts "\n\nerror with dealer\n\n"
					end
				end

				dealer_hand << dealercard
				dealer_total = dealer_hand.inject(:+)
			end
			if dealer_total > 21
				sleep 1
				puts "\nDealer busted with #{dealer_total} and the holecard was #{holecard}."
				puts "You won $#{(bet*2).dec_drop}!"
				bankroll = bankroll + (bet*2)
			elsif dealer_total > player_total
				sleep 1
				puts "\nPlayer hand: #{player_total}"
				puts "Dealer won with #{dealer_total} and the holecard was #{holecard}."
				puts "You lost $#{bet.dec_drop}"
				bankroll = bankroll - bet
			elsif dealer_total == player_total
				sleep 1
				puts "\nPlayer hand: #{player_total}"
				sleep 1
				puts "Dealer hand: #{dealer_total}"
				sleep 1
				puts "It's a push! The holecard was #{holecard}."
			else
				sleep 1
				puts "\nPlayer hand: #{player_total}"
				sleep 1
				puts "Dealer hand: #{dealer_total}"
				sleep 1
				puts "You won $#{(bet*2).dec_drop}! The holecard was #{holecard}."
				bankroll = bankroll + (bet*2)
			end
		end
	end
	sleep 1
	if bankroll <= 0.0
		puts "\nYou've lost your entire bankroll!"
		break
	elsif bankroll < 5.0
		puts "\nYou don't have enough money left to play at this table."
		break
	end
	puts "\nWould you like to play again?\n\n"
	print "Type \"y\" to play again or anything else to exit the game: "
	continue = gets.chomp
	print "\n"
end

puts "\nThank you for playing!\n\n"
sleep 1