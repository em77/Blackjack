# Double-Deck Blackjack in Ruby
# https://github.com/em77

require_relative 'deck'

class Float
	def dec_drop
		to_i == self ? to_i : self
	end
end

continue = "y"
bet = 0
bankroll = 100.0
holecard = {}
upcard = {}
playercard1 = {}
playercard2 = {}
player_ace_count = 0
dealer_ace_count = 0
cards = (@deck * 2).shuffle
player_hand = []
dealer_hand = []

puts "\nWelcome to Double-Deck Blackjack!"
puts "Minimum Bet: $5\n\n"
sleep 1
puts "We are just beginning a new deck."
sleep 1
cards.delete_at(0)
puts "One card burned...\n"
sleep 1

while continue == "y"
	decision = "h"
	round_counter = 0
	player_ace_count = 0
	dealer_ace_count = 0
	if cards.count <= 11
		cards = (@deck * 2)
		cards.shuffle!
		sleep 2
		puts "\nCards are being shuffled...\n"
		cards.delete_at(0)
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
	end

	dealer_hand = []
	player_hand = []
	dealer_hand << (holecard = cards.delete_at(0))
	dealer_hand << (upcard = cards.delete_at(0))
	player_hand << (playercard1 = cards.delete_at(0))
	player_hand << (playercard2 = cards.delete_at(0))
	playercard = {}
	dealercard = {}
	dealer_total = dealer_hand.reduce(0) {|total,c| total + c[:value]}
	player_total = player_hand.reduce(0) {|total,c| total + c[:value]}

	if (playercard1[:value] && playercard2[:value]) == 11
		player_ace_count = player_ace_count + 1
		playercard1[:value] = 1
	elsif (playercard1[:value] || playercard2[:value]) == 11
		player_ace_count = player_ace_count + 1
	end

	if dealer_total == 21
		sleep 1
		card_names_p = (player_hand.map{|c| c[:name]})
		card_names_d = (dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{player_total}\n"
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{dealer_total}\n"
		puts "\nDealer has blackjack! The holecard was #{holecard[:name]}."
		puts "You lost $#{bet.dec_drop}"
		bankroll = bankroll - bet
	elsif player_total == 21
		sleep 1
		puts "\nPlayer has blackjack! The holecard was #{holecard[:name]}."
		puts "You won $#{(bet*1.5).dec_drop}!"
		bankroll = bankroll + (bet*1.5)
	else
		while player_total <= 20
			if decision == "h"
				sleep 1
				puts "Dealer upcard: #{upcard[:name]}\n"
				sleep 1
				card_names_p = (player_hand.map{|c| c[:name]})
				location_p = player_hand.index {|c| c[:value] == 11}
				if (location_p != nil)
					puts "\nPlayer hand: #{card_names_p.join(', ')}"
					puts "Player total: Soft #{player_total}"
					sleep 1
				else
					puts "\nPlayer hand: #{card_names_p.join(', ')}"
					puts "Player total: #{player_total}"
					sleep 1
				end

				if round_counter == 0
					print "\nType \"h\" to hit, \"d\" to double down, \"s\" to stand and \"sur\" to surrender: "
					decision = gets.chomp
					while (["h", "d", "s", "sur"].include? decision) == false
						print "\nThat is not a valid choice. Enter \"h,\" \"d,\" \"s\" or \"sur\": "
						decision = gets.chomp
					end
				else
					print "\nType \"h\" to hit and \"s\" to stand: "
					decision = gets.chomp
					while (["h", "s"].include? decision) == false
						print "\nThat is not a valid choice. Enter \"h\" or \"s\": "
						decision = gets.chomp
					end
				end

				while (decision == "d") && (bankroll < (bet*2))
					puts "\nYou don't have enough money to double down."
					print "\nPlease enter \"h,\" \"s\" or \"sur\": "
					decision = gets.chomp
				end
				if (decision == "h") || ((decision == "d") && (round_counter == 0))
					playercard = cards.delete_at(0)
					if (playercard[:value] == 11)
						player_ace_count = player_ace_count + 1
						if (player_ace_count == 1) && ((playercard[:value] + player_total) > 21)
							playercard[:value] = 1
							player_ace_count = player_ace_count - 1
						elsif player_ace_count >= 2
							playercard[:value] = 1
							player_ace_count = player_ace_count - 1
						end
					end
					location_p = player_hand.index(player_hand.index {|c| c[:value] == 11})
					if ((player_total + playercard[:value]) > 21) && 
					(location_p != nil)
						player_hand[location_p][:value] = 1
					end
					player_hand << playercard
					player_total = player_hand.reduce(0) {|total,c| total + c[:value]}
					if decision == "d"
						bet = bet*2
					end
					round_counter = round_counter + 1
				end
			else
				break
			end
		end
		while dealer_total <= 16
			dealercard = cards.delete_at(0)
			if (dealercard[:value] == 11)
				dealer_ace_count = dealer_ace_count + 1
				if (dealer_ace_count == 1) && ((dealercard[:value] + dealer_total) > 21)
					dealercard[:value] = 1
					dealer_ace_count = dealer_ace_count - 1
				elsif dealer_ace_count >= 2
					dealercard[:value] = 1
					dealer_ace_count = dealer_ace_count - 1
				end
			end

			location_d = dealer_hand.index {|c| c[:value] == 11}
			dealer_total = dealer_hand.reduce(0) {|total,c| total + c[:value]}
			if ((dealer_total + dealercard[:value]) > 21) && (location_d != nil)
				dealer_hand[location_d][:value] = 1
			end

			dealer_hand << dealercard
			dealer_total = dealer_hand.reduce(0) {|total,c| total + c[:value]}
		end
		if (decision == "sur")
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nYou surrendered and #{bet/2} was returned to your bankroll."
			puts "The holecard was #{holecard[:name]}"
			bankroll = bankroll - (bet/2)
		elsif player_total > 21
			sleep 1
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nPlayer busted with #{player_total}"
			puts "You lost $#{bet.dec_drop}"
			bankroll = bankroll - bet
		elsif dealer_total > 21
			sleep 1
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			sleep 1
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nDealer busted with #{dealer_total} and the holecard was #{holecard[:name]}."
			puts "You won $#{bet.dec_drop}!"
			bankroll = bankroll + bet
		elsif dealer_total > player_total
			sleep 1
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			sleep 1
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nDealer won with #{dealer_total} and the holecard was #{holecard[:name]}."
			puts "You lost $#{bet.dec_drop}"
			bankroll = bankroll - bet
		elsif dealer_total == player_total
			sleep 1
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			sleep 1
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nIt's a push! The holecard was #{holecard[:name]}."
		else
			sleep 1
			card_names_p = (player_hand.map{|c| c[:name]})
			card_names_d = (dealer_hand.map{|c| c[:name]})
			puts "\nPlayer hand: #{card_names_p.join(', ')}"
			puts "Player total: #{player_total}\n"
			sleep 1
			puts "\nDealer hand: #{card_names_d.join(', ')}"
			puts "Dealer total: #{dealer_total}\n"
			sleep 1
			puts "\nYou won $#{bet.dec_drop}! The holecard was #{holecard[:name]}."
			bankroll = bankroll + bet
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